<?php
header("content-type:text/javascript;charset=utf-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);
$link = mysqli_connect('localhost', 'root', '', "buudeli");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}


if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
			
		$id = $_GET['id'];
		$foodName = $_GET['foodName'];
		$imgPath = $_GET['imgPath'];
		$price = $_GET['price'];
		$info = $_GET['info'];
		
							
		$sql = "UPDATE `foodtable` SET `foodName`='$foodName',`imgPath`='$imgPath',`price`='$price',`info`='$info' WHERE id = '$id' ";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
			echo `$result`;
		}

	} else echo "Everything is okay ready for working";
   
}

	mysqli_close($link);
?>