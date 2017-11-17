<?php
$task = $argv[1];
$reason = $argv[2];
$app_id = 'bjFangXinSearch';
$app_secret = 'EgeWbFvB';
$number = '17010284833';//numbers joined by ','
$msg = "'${task}' because '${reason}' not success";
$sig = hash("sha256","appkey=$app_secret&mobile=$number");
$msg = urlencode($msg);
$u = "http://idc02-im-message-vip00/message/send?number=$number&msg=$msg&appId=$app_id&sig=$sig";
#$u = "http://10.2.28.80:8085/message/send?number=$number&msg=$msg&appId=$app_id&sig=$sig";
$r = json_decode(file_get_contents($u),true);
if(isset($r['status']['status_code']) && $r['status']['status_code'] === 0){
	echo "send message success\n";
}else{
	echo "send message failed.\n";
	print_r($r);
}
?>
