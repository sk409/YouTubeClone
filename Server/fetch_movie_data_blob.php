<?php
require_once("util.php");
const USER_ID_KEY = "user_id";
const MOVIE_ID_KEY = "movie_id";
const OFFSET_KEY = "offset";
const LENGTH_KEY = "length";
$parameters = filter_input_array(INPUT_GET, [USER_ID_KEY=>FILTER_DEFAULT, MOVIE_ID_KEY=>FILTER_DEFAULT, OFFSET_KEY=>FILTER_DEFAULT, LENGTH_KEY=>FILTER_DEFAULT]);
$user_id = $parameters[USER_ID_KEY];
$movie_id = $parameters[MOVIE_ID_KEY];
$offset = $parameters[OFFSET_KEY];
$length = $parameters[LENGTH_KEY];
if (is_null($user_id) || is_null($movie_id) || is_null($offset) || is_null($length)) {
    exit("Invalid query parameter.");
}
try {
    $pdo = make_pdo();
    $select_movie_data_sql = "SELECT data FROM movies WHERE id = ? AND user_id = ?";
    $stm = $pdo->prepare($select_movie_data_sql);
    $stm->bindValue(1, $movie_id, PDO::PARAM_INT);
    $stm->bindValue(2, $user_id, PDO::PARAM_INT);
    $stm->execute();
    $result = $stm->fetchAll(PDO::FETCH_ASSOC);
    $data = $result[0]["data"];
    if ($offset + $length < strlen($data)) {
        echo substr($data, $offset, $length);
    } else {
        echo substr($data, $offset);
    }
} catch(Exception $exception) {
    echo $exception->getMessage();
}
