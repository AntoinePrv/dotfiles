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

function alternate_files()
	telescope_builtin.git_files({
		show_untracked=true,
		default_text=vim.fn.expand('%:t:r'):gsub("-", ""):gsub("_", ""):gsub("test", ""),
	})
end

vim.keymap.set("n", "gf", function() telescope_builtin.git_files({show_untracked=true}) end, {})
vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, {})
vim.keymap.set("n", "gt", telescope_builtin.lsp_type_definitions, {})
vim.keymap.set("n", "gr", telescope_builtin.lsp_references, {})
vim.keymap.set("n", "gs", telescope_builtin.lsp_document_symbols, {})
vim.keymap.set("n", "gS", telescope_builtin.lsp_workspace_symbols, {})
vim.keymap.set("n", "ge", function() telescope_builtin.diagnostics({bufnr=0}) end, {})
vim.keymap.set("n", "gE", telescope_builtin.diagnostics, {})
vim.keymap.set("n", "g*", telescope_builtin.grep_string, {})
vim.keymap.set("n", "g/", telescope_builtin.current_buffer_fuzzy_find, {})
vim.keymap.set("n", "gg", telescope_builtin.live_grep, {})
vim.keymap.set("n", "gb", telescope_builtin.buffers, {})
vim.keymap.set("n", "<tab><tab>", alternate_files, {})
vim.keymap.set("n", "gh", telescope_builtin.help_tags, {})
vim.keymap.set("n", "gm", telescope_builtin.marks, {})
vim.keymap.set("n", "gc", telescope_builtin.quickfix, {})


-- Customizing VIM UI callbacks

telescope_ui = require("telescope").load_extension("ui-select")

require("dressing").setup({
	select={enable=false},--UsingTelescopehere
	input={
		default_prompt="Input",
		title_pos="center",
		insert_only=false,
		start_in_insert=true,
		border="single",
		relative="editor",
		--Thesecanbeintegersorafloatbetween0and1(e.g.0.4for40%)
		prefer_width=.4,
		win_options={
			wrap=false,
			list=true,
			listchars="precedes:…,extends:…",
			sidescrolloff=0,
		},
		mappings={
			n={
				["<Esc>"]="Close",
				["<CR>"]="Confirm",
				["<Up>"]="HistoryPrev",
				["k"]="HistoryPrev",
				["<Down>"]="HistoryNext",
				["j"]="HistoryNext",
			},
			i={
				["<C-c>"]="Close",
				["<CR>"]="Confirm",
				["<Up>"]="HistoryPrev",
				["<Down>"]="HistoryNext",
			},
		},
		win_options={
			winhighlight=
			"FloatBorder:TelescopePromptBorder"
			.. ",FloatTitle:TelescopePromptTitle"
			.. ",NormalFloat:TelescopePromptNormal"
		},
		override=function(config)
		-- Strip last space and colon from potential title
			config.title = config.title:match("(.-):%s*$") .. " "  
			return config
		end,
	},
})
