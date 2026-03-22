#!/bin/bash

# === CẤU HÌNH ===
TARGET_USER="baotrinh"
BAT_PATH="/sys/class/power_supply/BAT1"
LIMIT=20  
LOCK_FILE="/tmp/battery_low_lock"
BACKUP_FILE="/tmp/brightness_backup"

# Đường dẫn tuyệt đối tới các lệnh (BẮT BUỘC CHO UDEV)
CMD_CAT="/usr/bin/cat"
CMD_BRIGHTNESSCTL="/usr/bin/brightnessctl"
CMD_TOUCH="/usr/bin/touch"
CMD_RM="/usr/bin/rm"
CMD_SU="/usr/bin/su"
CMD_ID="/usr/bin/id"
CMD_NOTIFY="/usr/bin/notify-send"

# Lấy thông tin pin
CAPACITY=$($CMD_CAT "$BAT_PATH/capacity")
STATUS=$($CMD_CAT "$BAT_PATH/status")

# Hàm gửi thông báo (Sửa lại để dùng full path)
send_notify() {
    USER_ID=$($CMD_ID -u "$TARGET_USER")
    export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"
    $CMD_SU "$TARGET_USER" -c "$CMD_NOTIFY -u critical '$1' '$2'"
}

# === LOGIC XỬ LÝ ===

# Ghi log để debug (tùy chọn, để xem script có chạy không)
echo "$(date): Status=$STATUS, Cap=$CAPACITY" >> /tmp/battery_debug.log

if [ "$STATUS" = "Discharging" ] && [ "$CAPACITY" -le "$LIMIT" ]; then
    if [ ! -f "$LOCK_FILE" ]; then
        $CMD_BRIGHTNESSCTL get > "$BACKUP_FILE"
        $CMD_BRIGHTNESSCTL set 20%
        $CMD_TOUCH "$LOCK_FILE"
        send_notify "⚠️ Pin yeu ($CAPACITY%)" ""
    fi
else
    if [ -f "$LOCK_FILE" ]; then
        if [ -f "$BACKUP_FILE" ]; then
            OLD_VAL=$($CMD_CAT "$BACKUP_FILE")
            $CMD_BRIGHTNESSCTL set "$OLD_VAL"
            $CMD_RM "$BACKUP_FILE"
            if [ "$STATUS" != "Discharging" ]; then
                 send_notify "⚡ Đã cắm sạc" ""
            fi
        fi
        $CMD_RM "$LOCK_FILE"
    fi
fi
