<?php
// Cho phép tất cả các ứng dụng (bao gồm Flutter) truy cập vào API này
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

// Thông tin kết nối Database
$host = "localhost";
$user = "root";      // Mặc định của XAMPP là root
$pass = "";          // Mặc định của XAMPP là để trống
$db   = "ban_hang"; // Thay bằng tên Database bạn đã tạo trong phpMyAdmin

// Kết nối
$conn = mysqli_connect($host, $user, $pass, $db);

// Thiết lập font chữ Tiếng Việt (UTF-8)
mysqli_set_charset($conn, "utf8");

// Kiểm tra kết nối
if (!$conn) {
    die(json_encode([
        "status" => "error",
        "message" => "Kết nối Database thất bại: " . mysqli_connect_error()
    ]));
}
?>
