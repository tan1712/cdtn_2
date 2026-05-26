<?php
header('Content-Type: application/json; charset=utf-8');
include "db_config.php";

$sql = "SELECT o.*, u.full_name FROM orders o LEFT JOIN users u ON o.user_id = u.id ORDER BY o.order_date DESC";
$result = $conn->query($sql);
$orders = [];
while($row = $result->fetch_assoc()) { $orders[] = $row; }
echo json_encode($orders);
?>