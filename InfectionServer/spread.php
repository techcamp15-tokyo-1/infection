<?php

require_once 'util.php';

/**
 * ウィルスの拡散を開始したことを通知する。
 */
$required_keys = array('virus_id');
assert_given_post($required_keys);
$virus_id = $_POST['virus_id'];

// 拡散を開始するクエリ
$spread_start_query = "INSERT INTO InfectionState
                              ( virus_id,  infected_now, infected_total)
                       VALUES ($virus_id,             1,              1)";

// DBへの接続
$link = connect_or_exit();

// クエリの実行
$success = mysql_query($spread_start_query, $link);
if ($success === FALSE) { // クエリ実行失敗。エラー吐いて終了
    $json_array = array(
        'result'  => 'failure',
        'message' => mysql_error($link),
    );
    exit_with_json_array($json_array);
}

$json_array = array(
    'result'  => 'success',
    'message' => 'spread start complete',
);
exit_with_json_array($json_array);