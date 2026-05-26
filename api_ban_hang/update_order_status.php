<?php
include "db_config.php";
$id = $_POST['id'];
$status = $_POST['status'];
$sql = "UPDATE orders SET status = '$status' WHERE id = $id";
if ($conn->query($sql)) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}
?>