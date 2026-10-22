// Isolated-test host: real Edge handler + PostgreSQL; Auth verification is a
// fixed fixture identity. This does not prove deployed Supabase JWT verification.
import postgres from "npm:postgres@3.4.7";
import {
  executeCreateHabit,
  handleCreateHabit,
} from "../functions/create-habit-v1/index.ts";

const sql = postgres(Deno.env.get("HABIT_TEST_DATABASE_URL")!, {
  prepare: false,
  max: 8,
});
const actor = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa";
const server = Deno.serve(
  { hostname: "127.0.0.1", port: 56081 },
  (request) =>
    handleCreateHabit(request, {
      verify: async (token) => token === "isolated-test-token" ? actor : null,
      execute: (verified, command) =>
        executeCreateHabit(sql, verified, command),
    }),
);
Deno.addSignalListener("SIGINT", async () => {
  await server.shutdown();
  await sql.end();
});
