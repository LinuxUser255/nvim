# nvim-dap-ui (rcarriga/nvim-dap-ui)

What it is
- UI for nvim-dap providing scopes, breakpoints, watches, stacks, and console panes.

Use cases
- Visualize debugging state alongside code.

Behavior
- Auto-opens on debug start and closes when sessions end (per config).

Modify
- Edit lua/plugins/dap.lua and lua/plugins/cpp.lua/python.lua for dap-ui setup and listener hooks.

Dependencies
- mfussenegger/nvim-dap, nvim-neotest/nvim-nio
