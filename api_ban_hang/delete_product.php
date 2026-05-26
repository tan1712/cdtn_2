<?php
include "db_config.php";
$id = $_POST['id'];
$query = "DELETE FROM products WHERE id=$id";
if(mysqli_query($conn, $query)) echo json_encode(["status" => "success"]);
?>