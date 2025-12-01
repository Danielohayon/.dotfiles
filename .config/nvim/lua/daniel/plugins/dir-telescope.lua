return {
  "princejoogie/dir-telescope.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  lazy = true,  -- load when telescope calls load_extension("dir")
  config = function()
    require("dir-telescope").setup({
      hidden = true,
      no_ignore = false,
      show_preview = true,
    })
  end,
}
