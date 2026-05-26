<?php
include "db_config.php";

$username = $_POST['username'];
$password = $_POST['password'];

$query = "SELECT * FROM users WHERE username = '$username'";
$data = mysqli_query($conn, $query);
$user = mysqli_fetch_assoc($data);

if ($user && password_verify($password, $user['password'])) {
    echo json_encode(["status" => "success", "user" => $user]);
} else {
    echo json_encode(["status" => "error", "message" => "Sai tài khoản hoặc mật khẩu"]);
}
?>