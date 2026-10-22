\set ON_ERROR_STOP on
begin;
create function pg_temp.check_result(ok boolean, label text) returns void language plpgsql as $$
begin if ok is distinct from true then raise exception 'FAIL: %', label; end if; end $$;

do $$
declare
  actor uuid := 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
  command uuid := '11111111-1111-4111-8111-111111111111';
  entity uuid := '22222222-2222-4222-8222-222222222222';
  payload jsonb := '{"name":" Read ","description":"","category":null,"targetMinutes":null,"visibility":"private","schedule":{"frequency":"daily","weekdays":[],"timezone":"Africa/Cairo"}}';
  accepted jsonb;
  replay jsonb;
  rejected jsonb;
begin
  accepted := private.create_habit_v1(actor, command, entity, 1, payload);
  perform pg_temp.check_result(accepted->>'outcome' = 'accepted', 'valid creation');
  perform pg_temp.check_result(accepted->'habit'->>'accountId' = actor::text and
    accepted->'habit'->>'revision' = '1', 'server ownership/revision');
  replay := private.create_habit_v1(actor, command, entity, 1, payload);
  perform pg_temp.check_result(replay = accepted, 'same command returns exact recorded result');
  perform pg_temp.check_result((select count(*) = 1 from private.owned_habits where id = entity), 'one Habit');
  rejected := private.create_habit_v1(actor, command, entity, 1, payload || '{"name":"Changed"}');
  perform pg_temp.check_result(rejected->>'reason' = 'commandReused', 'changed payload rejected');
  perform pg_temp.check_result((select result = accepted from private.create_habit_receipts
    where actor_id = actor and command_id = command), 'original receipt retained');
  rejected := private.create_habit_v1(actor, '33333333-3333-4333-8333-333333333333', entity, 1, payload);
  perform pg_temp.check_result(rejected->>'reason' = 'entityExists', 'different command cannot overwrite entity');
  rejected := private.create_habit_v1(actor, '44444444-4444-4444-8444-444444444444',
    '55555555-5555-4555-8555-555555555555', 1,
    payload || '{"ownerId":"bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb"}');
  perform pg_temp.check_result(rejected->>'reason' = 'invalidPayload', 'forged ownership rejected');
  perform pg_temp.check_result(not exists(select 1 from private.owned_habits
    where id = '55555555-5555-4555-8555-555555555555'), 'no forged Habit');
  replay := private.create_habit_v1(actor, '44444444-4444-4444-8444-444444444444',
    '55555555-5555-4555-8555-555555555555', 1,
    payload || '{"ownerId":"bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb"}');
  perform pg_temp.check_result(replay = rejected, 'rejected outcome also replayable');
  begin
    perform private.create_habit_v1(null, command, entity, 1, payload);
    raise exception 'FAIL: missing actor accepted';
  exception when insufficient_privilege then null; end;
end $$;

select pg_temp.check_result(not has_schema_privilege('authenticated','private','usage'), 'no client schema access');
select pg_temp.check_result(not has_table_privilege('authenticated','private.owned_habits','insert'), 'no client Habit writes');
select pg_temp.check_result(not has_table_privilege('authenticated','private.create_habit_receipts','insert'), 'no client receipt writes');
select pg_temp.check_result(not has_function_privilege('authenticated',
  'private.create_habit_v1(uuid,uuid,uuid,integer,jsonb)','execute'), 'no client command execution');
set local role authenticated;
do $$ begin
  begin
    perform private.create_habit_v1('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
      '11111111-1111-4111-8111-111111111111','22222222-2222-4222-8222-222222222222',1,'{}');
    raise exception 'FAIL: unauthorized role executed';
  exception when insufficient_privilege then null; end;
end $$;
reset role;
rollback;
\echo PASS: creation, replay, changed reuse, entity collision, forged owner, authorization and grants
