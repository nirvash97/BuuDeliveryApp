-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 27, 2020 at 02:28 PM
-- Server version: 10.4.13-MariaDB
-- PHP Version: 7.4.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `buudeli`
--

-- --------------------------------------------------------

--
-- Table structure for table `foodtable`
--

CREATE TABLE `foodtable` (
  `id` int(11) NOT NULL,
  `idShop` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `foodName` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `imgPath` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `info` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `foodtable`
--

INSERT INTO `foodtable` (`id`, `idShop`, `foodName`, `imgPath`, `price`, `info`) VALUES
(1, '12', 'อื้มมมมม อาโหร่ยยย', '/Buudeli/Foodpic/FoodEdit810114110.jpg', '99999', 'สาธุ'),
(2, '12', 'Test_food1', '/Buudeli/Foodpic/Food211685399.jpg', '80', 'Hmmmmmm'),
(3, '12', 'แจงกืดแฮร่', '/Buudeli/Foodpic/Food566921088.jpg', '5000', 'มีตังก็แดกไม่มีก็ไปร้านอื่นอย่าโง่'),
(4, '12', 'โหยหา', '/Buudeli/Foodpic/Food853291407.jpg', '1000', '------'),
(5, '12', 'Test_food2', '/Buudeli/Foodpic/FoodEdit182068997.jpg', '200', 'กำหมัดละนะ แง๊2'),
(11, '18', 'เตี๋ยวหมู', '/Buudeli/Foodpic/Food766366914.jpg', '35', 'อาหารจากสวรรค์');

-- --------------------------------------------------------

--
-- Table structure for table `ordertable`
--

CREATE TABLE `ordertable` (
  `id` int(11) NOT NULL,
  `orderDate` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `idUser` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameUser` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `idShop` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameShop` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `distance` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `transport` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `idFood` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameFood` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `sum` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `rider` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `process` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ordertable`
--

INSERT INTO `ordertable` (`id`, `orderDate`, `idUser`, `nameUser`, `idShop`, `nameShop`, `distance`, `transport`, `idFood`, `nameFood`, `price`, `amount`, `sum`, `rider`, `process`) VALUES
(5, '2020-09-27 19:04:14', '11', 'user_test1', '12', 'Jumbo', '4.27', '65', '[3, 5, 2]', '[แจงกืดแฮร่, Test_food2, Test_food1]', '[5000, 200, 80]', '[1, 2, 3]', '[5000, 400, 240]', 'NONE', 'UserOrder'),
(6, '2020-09-27 19:15:18', '11', 'user_test1', '18', 'Ummmm', '0.08', '35', '[11]', '[เตี๋ยวหมู]', '[35]', '[2]', '[70]', 'NONE', 'UserOrder');

-- --------------------------------------------------------

--
-- Table structure for table `usertable`
--

CREATE TABLE `usertable` (
  `id` int(11) NOT NULL,
  `usertype` text COLLATE utf8_unicode_ci NOT NULL,
  `name` text COLLATE utf8_unicode_ci NOT NULL,
  `username` text COLLATE utf8_unicode_ci NOT NULL,
  `password` text COLLATE utf8_unicode_ci NOT NULL,
  `NameShop` text COLLATE utf8_unicode_ci NOT NULL,
  `Address` text CHARACTER SET utf32 COLLATE utf32_unicode_ci NOT NULL,
  `Phone` text COLLATE utf8_unicode_ci NOT NULL,
  `ImageUrl` text COLLATE utf8_unicode_ci NOT NULL,
  `Lat` text COLLATE utf8_unicode_ci NOT NULL,
  `Lng` text COLLATE utf8_unicode_ci NOT NULL,
  `Token` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `usertable`
--

INSERT INTO `usertable` (`id`, `usertype`, `name`, `username`, `password`, `NameShop`, `Address`, `Phone`, `ImageUrl`, `Lat`, `Lng`, `Token`) VALUES
(5, 'User', 'usertest', 'test1', '1231', '', '', '', '', '', '', ''),
(6, 'Rider', 'usertest2', 'test12', '12312', '', '', '', '', '', '', ''),
(7, 'Owner', 'userte3', 'test13', '12312', '', '', '', '', '', '', ''),
(8, 'User', 'อุ้ม', 'Aum1', '1234', '', '', '', '', '', '', ''),
(9, 'User', 'testdup', 'test4', '1234', '', '', '', '', '', '', ''),
(10, 'User', 'apptest1', 'apptest1', '1234', '', '', '', '', '', '', ''),
(11, 'User', 'user_test1', 'user_test1', '1234', '', '', '', '', '', '', ''),
(12, 'Owner', 'shop_test1', 'shop_test1', '1234', 'Jumbo', 'Yesss', '087777777', '/Buudeli/shopBanner/FixShop1233971.jpg', '13.277472', '100.953093', ''),
(13, 'Rider', 'rider_test1', 'rider_test1', '1234', '', '', '', '', '', '', ''),
(16, 'Owner', 'Shop Test User', 'shop_test001', '123456', 'Shop_test1 name', 'somewhere', '0998988888', '/Buudeli/shopBanner/FixShop6376030.jpg', '13.278337', '100.926150', ''),
(17, 'Owner', 'อุ้ม', 'aum_tester1', '1234', 'tx shop', 'heaven', '09777777', '/Buudeli/ShopBanner/shop52566.jpg', '13.2911098', '100.9162482', ''),
(18, 'Owner', 'ทศพร', 'shop_test2', '1234', 'Ummmm', 'burapha university', '0999999999', '/Buudeli/shopBanner/shop34617.jpg', '13.291717', '100.915933', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `foodtable`
--
ALTER TABLE `foodtable`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ordertable`
--
ALTER TABLE `ordertable`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usertable`
--
ALTER TABLE `usertable`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `foodtable`
--
ALTER TABLE `foodtable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `ordertable`
--
ALTER TABLE `ordertable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `usertable`
--
ALTER TABLE `usertable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
