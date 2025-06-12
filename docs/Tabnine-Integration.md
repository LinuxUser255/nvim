## [Tabnine Neovim Integration](https://github.com/codota/tabnine-nvim/tree/master) 

**Tabnine provides AI-powered code completion and assistance features.**

### Tabnine Basic Features

| Mapping | Mode | Description |
|---------|------|-------------|
| `<Tab>` | Insert | Accept Tabnine suggestion |
| `<C-]>` | Insert | Dismiss Tabnine suggestion |
| `<leader>th` | Normal | Open Tabnine Hub |
| `<leader>tl` | Normal | Tabnine Login |
| `<leader>ts` | Normal | Tabnine Status |
| `<leader>tt` | Normal | Toggle Tabnine |
| `<leader>tn` | Normal | Next Tabnine suggestion |

<br>

### Tabnine Code Assistance

| Mapping | Mode | Description |
|---------|------|-------------|
| `<leader>tw` | Normal | Edit code with Tabnine |
| `<leader>tf` | Normal | Fix code with Tabnine |
| `<leader>te` | Normal | Explain code with Tabnine |
| `<leader>td` | Normal | Document code with Tabnine |
| `<leader>tg` | Normal | Generate test with Tabnine |

<br>

### [Tabnine Chat](https://github.com/codota/tabnine-nvim/tree/master?tab=readme-ov-file#tabnine-chat)

Tabnine Chat provides an interactive AI assistant for coding help directly in Neovim.

| Mapping | Mode | Description |
|---------|------|-------------|
| `<leader>tc` | Normal | Open Tabnine Chat |
| `<leader>tc` | Visual | Open Tabnine Chat with selected code |
| `<leader>tch` | Normal | View Tabnine Chat history |
| `<leader>tcn` | Normal | Start new Tabnine Chat session |

<br>

#### Using Tabnine Chat

1. Select code you want to discuss (optional)
2. Press `<leader>tc` to open Tabnine Chat
3. Type your question or request
4. Press Enter to send your message
5. View the AI response in the chat window
6. Continue the conversation as needed

Tabnine Chat can help with:
- Explaining code functionality
- Suggesting improvements
- Debugging issues
- Answering programming questions
- Providing code examples

**Note:** Tabnine Chat requires an active Tabnine account and may require a subscription for full functionality.

<br>

#### Advanced Tabnine Chat Commands

For convenience, several specialized Tabnine Chat commands are available:

| Mapping | Mode | Description |
|---------|------|-------------|
| `<leader>tce` | Normal/Visual | Explain code with Tabnine Chat |
| `<leader>tcr` | Normal/Visual | Refactor code with Tabnine Chat |
| `<leader>tco` | Normal/Visual | Optimize code with Tabnine Chat |
| `<leader>tcd` | Normal/Visual | Debug code with Tabnine Chat |

These commands automatically send your code to Tabnine Chat with specific prompts, saving you from typing common requests.

<br>

### Tabnine Chat Setup

If you encounter the error "Tabnine_chat binary not found", you need to build the chat binary:

1. Make sure you have Rust and Cargo installed:
```bash
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source $HOME/.cargo/env
  cargo build --release
 ```
   inside `chat/` directory

<br>

2. Navigate to the Tabnine chat directory and build the binary:
```bash
  cd ~/.local/share/nvim/lazy/tabnine-nvim/chat/
  cargo build --release
```

## Tabnine Configuration
You can customize Tabnine's behavior by modifying the configuration in `lua/plugins/tabnine.lua`:
```lua
require('tabnine').setup({
  disable_auto_comment = true,  -- Set to false to keep auto-comments
  accept_keymap = "<Tab>",      -- Change to your preferred key
  dismiss_keymap = "<C-]>",     -- Change to your preferred key
  debounce_ms = 800,            -- Adjust for performance vs. responsiveness
  suggestion_color = {gui = "#808080", cterm = 244},  -- Change suggestion color
  exclude_filetypes = {"TelescopePrompt"},  -- Add filetypes to exclude
})
```
<br>

### Troubleshooting Tabnine

**If you encounter issues with Tabnine, try the following:**

<br>

**1. Check Tabnine Status using this command in Neovim**
```bash
  :TabnineStatus
```
<br>

**2. Restart Tabnine:**
```bash
  :TabnineDisable
  :TabnineEnable
```
<br>

**3. Update Tabnine:**
```bash
  :Lazy update tabnine-nvim
```
<br>

**4. Clear Tabnine Cache:**
```base  
    rm -rf ~/.config/TabNine/
```
<br>

**5. Debug Tabnine:**
```bash
  :TabnineDebug
```

<br>

## Tabnine Privacy Considerations

Tabnine processes code on their servers to provide AI-powered suggestions. Consider the following:

  - Code snippets are sent to Tabnine's servers for processing

  - Enterprise tier offers local processing options

  - You can exclude sensitive files using .tabnine-ignore files (similar to .gitignore)

  - Review Tabnine's privacy policy for more details

  - Extending Tabnine Functionality

  - You can create custom Tabnine Chat commands for specific tasks:

<br>
 
**`tabnine-extensions.lua`**
```lua
-- Example: Create a command to generate documentation for a function
vim.api.nvim_create_user_command('TabnineChatDocumentFunction', function()
  local prompt = "Generate comprehensive documentation for this function:"
  require('custom.tabnine-chat').chat_with_prompt(prompt)
end, {})

-- Add a keymap for the new command
vim.keymap.set("n", "<leader>tcdf", "<cmd>TabnineChatDocumentFunction<CR>", 
  { desc = "Document function with Tabnine Chat" })
```

<br>


### [Tabnine](https://www.tabnine.com/) offers different subscription tiers with varying features:
1. Free Tier:
   - Basic code completions
   - Limited chat functionality
   -Public code model
     
     <br>

2. Pro Tier:
   - Enhanced code completions
   - Full chat functionality
   - Faster response times
   - Team collaboration features
   
<br>

3. Enterprise Tier:
   - Private code models 
   - Advanced security features 
   - Custom model training 
   - Dedicated support
   
 <br>

### I hope the extensive documentation on Tabnine integration helpful. 
### Feel free to submit a PR if something is missing, or to add more information.


 <br>

**Best,**

**- LinuxUser255**
 

### Neovim with Tabnine Chat 
![Tabnine-Chat-Neovim.png](images/Tabnine-Chat-Neovim.png)