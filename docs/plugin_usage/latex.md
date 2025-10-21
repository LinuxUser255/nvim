# LaTeX support

What it is
- Treesitter parser updates are configured to ensure LaTeX/Markdown parsing is up to date.

Use cases
- Better highlighting and structure for LaTeX/Markdown files.

Modify
- See lua/plugins/latex.lua (invokes nvim-treesitter update). For broader LaTeX workflows (build/view), consider adding a plugin like lervag/vimtex.
