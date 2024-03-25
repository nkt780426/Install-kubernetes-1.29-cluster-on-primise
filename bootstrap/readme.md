# Điều kiện tiên quyết
- Cần 1 máy ubuntu làm workstation (Là máy cá nhân không liên quan đến hệ thống của công ty hoặc máy nằm trong hệ thống công ty đều được)
- Kết nối máy này đến mạng lan chứa cụm k8s định cài
- Các host định cài phải có chung username/password, nếu không có tự biên tự diễn đoạn myscript.sh (sử dụng tài khoản root và cài mật khẩu chung tất cả các host cho chắc)
# Mục đích của folder bootstrap
- Dùng để khởi tạo những thứ cơ bản nhất lên các máy như kết nối ansible đến các host từ workstation (thêm public key của workstation vào các host), thêm username chứa tên của system admin đến các host, set timezone cho các host, ...
- Chỉ dùng chạy 1 lần duy nhất khi mới bắt đầu làm việc với hệ thống (bootstrap)
# Các bước build bootstrap
1. Ping đến các host bằng tay lần đầu tiên
```bash
ssh <tên_user_của_host>@<địa_chỉ_ip_host>
```
2. Chạy myscript.sh
- Sửa file inventory.ini thay bằng các địa chỉ ip của các máy bạn muốn tạo cụm k8s
- Chạy script và làm theo hướng dẫn (Khi chạy hãy nhớ nơi lưu ssh key của bạn đã tạo bằng đoạn script này)
```bash
sudo chmod +x myscript.sh
./myscript.sh
```
3. Chỉnh file ansible.cfg
- Thay đường dẫn đến private key mà myscript.sh ở trên đã tạo ra vào file ansible.cfg
- Kiểm tra đã cài thành công ansible chưa
```bash
ansible all -m ping
```
4. Chạy bootstrap.yml playbook
- Tìm trong file bootstrap.yml và thay tất cả từ sullyvan (đây là tên tôi) thành tên của bạn
- Sửa tên file files/sudoer_sullyvan thành files/sudoer_<tên bạn>
- **Quan trọng: thay ssh public key của bạn vừa mới tạo bằng đoạn script myscript.sh.**
```bash
ansible-playbook bootstrap.yml --ask-become-pass
```
*Đây là đoạn script bootstrap, chỉ dùng để chạy 1 lần khi bạn mới tiếp xức với hệ thống, không chạy nhiều lần*
