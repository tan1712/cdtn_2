<?php
header("Content-Type: application/json; charset=UTF-8");
$conn = new mysqli("localhost", "root", "", "ban_hang");
$conn->set_charset("utf8mb4");

// 1. Chỉ tính doanh thu từ đơn hàng đã giao thành công (delivered)
$res_revenue = $conn->query("SELECT SUM(total_amount) as total FROM orders WHERE status = 'delivered'");
$revenue = $res_revenue->fetch_assoc()['total'] ?? 0;

// 2. Tổng số đơn hàng
$res_orders = $conn->query("SELECT COUNT(*) as total FROM orders");
$total_orders = $res_orders->fetch_assoc()['total'] ?? 0;

// 3. KHỞI TẠO MẶC ĐỊNH CHO CÁC TRẠNG THÁI (Quan trọng để tránh lỗi Flutter)
$status_stats = [
    "pending" => 0,
    "confirmed" => 0,
    "shipping" => 0,
    "delivered" => 0,
    "cancelled" => 0
];

$res_status = $conn->query("SELECT status, COUNT(*) as count FROM orders GROUP BY status");
while($row = $res_status->fetch_assoc()) {
    $status_stats[$row['status']] = (int)$row['count'];
}

// 4. Tổng người dùng
$res_users = $conn->query("SELECT COUNT(*) as total FROM users WHERE role = 0");
$total_users = $res_users->fetch_assoc()['total'] ?? 0;

// 5. Top sản phẩm bán chạy
$top_products = [];
$res_top = $conn->query("SELECT p.name, SUM(od.quantity) as sold_count 
                        FROM order_details od 
                        JOIN products p ON od.product_id = p.id 
                        GROUP BY od.product_id 
                        ORDER BY sold_count DESC LIMIT 5");
while($row = $res_top->fetch_assoc()) {
    $top_products[] = $row;
}

echo json_encode([
    "overview" => [
        "total_revenue" => (double)$revenue,
        "total_orders" => (int)$total_orders
    ],
    "status_counts" => $status_stats,
    "total_users" => (int)$total_users,
    "top_products" => $top_products
]);
?>