# FixCursorHold (antoinemadec/FixCursorHold.nvim)

What it is
- Fixes the 'CursorHold' event to trigger more reliably, improving responsiveness for plugins depending on it.

Use cases
- Required by neotest and other plugins to avoid delayed UI updates.

Modify
- No configuration; loaded as a dependency in lua/plugins/cpp.lua and lua/plugins/python.lua.