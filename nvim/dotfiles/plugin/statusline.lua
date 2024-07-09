local symbols = {
    file_modified = "",
    file_readonly = "",
    file_unnamed = "[...]",
    file_newfile = "",
    error = " ",
    warning = " ",
    info = " ",
    hint = " ",
}

local lualine_sections = {
    lualine_a = {},
    lualine_b = {
        {
            "filename",
            path = 1,
            symbols = {
                modified = symbols.file_modified,
                readonly = symbols.file_readonly,
                unnamed = symbols.file_unnamed,
                newfile = symbols.file_newfile,
            },
        },
        { "diff" },
    },

    lualine_c = { "encoding", "fileformat", "filetype" },
    lualine_x = {},
    lualine_y = {
        {
            "diagnostics",
            sections = { "error", "warn" },
            symbols = {
                error = symbols.error,
                warn = symbols.warning,
                info = symbols.info,
                hint = symbols.hint,
            },
            colored = true,
            update_in_insert = false,
            always_visible = false,
        },
    },
    lualine_z = { "location", "progress", "searchcount" },
}

require("lualine").setup({
    options = {
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
    },
    sections = lualine_sections,
    inactive_sections = lualine_sections,
    tabline = {
        lualine_b = {
            {
                "tabs",
                mode = 1,
                symbols = { modified = symbols.file_modified },
            },
        },
        lualine_z = { "mode" },
    },
    winbar = lualine_winbar,
    inactive_winbar = lualine_winbar,
    extensions = {},
})
