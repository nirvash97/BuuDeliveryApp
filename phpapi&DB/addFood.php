<?php
header("content-type:text/javascript;charset=utf-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);
$link = mysqli_connect('localhost', 'buuzap', 'buuzap@dmi1234', "buuzap");

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
				
		$idShop = $_GET['idShop'];
		$foodName = $_GET['foodName'];
		$imgPath = $_GET['imgPath'];
		$price = $_GET['price'];
		$info = $_GET['info'];

							
		$sql = "INSERT INTO `foodtable`(`id`, `idShop`, `foodName`, `imgPath`, `price`, `info`) VALUES (Null,'$idShop','$foodName','$imgPath','$price','$info')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Everything is okay ready for waorking";
   
}
	mysqli_close($link);
?>