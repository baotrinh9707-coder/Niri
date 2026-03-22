return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("refactoring").setup({})
  end,
  -- Phím tắt (LazyVim sẽ tự nhận diện cái này)
  keys = {
    { "<leader>re", ":Refactor extract ", mode = "x", desc = "Extract Function" },
    { "<leader>rv", ":Refactor extract_var ", mode = "x", desc = "Extract Variable" },
    { "<leader>ri", ":Refactor inline_var", mode = "n", desc = "Inline Variable" },
  },
}
