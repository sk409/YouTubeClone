<?php
require_once("auth.php");
require_once("constants.php");
require_once("util.php");
$parameters = filter_input_array(INPUT_GET, [Constants::USER_NAME_KEY=>FILTER_DEFAULT, Constants::PASSWORD_KEY=>FILTER_DEFAULT]);
$user_name = $parameters[Constants::USER_NAME_KEY];
$password = $parameters[Constants::PASSWORD_KEY];
if (is_null($user_name) || is_null($password)) {
    exit("Invalid query parameter");
}
$user = Auth::user($user_name, $password);
if (is_null($user)) {
    echo Constants::RESPONSE_FAILED;
} else {
    echo json_encode(["id"=>$user->getId(), "name"=>$user->getName()]);
}
// try {
//     $pdo = make_pdo();
//     $select_user_sql = "SELECT * FROM users WHERE "
// } catch(Exception $exception) {
//     echo $exception->getMessage();
// }