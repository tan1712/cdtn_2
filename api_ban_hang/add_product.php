<?php
header("Content-Type: application/json");
$conn = new mysqli("localhost", "root", "", "ban_hang");

// Nhận dữ liệu
$name = $_POST['name'];
$price = $_POST['price'];
$stock = $_POST['stock_quantity']; // Nhận số lượng
$desc = $_POST['description'];
$img = $_POST['image_url'];
$cat = $_POST['category_id'];

$sql = "INSERT INTO products (name, price, stock_quantity, description, image_url, category_id) 
        VALUES ('$name', $price, $stock, '$desc', '$img', $cat)";

if ($conn->query($sql)) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}
?>