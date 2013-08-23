<?php

/**
 * 変数の内容を見やすい形式で表示する。
 * @param mixed $var 表示したい変数
 */
function debug($var) {
    print '<pre>';
    print_r($var);
    print '</pre>';
}

/**
 * 連想配列の内容をJSON形式として出力して終了する。
 * @param array $json_array JSON形式で出力する連想配列
 */
function exit_with_json_array($json_array) {
    $json_string = json_encode($json_array);
    if ($json_string === FALSE) {
        switch (json_last_error()) {
            case JSON_ERROR_NONE:
                print ' - No errors';
            break;
            case JSON_ERROR_DEPTH:
                print ' - Maximum stack depth exceeded';
            break;
            case JSON_ERROR_STATE_MISMATCH:
                print ' - Underflow or the modes mismatch';
            break;
            case JSON_ERROR_CTRL_CHAR:
                print ' - Unexpected control character found';
            break;
            case JSON_ERROR_SYNTAX:
                print ' - Syntax error, malformed JSON';
            break;
            case JSON_ERROR_UTF8:
                print ' - Malformed UTF-8 characters, possibly incorrectly encoded';
            break;
            default:
                print ' - Unknown error';
            break;
        }
    }
    exit($json_string);
}

/**
 * $_POST変数のキーとして$required_keysの要素がすべて含まれていなければエラーメッセージを出力して終了する 
 * @param array $required_keys キーチェック対象の文字列配列 
 */
function assert_given_post($required_keys) {
    foreach ($required_keys as $key) {
        if (!array_key_exists($key, $_POST)) { // 要求されたキーが存在しないのでエラーを吐いて終了 
            $json_array = array(
                'result'  => 'failure',
                'message' => "$key must be given in POST data",
            );
            exit_with_json_array($json_array);
        }
    }
}

/**
 * DBとの接続を構築する． 
 * @return resource 接続に成功した場合はDBへのlink identifier，失敗した場合はnull 
 */
function db_connect() {
    $link = mysql_connect('localhost', 'infectionapp', '0e485c00f192b27c35f8');
    if (!$link) {
        return null;
    }

    $db_selected = mysql_select_db('db0infectionapp', $link);
    if (!$db_selected) {
        return null;
    }
    
    return $link;
}

/**
 * DBとの接続を試み，成功したらlink identifierを返し，失敗したらエラーメッセージを吐いて終了する． 
 */
function connect_or_exit() {
    $link = db_connect();
    if (is_null($link)) {
        $json_array = array(
            'result' => 'failure',
            'message' => 'DB connection failure',
        );
        exit_with_json_array($json_array);
    }
    return $link;
}

