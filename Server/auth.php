<?php
require_once("user.php");
require_once("util.php");

class Auth {

    public static function user(string $user_name, string $password): User {
        $result = null;
        try {
            $pdo = make_pdo();
            $select_user_sql = "SELECT * FROM users WHERE name = ?";
            $stm = $pdo->prepare($select_user_sql);
            $stm->bindValue(1, $user_name, PDO::PARAM_STR);
            $stm->execute();
            $users = $stm->fetchAll(PDO::FETCH_ASSOC);
            foreach ($users as $user) {
                if (password_verify($password, $user["password"])) {
                    $result = new User($user["id"], $user["name"], $user["password"]);
                    break;
                }
            }
        } catch (Exception $exception) {
            echo $exception->getMessage();
        }
        return $result;
    }

    public static function exists(string $user_name, string $password): bool {
        return is_null(Auth::user($user_name, $password)) ? false : true;
        // $succeeded = false;
        // try {
        //     $pdo = make_pdo();
        //     $select_user_sql = "SELECT * FROM users WHERE name = ?";
        //     $stm = $pdo->prepare($select_user_sql);
        //     $stm->bindValue(1, $user_name, PDO::PARAM_STR);
        //     $stm->execute();
        //     $users = $stm->fetchAll(PDO::FETCH_ASSOC);
        //     foreach ($users as $user) {
        //         if (password_verify($password, $user["password"])) {
        //             $succeeded = true;
        //             break;
        //         }
        //     }
        // } catch (Exception $exception) {
        //     echo $exception->getMessage();
        // }
        // return $succeeded;
    }

}