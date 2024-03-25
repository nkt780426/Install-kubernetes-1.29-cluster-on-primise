#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt install ansible -y
sudo apt install sshpass -y

echo "----------------------------------------------------"
echo "Path to ssh key for ansible"
read public_key

echo "----------------------------------------------------"
echo "Input your account for of all user remote user."

echo "Username:"
read user

echo "Password:"
read password

if [ -s "inventory.ini" ]; then
    # Đọc từ tệp và thêm khóa cho mỗi máy chủ
    while IFS= read -r line; do
        # Loại bỏ các dấu cách ở đầu và cuối dòng
        host=$(echo "$line" | xargs)
        # Thêm public key
            sshpass -p "$password" ssh-copy-id -i "$public_key" "$user@$host"
        # Kiểm tra mã trả về của lệnh sshpass
        if [ $? -eq 0 ]; then
            echo "Successfully added SSH key to $host"
            echo -e "\U1F44F \U1F44F \U1F44F Run sucessfully! \U1F44F \U1F44F \U1F44Fs"
        else
            echo "Failed to add SSH key to $host"
        fi
    done < "inventory.ini"
else
    echo "inventory.ini doesn't exit or empty."
fi
echo "-----------------------end--------------------------"