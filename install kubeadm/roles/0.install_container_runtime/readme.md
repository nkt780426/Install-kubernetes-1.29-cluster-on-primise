# Nguồn thực hiện (ngày 25/3/2024)
https://kubernetes.io/docs/setup/production-environment/container-runtimes/
# Tại sao cần cài container runtime ?
- Từ phiên bản k8s 1.24, Dockershim-container runtime mặc định của các phiên bản trước đó, đã bị bỏ do 1 số vấn đề lo ngại về bảo mật (là 1 tiến trình daemon yêu cầu quyền root). Vốn dĩ dockershim được thiết kế như 1 phiên bản container runtime tạm thời cho k8s từ lúc nó mới ra mắt, k8s phất triển => bỏ
- Thay vào đó K8s cung cấp 1 template (Container Runtime Interface - CRI) trên github, các hãng sản xuất container runtime muốn sản phẩm của mình được sử dụng trên k8s chỉ cần đáp ứng CRI là có thể chạy được trên k8s
Đây là cách k8s vừa có thể là open source nhưng cũng có thể đáp ứng được môi trường enterprise
- Các loại container runtime phổ biến hiện nay
    - containered: được phát triển bởi cộng đồng docker để thay cho docker shim, và nó miễn phí nên được sử dụng nhiều nhất và là container runtime có tính tương thích/ổn định cao nhất, giúp tói ưu hóa việc triển khai và quản lý ứng dụng k8s. Nhược điểm, thiếu tính năng mở rộng so với docker engine như quản lý mạng và lưu trữ
    - CRI-O: Đứng thứ 2 chỉ sau containerd về độ phổ biến. Được thiết kế tối ưu hóa hiệu suất và bảo mật (chạy container không cần quá nhiều tính năng không cần thiết, giúp giảm bớt kích thước và overhead do với Docker Engine). Nhước điểm, không phải free, thiếu nhiều tính năng tiện ích có sẵn trong Docker Engine, đặc biệt là liên quan đến mornitoring
    - Docker Engine: là Docker bình thường hiển nhiên phổ biến nhất nếu ko tính đến trong k8s. Nhược điểm, tốn nhiều tài nguyên hơn so với các thằng trên, là tiến trình daemon yêu cầu quyền root, đổi lại do cộng đồng sử dụng lớn lên nó có rất nhiều plugin
    - Mirantis Container Runtime: là 1 phiên bản tinh chỉnh của Docker Engine, được tối ưu hóa cho việc triển khai và quản lý trong các môi trường production. Do là sản phẩm mới nên không có nhiều thông tin về nhược điểm
**Role này dùng để cài containerd lên các hosts, nếu thay đổi đọc lại document**