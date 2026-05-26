<?php
header('Content-Type: application/json; charset=utf-8');
include "db_config.php";

$user_id = $_GET['user_id'];

// Lấy danh sách đơn hàng của một User cụ thể
$sql = "SELECT * FROM orders WHERE user_id = $user_id ORDER BY order_date DESC";
$result = $conn->query($sql);

$orders = [];
if ($result) {
    while($row = $result->fetch_assoc()) {
        $orders[] = $row;
    }
}

echo json_encode($orders);
?>