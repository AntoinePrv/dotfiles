require("nvim-treesitter.configs").setup({
    ensure_installed = "all",

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "v]",   -- Intuitively a "visual" mode
            scope_incremental = "]",
            node_incremental = "=",  -- Key for +
            node_decremental = "-",  -- Key for -
        },
    },

    indent = { enable = false },

    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["ip"] = { query = "@parameter.inner", desc = "Select inner part of a parameter." },
                ["ap"] = { query = "@parameter.outer", desc = "Select outter part of a parameter." },
                ["ib"] = { query = "@block.inner", desc = "Select inner part of a block." },
                ["ab"] = { query = "@block.outer", desc = "Select outter part of a block." },
                ["if"] = { query = "@function.inner", desc = "Select inner part of a function." },
                ["af"] = { query = "@function.outer", desc = "Select outter part of a function." },
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class." },
                ["ac"] = { query = "@class.outter", desc = "Select outter part of a class." },
                ["a/"] = { query = "@comment.outer", desc = "Select outter part of a comment." },
            },
            selection_modes = {
                -- charwise v
                ["@parameter.inner"] = "v",
                ["@parameter.outer"] = "v",
                -- linewise V
                ["@block.inner"] = "V",
                ["@block.outer"] = "V",
                ["@function.inner"] = "V",
                ["@function.outer"] = "V",
                ["@class.inner"] = "V",
                ["@class.outer"] = "V",
                -- blockwise <c-v>
            },
            include_surrounding_whitespace = false,
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]p"] = { query = "@parameter.inner", desc = "Start of next parameter." },
                ["]f"] = { query = "@function.outer", desc = "Start of next function." },
                ["]c"] = { query = "@class.outer", desc = "Start of next class." },
            },
            goto_previous_start = {
                ["[p"] = { query = "@parameter.inner", desc = "Start of previous parameter." },
                ["[f"] = { query = "@function.outer", desc = "Start of previous function." },
                ["[c"] = { query = "@class.outer", desc = "Start of previous class." },
            },
            goto_next_end = {
                ["]P"] = { query = "@parameter.inner", desc = "Start of next parameter." },
                ["]F"] = { query = "@function.outer", desc = "Start of next function." },
                ["]C"] = { query = "@class.outer", desc = "Start of next class." },
            },
            goto_previous_end = {
                ["[P"] = { query = "@parameter.inner", desc = "Start of previous parameter." },
                ["[F"] = { query = "@function.outer", desc = "Start of previous function." },
                ["[C"] = { query = "@class.outer", desc = "Start of previous class." },
            },
        },
    },
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
