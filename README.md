# 🛍️ UD SHOP - Ứng dụng Bán hàng Tích hợp AI Gemini

## 📝 Giới thiệu dự án
**UD SHOP** là một ứng dụng thương mại điện tử hiện đại được phát triển bằng Flutter. Dự án không chỉ dừng lại ở việc mua bán hàng trực tuyến mà còn tích hợp **Trợ lý ảo AI (Gemini)** để tư vấn sản phẩm và hệ thống **quản lý kho hàng tự động** phía Backend, đảm bảo trải nghiệm mua sắm thông minh và chính xác.

---

## 🚀 Tính năng nổi bật
- **Phân quyền người dùng:** Hệ thống Đăng nhập/Đăng ký bảo mật, quản lý giỏ hàng riêng biệt theo `userId`.
- **Trợ lý AI Gemini:** Tích hợp Chatbot thông minh, tự động tư vấn sản phẩm dựa trên dữ liệu thực tế của cửa hàng.
- **Quản lý kho tự động:** Hệ thống tự động kiểm tra và trừ số lượng sản phẩm (`stock_quantity`) khi đặt hàng thành công.
- **Báo cáo thống kê:** Tự động tính toán doanh thu và quản lý đơn hàng chuyên nghiệp.
- **Kiểm thử tự động:** Tích hợp bộ Unit Test toàn diện, tự động xuất kết quả ra file **Excel (API_Auto_Report.xlsx)** ngay sau khi hoàn tất.

---

## 🛠️ Công nghệ sử dụng
- **Frontend:** Flutter & Dart (Quản lý trạng thái, kết nối API).
- **Backend:** PHP (RESTful API) xử lý logic nghiệp vụ.
- **Database:** MySQL (Quản lý Users, Products, Orders).
- **AI Integration:** Google Gemini Pro API.
- **Testing Framework:** Mockito & Excel Library cho báo cáo tự động.

---

## 👥 Phân công nhiệm vụ

### 1. Hoàng Trọng Tấn (Nhóm trưởng / Frontend Developer)
- **Nhiệm vụ:** Phân tích yêu cầu hệ thống & Thiết kế UI/UX ứng dụng Flutter.
- **Thực hiện:** Xây dựng các màn hình (Login, Register, Home, Cart, Chat AI...). Xử lý kết nối API và đồng bộ giỏ hàng theo User ID.
- **File chính:** `lib/main.dart`, `lib/screens/`, `lib/services/api_service.dart`.

### 2. Nguyễn Quang Linh (Backend Developer)
- **Nhiệm vụ:** Xây dựng hệ thống RESTful API và Logic Server.
- **Thực hiện:** Thiết kế API đăng nhập, đặt hàng, quản lý kho và thống kê doanh thu. Tích hợp logic xử lý cho Gemini AI.
- **File chính:** Các file PHP trên Server (`login.php`, `place_order.php`, `get_stats.php`...).

### 3. Hoàng Kiên Cương (Database & Testing)
- **Nhiệm vụ:** Thiết kế Cơ sở dữ liệu & Kiểm thử hệ thống.
- **Thực hiện:** Xây dựng cấu trúc MySQL. Triển khai bộ mã Unit Test cho toàn bộ API và cấu hình tự động xuất báo cáo Excel.
- **File chính:** `database.sql`, `test/api_service_test.dart`.

---

## 📈 Hướng dẫn chạy Kiểm thử & Xuất báo cáo
Để kiểm tra tính ổn định của toàn bộ hệ thống API và tự động trích xuất báo cáo kết quả ra Excel, hãy thực hiện lệnh sau:

```sh
flutter test test/api_service_test.dart
```

Sau khi chạy xong, file **`API_Comprehensive_Report.xlsx`** sẽ xuất hiện tại thư mục gốc của dự án.

---

## 🌐 Thông số cấu hình
- **Base URL API:** `http://192.171.17.87/api_ban_hang`
- **Xử lý ngôn ngữ:** Hỗ trợ đầy đủ tiếng Việt (UTF-8).
- **Trạng thái kho:** Tự động cập nhật thời gian thực.

---
© 2024 **UD SHOP Team** - Dự án học tập chuyên nghiệp.
