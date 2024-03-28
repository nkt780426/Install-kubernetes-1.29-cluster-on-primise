# Mục đích
set_hostname cho cụm k8s
# Yêu cầu
- Modify file k8s_host cho phù hợp với cấu hình mạng cụm k8s của bạn
- Tạo thêm các file trong host_vas (ở playbook không phải trong role này) và điều chỉnh hostname cho phù hợp với cấu hình cụm k8s của bạn 
- Kiểm tra thành quả bằng cách đăng nhập vào 1 host bất kỳ trong cụm k8s
```bash
# Kiểm tra tên của host xem có đúng trong file k8s_host không
hostnamectl status
# Ping đến host bằng địa chỉ ip trước để kiểm tra, nếu ko ping đc xem lại thiết lập mạng
# Ví dụ ping đến master node (thay địa chỉ ip của bạn vào)
ping 192.168.1.21
# Ping đến host bằng dns, nếu ping đc ở trên mà ko ping đc dưới này theo dns thì role lỗi
ping k8s-master.htp.local
```