# Nguồn thực hiện
Role cài cụm kubeadm phiên bản 1.29
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
# Điều kiện tiên quyết
- Tất cả các host > 2 CPU và > 2 GB RAM và kết nối network được với nhau và internet
- Hostname, MAC address, product_uuid (sudo cat /sys/class/dmi/id/product_uuid) ở mỗi node phải khác nhau
- Các port sau phải open để cụm k8s có thể hoạt động. Xem thêm ở [đây](https://kubernetes.io/docs/reference/networking/ports-and-protocols/)
- Tất cả các host đã cài container runtime. Có thể là containerd, CRIO-O, ...
# Lý thuyết
## Swap configure là gì
- Là 1 phần của hệ thống quản lý bộ nhớ ảo trong các hệ điều hành UNIX và tương tự
- Khi RAM được sử dụng hết, swap space (swap file) sẽ được sử dụng để bổ sung vùng còn thiếu (bản chất là sử dụng dish làm RAM ảo, dùng nhiều hại máy)
- Khi hệ thống cần thêm RAM để chứa data của các process, nhưng RAM được sử dụng hết, kernel của hệ điều hành sẽ di chuyển data không cần thiết hoặc ít được sử dụng vào swap space
## Lưu ý
- Khi thay đổi phiên bản kubernetes bạn muốn cài, hãy thay đổi version của kubectl và kubeadm cùng để tránh những xung đột phần mềm và bảo mật
