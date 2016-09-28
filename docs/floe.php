<html>
	<head>
		<title>Floe</title>
		<meta charset="utf-8" />
		<link href="index.css" type="text/css" rel="stylesheet" />
		<link rel="shortcut icon" type="image/png" href="/favicon.png" />
		<script type= "text/javascript">
			function setFocusOnFlash(){
				var f1 = document.getElementById("floeGame");
				f1.tabIndex = 1234;
				f1.focus();
			}
		</script>
	</head>

	<body onload="setFocusOnFlash()">
		<div id="main">
			<h1>Floe</h1>
			<object id="floeGame" width="640" height="640" border="1">
				<param name="movie" value="Floe_Fin.swf">
				<embed src="Floe_Fin.swf" width="640" height="640"></embed>
			</object>
		</div>
	</body>
</html>