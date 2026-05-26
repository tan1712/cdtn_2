<?php
include "db_config.php";

$username = $_POST['username'];
$password = password_hash($_POST['password'], PASSWORD_DEFAULT);
$full_name = $_POST['full_name'];
$email = $_POST['email']; // Thêm trường này
$phone = $_POST['phone'];
$address = $_POST['address']; // Thêm trường này

// Cập nhật câu lệnh SQL đầy đủ các cột
$query = "INSERT INTO users (username, password, full_name, email, phone, address) 
          VALUES ('$username', '$password', '$full_name', '$email', '$phone', '$address')";

if (mysqli_query($conn, $query)) {
    echo json_encode(["status" => "success", "message" => "Đăng ký thành công"]);
} else {
    echo json_encode(["status" => "error", "message" => "Lỗi: " . mysqli_error($conn)]);
}
?>