return {
  "lervag/vimtex",

  init = function()
    vim.g.vimtex_compiler_latexmk_engines = {
      _ = "-lualatex",
    }

    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-interaction=nonstopmode",
        "-synctex=1",
      },
    }
  end,
}
