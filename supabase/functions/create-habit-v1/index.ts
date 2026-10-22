import postgres from "npm:postgres@3.4.7";

type Dependencies = {
  verify: (token: string) => Promise<string | null>;
  execute: (
    actor: string,
    command: Record<string, unknown>,
  ) => Promise<Record<string, unknown>>;
};
const uuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export async function handleCreateHabit(
  request: Request,
  dependencies: Dependencies,
): Promise<Response> {
  const respond = (status: number, body: unknown) =>
    Response.json(body, { status });
  if (request.method !== "POST") {
    return respond(405, { outcome: "invalidRequest" });
  }
  const authorization = request.headers.get("Authorization");
  if (!authorization?.startsWith("Bearer ") || authorization.length <= 7) {
    return respond(401, { outcome: "unauthorized" });
  }
  try {
    const actor = await dependencies.verify(authorization.slice(7));
    if (!actor || !uuid.test(actor)) {
      return respond(401, { outcome: "unauthorized" });
    }
    let command: Record<string, unknown>;
    try {
      command = await request.json();
    } catch {
      return respond(400, { outcome: "invalidRequest" });
    }
    if (
      !command || typeof command !== "object" || Array.isArray(command) ||
      Object.keys(command).some((key) =>
        !["commandId", "entityId", "version", "payload"].includes(key)
      ) ||
      typeof command.commandId !== "string" || !uuid.test(command.commandId) ||
      typeof command.entityId !== "string" || !uuid.test(command.entityId) ||
      command.version !== 1 || !command.payload ||
      typeof command.payload !== "object" ||
      Array.isArray(command.payload)
    ) {
      return respond(400, { outcome: "invalidRequest" });
    }
    const result = await dependencies.execute(actor, command);
    return respond(result.outcome === "accepted" ? 200 : 422, result);
  } catch {
    // No JWT, payload, database detail or exception text enters the response/log.
    return respond(503, { outcome: "retryable" });
  }
}

export async function executeCreateHabit(
  sql: postgres.Sql,
  actor: string,
  command: Record<string, unknown>,
): Promise<Record<string, unknown>> {
  return await sql.begin(async (transaction) => {
    await transaction`set local role habit_command_executor`;
    const rows = await transaction`
      select private.create_habit_v1(${actor}::uuid, ${command
      .commandId as string}::uuid,
        ${command.entityId as string}::uuid, ${command
      .version as number}::integer,
        ${
      transaction.json(command.payload as postgres.JSONValue)
    }::jsonb) as result`;
    return rows[0].result;
  });
}

if (import.meta.main) {
  const url = Deno.env.get("SUPABASE_URL")!;
  const key = Deno.env.get("SUPABASE_ANON_KEY")!;
  // Server-only connection secret; never included in Flutter configuration.
  const sql = postgres(Deno.env.get("SUPABASE_DB_URL")!, {
    prepare: false,
    max: 1,
  });
  Deno.serve((request) =>
    handleCreateHabit(request, {
      verify: async (token) => {
        // Auth service verifies the JWT; decoding claims alone is insufficient.
        const response = await fetch(`${url}/auth/v1/user`, {
          headers: { apikey: key, Authorization: `Bearer ${token}` },
          signal: AbortSignal.timeout(20_000),
        });
        if (response.status === 401 || response.status === 403) return null;
        if (!response.ok) throw new Error("Auth verification unavailable");
        const user = await response.json();
        return typeof user.id === "string" ? user.id : null;
      },
      execute: (actor, command) => executeCreateHabit(sql, actor, command),
    })
  );
}
