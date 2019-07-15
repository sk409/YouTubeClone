<?php
$id = $_POST["id"];
$blob = $_POST["blob"];
$dsn = "mysql:host=localhost;dbname=test;charset=utf8";
$user = "admin";
$password = "admin";
$pdo = new PDO($dsn, $user, $password);
$sql = "UPDATE user_image SET data = concat(data, ?) WHERE id = ?";
$stm = $pdo->prepare($sql);
$stm->bindValue(1, $blob, PDO::PARAM_STR);
$stm->bindValue(2, $id, PDO::PARAM_INT);
$stm->execute();