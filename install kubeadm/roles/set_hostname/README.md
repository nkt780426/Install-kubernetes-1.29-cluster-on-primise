# Mục đích
set_hostname cho cụm k8s
# Yêu cầu
- Modify file k8s_host cho phù hợp với cấu hình mạng cụm k8s của bạn
- Tạo thêm các file trong host_vas (ở playbook không phải trong role này) và điều chỉnh hostname cho phù hợp với cấu hình cụm k8s của bạn 
- Kiểm tra thành quả bằng lênh
```bash
hostnamectl status
```