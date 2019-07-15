<?php
require_once("config.php");
require_once("util.php");
$dsn = "mysql:host=localhost;charset=utf8";
try {
    $pdo = new PDO($dsn, Config::USER_NAME, Config::PASSWORD, [PDO::ATTR_EMULATE_PREPARES => false, PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    $create_database_sql = "CREATE DATABASE " . Config::DATABASE_NAME;
    $pdo->query($create_database_sql);
} catch (Exception $exception) {
    echo $exception->getMessage();
}
try {
    $pdo = make_pdo();
    $pdo->beginTransaction();
    $create_users_table_sql = "CREATE TABLE IF NOT EXISTS users(
        id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(128) NOT NULL,
        password VARCHAR(255) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        CONSTRAINT user_table_name_password_unique_constraint UNIQUE(name, password)
        )";
    $pdo->query($create_users_table_sql);
    $create_movies_table_sql = "CREATE TABLE IF NOT EXISTS movies(
        id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(128) NOT NULL,
        overview VARCHAR(1024) NOT NULL DEFAULT '',
        data LONGBLOB NOT NULL,
        user_id INT UNSIGNED NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        CONSTRAINT movies_table_user_id_foreign_key_constraint
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE ON UPDATE CASCADE
        )";
    $pdo->query($create_movies_table_sql);
    $pdo->commit();
} catch(Exception $exception) {
    $pdo->rollBack();
    echo $exception->getMessage();
}