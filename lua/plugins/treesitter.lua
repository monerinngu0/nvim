return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "neovim-treesitter/treesitter-parser-registry",
    },
    lazy = false,
    build = ":TSUpdate",

    config = function()
        local ts = require("nvim-treesitter")

        ts.install({
            "c",
            "cpp",
            "lua",
            "python",
            "rust",
            "json",
            "markdown",
            "bash",
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "c",
                "cpp",
                "lua",
                "python",
                "rust",
                "json",
                "markdown",
                "sh",
            },

            callback = function()
                vim.treesitter.start()

                vim.bo.indentexpr =
                    "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
