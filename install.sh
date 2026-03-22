#!/bin/bash

echo "🚀 BẮT ĐẦU CHIẾN DỊCH XÂY NHÀ TỰ ĐỘNG..."

# 1. Cài đặt các công cụ cốt lõi và môi trường C++
echo "📦 Đang cài đặt công cụ cốt lõi..."
sudo pacman -S --needed --noconfirm base-devel git stow curl wget unzip gcc gdb make

# 2. Cài đặt kho AUR (yay) nếu chưa có
if ! command -v yay &>/dev/null; then
  echo "🔑 Đang rèn chìa khóa AUR (yay)..."
  git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
  cd /tmp/yay-bin
  makepkg -si --noconfirm
  rm -rf /tmp/yay-bin
  cd ~/dotfiles
fi

# 3. Cài đặt toàn bộ Phần mềm & Giao diện
echo "🖥️ Đang tải Niri, Terminal, Waybar và các app..."
yay -S --needed --noconfirm niri waybar kitty neovim btop brave-bin ttf-jetbrains-mono-nerd

# 4. Thiết lập Zsh, Oh My Zsh và các Plugin thần thánh
echo "🐚 Đang thiết lập Zsh và các plugin..."
sudo pacman -S --needed --noconfirm zsh
# Cài Oh My Zsh tự động (nếu chưa có)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Tải 2 plugin Zsh (Gợi ý lệnh & Tô màu cú pháp)
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

# 5. Dùng Stow để rải cấu hình từ kho dotfiles ra hệ thống
echo "🔗 Đang rải file cấu hình bằng GNU Stow..."
cd ~/dotfiles
stow niri nvim zsh waybar kitty system_scripts

# 6. Chuyển Shell mặc định sang Zsh
echo "⚙️ Đang chuyển Shell mặc định sang Zsh..."
chsh -s $(which zsh)

echo "🎉 HOÀN TẤT! HÃY KHỞI ĐỘNG LẠI MÁY ĐỂ TẬN HƯỞNG THÀNH QUẢ!"

# ... (các phần trên giữ nguyên) ...

# 4. Thiết lập Zsh, Oh My Zsh và các Plugin
echo "🐚 Đang thiết lập Zsh và các plugin..."
sudo pacman -S --needed --noconfirm zsh

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# 🔥 BÍ KÍP Ở ĐÂY: Danh sách các plugin (Bạn muốn thêm bao nhiêu cứ dán link vào đây)
DANH_SACH_PLUGINS=(
  "https://github.com/zsh-users/zsh-autosuggestions"
  "https://github.com/zsh-users/zsh-syntax-highlighting.git"
  # "https://github.com/zsh-users/zsh-completions"  <-- Ví dụ lỡ mốt muốn thêm cái này thì cứ bỏ dấu # đi
)

echo "📥 Đang tải các Zsh Plugin tùy chỉnh..."
for link in "${DANH_SACH_PLUGINS[@]}"; do
  # Tự động trích xuất tên thư mục từ đường link
  ten_plugin=$(basename "$link" .git)

  # Kiểm tra nếu chưa tải thì mới clone về
  if [ ! -d "$ZSH_CUSTOM/plugins/$ten_plugin" ]; then
    echo "   -> Đang cài: $ten_plugin"
    git clone "$link" "$ZSH_CUSTOM/plugins/$ten_plugin"
  else
    echo "   -> Đã có sẵn: $ten_plugin"
  fi
done

# ... (các phần trên giữ nguyên) ...

# 7. Thiết lập cảnh báo pin cấp hệ thống (udev)
echo "🔋 Đang thiết lập cảnh báo pin bằng udev..."

# Giả sử bạn lưu file rule trong kho dotfiles ở thư mục udev-rules
if [ -f "$HOME/dotfiles/udev-rules/99-battery.rules" ]; then
  # Copy rule vào hệ thống
  sudo cp ~/dotfiles/udev-rules/99-battery.rules /etc/udev/rules.d/

  # Copy file script thực thi (nếu bạn có tách riêng file script sh)
  if [ -f "$HOME/dotfiles/scripts/battery-alert.sh" ]; then
    sudo cp ~/dotfiles/scripts/battery-alert.sh /usr/local/bin/
    sudo chmod +x /usr/local/bin/battery-alert.sh
  fi

  # Báo cho hệ thống biết là có luật mới để nó nạp lại
  sudo udevadm control --reload-rules
  sudo udevadm trigger
  echo "   -> Đã nạp thành công luật udev cho pin!"
else
  echo "   -> Chưa tìm thấy file udev rule trong kho dotfiles."
fi

# ... (dòng HOÀN TẤT) ...
