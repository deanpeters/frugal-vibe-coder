# Reference

Quick-lookup material for when you need to find something without reading a full guide.

---

## What's here

| File | Use it when you need to... |
|------|--------------------------|
| [config-locations.md](config-locations.md) | Find where a tool stores its settings on your machine |
| [tool-map.md](tool-map.md) | Get a quick overview of every tool in this repo |
| [my-setup.md](my-setup.md) | See what's installed on your machine and where its config lives |
| `setup-progress.env` | Let the guided Mac/Linux setup resume from the last unfinished step after an interruption |

---

## About my-setup.md

`my-setup.md` is a local-only file written and updated by the install scripts in this repo. It records everything installed on your machine — versions, config locations, and which learning surface each tool supports.

It is gitignored and never committed. It lives only on your machine.

If it doesn't exist yet, it means you haven't run any of the install scripts. Follow the [setup guides](../setup/README.md) to get started — they will create it automatically.

If you rerun setup later, the scripts update the relevant sections instead of stacking duplicate sections on top of each other.

If you want to see what the file will look like when it's populated, see [my-setup.template.md](my-setup.template.md).

## About setup-progress.env

`setup-progress.env` is a local-only checkpoint file used by the guided setup scripts in this repo.

If setup gets interrupted halfway through, the next run can continue from the next unfinished step instead of making you mentally reconstruct where things stopped. The file is gitignored and lives only on your machine.
