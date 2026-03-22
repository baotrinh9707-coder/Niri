-- Nhấn <leader>r (Space + r) để compile và chạy nhanh file C++ đơn lẻ
vim.keymap.set("n", "<leader>r", function()
  vim.cmd("write")
  local file = vim.fn.expand("%")
  local out = vim.fn.expand("%:r")
  -- Mở terminal, compile rồi chạy file ngay lập tức
  vim.cmd("split | term g++ " .. file .. " -o " .. out .. " && ./" .. out)
end, { desc = "Quick Compile & Run" })

