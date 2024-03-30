# Nguồn thực hiện (ngày 25/3/2024)
https://kubernetes.io/docs/setup/production-environment/container-runtimes/
# Lý thuyết
## Tại sao cần cài container runtime ?
- Từ phiên bản k8s 1.24, Dockershim-container runtime mặc định của các phiên bản trước đó, đã bị bỏ do 1 số vấn đề lo ngại về bảo mật (là 1 tiến trình daemon yêu cầu quyền root). Vốn dĩ dockershim được thiết kế như 1 phiên bản container runtime tạm thời cho k8s từ lúc nó mới ra mắt, k8s phất triển => bỏ
- Thay vào đó K8s cung cấp 1 template (Container Runtime Interface - CRI) trên github, các hãng sản xuất container runtime muốn sản phẩm của mình được sử dụng trên k8s chỉ cần đáp ứng CRI là có thể chạy được trên k8s
Đây là cách k8s vừa có thể là open source nhưng cũng có thể đáp ứng được môi trường enterprise
- Các loại container runtime phổ biến hiện nay
    - containered: được phát triển bởi cộng đồng docker để thay cho docker shim, và nó miễn phí nên được sử dụng nhiều nhất và là container runtime có tính tương thích/ổn định cao nhất, giúp tói ưu hóa việc triển khai và quản lý ứng dụng k8s. Nhược điểm, thiếu tính năng mở rộng so với docker engine như quản lý mạng và lưu trữ
    - CRI-O: Đứng thứ 2 chỉ sau containerd về độ phổ biến. Được thiết kế tối ưu hóa hiệu suất và bảo mật (chạy container không cần quá nhiều tính năng không cần thiết, giúp giảm bớt kích thước và overhead do với Docker Engine). Nhước điểm, không phải free, thiếu nhiều tính năng tiện ích có sẵn trong Docker Engine, đặc biệt là liên quan đến mornitoring
    - Docker Engine: là Docker bình thường hiển nhiên phổ biến nhất nếu ko tính đến trong k8s. Nhược điểm, tốn nhiều tài nguyên hơn so với các thằng trên, là tiến trình daemon yêu cầu quyền root, đổi lại do cộng đồng sử dụng lớn lên nó có rất nhiều plugin
    - Mirantis Container Runtime: là 1 phiên bản tinh chỉnh của Docker Engine, được tối ưu hóa cho việc triển khai và quản lý trong các môi trường production. Do là sản phẩm mới nên không có nhiều thông tin về nhược điểm
## Cgroup drivers
- Control groups (Cgroup) là 1 tính năng trong hệ điều hành linux, được sử dụng để quản lý và giới hạn tài nguyên của các tiến trình, nhóm tiến trình trong hệ thống (limit CPUS, memory, brandwidth, ...) 
    - Cgroup v1 (legacy): là phiên bản cầu tiên cung cấp khả năng quản lý tài nguyên cơ bản như CPU, mem, I/O
    - Cgroup v2: cải thiện, mở rộng khả năng quản lý (sử dụng namespace) và bảo mật hơn
    - Systemd cgroups: là init system phổ biến từ năm 2010 và sử dụng để quản lý các tiến trình trong hệ thống, xem thêm về [systemd](https://www.youtube.com/watch?v=Kzpm-rGAXos&t=277s)
- Kubelet và container runtime đều cần cgroup để quản lý các pods và container (limit resource) và để cài nó trên các máy cần cgroup driver. Có 2 loại cgroup driver
    - cgroupfs: là mặc định trong kubelet. Kubectl và container runtime sẽ tương tác với cgroup driver để tạo và quản lý các cgroup. **Không khuyến khích khi systemd là init system, vì systemd yêu cầu chỉ 1 cgroup tồn tại trên hệ thống. Nếu sử dụng cgroup v2, sử dụng systemd cgroup driver thay thế cho cgroupfs**
    - systemd cgroup driver: **Nên dùng vì systemd là init system mặc định trong các phiên bản phân phôi linux kể từ 2010, không nên có 2 cgroup driver trong 1 hệ thống vì nó làm hệ thống mất ổn định.**. Kể từ phiên bản 1.22, kubeadm mặc định sử dụng systemd là cgroup driver trong KubeletConfiguration resource
- Trong phiên bản k8s v1.28, KubeletCgroupDriverFromCRI được bật (là 1 interface/template cho các hãng) và container runtime cái mà hỗ trợ RuntimeConfig (file rc tải trong playbook) CRI RPC, kubelet mặc định tự động phát hiện cgroup driver phù hợp trong runtime và bỏ qua setting mặc định trong file config. **Nếu bạn sử dụng systemd là cgroup driver cho kubelet, bạn đồng thời phải config systemd là cgroup driver cho container runtime.**
Tóm lại, đây chỉ là thông tin đọc thêm hữu ích, chỉ cần follow [document](https://kubernetes.io/docs/setup/production-environment/container-runtimes/) để cài container runtime mong muốn là đáp ứng được yêu cầu này 
**Role này dùng để cài containerd lên các hosts, nếu thay đổi đọc lại document**
**BIG NOTE: việc thay đổi cgroup của 1 node đã join vào k8s cluster là việc không nên. Lý do, nếu Node này đã tạo Pod trên 1 cgroup nào đó thì việc này dẫn đến error, re-create lại Pod cũng không giải quyết được vấn đề khể cả restart lại kubelet. Giải pháp duy nhất là thay thế node này bằng 1 node khác đã update config, tham khảo tại [Migrating to the systemd driver in kubeadm managed clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/)**
# Mục đích role
1.Cài containerd lên tất cả các host (có thể cải biến để cài các loại container runtime khác) phục vụ cho cài kubelet và kubeadm.
2.Role chạy được trên Ubuntu và CentOS cùng lúc và các phiên bản Debian/Red Hat theo document chính thức của kubenetes
3.Cài cni plugin
Hãy chắc chắn "/usr/local/bin" tồn tại trong PATH
# Nhược điểm:
Có thể outdate khi các phiên bản mới hơn cập nhật (hiển nhiên). Giải pháp
- Theo dõi trang web của [hãng](https://kubernetes.io/docs/setup/production-environment/container-runtimes/) và update lại version trong thư mục vas
- Tại bước cấu hình file /etc/containerd/config.toml, đầu tiên chạy playbook chứa role này lần 1, truy cập vào 1 host thực hiện xóa file đó đi và chạy lệnh
```bash
containerd config default > /etc/containerd/config.toml
```
- Thực hiện các thay đổi file /etc/containerd/config.toml vừa tạo ra theo tài liệu chính thức của [kubernetes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/) tại mục Container runtimes/containerd. Override file vừa tạo vào thư mục /files/config.toml của role và chạy lại playbook