<?php
/**
 * ウィルス感染から復帰したことを通知する
 */

require_once 'util.php';

$required_keys = array('virus_id');
assert_given_post($required_keys);
$virus_id = $_POST['virus_id'];

// ウィルスの感染数を増やすクエリ
$decrement_query = "UPDATE InfectionState
                 SET infected_now   = infected_now -1
                 WHERE virus_id = $virus_id";

// DBへ接続
$link = connect_or_exit();

// クエリを発行して感染数を減少させる
// 更新が衝突しないように、トランザクションを使って行レベルのロックを取得
mysql_query('START TRANSACTION', $link);
$success = mysql_query($decrement_query, $link);
if ($success === FALSE) { // クエリ実行失敗。エラーを吐いて終了
    mysql_query('ROLLBACK', $link);
    $json_array = array(
        'result'  => 'failure',
        'message' => mysql_error($link),
    );
    exit_with_json_array($json_array);
}

mysql_query('COMMIT', $link);
$json_array = array(
    'result'  => 'success',
    'message' => 'recovered complete'
);
exit_with_json_array($json_array);