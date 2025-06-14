-- Automatic install
local packer_url = "https://github.com/wbthomason/packer.nvim"
local packer_dir = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local packer_bootstrap
if vim.fn.empty(vim.fn.glob(packer_dir)) > 0 then
    packer_bootstrap = vim.fn.system({ "git", "clone", "--depth", "1", packer_url, packer_dir })
    vim.cmd([[packadd packer.nvim]])
end

require("packer").startup({
    function(use)
        -- Plugin manager itself
        use("wbthomason/packer.nvim")

        -- General
        use("preservim/nerdcommenter")
        use("tpope/vim-sensible")
        use("tpope/vim-obsession")
        use("tpope/vim-sleuth")
        use("stefandtw/quickfix-reflector.vim")
        use("ton/vim-bufsurf")
        use("nvimdev/hlsearch.nvim")
        use("drzel/vim-scrolloff-fraction")

        -- Colors themes
        -- TODO consider echasnovski/mini.base16 when migrated to neovim 0.10
        use({
            -- "tinted-theming/base16-vim"
            -- https://github.com/tinted-theming/base16-vim/pull/82 but missing rerender
            "AntoinePrv/fork-tinted-theming-base16-vim",
            branch = "nvim-0.10-rendered",
        })

        -- Visual
        use({
            "nvim-lualine/lualine.nvim",
            requires = { "nvim-tree/nvim-web-devicons", opt = true },
        })
        use("ryanoasis/vim-devicons")
        use({
            -- https://github.com/edluffy/specs.nvim/pull/30
            -- https://github.com/edluffy/specs.nvim/issues/31
            -- "edluffy/specs.nvim"
            "AntoinePrv/specs.nvim",
        })
        use("lukas-reineke/indent-blankline.nvim")
        use("lukas-reineke/virt-column.nvim")
        use("luukvbaal/statuscol.nvim")
        use({
            "MeanderingProgrammer/render-markdown.nvim",
            requires = { "nvim-tree/nvim-web-devicons", opt = true },
        })

        -- Git support
        use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })

        -- Completion and and syntax
        -- Crashed cpp parser last update (?)
        use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
        use("nvim-treesitter/nvim-treesitter-textobjects")
        use("rbberger/vim-singularity-syntax")
        use({ "neovim/nvim-lspconfig", tag = "v2.0.0" })
        use("hrsh7th/cmp-nvim-lsp")
        use("hrsh7th/cmp-nvim-lsp-signature-help")
        use("hrsh7th/cmp-buffer")
        use("hrsh7th/cmp-path")
        use("hrsh7th/cmp-cmdline")
        use("hrsh7th/vim-vsnip")
        use("hrsh7th/cmp-vsnip")
        use("ray-x/cmp-treesitter")
        use("hrsh7th/nvim-cmp")
        use("b0o/schemastore.nvim")
        use("windwp/nvim-autopairs")
        use("windwp/nvim-ts-autotag")

        -- AI
        use({ "zbirenbaum/copilot.lua" }) -- For authenticating
        use({
            "olimorris/codecompanion.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter",
            },
        })

        -- Telescope and other Windows
        use({
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            requires = { { "nvim-lua/plenary.nvim" }, { "nvim-tree/nvim-web-devicons" } },
        })
        use("nvim-telescope/telescope-ui-select.nvim")
        use("nvim-telescope/telescope-live-grep-args.nvim")
        use("Marskey/telescope-sg")
        use("gbprod/yanky.nvim")
        -- TODO archived, use snacks.nvim
        use("stevearc/dressing.nvim")

        -- Tmux integration
        use("christoomey/vim-tmux-navigator")
        use("tmux-plugins/vim-tmux-focus-events")

        -- Local files loaded with plugin manager
        use({ vim.fn.expand("<sfile>:p:h") .. "/dotfiles" })

        -- Automatically set up your configuration after cloning packer.nvim (at the end)
        if packer_bootstrap then
            require("packer").sync()
        end
    end,

    config = {
        compile_path = vim.fn.stdpath("data") .. "/site/plugin/packer_compiled.lua",
    },
})
