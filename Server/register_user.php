<?php
require_once("constants.php");
require_once("util.php");
$parameters = filter_input_array(INPUT_POST, [Constants::USER_NAME_KEY=>FILTER_DEFAULT, Constants::PASSWORD_KEY=>FILTER_DEFAULT]);
$name = $parameters["user_name"];
$password = $parameters["password"];
if (is_null($name) || is_null($password)) {
    exit("invalid query parameter");
}
$password = password_hash($password, PASSWORD_BCRYPT);
try {
    $pdo = make_pdo();
    $register_user_sql = "INSERT INTO users(name, password) VALUES(?, ?)";
    $stm = $pdo->prepare($register_user_sql);
    $stm->bindValue(1, $name, PDO::PARAM_STR);
    $stm->bindValue(2, $password, PDO::PARAM_STR);
    $stm->execute();
} catch(Exception $exception) {
    echo $exception->getMessage();
}
echo Constants::RESPONSE_SUCCEEDED;