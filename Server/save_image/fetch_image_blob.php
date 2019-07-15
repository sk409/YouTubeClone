<?php
$id = $_GET["id"];
$offset = $_GET["offset"];
$length = $_GET["length"];
$dsn = "mysql:host=localhost;dbname=test;charset=utf8";
$user = "admin";
$password = "admin";
$pdo = new PDO($dsn, $user, $password);
$sql = "SELECT data FROM user_image WHERE id = ?";
$stm = $pdo->prepare($sql);
$stm->bindValue(1, $id, PDO::PARAM_INT);
$stm->execute();
$result = $stm->fetchAll(PDO::FETCH_ASSOC);
$data = $result[0]["data"];
if ($offset + $length < strlen($data)) {
    echo substr($data, $offset, $length);
} else {
    echo substr($data, $offset);
}