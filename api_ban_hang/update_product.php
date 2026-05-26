<?php
header("Content-Type: application/json");
$conn = new mysqli("localhost", "root", "", "ban_hang");

$id = $_POST['id'];
$name = $_POST['name'];
$price = $_POST['price'];
$stock = $_POST['stock_quantity']; // Nhận số lượng mới
$desc = $_POST['description'];
$img = $_POST['image_url'];

$sql = "UPDATE products SET 
        name='$name', 
        price=$price, 
        stock_quantity=$stock, 
        description='$desc', 
        image_url='$img' 
        WHERE id=$id";

if ($conn->query($sql)) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}
?>