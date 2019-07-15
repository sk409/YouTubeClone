<?php
$id = $_GET["id"];
$dsn = "mysql:host=localhost;dbname=test;charset=utf8";
$user = "admin";
$password = "admin";
$pdo = new PDO($dsn, $user, $password);
$sql = "SELECT data FROM user_image WHERE id=?";
$stm = $pdo->prepare($sql);
$stm->bindValue(1, $id, PDO::PARAM_INT);
$stm->execute();
$result = $stm->fetchAll(PDO::FETCH_ASSOC);
echo strlen($result[0]["data"]);