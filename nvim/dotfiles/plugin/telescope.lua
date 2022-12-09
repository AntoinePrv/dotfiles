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
		results_title = false,
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
			layout_strategy = "center",
			borderchars = {
				prompt={"─", "│", "─", "│", "┌", "┐", "┘", "└"},
				results={"─", "│", "─", "│", "├", "┤", "┘", "└"},
			},
		}
	}
})

require("telescope").load_extension("ui-select")

vim.keymap.set("n", "gf", function() telescope_builtin.git_files({show_untracked=true}) end, {})
vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, {})
vim.keymap.set("n", "gt", telescope_builtin.lsp_type_definitions, {})
vim.keymap.set("n", "gr", telescope_builtin.lsp_references, {})
vim.keymap.set("n", "gs", telescope_builtin.lsp_document_symbols, {})
