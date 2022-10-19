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

		-- Local files loaded with plugin manager
		use {vim.fn.expand("<sfile>:p:h") .. "/dotfiles"}

		-- General
		use "preservim/nerdcommenter"
		use "tpope/vim-sensible"
		use "tpope/vim-obsession"
		use "stefandtw/quickfix-reflector.vim"
		use {"drzel/vim-scrolloff-fraction", commit="c4e543a9d9da6382f00c9f3c170d5c5def1f77f0"}
		use {"junegunn/fzf", tag="0.27.0", run="fzf#install()"}

		-- Colors themes
		use "tinted-theming/base16-vim"

		-- Visual
		use "vim-airline/vim-airline"
		use "vim-airline/vim-airline-themes"
		use "ryanoasis/vim-devicons"
		use "edluffy/specs.nvim"

		-- Git support
		use {"lewis6991/gitsigns.nvim", requires={"nvim-lua/plenary.nvim"}}

		-- Completion and and syntax
		use {"nvim-treesitter/nvim-treesitter", run=":TSUpdate"}
		use "rbberger/vim-singularity-syntax"
		use "neovim/nvim-lspconfig"
		use "hrsh7th/cmp-nvim-lsp"
		use "hrsh7th/cmp-buffer"
		use "hrsh7th/cmp-path"
		use "hrsh7th/cmp-cmdline"
		use "hrsh7th/vim-vsnip"
		use "hrsh7th/cmp-vsnip"
		use "hrsh7th/nvim-cmp"

		-- Tmux integration
		use "christoomey/vim-tmux-navigator"
		use "tmux-plugins/vim-tmux-focus-events"

		-- Plugins for outside of vim
		use "edkolev/tmuxline.vim"
		use "edkolev/promptline.vim"

		-- Automatically set up your configuration after cloning packer.nvim (at the end)
		if packer_bootstrap then
			require("packer").sync()
		end
	end,

	config={
		compile_path=vim.fn.stdpath("data") .. "/site/plugin/packer_compiled.lua"
	}
})
