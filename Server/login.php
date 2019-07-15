<?php
require_once("auth.php");
require_once("constants.php");
require_once("util.php");
$parameters = filter_input_array(INPUT_GET, [Constants::USER_NAME_KEY=>FILTER_DEFAULT, Constants::PASSWORD_KEY=>FILTER_DEFAULT]);
$user_name = $parameters[Constants::USER_NAME_KEY];
$password = $parameters[Constants::PASSWORD_KEY];
if (is_null($user_name) || is_null($password)) {
    exit("invalid query parameter");
}
echo Auth::exists($user_name, $password) ? Constants::RESPONSE_SUCCEEDED : Constants::RESPONSE_FAILED;