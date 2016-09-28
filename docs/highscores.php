<html>
	<head>
		<title>High Scores</title>
		<meta charset="utf-8" />
		<link href="index.css" type="text/css" rel="stylesheet" />
		<link rel="shortcut icon" type="image/png" href="/favicon.png" />
	</head>

	<body>
<?php include("header.html"); ?>

		<div id="main">
			<h1>High Scores</h1>
			<div>
				<table class="highscores">
					<caption>Floe</caption>
					<?php 
						$handle = fopen("lock.txt", 'c');
						flock($handle);
						$floe_scores = explode("\n", trim(file_get_contents("floe_scores.txt")));
						fclose($handle);
					?>
					<?php
						$place = 1;
						foreach($floe_scores as $score) { 
						$table_data = explode(",", $score);
					?>
					<tr>
						<td><?=$place; $place++?></td>
						<td><?=$table_data[0] ?></td>
						<td><?=$table_data[1] ?></td>
					</tr>
					<?php  } ?>
				</table>
			</div>
		</div>
	</body>
</html>