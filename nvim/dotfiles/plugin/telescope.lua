local telescope_actions=require("telescope.actions")
local telescope_builtin=require("telescope.builtin")
local telescope_themes=require("telescope.themes")


require("telescope").setup({
	defaults={
		mappings={
			-- Telescope insert mode mappings
			i={
				["<esc>"]=telescope_actions.close
			},
		},
		layout_config={
			prompt_position="top",
		},
		results_title=false,
		prompt_prefix="  ",
		selection_caret=" ",
		sorting_strategy="ascending",
		border=true,
		borderchars={"─", "│", "─", "│", "┌", "┐", "┘", "└"},
		color_devicons=true,
		file_ignore_patterns={"%.orig", "%.swap"},
	},
	extensions={
		["ui-select"]={
			previewer=false,
			layout_strategy="center",
			borderchars={
				prompt={"─", "│", "─", "│", "┌", "┐", "┘", "└"},
				results={"─", "│", "─", "│", "├", "┤", "┘", "└"},
			},
		}
	}
})

telescope_ui = require("telescope").load_extension("ui-select")

vim.keymap.set("n", "gf", function() telescope_builtin.git_files({show_untracked=true}) end, {})
vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, {})
vim.keymap.set("n", "gt", telescope_builtin.lsp_type_definitions, {})
vim.keymap.set("n", "gr", telescope_builtin.lsp_references, {})
vim.keymap.set("n", "gs", telescope_builtin.lsp_document_symbols, {})
vim.keymap.set("n", "gS", telescope_builtin.lsp_workspace_symbols, {})
vim.keymap.set("n", "ge", function() telescope_builtin.diagnostics({bufnr=0}) end, {})
vim.keymap.set("n", "gE", telescope_builtin.diagnostics, {})
vim.keymap.set("n", "g*", telescope_builtin.grep_string, {})
vim.keymap.set("n", "g/", telescope_builtin.live_grep, {})
vim.keymap.set("n", "gb", telescope_builtin.buffers, {})
