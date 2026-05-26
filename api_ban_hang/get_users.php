<?php
include "db_config.php";
$query = "SELECT id, username, full_name, role FROM users";
$data = mysqli_query($conn, $query);
$res = array();while($row = mysqli_fetch_assoc($data)) $res[] = $row;
echo json_encode($res);
?>