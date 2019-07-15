<?php
require_once("config.php");
require_once("util.php");
try {
    $pdo = make_pdo();
    $drop_database_sql = "DROP DATABASE " . Config::DATABASE_NAME;
    $pdo->query($drop_database_sql);
} catch (Exception $exception) {
    echo $exception->getMessage();
}