import { handleCreateHabit } from "./index.ts";

const actor = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa";
const command = {
  commandId: "11111111-1111-4111-8111-111111111111",
  entityId: "22222222-2222-4222-8222-222222222222",
  version: 1,
  payload: { name: "Read" },
};
function request(body: unknown = command, token = "verified") {
  return new Request("http://localhost/create-habit-v1", {
    method: "POST",
    headers: { Authorization: `Bearer ${token}` },
    body: JSON.stringify(body),
  });
}
function check(ok: boolean) {
  if (!ok) throw new Error("Assertion failed");
}

Deno.test("verified actor is derived, not taken from payload; canonical result returned", async () => {
  const response = await handleCreateHabit(request(), {
    verify: async () => actor,
    execute: async (verified, input) => {
      check(verified === actor && input.commandId === command.commandId);
      return { outcome: "accepted", accountId: verified };
    },
  });
  check(response.status === 200 && (await response.json()).accountId === actor);
});
Deno.test("missing/invalid JWT never executes database command", async () => {
  let calls = 0;
  for (
    const input of [
      new Request("http://localhost", { method: "POST" }),
      request(command, "invalid"),
    ]
  ) {
    const response = await handleCreateHabit(input, {
      verify: async () => null,
      execute: async () => {
        calls++;
        return {};
      },
    });
    check(response.status === 401);
  }
  check(calls === 0);
});
Deno.test("invalid envelope/version/forged envelope owner never executes", async () => {
  let calls = 0;
  for (
    const body of [{ ...command, version: 2 }, { ...command, ownerId: actor }, {
      ...command,
      commandId: "bad",
    }]
  ) {
    const response = await handleCreateHabit(request(body), {
      verify: async () => actor,
      execute: async () => {
        calls++;
        return {};
      },
    });
    check(response.status === 400);
  }
  check(calls === 0);
});
Deno.test("definitive rejection uses 422; operational failure uses safe 503", async () => {
  const rejected = await handleCreateHabit(request(), {
    verify: async () => actor,
    execute: async () => ({ outcome: "rejected", reason: "invalidPayload" }),
  });
  check(rejected.status === 422);
  const failed = await handleCreateHabit(request(), {
    verify: async () => actor,
    execute: async () => {
      throw new Error("secret details");
    },
  });
  check(failed.status === 503 && !(await failed.text()).includes("secret"));
});
