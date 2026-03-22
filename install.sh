#!/bin/bash

echo "=== BẮT ĐẦU CÀI ĐẶT HỆ THỐNG ==="

# 1. Cài đặt các công cụ cần thiết
echo "-> Đang cài đặt phần mềm từ pacman..."
sudo pacman -S --needed git stow niri neovim zsh

# 2. Dùng Stow để liên kết cấu hình
echo "-> Đang liên kết cấu hình (Symlink)..."
cd ~/dotfiles
stow niri nvim zsh

# 3. Phục hồi script cảnh báo pin hệ thống
echo "-> Đang copy script udev cảnh báo pin..."
sudo cp system_scripts/battery-alert.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/battery-alert.sh

echo "=== CÀI ĐẶT HOÀN TẤT! ==="
