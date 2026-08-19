-- Automatic install
local function bootstrap_pckr()
    local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

    --- @diagnostic disable-next-line: undefined-field
    if not (vim.uv or vim.loop).fs_stat(pckr_path) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/lewis6991/pckr.nvim",
            pckr_path,
        })
    end

    vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require("pckr").add({
    -- General
    "preservim/nerdcommenter",
    "tpope/vim-sensible",
    "tpope/vim-obsession",
    "tpope/vim-sleuth",
    "stefandtw/quickfix-reflector.vim",
    "ton/vim-bufsurf",
    "nvimdev/hlsearch.nvim",
    "drzel/vim-scrolloff-fraction",

    -- Colors themes
    -- TODO consider echasnovski/mini.base16 when migrated to neovim 0.10
    {
        -- "tinted-theming/base16-vim"
        -- https://github.com/tinted-theming/base16-vim/pull/82 but missing rerender
        "AntoinePrv/fork-tinted-theming-base16-vim",
        branch = "nvim-0.10-rendered",
    },

    -- Visual
    {
        "nvim-lualine/lualine.nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
    },
    "ryanoasis/vim-devicons",
    {
        -- https://github.com/edluffy/specs.nvim/pull/30
        -- https://github.com/edluffy/specs.nvim/issues/31
        -- "edluffy/specs.nvim"
        "AntoinePrv/specs.nvim",
    },
    "lukas-reineke/indent-blankline.nvim",
    "lukas-reineke/virt-column.nvim",
    "luukvbaal/statuscol.nvim",
    {
        "MeanderingProgrammer/render-markdown.nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
    },

    -- Git support
    { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } },

    -- Completion and syntax
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", branch = "main" },
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    "rbberger/vim-singularity-syntax",
    { "neovim/nvim-lspconfig", tag = "v2.10.0" },
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/vim-vsnip",
    "hrsh7th/cmp-vsnip",
    "ray-x/cmp-treesitter",
    "hrsh7th/nvim-cmp",
    "b0o/schemastore.nvim",
    "windwp/nvim-autopairs",
    "windwp/nvim-ts-autotag",

    -- AI
    "zbirenbaum/copilot.lua", -- For authenticating
    {
        "olimorris/codecompanion.nvim",
        tag = "v19.7.0",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },

    -- Telescope and other Windows
    {
        "nvim-telescope/telescope.nvim",
        tag = "v0.2.1",
        requires = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    "Marskey/telescope-sg",
    "gbprod/yanky.nvim",
    -- TODO archived, use snacks.nvim
    "stevearc/dressing.nvim",

    -- Tmux integration
    "tmux-plugins/vim-tmux-focus-events",

    -- Local files loaded with plugin manager
    vim.fn.expand("<sfile>:p:h") .. "/dotfiles",
})
