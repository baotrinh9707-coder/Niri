return {
  "CRAG666/code_runner.nvim",
  config = function()
    require("code_runner").setup({
      mode = "term",
      focus = true,
      filetype = {
        python = "python3 -u",
        -- COPY VÀ THAY THẾ DÒNG CỦA C++ BẰNG DÒNG DƯỚI ĐÂY:
        cpp = "cd $dir && if [ -f Makefile ]; then make run; else g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt; fi",
      },
    })
  end,
  keys = {
    { "<F5>", ":RunCode<CR>", desc = "Run Code", mode = "n" },
  },
}
