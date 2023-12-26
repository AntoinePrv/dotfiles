-- Automatic install
local packer_url = "https://github.com/wbthomason/packer.nvim"
local packer_dir = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(packer_dir)) > 0 then
	packer_bootstrap = vim.fn.system({"git", "clone", "--depth", "1", packer_url, packer_dir})
	vim.cmd [[packadd packer.nvim]]
end

require("packer").startup({
	function(use)
		-- Plugin manager itself
		use "wbthomason/packer.nvim"

		-- General
		use "preservim/nerdcommenter"
		use "tpope/vim-sensible"
		use "tpope/vim-obsession"
		use "tpope/vim-sleuth"
		use "stefandtw/quickfix-reflector.vim"
		use "ton/vim-bufsurf"
		use "drzel/vim-scrolloff-fraction"
		use "windwp/nvim-autopairs"

		-- Colors themes
		use "tinted-theming/base16-vim"

		-- Visual
		use "vim-airline/vim-airline"
		use "vim-airline/vim-airline-themes"
		use "ryanoasis/vim-devicons"
		use "edluffy/specs.nvim"
		use "lukas-reineke/indent-blankline.nvim"
		use "luukvbaal/statuscol.nvim"

		-- Git support
		use {"lewis6991/gitsigns.nvim", requires={"nvim-lua/plenary.nvim"}}

		-- Completion and and syntax
		use {"nvim-treesitter/nvim-treesitter", run=":TSUpdate"}
		use "nvim-treesitter/nvim-treesitter-textobjects"
		use "rbberger/vim-singularity-syntax"
		use "neovim/nvim-lspconfig"
		use "hrsh7th/cmp-nvim-lsp"
		use "hrsh7th/cmp-nvim-lsp-signature-help"
		use "hrsh7th/cmp-buffer"
		use "hrsh7th/cmp-path"
		use "hrsh7th/cmp-cmdline"
		use "hrsh7th/vim-vsnip"
		use "hrsh7th/cmp-vsnip"
		use "ray-x/cmp-treesitter"
		use "hrsh7th/nvim-cmp"

		-- Telescope and other Windows
		use {
			"nvim-telescope/telescope.nvim", tag = "0.1.3",
			requires = {{"nvim-lua/plenary.nvim"}, {"nvim-tree/nvim-web-devicons"}}
		}
		use "nvim-telescope/telescope-ui-select.nvim"
		use "stevearc/dressing.nvim"

		-- Tmux integration
		use "christoomey/vim-tmux-navigator"
		use "tmux-plugins/vim-tmux-focus-events"

		-- Plugins for outside of vim
		use "edkolev/tmuxline.vim"
		use "edkolev/promptline.vim"

		-- Local files loaded with plugin manager
		use {vim.fn.expand("<sfile>:p:h") .. "/dotfiles"}

		-- Automatically set up your configuration after cloning packer.nvim (at the end)
		if packer_bootstrap then
			require("packer").sync()
		end
	end,

	config={
		compile_path=vim.fn.stdpath("data") .. "/site/plugin/packer_compiled.lua"
	}
})
