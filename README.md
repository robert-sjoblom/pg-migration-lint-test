# pg-migration-lint action test repo

Exercises the `robert-sjoblom/pg-migration-lint` GitHub Action against the
migration conventions it supports:

- **`go-migrate-app/`** — plain SQL, `filename_lexicographic` strategy,
  go-migrate's `<timestamp>_<name>.up.sql`/`.down.sql` naming.
- **`liquibase-app/`** — Liquibase XML changelogs, `liquibase` strategy
  (`migrations.xml` master + included changelogs). Each included file
  here happens to hold a single changeset — not a convention, just the
  simplest shape: a new changeset always lands in a brand-new file, so
  there's no pre-existing content in that file for a PR's diff to
  partially overlap.
- **`liquibase-domain-app/`** — same strategy, but changesets accumulate
  in a handful of per-domain files over time instead
  (`changelog/master.xml` includes `users.xml` and `orders.xml`, each
  already carrying several changesets) — closer to how most real
  Liquibase projects actually grow: changesets get added to whichever
  file covers that subject area, however many already live there. This
  is the shape Hard Problem #1 (line-filtering PR comments against diff
  hunks) is actually designed around — appending a changeset deep inside
  a file that already has several unrelated, pre-existing changesets is
  what makes "only the new changeset's line is in the diff" a real
  routing problem, not a trivial one.

Both Liquibase paths' workflows download `liquibase-bridge.jar` separately
and point `bridge_jar_path` at it, since it isn't part of the action's own
release bundle.

All three start from a clean baseline (`users`, `orders`, `order_items`)
with no lint findings.

## Known limitation being tested around

The action's PR-comment markers aren't scoped per invocation. A single PR
touching more than one of these three paths would make each subsequent
workflow's run delete the previous one's comments before posting its own.
Until that's fixed, test each path in its own PR.
