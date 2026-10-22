begin;

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

-- Only the trusted Edge database connection may assume this execution role.
do $$ begin
  if not exists (select 1 from pg_roles where rolname = 'habit_command_executor') then
    create role habit_command_executor nologin;
  end if;
end $$;
grant habit_command_executor to postgres;
grant usage on schema private to habit_command_executor;

create table private.owned_habits (
  id uuid primary key,
  owner_id uuid not null references auth.users(id),
  name text not null check (length(btrim(name)) > 0),
  description text not null,
  category text,
  target_minutes integer check (target_minutes > 0),
  frequency text not null check (frequency in ('daily', 'selectedWeekdays')),
  weekdays integer[] not null,
  timezone text not null,
  revision bigint not null default 1 check (revision = 1),
  created_at timestamptz not null default transaction_timestamp(),
  updated_at timestamptz not null default transaction_timestamp()
);
create table private.create_habit_receipts (
  actor_id uuid not null references auth.users(id),
  command_id uuid not null,
  fingerprint jsonb not null,
  result jsonb not null,
  primary key (actor_id, command_id)
);
alter table private.owned_habits enable row level security;
alter table private.create_habit_receipts enable row level security;
revoke all on private.owned_habits, private.create_habit_receipts
  from public, anon, authenticated, service_role, habit_command_executor;

create function private.create_habit_v1(
  actor uuid, command_id uuid, entity_id uuid, version integer, payload jsonb
) returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  fingerprint jsonb := jsonb_build_object('entityId', entity_id, 'version', version, 'payload', payload);
  previous private.create_habit_receipts%rowtype;
  correlation jsonb := jsonb_build_object('commandId', command_id, 'entityId', entity_id,
    'version', version, 'accountId', actor);
  result jsonb;
  reason text;
  schedule jsonb;
  days integer[];
  target integer;
  inserted private.owned_habits%rowtype;
begin
  if actor is null or not exists (select 1 from auth.users u where u.id = actor) then
    raise insufficient_privilege using message = 'Verified actor required';
  end if;
  if command_id is null or entity_id is null or version is null then
    raise invalid_parameter_value using message = 'Invalid envelope';
  end if;
  -- Concurrent retries serialize on the receipt identity, not Edge memory.
  perform pg_advisory_xact_lock(hashtextextended(actor::text || ':' || command_id::text, 0));
  select * into previous from private.create_habit_receipts r
    where r.actor_id = actor and r.command_id = create_habit_v1.command_id;
  if found then
    if previous.fingerprint = fingerprint then return previous.result; end if;
    return correlation || jsonb_build_object('outcome', 'rejected', 'reason', 'commandReused');
  end if;

  -- Validation casts run inside this block so malformed payload is a stable rejection.
  begin
    if version <> 1 or jsonb_typeof(payload) <> 'object' or
        (payload - array['name','description','category','targetMinutes','visibility','schedule']) <> '{}'::jsonb or
        jsonb_typeof(payload->'name') is distinct from 'string' or
        length(btrim(payload->>'name')) = 0 or
        jsonb_typeof(payload->'description') is distinct from 'string' or
        payload->>'visibility' is distinct from 'private' or
        not (payload ? 'category' and payload ? 'targetMinutes') or
        (payload->'category' <> 'null'::jsonb and
          (jsonb_typeof(payload->'category') <> 'string' or payload->>'category' not in
            ('exercise','water','reading','mindfulness','sleep'))) then
      reason := 'invalidPayload';
    end if;
    if payload->'targetMinutes' <> 'null'::jsonb then
      if jsonb_typeof(payload->'targetMinutes') <> 'number' or
        (payload->>'targetMinutes') !~ '^[0-9]+$' then reason := 'invalidPayload'; end if;
      target := (payload->>'targetMinutes')::integer;
      if target <= 0 then reason := 'invalidPayload'; end if;
    end if;
    schedule := payload->'schedule';
    if jsonb_typeof(schedule) is distinct from 'object' or
        (schedule - array['frequency','weekdays','timezone']) <> '{}'::jsonb or
        jsonb_typeof(schedule->'timezone') is distinct from 'string' or
        not exists (select 1 from pg_timezone_names z where z.name = schedule->>'timezone') or
        jsonb_typeof(schedule->'weekdays') is distinct from 'array' or
        schedule->>'frequency' not in ('daily','selectedWeekdays') or
        not (schedule ? 'frequency') then reason := 'invalidPayload'; end if;
    if exists (select 1 from jsonb_array_elements(schedule->'weekdays') d
        where jsonb_typeof(d) <> 'number' or d::text !~ '^[1-7]$') then
      reason := 'invalidPayload';
    end if;
    select coalesce(array_agg(d::text::integer order by d::text::integer), '{}'::integer[])
      into days from jsonb_array_elements(schedule->'weekdays') d;
    if cardinality(days) <> (select count(distinct d) from unnest(days) d) or
        (schedule->>'frequency' = 'daily' and cardinality(days) <> 0) or
        (schedule->>'frequency' = 'selectedWeekdays' and cardinality(days) = 0) then
      reason := 'invalidPayload';
    end if;
  exception when invalid_text_representation or numeric_value_out_of_range or invalid_parameter_value then
    reason := 'invalidPayload';
  end;

  if reason is null then
    insert into private.owned_habits(id, owner_id, name, description, category,
      target_minutes, frequency, weekdays, timezone)
      values(entity_id, actor, btrim(payload->>'name'), btrim(payload->>'description'),
        payload->>'category', target, schedule->>'frequency', days, schedule->>'timezone')
      on conflict (id) do nothing returning * into inserted;
    if not found then reason := 'entityExists'; end if;
  end if;
  if reason is not null then
    result := correlation || jsonb_build_object('outcome','rejected','reason',reason);
  else
    result := correlation || jsonb_build_object('outcome','accepted','habit',
      jsonb_build_object('id',inserted.id,'accountId',inserted.owner_id,'name',inserted.name,
        'description',inserted.description,'category',inserted.category,'targetMinutes',inserted.target_minutes,
        'schedule',jsonb_build_object('frequency',inserted.frequency,'weekdays',to_jsonb(inserted.weekdays),'timezone',inserted.timezone),
        'revision',inserted.revision,
        'createdAt',to_char(inserted.created_at at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"'),
        'updatedAt',to_char(inserted.updated_at at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"')));
  end if;
  insert into private.create_habit_receipts values(actor, command_id, fingerprint, result);
  return result;
end $$;
revoke all on function private.create_habit_v1(uuid,uuid,uuid,integer,jsonb)
  from public, anon, authenticated, service_role;
grant execute on function private.create_habit_v1(uuid,uuid,uuid,integer,jsonb) to habit_command_executor;
commit;
