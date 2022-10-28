local telescope_actions = require("telescope.actions")
local telescope_builtin = require("telescope.builtin")


require("telescope").setup({
	defaults = {
		mappings = {
			-- Telescope insert mode mappings
			i = {
				["<esc>"] = telescope_actions.close
			},
		},
		layout_config = {
		},
		prompt_prefix = "  ",
		selection_caret = " ",
		border = true,
		borderchars = {"─", "│", "─", "│", "┌", "┐", "┘", "└"},
		color_devicons = true,
		file_ignore_patterns = {"%.orig"},
	},
})

vim.keymap.set("n", "<leader>p", telescope_builtin.find_files, {})
