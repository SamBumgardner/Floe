<?php
if($_SERVER['HTTP_ORIGIN'] == "http://SamBumgardner.github.io/Floe") {

	if($_POST["game"] == "floe") {
		record_score("floe_scores.txt");
	}
}
function record_score($filename) {
	if(file_exists($filename)) {
		$score_entry = array($_POST["initials"], $_POST["score"]);
		$score_entry_string = implode(",", $score_entry)."\n";

		$handle = fopen("lock.txt", 'c');
		flock($handle, LOCK_EX);

		$raw = file_get_contents($filename);
		if($raw == "") {
			file_put_contents($filename, $score_entry_string,FILE_APPEND);
		}
		else {
			$pairs = explode("\n", trim($raw));
			for($i = 0; $i < 20; $i++) {
				if($i >= count($pairs)) {
					file_put_contents($filename, $score_entry_string,FILE_APPEND);
					break;
				}
				else {
					$line = explode(",", $pairs[$i]);
					if($line[1] <= $score_entry[1]) {
						if($i == 0) {
							$head = "";
						}
						else {
							$head = implode("\n", array_slice($pairs, 0, $i))."\n";
						}
						if($i == count($pairs)) {
							$tail = "";
						}
						else {
							$tail = implode("\n", array_slice($pairs, $i, 19-$i))."\n";
						}
						$new_contents = $head.$score_entry_string.$tail;
						file_put_contents($filename,$new_contents);
						break;
					}
				}
			}
		}
		fclose($handle);
	}
}
?>