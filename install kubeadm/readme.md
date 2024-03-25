# Mục đích playbook
- Cài cụm k8s phiên bản 1.29 bằng kubeadm bằng việc sử dụng ansible
- Playbook sau làm theo [hướng dẫn chính thức](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
**Ngày cập nhật cuối cùng: 25/3/2024**
**Tuyên bố miễn trừ trách nhiệm: Tôi không chịu bất kỳ trách nhiệm nào với những lỗi/thiệt hại nếu bạn làm theo hướng dẫn này**
# Điều kiện tiên quyết
- Chạy được folder bootstrap
# Chuẩn bị
1. Các host
- Playbook chỉ chạy được với các linux host thuộc họ debian và red hat
- Mỗi host > 2 CPU, > 2 GB RAM
- Kết nối internet được với nhau (tốt nhất thuộc cùng 1 mạng lan)
- Unique hostname, MAC address, and product_uuid for every node. Kiểm tra bằng cách
```bash
ip link
sudo su
cat /sys/class/dmi/id/product_uuid
```
- Kubenetes component mặc định sử dụng port 6443 để giao tiếp giữa các host, hãy chắc chắn nó phải được mở. Download [netcat](https://netcat.sourceforge.net) (có thể gặp cảnh báo security vì netcat thực hiện mở cổng ở tầng transport, cứ tải về nó an toàn).
```bash
nc 127.0.0.1 6443 -v
```
2. Playbook này thực hiện với Ubuntu-22.04 và CentOS-9, thay địa chỉ ip tương ứng vào file inventory.ini và đổi tên các file trong host_vars sao cho thích hợp với các hosts của bạn
3. Sửa đổi file ansible.cfg cho phù hợp với nhu cầu của bạn
# Chạy playbook
