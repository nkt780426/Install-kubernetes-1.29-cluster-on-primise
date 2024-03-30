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
# Sửa role
Role mặc định cài kubectl, kubeadm, kubelet ứng với phiên bản kubernetes 1.29 lên các host. Nếu muốn cài phiên bản mới nhất
- Chạy lệnh sau để tìm phiên bản mới nhất của kubernetes và thay vào biến kubernetes_version
```bash
curl -sSL https://dl.k8s.io/release/stable.txt
```
- Tìm trong [document mới nhất](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) của k8s đoạn "Installing kubeadm, kubelet and kubectl" => Install bằng "Without a package manager" => Install kubeadm, kubelet and add a kubelet systemd service
# Lỗi nghiêm trọng
Trong document về cài đặt kubeadm và kubelet [chính thức](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin), tệp thực thi kubeadm và kubelet được đặt ở thư mục /usr/local/bin. Tuy nhiên trong file 10-kubeadm.conf mà tài liệu bắt down về có đoạn
```bash
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS 
```
Do đó cần sửa file đoạn này thành /usr/local/bin thì kubelet service mới hoạt động đúng cách, file repair_mistake sẽ làm điều này (lưu ý điều này chỉ đúng đến 30/3/2024), cần kiểm tra lại lỗi này và bỏ file trên trong tương lai nếu k8s sửa lỗi này