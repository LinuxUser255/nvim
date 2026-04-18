-- DISABLED: Duplicate plugin definition causing key delays
-- See which-key.lua for the canonical (also disabled) configuration
return {
	'folke/which-key.nvim',
	enabled = false,  -- Disabled: was causing Enter key delays in netrw
	opts = {},
}
