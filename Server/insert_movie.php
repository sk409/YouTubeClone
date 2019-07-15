<?php
require_once("util.php");
const USER_ID_KEY = "user_id";
const TITLE_KEY = "title";
const OVERVIEW_KEY = "overview";
$parameters = filter_input_array(INPUT_POST, [USER_ID_KEY=>FILTER_DEFAULT, TITLE_KEY=>FILTER_DEFAULT, OVERVIEW_KEY=>FILTER_DEFAULT]);
$user_id = $parameters[USER_ID_KEY];
$title = $parameters[TITLE_KEY];
$overview = $parameters[OVERVIEW_KEY];
if (is_null($user_id) || is_null($title) || is_null($overview)) {
    exit("Invalid query parameter.");
}
try {
    $pdo = make_pdo();
    $insert_movie_sql = "INSERT INTO movies(title, overview, data, user_id) VALUES(?, ?, '', ?)";
    $stm = $pdo->prepare($insert_movie_sql);
    $stm->bindValue(1, $title);
    $stm->bindValue(2, $overview);
    $stm->bindValue(3, $user_id);
    $stm->execute();
} catch(Exception $exception) {
    echo $exception->getMessage();
    exit;
}
echo $pdo->lastInsertId("id");