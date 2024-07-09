local colors_ansi = {
    black = 0, -- background, is white in light-mode
    red = 1,
    green = 2,
    yellow = 3,
    blue = 4,
    magenta = 5,
    cyan = 6,
    white = 7, -- foreground, is black in dark-mode
}

function load_base16_vars(css)
    local variables = {}

    -- Iterate over each line in the string
    for line in css:gmatch("[^\r\n]+") do
        -- Capture variable name and value
        local name, value = line:match("%s*%-%-(%w+):%s*(#%x+);")
        if name and value then
            variables[name] = value
        end
    end

    return variables
end

local function tinty_path()
	return os.getenv("USER_TINTED_THEMING_DIR") .. "/css-output-css-variables-file.css"
end

-- Return the content from a string or return some default content
local function read_base16_file()
	local file = io.open(tinty_path(), "r")
    local content = file:read("*a")
    file:close()
    return load_base16_vars(content)
end

-- FIXME this is is not reloaded, we need to use highlight groups
local colors = read_base16_file()

local theme = {
    normal = {
        a = { bg = colors.base0D, fg = colors.base06, gui = "bold" },
        b = { bg = colors.base03, fg = colors.base06 },
        c = { bg = colors.base02, fg = colors.base06 },
    },
    insert = {
        a = { bg = colors.base0B, fg = colors.base06, gui = "bold" },
    },
    visual = {
        a = { bg = colors.base0E, fg = colors.base06, gui = "bold" },
    },
    replace = {
        a = { bg = colors.base08, fg = colors.base06, gui = "bold" },
    },
    command = {
        a = { bg = colors.base03, fg = colors.base06, gui = "bold" },
        b = { bg = colors.base02, fg = colors.base06 },
        c = { bg = colors.base01, fg = colors.base06 },
    },
    inactive = {
        a = { bg = colors.base03, fg = colors.base06, gui = "bold" },
        b = { bg = colors.base02, fg = colors.base06 },
        c = { bg = colors.base01, fg = colors.base06 },
    },
}

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
        {
            "diff",
            diff_color = {
                added = { fg = colors.base0B },
                modified = { fg = colors.base0E },
                removed = { fg = colors.base08 },
            },
        },
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
            diagnostics_color = {
                error = { fg = colors.base08 },
                warn = { fg = colors.base0A },
                info = { fg = colors.base0D },
                hint = { fg = colors.base0C },
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
        theme = theme,
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
