# Plans

Index of plans for this repo, newest first. Each Spec Kit feature gets one section here, with
a status line and a link to its plan in `specs/<NNN-name>/plan.md`. The rule is in the
[constitution](.specify/memory/constitution.md), under Development Workflow.

## 2026-11-20 — Adopt Spec Kit

*Status: done. Squash-merged into `develop` on 2026-11-20; `feature/specs-init` is kept.*

This phase has no spec directory, because it sets up the workflow that later features use.

- [x] Create `main` and `develop` locally and initialise git-flow
- [x] Scaffold Spec Kit 1.2.3 with the Claude integration (`.specify/`, `.claude/skills/`)
- [x] Track [.gitignore](.gitignore), with exceptions for the Spec Kit files
- [x] Draft constitution 1.0.0 from the README and the code
- [x] Create this index
- [x] Rename `master` to `main` on the remote and make it the default branch
- [x] Remove the Sync Impact Report comment from the constitution and commit
- [x] Finish the branch with a squash-merge into `develop`
