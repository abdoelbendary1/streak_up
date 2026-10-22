// Run against the isolated HTTP fixture; all persistence is actual PostgreSQL.
const url = Deno.env.get("HABIT_REMOTE_TEST_URL")!;
const token = "isolated-test-token";
const payload = {
  name: "Remote test",
  description: "",
  category: null,
  targetMinutes: null,
  visibility: "private",
  schedule: { frequency: "daily", weekdays: [], timezone: "Africa/Cairo" },
};
async function post(command: unknown, authorization = token) {
  return await fetch(url, {
    method: "POST",
    headers: { Authorization: `Bearer ${authorization}` },
    body: JSON.stringify(command),
  });
}
function check(ok: boolean) {
  if (!ok) throw new Error("Assertion failed");
}
Deno.test("concurrent duplicate requests return identical canonical receipt", async () => {
  const command = {
    commandId: crypto.randomUUID(),
    entityId: crypto.randomUUID(),
    version: 1,
    payload,
  };
  const results = await Promise.all(Array.from({ length: 12 }, async () => {
    const response = await post(command);
    check(response.status === 200);
    return await response.json();
  }));
  check(
    results.every((result) =>
      JSON.stringify(result) === JSON.stringify(results[0])
    ),
  );
  const replay = await post(command);
  check(JSON.stringify(await replay.json()) === JSON.stringify(results[0]));
  const changed = await post({
    ...command,
    payload: { ...payload, name: "Changed" },
  });
  check(
    changed.status === 422 && (await changed.json()).reason === "commandReused",
  );
  const collision = await post({ ...command, commandId: crypto.randomUUID() });
  check(
    collision.status === 422 &&
      (await collision.json()).reason === "entityExists",
  );
});
Deno.test("HTTP unauthorized and forged owner cannot create", async () => {
  const command = {
    commandId: crypto.randomUUID(),
    entityId: crypto.randomUUID(),
    version: 1,
    payload,
  };
  const unauthorized = await post(command, "wrong-token");
  check(unauthorized.status === 401);
  await unauthorized.body?.cancel();
  const forged = await post({
    ...command,
    payload: { ...payload, ownerId: crypto.randomUUID() },
  });
  check(
    forged.status === 422 && (await forged.json()).reason === "invalidPayload",
  );
});
