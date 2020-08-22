-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 22, 2020 at 10:15 AM
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
(1, '12', 'อื้มมมมม อาโหร่ยยย', '/Buudeli/Foodpic/Food165701588.jpg', '99999', 'สาธุ');

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
(7, 'Owner', 'userte3', 'test13', '12312', 'nameshop_test1', 'adds', 'asdsa', 'url', 'lat', 'lng', ''),
(8, 'User', 'อุ้ม', 'Aum1', '1234', '', '', '', '', '', '', ''),
(9, 'User', 'testdup', 'test4', '1234', '', '', '', '', '', '', ''),
(10, 'User', 'apptest1', 'apptest1', '1234', '', '', '', '', '', '', ''),
(11, 'User', 'user_test1', 'user_test1', '1234', '', '', '', '', '', '', ''),
(12, 'Owner', 'shop_test1', 'shop_test1', '1234', 'Jumbo', 'Yesss', '087777777', '/Buudeli/shopBanner/FixShop1233971.jpg', '13.2911065', '100.9162398', ''),
(13, 'Rider', 'rider_test1', 'rider_test1', '1234', '', '', '', '', '', '', ''),
(16, 'Owner', 'Shop Test User', 'shop_test001', '123456', 'Shop_test1 name', 'somewhere', '0998988888', '/Buudeli/shop/shop9228.jpg', '13.2829724', '100.9254872', ''),
(17, 'Owner', 'อุ้ม', 'aum_tester1', '1234', 'tx shop', 'heaven', '09777777', '/Buudeli/shop/shop52566.jpg', '13.2911098', '100.9162482', ''),
(18, 'Owner', 'ทศพร', 'shop_test2', '1234', '', '', '', '', '', '', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `foodtable`
--
ALTER TABLE `foodtable`
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `usertable`
--
ALTER TABLE `usertable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
