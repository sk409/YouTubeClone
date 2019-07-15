<?php
require_once("config.php");

function make_pdo(): PDO {
    $pdo = new PDO(Config::DSN, Config::USER_NAME, Config::PASSWORD, [PDO::ATTR_EMULATE_PREPARES=>false, PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION]);
    return $pdo;
}

function make_optimized_hash_cost(): int {
    $timeTarget = 0.05;
    $cost = 8;
    do {
        ++$cost;
        $start = microtime(true);
        password_hash("test", PASSWORD_BCRYPT, ["cost"=>$cost]);
        $end = microtime(true);
    } while(($end - $start) < $timeTarget);
    return $cost;
}