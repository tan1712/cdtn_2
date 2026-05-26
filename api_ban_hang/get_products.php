<?php
include "db_config.php";

// Kiểm tra nếu có lọc theo category_id
$category_id = isset($_GET['category_id']) ? $_GET['category_id'] : null;

if ($category_id) {
    $query = "SELECT * FROM products WHERE category_id = $category_id";
} else {
    $query = "SELECT * FROM products";
}

$data = mysqli_query($conn, $query);
$result = array();

while ($row = mysqli_fetch_assoc($data)) {
    array_push($result, array(
        "id" => $row['id'],
        "category_id" => $row['category_id'],
        "name" => $row['name'],
        "price" => $row['price'],
        "old_price" => $row['old_price'],
        "description" => $row['description'],
        "image_url" => $row['image_url'],
        "stock_quantity" => $row['stock_quantity'],
        "is_popular" => $row['is_popular']
    ));
}

echo json_encode($result);
?>