# pg-migration-lint action test repo

Exercises the `robert-sjoblom/pg-migration-lint` GitHub Action against both
migration conventions it supports:

- **`go-migrate-app/`** — plain SQL, `filename_lexicographic` strategy,
  go-migrate's `<timestamp>_<name>.up.sql`/`.down.sql` naming.
- **`liquibase-app/`** — Liquibase XML changelogs (`migrations.xml` master +
  one included changelog per changeset), `liquibase` strategy. The bridge
  JAR isn't part of the action's own release bundle, so this path's
  workflow downloads `liquibase-bridge.jar` separately and points
  `bridge_jar_path` at it.

Both start from a clean baseline (three tables: `users`, `orders`,
`order_items`) with no lint findings.

## Known limitation being tested around

The action's PR-comment markers aren't scoped per invocation. A single PR
touching both `go-migrate-app/` and `liquibase-app/` would make the second
workflow's run delete the first one's comments before posting its own.
Until that's fixed, test each path in its own PR.
