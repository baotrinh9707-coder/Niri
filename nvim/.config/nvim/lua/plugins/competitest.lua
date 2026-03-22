return {
  "xeluxee/competitest.nvim",
  dependencies = "MunifTanjim/nui.nvim",
  cmd = "CompetiTest",
  keys = {
    { "<leader>ta", "<cmd>CompetiTest add_testcase<CR>", desc = "Add Testcase" },
    { "<leader>tr", "<cmd>CompetiTest run<CR>", desc = "Run Testcases" },
    { "<leader>td", "<cmd>CompetiTest delete_testcase<CR>", desc = "Delete Testcase" },
    { "<leader>te", "<cmd>CompetiTest edit_testcase<CR>", desc = "Edit Testcase" },
  },
  config = function()
    require("competitest").setup({
      -- 1. Gom tất cả testcase vào thư mục ẩn có tên là ".testcases"
      testcases_directory = ".testcases",
      testcases_use_single_file = true,

      -- 2. Cấu hình Compile & Run (Đã sửa chuẩn các biến $(FNAME) và $(FNOEXT) để hết báo lỗi đỏ)
      compile_command = {
        cpp = { exec = "g++", args = { "-std=c++17", "-O2", "-Wall", "-Wextra", "$(FNAME)", "-o", "/tmp/$(FNOEXT)" } },
      },
      run_command = {
        cpp = { exec = "/tmp/$(FNOEXT)" },
      },
    })
  end,
}
