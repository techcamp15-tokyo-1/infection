<?php
/**
 * 指定したウィルスIDの感染状況を返す。
 */

require_once 'util.php';

$required_keys = array('virus_id');
assert_given_post($required_keys);
$virus_id = $_POST['virus_id'];

// ウィルスの感染状況を取得するクエリ
$state_query = "SELECT infected_now, infected_total
                FROM InfectionState
                WHERE virus_id = $virus_id";
// DBへ接続
$link = connect_or_exit();

// クエリを実行し、取得した値をJSON形式で吐く
$success = mysql_query($state_query, $link);
if ($success === FALSE) { // クエリ実行失敗。エラーメッセージを吐いて終了
    $json_array = array(
        'result'  => 'failure',
        'message' => mysql_error($link),
    );
    exit_with_json_array($json_array);
}
else if (mysql_num_rows($success) == 0) { // 該当するIDなし。エラーメッセージを吐いて終了
    $json_array = array(
        'result'  => 'failure',
        'message' => "There are no data applicable to virus_id: $virus_id",
    );
    exit_with_json_array($json_array);
}

// 取得成功。resource型をarrayに変換して吐いて終了
$json_array = mysql_fetch_assoc($success);
$json_array['result']  = 'success';
$json_array['message'] = 'state complete';
exit_with_json_array($json_array);