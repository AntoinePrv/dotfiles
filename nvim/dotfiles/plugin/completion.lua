------------------------
-- Setup for nvim-cmp --
------------------------

local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local cmp_icons = {
    Text = "󰊄",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "",
    Variable = "𝒙",
    Class = "󰏗",
    Interface = "",
    Module = "󱒌",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "&",
    Folder = "",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "",
}

local cmp_sources = {
    buffer = "[󰈙]",
    nvim_lsp = "[󰗊]",
    nvim_lsp_signature_help = "[󰊕]",
    luasnip = "[]",
    nvim_lua = "[]",
    latex_symbols = "[󰿈]",
    treesitter = "[]",
}

-- Check whether there are words before the cursor
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Call a given key in Nvim
local feed_key = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- Code completion in buffer
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    completion = {
        autocomplete = false,
    },
    experimental = { ghost_text = true },
    mapping = {
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        -- Super-Tab like mapping
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
                cmp.complete()
            else
                fallback() -- The fallback function sends a already mapped key
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, { "i", "s" }),
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            vim_item.kind = string.format("%s ", cmp_icons[vim_item.kind])
            vim_item.menu = cmp_sources[entry.source.name]
            return vim_item
        end,
    },
    -- Only show buffer source when the first set is not available.
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
    }, {
        { name = "treesitter" },
        { name = "vsnip" },
        {
            name = "path",
            option = {
                get_cwd = function(params)
                    return vim.fn.getcwd()
                end,
            },
        },
        { name = "buffer" },
    }),
})

-- Completion for "/" search
cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
})

-- Completion for ":" commands
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})

-------------------------
-- Setup for lspconfig --
-------------------------

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Mappings.
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>s", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set(
        "n",
        "[t", -- memo: [tip
        function()
            vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.HINT })
        end,
        opts
    )
    vim.keymap.set(
        "n",
        "]t", -- memo: ]tip
        function()
            vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.HINT })
        end,
        opts
    )
    vim.keymap.set("n", "[i", function()
        vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.INFO })
    end, opts)
    vim.keymap.set("n", "]i", function()
        vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.INFO })
    end, opts)
    vim.keymap.set("n", "[w", function()
        vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.WARN })
    end, opts)
    vim.keymap.set("n", "]w", function()
        vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.WARN })
    end, opts)
    vim.keymap.set("n", "[e", function()
        vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
    end, opts)
    vim.keymap.set("n", "]e", function()
        vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
    end, opts)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, opts)
end

local nvim_lsp = require("lspconfig")

local function merge_tables(a, b)
    local merged = {}
    for k, v in pairs(b) do
        merged[k] = v
    end
    for k, v in pairs(a) do
        merged[k] = v
    end
    return merged
end

-- Fetch lsp completion source
local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

local server_setup = {
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
}

-- Map buffer local keybindings when the language server attaches.
-- :help lspconfig-server-configurations for LSP servers.
local servers = {
    -- Ruff does not provide completion
    "ruff",
    "pylsp",
    -- Clangd cmake for C/C++
    "clangd",
    -- vscode-langservers-extracted
    -- "eslint", "cssls", "html",
}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup(server_setup)
end

nvim_lsp.clangd.setup(merge_tables(server_setup, {
    cmd = {
        "clangd",
        "--all-scopes-completion",
        "--clang-tidy",
        "--background-index",
        "--header-insertion=iwyu",
        "--function-arg-placeholders",
        "--completion-style=detailed",
        "--limit-results=1000000",
    },
}))

nvim_lsp.neocmake.setup(merge_tables(server_setup, {
    init_options = {
        format = { enable = true },
        lint = { enable = true },
    },
}))

nvim_lsp.lua_ls.setup(merge_tables(server_setup, {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                (path ~= vim.fn.stdpath("config"))
                and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                version = "LuaJIT",
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
        })
    end,
    settings = {
        Lua = {},
    },
}))

if vim.fn.executable("typos-lsp") == 1 then
    nvim_lsp.typos_lsp.setup(server_setup)
end

-- typescript-language-server typescript
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ts_ls
nvim_lsp.ts_ls.setup(merge_tables(server_setup, {
    cmd = { "npx", "--no-install", "typescript-language-server", "--stdio" },
    root_dir = nvim_lsp.util.root_pattern("tsconfig.json", "package.json"),
}))

-- @tailwindcss/language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tailwindcss
nvim_lsp.tailwindcss.setup(
    merge_tables(server_setup, { cmd = { "npx", "--no-install", "tailwindcss-language-server", "--stdio" } })
)

-- vscode-langservers-extracted

-- @biomejs/biome
nvim_lsp.biome.setup(
    merge_tables(server_setup, { root_dir = nvim_lsp.util.root_pattern("biome.json", "biome.jsonc", "package.json") })
)

-- vscode-langservers-extracted
nvim_lsp.jsonls.setup(merge_tables(server_setup, {
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
}))

nvim_lsp.rust_analyzer.setup({
    on_attach = on_attach,
})

-----------------------------
-- Configuring builtin LSP --
-----------------------------

-- TODO refactor to use same symbols table with lualine
vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
        texthl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 500

local function any_floating_win_open()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= "" then
            return true
        end
    end
    return false
end

vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
        if any_floating_win_open() then
            return
        end
        vim.diagnostic.open_float(nil, {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            source = "always",
            prefix = " ",
            scope = "cursor",
            noautocmd = true,
        })
    end,
})
