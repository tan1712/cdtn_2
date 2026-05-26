<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// 1. Kết nối Database 'ban_hang' theo đúng sơ đồ ảnh
$conn = new mysqli("localhost", "root", "", "ban_hang");

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Kết nối Database thất bại"]));
}
$conn->set_charset("utf8mb4");

// 2. Lấy dữ liệu từ Flutter gửi lên
$data = json_decode(file_get_contents("php://input"), true);
if (!$data) {
    die(json_encode(["status" => "error", "message" => "Dữ liệu không hợp lệ"]));
}

$conn->begin_transaction();

try {
    // A. Lưu vào bảng orders
    $stmt = $conn->prepare("INSERT INTO orders (user_id, total_amount, shipping_address, phone, payment_method, status) VALUES (?, ?, ?, ?, ?, 'pending')");
    $stmt->bind_param("idsss", $data['user_id'], $data['total_amount'], $data['shipping_address'], $data['phone'], $data['payment_method']);
    $stmt->execute();
    $order_id = $conn->insert_id;

    // B. Duyệt từng sản phẩm để trừ kho và lưu chi tiết
    foreach ($data['items'] as $item) {
        $pid = $item['product_id'];
        $qty = $item['quantity'];
        $u_price = $item['unit_price'];

        // 1. Kiểm tra tồn kho
        $check = $conn->query("SELECT stock_quantity, name FROM products WHERE id = $pid");
        $product = $check->fetch_assoc();

        if ($product['stock_quantity'] < $qty) {
            throw new Exception("Sản phẩm '" . $product['name'] . "' không đủ hàng!");
        }

        // 2. Lưu chi tiết đơn hàng
        $stmt_detail = $conn->prepare("INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)");
        $stmt_detail->bind_param("iiid", $order_id, $pid, $qty, $u_price);
        $stmt_detail->execute();

        // 3. THỰC HIỆN TRỪ KHO
        $conn->query("UPDATE products SET stock_quantity = stock_quantity - $qty WHERE id = $pid");
    }

    $conn->commit();
    echo json_encode(["status" => "success", "message" => "Đặt hàng thành công và đã trừ kho"]);

} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}

$conn->close();
?>