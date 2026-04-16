# Learnings

This file captures durable repo-specific lessons that should survive individual
refactors.

## Durable Lessons

- This repo is intentionally opinionated, but it still needs a clean boundary between reusable workflow defaults and personal extras.
- Install safety matters more than cleverness. Managed installs should stage, validate, and then activate.
- Docs, validator behavior, bootstrap steps, and helper CLI help text can drift easily. Treat that drift as a real bug.
- Kitty is the canonical place for visible session identity. tmux status remains off by design.
- `dev` is a workflow command for opening and managing project sessions, not a place to build an ever-expanding command framework.
- AI usage here is inspect-first. Agents and humans should read the repo, search it, and review diffs rather than blindly accept generated changes.
- Apple Silicon macOS is the supported automation target. Intel compatibility is not a planning priority.
- Native installers are preferred over npm globals when official support exists and the native path is stable.
- The curriculum under `docs/` is part of the product, not secondary documentation. If commands or defaults change, the lessons need to change too.
- Optional tools should stay optional unless there is a strong reason to move them into the required path.

## Practical Implication

When in doubt, optimize for:

- safer install/update behavior
- lower drift between code and docs
- clearer ownership between Kitty, tmux, Neovim, and zsh
- operational simplicity over novelty

## Related Canonical Docs

- [`USAGE.md`](USAGE.md)
- [`ARCHITECTURE.md`](ARCHITECTURE.md)
- [`DEVELOPMENT.md`](DEVELOPMENT.md)
