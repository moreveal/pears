-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jul 06, 2025 at 11:04 PM
-- Server version: 10.3.22-MariaDB-log
-- PHP Version: 7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pears_logs`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `convertCharset` (`input_text` TEXT, `from_charset` VARCHAR(32), `to_charset` VARCHAR(32)) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci BEGIN
    DECLARE converted_text TEXT;
    
        SET converted_text = CONVERT(input_text USING utf8mb4);
    
    IF to_charset = 'windows-1251' THEN
        SET converted_text = CONVERT(input_text USING cp1251);
    END IF;

    RETURN converted_text;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin_logs`
--

CREATE TABLE `admin_logs` (
  `id` int(11) NOT NULL,
  `action` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_player_id` int(11) DEFAULT 0,
  `primary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_id` int(11) DEFAULT 0,
  `secondary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `row` int(11) NOT NULL,
  `rows` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `business_logs`
--

CREATE TABLE `business_logs` (
  `id` int(11) NOT NULL,
  `business_id` int(11) NOT NULL DEFAULT 0,
  `action` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_player_id` int(11) DEFAULT 0,
  `primary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `row` int(11) NOT NULL,
  `rows` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `car_logs`
--

CREATE TABLE `car_logs` (
  `id` int(11) NOT NULL,
  `car_id` int(11) NOT NULL,
  `action` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_player_id` int(11) DEFAULT 0,
  `primary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `row` int(11) NOT NULL,
  `rows` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `casino_logs`
--

CREATE TABLE `casino_logs` (
  `id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL DEFAULT 0,
  `primary_player_id` int(11) NOT NULL DEFAULT 0,
  `primary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `row` int(11) NOT NULL,
  `rows` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `connection_logs`
--

CREATE TABLE `connection_logs` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `account_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_gpci` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `family_logs`
--

CREATE TABLE `family_logs` (
  `id` int(11) NOT NULL,
  `family_id` int(11) NOT NULL DEFAULT 0,
  `action` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_player_id` int(11) DEFAULT 0,
  `primary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_id` int(11) DEFAULT 0,
  `secondary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `row` int(11) NOT NULL,
  `rows` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gold_logs`
--

CREATE TABLE `gold_logs` (
  `id` int(11) NOT NULL,
  `action` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_player_id` int(11) DEFAULT 0,
  `primary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_id` int(11) DEFAULT 0,
  `secondary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `row` int(11) NOT NULL,
  `rows` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `house_logs`
--

CREATE TABLE `house_logs` (
  `id` int(11) NOT NULL,
  `house_type` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `house_id` int(11) NOT NULL DEFAULT 0,
  `action` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_player_id` int(11) DEFAULT 0,
  `primary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `row` int(11) NOT NULL,
  `rows` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insult_logs`
--

CREATE TABLE `insult_logs` (
  `id` int(11) NOT NULL,
  `primary_player_id` int(11) NOT NULL DEFAULT 0,
  `primary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `rows` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_logs`
--

CREATE TABLE `inventory_logs` (
  `id` int(11) NOT NULL,
  `action` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_player_id` int(11) DEFAULT 0,
  `primary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_id` int(11) DEFAULT 0,
  `secondary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `row` int(11) NOT NULL,
  `rows` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `money_logs`
--

CREATE TABLE `money_logs` (
  `id` int(11) NOT NULL,
  `action` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_player_id` int(11) DEFAULT 0,
  `primary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_id` int(11) DEFAULT 0,
  `secondary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `row` int(11) NOT NULL,
  `rows` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `org_logs`
--

CREATE TABLE `org_logs` (
  `id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL DEFAULT 0,
  `action` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_player_id` int(11) DEFAULT 0,
  `primary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_id` int(11) DEFAULT 0,
  `secondary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `row` int(11) NOT NULL,
  `rows` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report_logs`
--

CREATE TABLE `report_logs` (
  `id` int(11) NOT NULL,
  `report_id` int(11) NOT NULL DEFAULT 0,
  `primary_player_id` int(11) DEFAULT 0,
  `primary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_id` int(11) DEFAULT 0,
  `secondary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `rows` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sysinternal_logs`
--

CREATE TABLE `sysinternal_logs` (
  `id` int(11) NOT NULL,
  `action` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `row` int(11) NOT NULL DEFAULT 0,
  `rows` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trade_logs`
--

CREATE TABLE `trade_logs` (
  `id` int(11) NOT NULL,
  `trade_id` int(11) NOT NULL DEFAULT 0,
  `primary_player_id` int(11) DEFAULT 0,
  `primary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `primary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_id` int(11) DEFAULT 0,
  `secondary_player_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `secondary_player_ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `slot_1_name` varchar(34) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `slot_1_id` int(11) DEFAULT NULL,
  `slot_1_amount` int(11) DEFAULT NULL,
  `slot_2_name` varchar(34) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `slot_2_id` int(11) DEFAULT NULL,
  `slot_2_amount` int(11) DEFAULT NULL,
  `slot_3_name` varchar(34) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `slot_3_id` int(11) DEFAULT NULL,
  `slot_3_amount` int(11) DEFAULT NULL,
  `timestamp` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `business_logs`
--
ALTER TABLE `business_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `car_logs`
--
ALTER TABLE `car_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `casino_logs`
--
ALTER TABLE `casino_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `connection_logs`
--
ALTER TABLE `connection_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `family_logs`
--
ALTER TABLE `family_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gold_logs`
--
ALTER TABLE `gold_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `house_logs`
--
ALTER TABLE `house_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `insult_logs`
--
ALTER TABLE `insult_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `inventory_logs`
--
ALTER TABLE `inventory_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `money_logs`
--
ALTER TABLE `money_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `org_logs`
--
ALTER TABLE `org_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `report_logs`
--
ALTER TABLE `report_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sysinternal_logs`
--
ALTER TABLE `sysinternal_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trade_logs`
--
ALTER TABLE `trade_logs`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_logs`
--
ALTER TABLE `admin_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=808;
--
-- AUTO_INCREMENT for table `business_logs`
--
ALTER TABLE `business_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `car_logs`
--
ALTER TABLE `car_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `casino_logs`
--
ALTER TABLE `casino_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;
--
-- AUTO_INCREMENT for table `connection_logs`
--
ALTER TABLE `connection_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=606;
--
-- AUTO_INCREMENT for table `family_logs`
--
ALTER TABLE `family_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `gold_logs`
--
ALTER TABLE `gold_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `house_logs`
--
ALTER TABLE `house_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;
--
-- AUTO_INCREMENT for table `insult_logs`
--
ALTER TABLE `insult_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT for table `inventory_logs`
--
ALTER TABLE `inventory_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;
--
-- AUTO_INCREMENT for table `money_logs`
--
ALTER TABLE `money_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=142;
--
-- AUTO_INCREMENT for table `org_logs`
--
ALTER TABLE `org_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=408;
--
-- AUTO_INCREMENT for table `report_logs`
--
ALTER TABLE `report_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;
--
-- AUTO_INCREMENT for table `sysinternal_logs`
--
ALTER TABLE `sysinternal_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=190;
--
-- AUTO_INCREMENT for table `trade_logs`
--
ALTER TABLE `trade_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
