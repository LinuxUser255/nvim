# tsc.nvim (dmmulroy/tsc.nvim)

What it is
- Run TypeScript compiler from Neovim with quickfix integration and progress.

Use cases
- Check TypeScript project errors without leaving Neovim.

Commands
- :TSC — run tsc with configured options (auto opens quickfix in this setup)

Modify
- Edit lua/plugins/typescript.lua or lua/plugins/typescript-extras.lua for options (auto_open_qflist, notifications, spinner, pretty_errors).
