vim.api.nvim_create_user_command("Temp", function(opts)
    if opts.args == "clear" then
        vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
        return
    end

    local ext = vim.fn.expand("%:e")
    if ext == "" then
        return
    end

    local template_name = opts.args == "" and "default" or opts.args

    local local_filename = "." .. template_name .. "." .. ext .. ".nvim"
    local builtin_filename = template_name .. "." .. ext

    local local_path = vim.fs.joinpath(
        vim.fn.getcwd(),
        local_filename
    )

    local template_dir = vim.fs.joinpath(
        vim.fn.stdpath("config"),
        "lua",
        "commands",
        "templates"
    )

    local builtin_path = vim.fs.joinpath(
        template_dir,
        builtin_filename
    )

    local path

    if vim.fn.filereadable(local_path) == 1 then
        path = local_path
    elseif vim.fn.filereadable(builtin_path) == 1 then
        path = builtin_path
    else
        vim.notify(
            "テンプレートが存在しません: "
                .. local_filename
                .. " または "
                .. builtin_filename,
            vim.log.levels.WARN
        )
        return
    end

    local lines = vim.fn.readfile(path)

    local author = "monerinngu" --[[os.getenv("USER") or "unknown"]]--
    local created = os.date("%d.%m.%Y %H:%M:%S")
    local filename = vim.fn.expand("%:t")

    for i, line in ipairs(lines) do
        line = line:gsub("%${AUTHOR}", author)
        line = line:gsub("%${CREATED}", created)
        line = line:gsub("%${FILENAME}", filename)
        lines[i] = line
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

    local function find_func(name)
        for i, line in ipairs(lines) do
            if line:match("^%s*[%w_:<>~*&]+%s+" .. name .. "%s*%(") then
                local col = line:find("{", 1, true)

                if col then
                    return { i, col - 1 }
                end

                for j = i + 1, #lines do
                    local next_col = lines[j]:find("{", 1, true)

                    if next_col then
                        return { j, next_col - 1 }
                    end
                end
            end
        end

        return nil
    end

    local func_pos = find_func("solve") or find_func("main")

    if func_pos then
        vim.api.nvim_win_set_cursor(0, func_pos)
    end
end, {
    nargs = "?",

    complete = function(arg_lead)
        local ext = vim.fn.expand("%:e")
        if ext == "" then
            return {}
        end

        local names = {}

        local function add_name(name)
            if vim.startswith(name, arg_lead) then
                names[name] = true
            end
        end

        -- ローカルテンプレート: .default.cpp.nvim
        local local_suffix = "." .. ext .. ".nvim"

        for _, file in ipairs(vim.fn.readdir(vim.fn.getcwd())) do
            if file:sub(1, 1) == "."
                and file:sub(-#local_suffix) == local_suffix
            then
                local name = file:sub(2, -#local_suffix - 1)
                add_name(name)
            end
        end

        -- Neovim内部のテンプレート: default.cpp
        local template_dir = vim.fs.joinpath(
            vim.fn.stdpath("config"),
            "lua",
            "commands",
            "templates"
        )

        if vim.fn.isdirectory(template_dir) == 1 then
            local builtin_suffix = "." .. ext

            for _, file in ipairs(vim.fn.readdir(template_dir)) do
                if file:sub(-#builtin_suffix) == builtin_suffix then
                    local name = file:sub(1, -#builtin_suffix - 1)
                    add_name(name)
                end
            end
        end

        local result = vim.tbl_keys(names)
        table.sort(result)

        return result
    end,
})
