<?php
require_once("util.php");
const USER_ID_KEY = "user_id";
const MOVIE_ID_KEY = "movie_id";
$parameters = filter_input_array(INPUT_GET, [USER_ID_KEY=>FILTER_DEFAULT, MOVIE_ID_KEY=>FILTER_DEFAULT]);
$user_id = $parameters[USER_ID_KEY];
$movie_id = $parameters[MOVIE_ID_KEY];
if (is_null($user_id) || is_null($movie_id)) {
    exit("Invalid query parameter.");
}
try {
    $pdo = make_pdo();
    $select_image_data_sql = "SELECT data FROM movies WHERE id = ? AND user_id = ?";
    $stm = $pdo->prepare($select_image_data_sql);
    $stm->bindValue(1, $movie_id, PDO::PARAM_INT);
    $stm->bindValue(2, $user_id, PDO::PARAM_INT);
    $stm->execute();
    $result = $stm->fetchAll(PDO::FETCH_ASSOC);
    echo strlen($result[0]["data"]);
} catch(Exception $exception) {
    echo $exception->getMessage();
}
