-- options.lua

local function transparent_bg()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = transparent_bg,
})

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.encoding = "utf-8"

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.smartindent = true

vim.opt.termguicolors = true
vim.cmd.colorscheme("habamax")
transparent_bg()

vim.opt.signcolumn = "yes"

vim.opt.clipboard = "unnamedplus"

vim.opt.shada = "'1000,f1"

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "cp932", "sjis", "euc-jp" }
