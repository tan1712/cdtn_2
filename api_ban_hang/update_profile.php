<?php
include "db_config.php";

$id = $_POST['id'];
$full_name = $_POST['full_name'];
$phone = $_POST['phone'];
$address = $_POST['address'];

$sql = "UPDATE users SET full_name = '$full_name', phone = '$phone', address = '$address' WHERE id = $id";

if ($conn->query($sql)) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}
?>