# Nguồn thực hiện
Tài liệu chính thức của [kubernetes](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
Role này thực hiện cài kubeadme với phiên bản kubernetes phiên bản 1.29, link trên là phiên bản kubenetes mới nhất hãy swap nó sang phiên bản 1.29
## Lý thuyết
- Điêu kiện, mỗi host phải có ít nhất 2 GB RAM và 2 CPU và phải cài triển khai được container runtime tuân theo CRI của k8s
- Unique hostname. MAC address (ip link) và production__uuid (dùng lệnh cat /sys/class/dmi/id/product_uuid)