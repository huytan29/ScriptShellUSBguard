#Intall usbguard and conf file USB
#!/bin/bash

# Cài đặt usbguard
sudo apt-get update
sudo apt-get install -y usbguard

# Tạo các file cấu hình
sudo touch /etc/usbguard/rules.conf
sudo touch /etc/usbguard/allowlist.conf

# Khởi tạo file cấu hình rules.conf với nội dung mặc định
cat << EOF | sudo tee /etc/usbguard/rules.conf
# Rules file for usbguard

# Tất cả các thiết bị USB mặc định sẽ bị chặn
allow with-interface equals 09:00 id 1-*
EOF

# Khởi tạo file cấu hình allowlist.conf với nội dung mặc định
cat << EOF | sudo tee /etc/usbguard/allowlist.conf
# Allowlist file for usbguard

# File này chứa danh sách các device ID được phép chặn
EOF

# Cấu hình usbguard chạy khi khởi động hệ thống
sudo systemctl enable usbguard

# Khởi động usbguard
sudo systemctl start usbguard

# Chạy lệnh usbguard nếu có USB được cắm vào để lấy device ID và chặn kết nối
sudo usbguard generate-policy > /etc/usbguard/rules.conf

# Gán quyền cho file cấu hình rules.conf
sudo chmod 440 /etc/usbguard/rules.conf

# Gán quyền cho file cấu hình allowlist.conf
sudo chmod 440 /etc/usbguard/allowlist.conf

# Chặn tất cả các thiết bị USB
sudo usbguard allow-device-rule 09:00 id 1-* block

# Xóa device ID từ file cấu hình rules.conf để cho phép kết nối USB
sudo sed -i '/allow with-interface equals 09:00 id 1-\*/d' /etc/usbguard/rules.conf

# Khởi động lại usbguard để áp dụng thay đổi
sudo systemctl restart usbguard

