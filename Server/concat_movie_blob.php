<?php
require_once("constants.php");
require_once("util.php");
$parameters = filter_input_array(INPUT_POST, [Constants::USER_ID_KEY=>FILTER_DEFAULT, Constants::MOVIE_ID_KEY=>FILTER_DEFAULT, Constants::BLOB_KEY=>FILTER_DEFAULT]);
$user_id = $parameters[Constants::USER_ID_KEY];
$movie_id = $parameters[Constants::MOVIE_ID_KEY];
$blob = $parameters[Constants::BLOB_KEY];
$succeeded = true;
try {
    $pdo = make_pdo();
    $concat_blob_sql = "UPDATE movies SET data = concat(data, ?) WHERE id = ? AND user_id = ?";
    $stm = $pdo->prepare($concat_blob_sql);
    $stm->bindValue(1, $blob, PDO::PARAM_STR);
    $stm->bindValue(2, $movie_id, PDO::PARAM_INT);
    $stm->bindValue(3, $user_id, PDO::PARAM_INT);
    $stm->execute();
} catch(Exception $exception) {
    $succeeded = false;
    echo $exception->getMessage();
}
if ($succeeded) {
    echo Constants::RESPONSE_SUCCEEDED;
}

