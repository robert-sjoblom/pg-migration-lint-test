# pg-migration-lint action test repo

Exercises the `robert-sjoblom/pg-migration-lint` GitHub Action against the
migration conventions it supports:

- **`go-migrate-app/`** — plain SQL, `filename_lexicographic` strategy,
  go-migrate's `<timestamp>_<name>.up.sql`/`.down.sql` naming.
- **`liquibase-app/`** — Liquibase XML changelogs, one changeset per file
  (`migrations.xml` master + one included changelog per changeset),
  `liquibase` strategy.
- **`liquibase-domain-app/`** — Liquibase XML changelogs organized by
  *domain* instead: all changesets for a given subject area accumulate in
  one file over time (`changelog/master.xml` includes `users.xml` and
  `orders.xml`, each carrying several changesets), rather than one file
  per changeset. This is the shape Hard Problem #1 (line-filtering PR
  comments against diff hunks) was actually designed around — appending a
  changeset deep inside a file that already has several unrelated,
  pre-existing changesets is what makes "only the new changeset's line is
  in the diff" a real routing problem, not a trivial one.

Both Liquibase paths' workflows download `liquibase-bridge.jar` separately
and point `bridge_jar_path` at it, since it isn't part of the action's own
release bundle.

All three start from a clean baseline (`users`, `orders`, `order_items`)
with no lint findings.

## Known limitation being tested around

The action's PR-comment markers aren't scoped per invocation. A single PR
touching both `go-migrate-app/` and `liquibase-app/` would make the second
workflow's run delete the first one's comments before posting its own.
Until that's fixed, test each path in its own PR.
