
#  Fix: rust-analyzer `checkOnSave` Invalid Type Warning


##  Problem

**When opening a Rust file in Neovim with `rust-tools.nvim`, you may see this warning:**

```bash

LSP\[rust\_analyzer]\[Warning] invalid config value:
/checkOnSave: invalid type: map, expected a boolean;

````

---


**The configuration:**

```lua
checkOnSave = {
  command = "clippy",
}
````

...is no longer valid. As of recent `rust-analyzer` versions, `checkOnSave`
**must be a boolean**.

**The command and related fields now belong under a new
top-level key: `check`.**

---

## Solution

Update your config to:

```lua
["rust-analyzer"] = {
  checkOnSave = true,
  check = {
    command = "clippy",
  },
}
```

---

##  Example with rust-tools.nvim

```lua
require("rust-tools").setup({
  server = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = true,
        check = {
          command = "clippy",
        },
        inlayHints = {
          bindingModeHints = { enable = true },
          closureReturnTypeHints = { enable = true },
          lifetimeElisionHints = { enable = true, useParameterNames = true },
          reborrowHints = { enable = true },
        },
      },
    },
  },
})
```

---

## Environment

* **Neovim:** `0.10+`
* **Plugin:** `simrat39/rust-tools.nvim`
* **LSP:** `rust-analyzer (2025 or later)`

---

