<?php
$dsn = "mysql:host=localhost;dbname=test;charset=utf8";
$user = "admin";
$password = "admin";
$pdo = new PDO($dsn, $user, $password);
$pdo->query("INSERT INTO user_image(data) values('')");
echo $pdo->lastInsertId("id");