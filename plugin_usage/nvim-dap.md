# nvim-dap (mfussenegger/nvim-dap)

What it is
- Debug Adapter Protocol client for Neovim.

Use cases
- Debug programs with breakpoints, stepping, watches, REPL, etc.

Key bindings
- <F5>: Continue
- <F10>: Step over
- <F11>: Step into
- <F12>: Step out
- <Leader>b: Toggle breakpoint
- <Leader>B: Conditional breakpoint
- <Leader>lp: Log point
- <Leader>dr: Open REPL
- <Leader>dl: Run last

Modify
- Edit lua/plugins/dap.lua (and language-specific files like lua/plugins/cpp.lua) to configure adapters and language-specific settings.

Companions
- rcarriga/nvim-dap-ui for UI panes
- mfussenegger/nvim-dap-python for Python
