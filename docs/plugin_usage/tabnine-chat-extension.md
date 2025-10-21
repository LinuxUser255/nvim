# Tabnine Chat Extension (local plugin)

What it is
- Local extension for Tabnine Chat that adjusts font size and window appearance (especially in Neovide/GUI).

Use cases
- Improve readability and control of the Chat window.

Commands/Key bindings
- :TabnineChatFontSize {size} — set chat font size (GUI only)
- <leader>tcf — prompt to set chat font size
- Chat window appearance auto-adjusts on FileType tabnine-chat

Modify
- Edit lua/plugins/tabnine-chat.lua and lua/custom/tabnine-chat/init.lua to change behavior.
