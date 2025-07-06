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
-- Database: `pears`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`server_user`@`%` PROCEDURE `get_admins_money` (OUT `result` BIGINT(20))  BEGIN
	SELECT SUM(Account + Money + CEIL(Ammo1 * 0.94)) INTO result FROM pp_igroki WHERE Soska > 0;
END$$

CREATE DEFINER=`server_user`@`%` PROCEDURE `get_admins_treasury_money` (OUT `result` BIGINT(20))  BEGIN
	SELECT serv32 INTO result FROM pp_server;
END$$

CREATE DEFINER=`server_user`@`%` PROCEDURE `get_businesses_money` (IN `include_casino` BOOLEAN, OUT `result` BIGINT(20))  BEGIN
	SELECT SUM(Schet + Bablo) INTO result FROM pp_bizz WHERE (include_casino OR newid != 200);
END$$

CREATE DEFINER=`server_user`@`%` PROCEDURE `get_casino_money` (OUT `result` BIGINT(20))  BEGIN
	SELECT SUM(Schet + Bablo) INTO result FROM pp_bizz WHERE newid = 200;
END$$

CREATE DEFINER=`server_user`@`%` PROCEDURE `get_categorized_money` ()  BEGIN
    DECLARE total_money BIGINT;
    DECLARE total_players_money BIGINT;
    DECLARE total_admins_money BIGINT;
    DECLARE total_admins_treasury_money BIGINT;
    DECLARE total_treasury_money BIGINT;
    DECLARE total_casino_money BIGINT;
    DECLARE total_orgs_money BIGINT;
    DECLARE total_businesses_money BIGINT;

    CALL get_total_money(1, 1, 1, 1, total_money);
    CALL get_players_money(0, total_players_money);
    CALL get_admins_money(total_admins_money);
    CALL get_admins_treasury_money(total_admins_treasury_money);
    CALL get_treasury_money(total_treasury_money);
    CALL get_casino_money(total_casino_money);
    CALL get_orgs_money(0, total_orgs_money);
    CALL get_businesses_money(0, total_businesses_money);
    
    SELECT * FROM
    (
        (SELECT "Total" AS name, total_money AS amount, (total_money / total_money) * 100 AS percentage)
        UNION ALL
        (SELECT "Players" AS name, total_players_money AS amount, (total_players_money / total_money) * 100 AS percentage)
        UNION ALL
        (SELECT "Admins" AS name, total_admins_money AS amount, (total_admins_money / total_money) * 100 AS percentage)
        UNION ALL
		(SELECT "Admins treasury" AS name, total_admins_treasury_money AS amount, (total_admins_treasury_money / total_money) * 100 AS percentage)
        UNION ALL
        (SELECT "Treasury" AS name, total_treasury_money AS amount, (total_treasury_money / total_money) * 100 AS percentage)
        UNION ALL
        (SELECT "Casino" AS name, total_casino_money AS amount, (total_casino_money / total_money) * 100 AS percentage)
        UNION ALL
        (SELECT "Organizations" AS name, total_orgs_money AS amount, (total_orgs_money / total_money) * 100 AS percentage)
        UNION ALL
        (SELECT "Businesses" AS name, total_businesses_money AS amount, (total_businesses_money / total_money) * 100 AS percentage)
    ) AS categories
    ORDER BY percentage DESC;
END$$

CREATE DEFINER=`server_user`@`%` PROCEDURE `get_orgs_money` (IN `include_treasury` BOOLEAN, OUT `result` BIGINT(20))  BEGIN
	SELECT SUM(lave + depozit) INTO result FROM pp_organization WHERE (include_treasury OR frakid != 7);
END$$

CREATE DEFINER=`server_user`@`%` PROCEDURE `get_players_money` (IN `include_admins` BOOLEAN, OUT `result` BIGINT(20))  BEGIN
	SELECT SUM(Account + Money + CEIL(Ammo1 * 0.94)) INTO result FROM pp_igroki WHERE (include_admins OR Soska = 0);
END$$

CREATE DEFINER=`server_user`@`%` PROCEDURE `get_total_money` (IN `include_admins` BOOLEAN, IN `include_treasury` BOOLEAN, IN `include_casino` BOOLEAN, IN `include_admins_treasury` BOOLEAN, OUT `result` BIGINT(20))  BEGIN
    DECLARE total_players_money BIGINT;
    DECLARE total_orgs_money BIGINT;
    DECLARE total_businesses_money BIGINT;
    DECLARE total_admins_treasury_money BIGINT;

    CALL get_players_money(include_admins, total_players_money);
    CALL get_orgs_money(include_treasury, total_orgs_money);
    CALL get_businesses_money(include_casino, total_businesses_money);
    CALL get_admins_treasury_money(total_admins_treasury_money);
    
    SELECT (total_players_money + total_orgs_money + total_businesses_money + IF(include_admins_treasury, total_admins_treasury_money, 0)) INTO result;
END$$

CREATE DEFINER=`server_user`@`%` PROCEDURE `get_treasury_money` (OUT `result` BIGINT(20))  BEGIN
	SELECT lave INTO result FROM pp_organization WHERE frakid = 7;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `aa_test`
--

CREATE TABLE `aa_test` (
  `newid` int(11) NOT NULL,
  `variable0` int(11) NOT NULL DEFAULT 0,
  `variable1` int(11) NOT NULL DEFAULT 0,
  `variable2` varchar(64) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `accessory`
--

CREATE TABLE `accessory` (
  `newid` int(11) NOT NULL,
  `acModel` int(11) NOT NULL DEFAULT 0,
  `acName` varchar(34) DEFAULT NULL,
  `acPrice` int(11) NOT NULL DEFAULT 0,
  `acStatus` int(11) NOT NULL DEFAULT 0,
  `acBone` int(11) NOT NULL DEFAULT 0,
  `acX` float NOT NULL DEFAULT 0,
  `acY` float NOT NULL DEFAULT 0,
  `acZ` float NOT NULL DEFAULT 0,
  `acrX` float NOT NULL DEFAULT 0,
  `acrY` float NOT NULL DEFAULT 0,
  `acrZ` float NOT NULL DEFAULT 0,
  `acsX` float NOT NULL DEFAULT 0,
  `acsY` float NOT NULL DEFAULT 0,
  `acsZ` float NOT NULL DEFAULT 0,
  `actX` float NOT NULL DEFAULT 0,
  `actY` float NOT NULL DEFAULT 0,
  `actZ` float NOT NULL DEFAULT 0,
  `actZoom` float NOT NULL DEFAULT 0,
  `acCase` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `achieve_server`
--

CREATE TABLE `achieve_server` (
  `newid` int(11) NOT NULL,
  `a0` int(11) NOT NULL DEFAULT 0,
  `a1` int(11) NOT NULL DEFAULT 0,
  `a2` int(11) NOT NULL DEFAULT 0,
  `a3` int(11) NOT NULL DEFAULT 0,
  `a4` int(11) NOT NULL DEFAULT 0,
  `a5` int(11) NOT NULL DEFAULT 0,
  `a6` int(11) NOT NULL DEFAULT 0,
  `a7` int(11) NOT NULL DEFAULT 0,
  `a8` int(11) NOT NULL DEFAULT 0,
  `a9` int(11) NOT NULL DEFAULT 0,
  `a10` int(11) NOT NULL DEFAULT 0,
  `a11` int(11) NOT NULL DEFAULT 0,
  `a12` int(11) NOT NULL DEFAULT 0,
  `a13` int(11) NOT NULL DEFAULT 0,
  `a14` int(11) NOT NULL DEFAULT 0,
  `a15` int(11) NOT NULL DEFAULT 0,
  `a16` int(11) NOT NULL DEFAULT 0,
  `a17` int(11) NOT NULL DEFAULT 0,
  `a18` int(11) NOT NULL DEFAULT 0,
  `a19` int(11) NOT NULL DEFAULT 0,
  `a20` int(11) NOT NULL DEFAULT 0,
  `a21` int(11) NOT NULL DEFAULT 0,
  `a22` int(11) NOT NULL DEFAULT 0,
  `a23` int(11) NOT NULL DEFAULT 0,
  `a24` int(11) NOT NULL DEFAULT 0,
  `a25` int(11) NOT NULL DEFAULT 0,
  `a26` int(11) NOT NULL DEFAULT 0,
  `a27` int(11) NOT NULL DEFAULT 0,
  `a28` int(11) NOT NULL DEFAULT 0,
  `a29` int(11) NOT NULL DEFAULT 0,
  `a30` int(11) NOT NULL DEFAULT 0,
  `a31` int(11) NOT NULL DEFAULT 0,
  `a32` int(11) NOT NULL DEFAULT 0,
  `a33` int(11) NOT NULL DEFAULT 0,
  `a34` int(11) NOT NULL DEFAULT 0,
  `a35` int(11) NOT NULL DEFAULT 0,
  `a36` int(11) NOT NULL DEFAULT 0,
  `a37` int(11) NOT NULL DEFAULT 0,
  `a38` int(11) NOT NULL DEFAULT 0,
  `a39` int(11) NOT NULL DEFAULT 0,
  `a40` int(11) NOT NULL DEFAULT 0,
  `a41` int(11) NOT NULL DEFAULT 0,
  `a42` int(11) NOT NULL DEFAULT 0,
  `a43` int(11) NOT NULL DEFAULT 0,
  `a44` int(11) NOT NULL DEFAULT 0,
  `a45` int(11) NOT NULL DEFAULT 0,
  `a46` int(11) NOT NULL DEFAULT 0,
  `a47` int(11) NOT NULL DEFAULT 0,
  `a48` int(11) NOT NULL DEFAULT 0,
  `a49` int(11) NOT NULL DEFAULT 0,
  `a50` int(11) NOT NULL DEFAULT 0,
  `a51` int(11) NOT NULL DEFAULT 0,
  `a52` int(11) NOT NULL DEFAULT 0,
  `a53` int(11) NOT NULL DEFAULT 0,
  `a54` int(11) NOT NULL DEFAULT 0,
  `a55` int(11) NOT NULL DEFAULT 0,
  `a56` int(11) NOT NULL DEFAULT 0,
  `a57` int(11) NOT NULL DEFAULT 0,
  `a58` int(11) NOT NULL DEFAULT 0,
  `a59` int(11) NOT NULL DEFAULT 0,
  `a60` int(11) NOT NULL DEFAULT 0,
  `a61` int(11) NOT NULL DEFAULT 0,
  `a62` int(11) NOT NULL DEFAULT 0,
  `a63` int(11) NOT NULL DEFAULT 0,
  `a64` int(11) NOT NULL DEFAULT 0,
  `a65` int(11) NOT NULL DEFAULT 0,
  `a66` int(11) NOT NULL DEFAULT 0,
  `a67` int(11) NOT NULL DEFAULT 0,
  `a68` int(11) NOT NULL DEFAULT 0,
  `a69` int(11) NOT NULL DEFAULT 0,
  `a70` int(11) NOT NULL DEFAULT 0,
  `a71` int(11) NOT NULL DEFAULT 0,
  `a72` int(11) NOT NULL DEFAULT 0,
  `a73` int(11) NOT NULL DEFAULT 0,
  `a74` int(11) NOT NULL DEFAULT 0,
  `a75` int(11) NOT NULL DEFAULT 0,
  `a76` int(11) NOT NULL DEFAULT 0,
  `a77` int(11) NOT NULL DEFAULT 0,
  `a78` int(11) NOT NULL DEFAULT 0,
  `a79` int(11) NOT NULL DEFAULT 0,
  `a80` int(11) NOT NULL DEFAULT 0,
  `a81` int(11) NOT NULL DEFAULT 0,
  `a82` int(11) NOT NULL DEFAULT 0,
  `a83` int(11) NOT NULL DEFAULT 0,
  `a84` int(11) NOT NULL DEFAULT 0,
  `a85` int(11) NOT NULL DEFAULT 0,
  `a86` int(11) NOT NULL DEFAULT 0,
  `a87` int(11) NOT NULL DEFAULT 0,
  `a88` int(11) NOT NULL DEFAULT 0,
  `a89` int(11) NOT NULL DEFAULT 0,
  `a90` int(11) NOT NULL DEFAULT 0,
  `a91` int(11) NOT NULL DEFAULT 0,
  `a92` int(11) NOT NULL DEFAULT 0,
  `a93` int(11) NOT NULL DEFAULT 0,
  `a94` int(11) NOT NULL DEFAULT 0,
  `a95` int(11) NOT NULL DEFAULT 0,
  `a96` int(11) NOT NULL DEFAULT 0,
  `a97` int(11) NOT NULL DEFAULT 0,
  `a98` int(11) NOT NULL DEFAULT 0,
  `a99` int(11) NOT NULL DEFAULT 0,
  `a100` int(11) NOT NULL DEFAULT 0,
  `a101` int(11) NOT NULL DEFAULT 0,
  `a102` int(11) NOT NULL DEFAULT 0,
  `a103` int(11) NOT NULL DEFAULT 0,
  `a104` int(11) NOT NULL DEFAULT 0,
  `a105` int(11) NOT NULL DEFAULT 0,
  `a106` int(11) NOT NULL DEFAULT 0,
  `a107` int(11) NOT NULL DEFAULT 0,
  `a108` int(11) NOT NULL DEFAULT 0,
  `a109` int(11) NOT NULL DEFAULT 0,
  `a110` int(11) NOT NULL DEFAULT 0,
  `a111` int(11) NOT NULL DEFAULT 0,
  `a112` int(11) NOT NULL DEFAULT 0,
  `a113` int(11) NOT NULL DEFAULT 0,
  `a114` int(11) NOT NULL DEFAULT 0,
  `a115` int(11) NOT NULL DEFAULT 0,
  `a116` int(11) NOT NULL DEFAULT 0,
  `a117` int(11) NOT NULL DEFAULT 0,
  `a118` int(11) NOT NULL DEFAULT 0,
  `a119` int(11) NOT NULL DEFAULT 0,
  `a120` int(11) NOT NULL DEFAULT 0,
  `a121` int(11) NOT NULL DEFAULT 0,
  `a122` int(11) NOT NULL DEFAULT 0,
  `a123` int(11) NOT NULL DEFAULT 0,
  `a124` int(11) NOT NULL DEFAULT 0,
  `a125` int(11) NOT NULL DEFAULT 0,
  `a126` int(11) NOT NULL DEFAULT 0,
  `a127` int(11) NOT NULL DEFAULT 0,
  `a128` int(11) NOT NULL DEFAULT 0,
  `a129` int(11) NOT NULL DEFAULT 0,
  `a130` int(11) NOT NULL DEFAULT 0,
  `a131` int(11) NOT NULL DEFAULT 0,
  `a132` int(11) NOT NULL DEFAULT 0,
  `a133` int(11) NOT NULL DEFAULT 0,
  `a134` int(11) NOT NULL DEFAULT 0,
  `a135` int(11) NOT NULL DEFAULT 0,
  `a136` int(11) NOT NULL DEFAULT 0,
  `a137` int(11) NOT NULL DEFAULT 0,
  `a138` int(11) NOT NULL DEFAULT 0,
  `a139` int(11) NOT NULL DEFAULT 0,
  `a140` int(11) NOT NULL DEFAULT 0,
  `a141` int(11) NOT NULL DEFAULT 0,
  `a142` int(11) NOT NULL DEFAULT 0,
  `a143` int(11) NOT NULL DEFAULT 0,
  `a144` int(11) NOT NULL DEFAULT 0,
  `a145` int(11) NOT NULL DEFAULT 0,
  `a146` int(11) NOT NULL DEFAULT 0,
  `a147` int(11) NOT NULL DEFAULT 0,
  `a148` int(11) NOT NULL DEFAULT 0,
  `a149` int(11) NOT NULL DEFAULT 0,
  `a150` int(11) NOT NULL DEFAULT 0,
  `a151` int(11) NOT NULL DEFAULT 0,
  `a152` int(11) NOT NULL DEFAULT 0,
  `a153` int(11) NOT NULL DEFAULT 0,
  `a154` int(11) NOT NULL DEFAULT 0,
  `a155` int(11) NOT NULL DEFAULT 0,
  `a156` int(11) NOT NULL DEFAULT 0,
  `a157` int(11) NOT NULL DEFAULT 0,
  `a158` int(11) NOT NULL DEFAULT 0,
  `a159` int(11) NOT NULL DEFAULT 0,
  `a160` int(11) NOT NULL DEFAULT 0,
  `a161` int(11) NOT NULL DEFAULT 0,
  `a162` int(11) NOT NULL DEFAULT 0,
  `a163` int(11) NOT NULL DEFAULT 0,
  `a164` int(11) NOT NULL DEFAULT 0,
  `a165` int(11) NOT NULL DEFAULT 0,
  `a166` int(11) NOT NULL DEFAULT 0,
  `a167` int(11) NOT NULL DEFAULT 0,
  `a168` int(11) NOT NULL DEFAULT 0,
  `a169` int(11) NOT NULL DEFAULT 0,
  `a170` int(11) NOT NULL DEFAULT 0,
  `a171` int(11) NOT NULL DEFAULT 0,
  `a172` int(11) NOT NULL DEFAULT 0,
  `a173` int(11) NOT NULL DEFAULT 0,
  `a174` int(11) NOT NULL DEFAULT 0,
  `a175` int(11) NOT NULL DEFAULT 0,
  `a176` int(11) NOT NULL DEFAULT 0,
  `a177` int(11) NOT NULL DEFAULT 0,
  `a178` int(11) NOT NULL DEFAULT 0,
  `a179` int(11) NOT NULL DEFAULT 0,
  `a180` int(11) NOT NULL DEFAULT 0,
  `a181` int(11) NOT NULL DEFAULT 0,
  `a182` int(11) NOT NULL DEFAULT 0,
  `a183` int(11) NOT NULL DEFAULT 0,
  `a184` int(11) NOT NULL DEFAULT 0,
  `a185` int(11) NOT NULL DEFAULT 0,
  `a186` int(11) NOT NULL DEFAULT 0,
  `a187` int(11) NOT NULL DEFAULT 0,
  `a188` int(11) NOT NULL DEFAULT 0,
  `a189` int(11) NOT NULL DEFAULT 0,
  `a190` int(11) NOT NULL DEFAULT 0,
  `a191` int(11) NOT NULL DEFAULT 0,
  `a192` int(11) NOT NULL DEFAULT 0,
  `a193` int(11) NOT NULL DEFAULT 0,
  `a194` int(11) NOT NULL DEFAULT 0,
  `a195` int(11) NOT NULL DEFAULT 0,
  `a196` int(11) NOT NULL DEFAULT 0,
  `a197` int(11) NOT NULL DEFAULT 0,
  `a198` int(11) NOT NULL DEFAULT 0,
  `a199` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ad_reklama`
--

CREATE TABLE `ad_reklama` (
  `advert` varchar(5) DEFAULT NULL,
  `stat` int(11) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 0,
  `vip` int(11) NOT NULL DEFAULT 0,
  `tema` varchar(24) DEFAULT NULL,
  `info` varchar(128) DEFAULT NULL,
  `name` varchar(24) DEFAULT NULL,
  `num` int(11) NOT NULL DEFAULT 0,
  `id` int(11) NOT NULL DEFAULT 0,
  `par` int(11) NOT NULL DEFAULT 0,
  `partwo` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `apartments`
--

CREATE TABLE `apartments` (
  `newid` int(11) NOT NULL,
  `apId` int(11) NOT NULL DEFAULT 0,
  `apClass` int(11) NOT NULL DEFAULT 0,
  `apStatus` int(11) NOT NULL DEFAULT 0,
  `apFloor` int(11) NOT NULL DEFAULT 0,
  `apWorldDefineEntrance` int(11) NOT NULL DEFAULT 0,
  `apCoord0` float NOT NULL DEFAULT 0,
  `apCoord1` float NOT NULL DEFAULT 0,
  `apCoord2` float NOT NULL DEFAULT 0,
  `apElevatorCoord0` float NOT NULL DEFAULT 0,
  `apElevatorCoord1` float NOT NULL DEFAULT 0,
  `apElevatorCoord2` float NOT NULL DEFAULT 0,
  `apElevatorCoordFloor0` float NOT NULL DEFAULT 0,
  `apElevatorCoordFloor1` float NOT NULL DEFAULT 0,
  `apElevatorCoordFloor2` float NOT NULL DEFAULT 0,
  `apHolCoord0` float NOT NULL DEFAULT 0,
  `apHolCoord1` float NOT NULL DEFAULT 0,
  `apHolCoord2` float NOT NULL DEFAULT 0,
  `apRoomCoordOne0` float NOT NULL DEFAULT 0,
  `apRoomCoordOne1` float NOT NULL DEFAULT 0,
  `apRoomCoordOne2` float NOT NULL DEFAULT 0,
  `apRoomCoordTwo0` float NOT NULL DEFAULT 0,
  `apRoomCoordTwo1` float NOT NULL DEFAULT 0,
  `apRoomCoordTwo2` float NOT NULL DEFAULT 0,
  `apRoomCoordThree0` float NOT NULL DEFAULT 0,
  `apRoomCoordThree1` float NOT NULL DEFAULT 0,
  `apRoomCoordThree2` float NOT NULL DEFAULT 0,
  `apRoomCoordFour0` float NOT NULL DEFAULT 0,
  `apRoomCoordFour1` float NOT NULL DEFAULT 0,
  `apRoomCoordFour2` float NOT NULL DEFAULT 0,
  `apRoomCoordOneExit0` float NOT NULL DEFAULT 0,
  `apRoomCoordOneExit1` float NOT NULL DEFAULT 0,
  `apRoomCoordOneExit2` float NOT NULL DEFAULT 0,
  `apRoomCoordTwoExit0` float NOT NULL DEFAULT 0,
  `apRoomCoordTwoExit1` float NOT NULL DEFAULT 0,
  `apRoomCoordTwoExit2` float NOT NULL DEFAULT 0,
  `apRoomCoordThreeExit0` float NOT NULL DEFAULT 0,
  `apRoomCoordThreeExit1` float NOT NULL DEFAULT 0,
  `apRoomCoordThreeExit2` float NOT NULL DEFAULT 0,
  `apRoomCoordFourExit0` float NOT NULL DEFAULT 0,
  `apRoomCoordFourExit1` float NOT NULL DEFAULT 0,
  `apRoomCoordFourExit2` float NOT NULL DEFAULT 0,
  `apPrice` int(11) NOT NULL DEFAULT 0,
  `apPriceGold` int(11) NOT NULL DEFAULT 0,
  `apInt` int(11) NOT NULL DEFAULT 0,
  `apRoomCoordExclusiveExit0` float NOT NULL DEFAULT 0,
  `apRoomCoordExclusiveExit1` float NOT NULL DEFAULT 0,
  `apRoomCoordExclusiveExit2` float NOT NULL DEFAULT 0,
  `apCoordHolRoof0` float NOT NULL DEFAULT 0,
  `apCoordHolRoof1` float NOT NULL DEFAULT 0,
  `apCoordHolRoof2` float NOT NULL DEFAULT 0,
  `apCoordPlatform0` float NOT NULL DEFAULT 0,
  `apCoordPlatform1` float NOT NULL DEFAULT 0,
  `apCoordPlatform2` float NOT NULL DEFAULT 0,
  `apCoordRoof0` float NOT NULL DEFAULT 0,
  `apCoordRoof1` float NOT NULL DEFAULT 0,
  `apCoordRoof2` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `apartmentsroom`
--

CREATE TABLE `apartmentsroom` (
  `aprID` int(11) NOT NULL,
  `aprStatus` int(11) NOT NULL DEFAULT 0,
  `aprOwn` int(11) NOT NULL DEFAULT 0,
  `aprOwnName` varchar(24) DEFAULT '',
  `apr_slot0` blob DEFAULT NULL,
  `apr_slot1` blob DEFAULT NULL,
  `apr_slot2` blob DEFAULT NULL,
  `apr_slot3` blob DEFAULT NULL,
  `apr_slot4` blob DEFAULT NULL,
  `apr_slot5` blob DEFAULT NULL,
  `apr_slot6` blob DEFAULT NULL,
  `apr_slot7` blob DEFAULT NULL,
  `apr_slot8` blob DEFAULT NULL,
  `apr_slot9` blob DEFAULT NULL,
  `apr_slot10` blob DEFAULT NULL,
  `apr_slot11` blob DEFAULT NULL,
  `apr_slot12` blob DEFAULT NULL,
  `apr_slot13` blob DEFAULT NULL,
  `apr_slot14` blob DEFAULT NULL,
  `apr_slot15` blob DEFAULT NULL,
  `apr_slot16` blob DEFAULT NULL,
  `apr_slot17` blob DEFAULT NULL,
  `apr_slot18` blob DEFAULT NULL,
  `apr_slot19` blob DEFAULT NULL,
  `aprApartmentsID` int(11) NOT NULL DEFAULT 0,
  `aprSellOwn` int(11) NOT NULL DEFAULT 0,
  `aprTaxes` int(11) NOT NULL DEFAULT 0,
  `aprTaxday` int(11) NOT NULL DEFAULT 0,
  `aprArest` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `aquarium`
--

CREATE TABLE `aquarium` (
  `newid` int(11) NOT NULL,
  `aqFishStat0` int(11) NOT NULL DEFAULT 0,
  `aqFishStat1` int(11) NOT NULL DEFAULT 0,
  `aqFishStat2` int(11) NOT NULL DEFAULT 0,
  `aqFishSatiety0` int(11) NOT NULL DEFAULT 0,
  `aqFishSatiety1` int(11) NOT NULL DEFAULT 0,
  `aqFishSatiety2` int(11) NOT NULL DEFAULT 0,
  `FishName0` varchar(11) DEFAULT NULL,
  `FishName1` varchar(11) DEFAULT NULL,
  `FishName2` varchar(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `backpacks`
--

CREATE TABLE `backpacks` (
  `backpackid` int(11) NOT NULL,
  `b_slot_0` blob DEFAULT NULL,
  `b_slot_1` blob DEFAULT NULL,
  `b_slot_2` blob DEFAULT NULL,
  `b_slot_3` blob DEFAULT NULL,
  `b_slot_4` blob DEFAULT NULL,
  `b_slot_5` blob DEFAULT NULL,
  `b_slot_6` blob DEFAULT NULL,
  `b_slot_7` blob DEFAULT NULL,
  `b_slot_8` blob DEFAULT NULL,
  `b_slot_9` blob DEFAULT NULL,
  `b_slot_10` blob DEFAULT NULL,
  `b_slot_11` blob DEFAULT NULL,
  `b_slot_12` blob DEFAULT NULL,
  `b_slot_13` blob DEFAULT NULL,
  `b_slot_14` blob DEFAULT NULL,
  `b_slot_15` blob DEFAULT NULL,
  `b_slot_16` blob DEFAULT NULL,
  `b_slot_17` blob DEFAULT NULL,
  `b_slot_18` blob DEFAULT NULL,
  `b_slot_19` blob DEFAULT NULL,
  `b_slot_20` blob DEFAULT NULL,
  `b_slot_21` blob DEFAULT NULL,
  `b_slot_22` blob DEFAULT NULL,
  `b_slot_23` blob DEFAULT NULL,
  `b_slot_24` blob DEFAULT NULL,
  `b_slot_25` blob DEFAULT NULL,
  `b_slot_26` blob DEFAULT NULL,
  `b_slot_27` blob DEFAULT NULL,
  `b_slot_28` blob DEFAULT NULL,
  `b_slot_29` blob DEFAULT NULL,
  `b_slot_30` blob DEFAULT NULL,
  `b_slot_31` blob DEFAULT NULL,
  `b_slot_32` blob DEFAULT NULL,
  `b_slot_33` blob DEFAULT NULL,
  `b_slot_34` blob DEFAULT NULL,
  `b_slot_35` blob DEFAULT NULL,
  `b_slot_36` blob DEFAULT NULL,
  `b_slot_37` blob DEFAULT NULL,
  `b_slot_38` blob DEFAULT NULL,
  `b_slot_39` blob DEFAULT NULL,
  `b_slot_40` blob DEFAULT NULL,
  `b_slot_41` blob DEFAULT NULL,
  `b_slot_42` blob DEFAULT NULL,
  `b_slot_43` blob DEFAULT NULL,
  `b_slot_44` blob DEFAULT NULL,
  `b_slot_45` blob DEFAULT NULL,
  `b_slot_46` blob DEFAULT NULL,
  `b_slot_47` blob DEFAULT NULL,
  `b_slot_48` blob DEFAULT NULL,
  `b_slot_49` blob DEFAULT NULL,
  `b_slot_50` blob DEFAULT NULL,
  `b_slot_51` blob DEFAULT NULL,
  `b_slot_52` blob DEFAULT NULL,
  `b_slot_53` blob DEFAULT NULL,
  `b_slot_54` blob DEFAULT NULL,
  `b_slot_55` blob DEFAULT NULL,
  `b_slot_56` blob DEFAULT NULL,
  `b_slot_57` blob DEFAULT NULL,
  `b_slot_58` blob DEFAULT NULL,
  `b_slot_59` blob DEFAULT NULL,
  `b_slot_60` blob DEFAULT NULL,
  `b_slot_61` blob DEFAULT NULL,
  `b_slot_62` blob DEFAULT NULL,
  `b_slot_63` blob DEFAULT NULL,
  `b_slot_64` blob DEFAULT NULL,
  `b_slot_65` blob DEFAULT NULL,
  `b_slot_66` blob DEFAULT NULL,
  `b_slot_67` blob DEFAULT NULL,
  `b_slot_68` blob DEFAULT NULL,
  `b_slot_69` blob DEFAULT NULL,
  `b_slot_70` blob DEFAULT NULL,
  `b_slot_71` blob DEFAULT NULL,
  `b_slot_72` blob DEFAULT NULL,
  `b_slot_73` blob DEFAULT NULL,
  `b_slot_74` blob DEFAULT NULL,
  `b_slot_75` blob DEFAULT NULL,
  `b_slot_76` blob DEFAULT NULL,
  `b_slot_77` blob DEFAULT NULL,
  `b_slot_78` blob DEFAULT NULL,
  `b_slot_79` blob DEFAULT NULL,
  `lastunix` int(11) NOT NULL DEFAULT 0,
  `Name` varchar(24) DEFAULT '',
  `user_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `battlepass`
--

CREATE TABLE `battlepass` (
  `user_id` int(11) NOT NULL,
  `bpLevel` int(11) NOT NULL DEFAULT 0,
  `bpExp` int(11) NOT NULL DEFAULT 0,
  `bpTaskDaily_0` blob DEFAULT NULL,
  `bpTaskDaily_1` blob DEFAULT NULL,
  `bpTaskDaily_2` blob DEFAULT NULL,
  `bpTaskDaily_3` blob DEFAULT NULL,
  `bpTaskWeekly_0` blob DEFAULT NULL,
  `bpTaskWeekly_1` blob DEFAULT NULL,
  `bpTaskWeekly_2` blob DEFAULT NULL,
  `bpTaskWeekly_3` blob DEFAULT NULL,
  `bpTaskWeekly_4` blob DEFAULT NULL,
  `bpTaskWeekly_5` blob DEFAULT NULL,
  `bpTaskWeekly_6` blob DEFAULT NULL,
  `bpTaskWeekly_7` blob DEFAULT NULL,
  `bpTaskOneTime_0` blob DEFAULT NULL,
  `bpTaskOneTime_1` blob DEFAULT NULL,
  `bpTaskOneTime_2` blob DEFAULT NULL,
  `bpTaskOneTime_3` blob DEFAULT NULL,
  `bpTaskOneTime_4` blob DEFAULT NULL,
  `bpTaskOneTime_5` blob DEFAULT NULL,
  `bpTaskOneTime_6` blob DEFAULT NULL,
  `bpTaskOneTime_7` blob DEFAULT NULL,
  `bpDay` int(11) NOT NULL DEFAULT 0,
  `bpWeekly` int(11) NOT NULL DEFAULT 0,
  `bpOneTimeLoad` tinyint(1) NOT NULL DEFAULT 0,
  `bpAwards_0` blob DEFAULT NULL,
  `bpAwards_1` blob DEFAULT NULL,
  `bpAwards_2` blob DEFAULT NULL,
  `bpAwards_3` blob DEFAULT NULL,
  `bpAwards_4` blob DEFAULT NULL,
  `bpAwards_5` blob DEFAULT NULL,
  `bpAwards_6` blob DEFAULT NULL,
  `bpAwards_7` blob DEFAULT NULL,
  `bpAwards_8` blob DEFAULT NULL,
  `bpAwards_9` blob DEFAULT NULL,
  `bpAwards_10` blob DEFAULT NULL,
  `bpAwards_11` blob DEFAULT NULL,
  `bpAwards_12` blob DEFAULT NULL,
  `bpAwards_13` blob DEFAULT NULL,
  `bpAwards_14` blob DEFAULT NULL,
  `bpAwards_15` blob DEFAULT NULL,
  `bpAwards_16` blob DEFAULT NULL,
  `bpAwards_17` blob DEFAULT NULL,
  `bpAwards_18` blob DEFAULT NULL,
  `bpAwards_19` blob DEFAULT NULL,
  `bpAwards_20` blob DEFAULT NULL,
  `bpAwards_21` blob DEFAULT NULL,
  `bpAwards_22` blob DEFAULT NULL,
  `bpAwards_23` blob DEFAULT NULL,
  `bpAwards_24` blob DEFAULT NULL,
  `bpAwards_25` blob DEFAULT NULL,
  `bpAwards_26` blob DEFAULT NULL,
  `bpAwards_27` blob DEFAULT NULL,
  `bpAwards_28` blob DEFAULT NULL,
  `bpAwards_29` blob DEFAULT NULL,
  `bpAwards_30` blob DEFAULT NULL,
  `bpAwards_31` blob DEFAULT NULL,
  `bpAwards_32` blob DEFAULT NULL,
  `bpAwards_33` blob DEFAULT NULL,
  `bpAwards_34` blob DEFAULT NULL,
  `bpAwards_35` blob DEFAULT NULL,
  `bpAwards_36` blob DEFAULT NULL,
  `bpAwards_37` blob DEFAULT NULL,
  `bpAwards_38` blob DEFAULT NULL,
  `bpAwards_39` blob DEFAULT NULL,
  `bpAwards_40` blob DEFAULT NULL,
  `bpAwards_41` blob DEFAULT NULL,
  `bpAwards_42` blob DEFAULT NULL,
  `bpAwards_43` blob DEFAULT NULL,
  `bpAwards_44` blob DEFAULT NULL,
  `bpAwards_45` blob DEFAULT NULL,
  `bpAwards_46` blob DEFAULT NULL,
  `bpAwards_47` blob DEFAULT NULL,
  `bpAwards_48` blob DEFAULT NULL,
  `bpAwards_49` blob DEFAULT NULL,
  `bpDonate` int(11) NOT NULL DEFAULT 0,
  `bpBuyLevel` int(11) NOT NULL DEFAULT 0,
  `pName` varchar(24) DEFAULT '',
  `Name` varchar(24) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `blacklist`
--

CREATE TABLE `blacklist` (
  `newid` int(11) NOT NULL,
  `org` int(11) NOT NULL DEFAULT 0,
  `playerid` int(11) NOT NULL DEFAULT 0,
  `player` varchar(24) DEFAULT NULL,
  `playerip` varchar(24) DEFAULT NULL,
  `unix` int(11) NOT NULL DEFAULT 0,
  `term` int(11) NOT NULL DEFAULT 0,
  `reason` varchar(64) DEFAULT NULL,
  `bailed` int(11) NOT NULL DEFAULT 0,
  `senderid` int(11) NOT NULL DEFAULT 0,
  `sender` varchar(24) DEFAULT NULL,
  `senderip` varchar(24) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `court_decisions`
--

CREATE TABLE `court_decisions` (
  `slot` int(11) DEFAULT NULL,
  `suspect` int(11) NOT NULL COMMENT 'Подозреваемый (ID аккаунта)',
  `arbiter` int(11) NOT NULL COMMENT 'Судья (ID аккаунта)',
  `lawyer` int(11) NOT NULL COMMENT 'Адвокат (ID аккаунта)',
  `type` int(11) NOT NULL COMMENT 'Вынесенное решение',
  `deposit` int(11) NOT NULL DEFAULT 0 COMMENT 'Залог / Сумма отработки',
  `time` int(11) NOT NULL DEFAULT 0 COMMENT 'Время вынесения приговора',
  `period` int(11) NOT NULL COMMENT 'Количество дней (для отработки/залога)',
  `wanted_return` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Возвращался ли розыск',
  `wanted` blob NOT NULL COMMENT 'Информация о статьях'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `criminal_code`
--

CREATE TABLE `criminal_code` (
  `newid` int(11) NOT NULL,
  `ccI` int(11) NOT NULL DEFAULT 0,
  `ccP` int(11) NOT NULL DEFAULT 0,
  `ccStatus` tinyint(1) NOT NULL DEFAULT 0,
  `ccArticle` varchar(8) DEFAULT NULL,
  `ccName` varchar(31) DEFAULT NULL,
  `ccLevel` int(11) NOT NULL DEFAULT 0,
  `ccFine` int(11) NOT NULL DEFAULT 0,
  `ccText` varchar(121) DEFAULT NULL,
  `ccUnix` int(11) NOT NULL DEFAULT 0,
  `ccPlayer` varchar(21) DEFAULT NULL,
  `ccUserID` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `crypto_log`
--

CREATE TABLE `crypto_log` (
  `tradecryptoNewid` int(11) NOT NULL,
  `tradecryptoSenderID` int(11) NOT NULL,
  `tradecryptoPlayerID` int(11) NOT NULL,
  `tradecryptoPlayerName` varchar(24) NOT NULL,
  `tradecryptoSenderName` varchar(24) NOT NULL,
  `tradecryptoPlayerIP` varchar(21) NOT NULL,
  `tradecryptoSenderIP` varchar(21) NOT NULL,
  `tradecryptoStatus` int(1) NOT NULL,
  `tradecryptoCount` int(11) NOT NULL,
  `tradecryptoCourse` int(11) NOT NULL,
  `tradecryptoUnix` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `ded_moroz`
--

CREATE TABLE `ded_moroz` (
  `name` varchar(24) DEFAULT NULL,
  `nameip` varchar(24) DEFAULT NULL,
  `member` varchar(24) DEFAULT NULL,
  `leader` varchar(24) DEFAULT NULL,
  `admin` varchar(24) DEFAULT NULL,
  `text` varchar(256) DEFAULT NULL,
  `date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `depart_weapons`
--

CREATE TABLE `depart_weapons` (
  `frakid` int(11) NOT NULL,
  `weapon` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `division`
--

CREATE TABLE `division` (
  `newid` int(11) NOT NULL,
  `org` int(11) NOT NULL DEFAULT 0,
  `divid` int(11) NOT NULL DEFAULT 0,
  `divRanks` int(11) NOT NULL DEFAULT 0,
  `divName` varchar(31) DEFAULT NULL,
  `divAbbreviation` varchar(11) DEFAULT NULL,
  `divSpawnPos0` float NOT NULL DEFAULT 0,
  `divSpawnPos1` float NOT NULL DEFAULT 0,
  `divSpawnPos2` float NOT NULL DEFAULT 0,
  `divSpawnPos3` float NOT NULL DEFAULT 0,
  `divSpawnWorld` int(11) NOT NULL DEFAULT 0,
  `divSpawnInterior` int(11) NOT NULL DEFAULT 0,
  `divColorHex` varchar(7) DEFAULT NULL,
  `divAvailableWeapons` varchar(256) NOT NULL,
  `divColorVeh0` int(11) NOT NULL DEFAULT 0,
  `divColorVeh1` int(11) NOT NULL DEFAULT 0,
  `divRankName0` varchar(31) DEFAULT NULL,
  `divRankName1` varchar(31) DEFAULT NULL,
  `divRankName2` varchar(31) DEFAULT NULL,
  `divRankName3` varchar(31) DEFAULT NULL,
  `divRankName4` varchar(31) DEFAULT NULL,
  `divRankName5` varchar(31) DEFAULT NULL,
  `divRankName6` varchar(31) DEFAULT NULL,
  `divRankName7` varchar(31) DEFAULT NULL,
  `divRankName8` varchar(31) DEFAULT NULL,
  `divRankName9` varchar(31) DEFAULT NULL,
  `divRankName10` varchar(31) DEFAULT NULL,
  `divRankName11` varchar(31) DEFAULT NULL,
  `divRankName12` varchar(31) DEFAULT NULL,
  `divRankName13` varchar(31) DEFAULT NULL,
  `divRankName14` varchar(31) DEFAULT NULL,
  `divRankName15` varchar(31) DEFAULT NULL,
  `divRankName16` varchar(31) DEFAULT NULL,
  `divRankName17` varchar(31) DEFAULT NULL,
  `divRankName18` varchar(31) DEFAULT NULL,
  `divRankName19` varchar(31) DEFAULT NULL,
  `divRankName20` varchar(31) DEFAULT NULL,
  `divRankName21` varchar(31) DEFAULT NULL,
  `divRankName22` varchar(31) DEFAULT NULL,
  `divRankName23` varchar(31) DEFAULT NULL,
  `divRankName24` varchar(31) DEFAULT NULL,
  `divRankName25` varchar(31) DEFAULT NULL,
  `divRankName26` varchar(31) DEFAULT NULL,
  `divRankName27` varchar(31) DEFAULT NULL,
  `divRankName28` varchar(31) DEFAULT NULL,
  `divRankName29` varchar(31) DEFAULT NULL,
  `divRankName30` varchar(31) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `editmodel`
--

CREATE TABLE `editmodel` (
  `newid` int(11) NOT NULL,
  `editModel` int(11) NOT NULL DEFAULT 0,
  `editPos0` float NOT NULL DEFAULT 0,
  `editPos1` float NOT NULL DEFAULT 0,
  `editPos2` float NOT NULL DEFAULT 0,
  `editPos3` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `fund_logs`
--

CREATE TABLE `fund_logs` (
  `newid` int(11) NOT NULL,
  `senderid` int(11) NOT NULL,
  `sender` varchar(24) NOT NULL,
  `senderip` varchar(24) NOT NULL,
  `quan` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(24) NOT NULL,
  `fundid` int(11) NOT NULL,
  `unix` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `fund_raisers`
--

CREATE TABLE `fund_raisers` (
  `fundNewid` int(11) NOT NULL,
  `fundActive` tinyint(1) NOT NULL DEFAULT 0,
  `fundName` varchar(44) DEFAULT NULL,
  `fundText` varchar(84) DEFAULT NULL,
  `fundMoney` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `fundRequired` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `fundPos0` float NOT NULL DEFAULT 0,
  `fundPos1` float NOT NULL DEFAULT 0,
  `fundPos2` float NOT NULL DEFAULT 0,
  `fundUnix` int(11) NOT NULL DEFAULT 0,
  `fundQuan` int(11) NOT NULL DEFAULT 0,
  `fundMaxMoney` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `fundMaxPlayerid` int(11) NOT NULL DEFAULT 0,
  `fundMaxPlayerName` varchar(24) DEFAULT NULL,
  `fundMaxUnix` int(11) NOT NULL DEFAULT 0,
  `fundGift` tinyint(1) NOT NULL DEFAULT 0,
  `fundGiftThingId0` int(11) NOT NULL DEFAULT 0,
  `fundGiftThingQuan0` int(11) NOT NULL DEFAULT 0,
  `fundGiftThingType0` int(11) NOT NULL DEFAULT 0,
  `fundGiftPrice0` int(11) NOT NULL DEFAULT 0,
  `fundGiftThingId1` int(11) NOT NULL DEFAULT 0,
  `fundGiftThingQuan1` int(11) NOT NULL DEFAULT 0,
  `fundGiftThingType1` int(11) NOT NULL DEFAULT 0,
  `fundGiftPrice1` int(11) NOT NULL DEFAULT 0,
  `fundGiftThingId2` int(11) NOT NULL DEFAULT 0,
  `fundGiftThingQuan2` int(11) NOT NULL DEFAULT 0,
  `fundGiftThingType2` int(11) NOT NULL DEFAULT 0,
  `fundGiftPrice2` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `honorboard`
--

CREATE TABLE `honorboard` (
  `newid` int(11) NOT NULL,
  `org` int(11) NOT NULL DEFAULT 0,
  `playerid` int(11) NOT NULL DEFAULT 0,
  `playerName` varchar(21) DEFAULT NULL,
  `Tplayerid` int(11) NOT NULL DEFAULT 0,
  `TplayerName` varchar(21) DEFAULT NULL,
  `Unix` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `labor_log`
--

CREATE TABLE `labor_log` (
  `newid` int(11) NOT NULL,
  `frakid` int(11) NOT NULL,
  `action` varchar(14) NOT NULL,
  `playerid` int(11) NOT NULL,
  `player` varchar(20) NOT NULL,
  `unix` int(11) NOT NULL,
  `row` int(11) NOT NULL,
  `rows` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `minewar`
--

CREATE TABLE `minewar` (
  `user_id` int(11) NOT NULL COMMENT 'ID аккаунта',
  `date` int(11) NOT NULL COMMENT 'Дата последней игры'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `myname_log`
--

CREATE TABLE `myname_log` (
  `newid` int(11) NOT NULL,
  `adminid` int(11) NOT NULL,
  `admin` varchar(24) NOT NULL,
  `adminip` varchar(24) NOT NULL,
  `acc` int(11) NOT NULL,
  `current` varchar(24) NOT NULL,
  `playerip` varchar(24) NOT NULL,
  `newname` varchar(24) NOT NULL,
  `unix` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `obstacles`
--

CREATE TABLE `obstacles` (
  `id` int(11) NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ID аккаунта создателя',
  `passtime` int(11) NOT NULL COMMENT 'Время прохождения',
  `last_passtime` int(11) NOT NULL COMMENT 'Время прохождения перед последним запуском',
  `vehiclepass` int(1) NOT NULL COMMENT 'Тип транспорта',
  `points` blob NOT NULL COMMENT 'Точки маршрута',
  `stats` blob NOT NULL COMMENT 'Статистика последнего забега'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `offense`
--

CREATE TABLE `offense` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL COMMENT 'ID игрока',
  `name` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ник игрока',
  `intruder_user_id` int(11) NOT NULL COMMENT 'ID нарушителя',
  `intruder_name` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ник нарушителя',
  `date` blob NOT NULL COMMENT 'Дата',
  `messages` blob NOT NULL COMMENT 'Сообщения нарушителя'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_logs`
--

CREATE TABLE `player_logs` (
  `newid` int(11) NOT NULL,
  `actionid` int(11) NOT NULL DEFAULT 0,
  `action` varchar(24) DEFAULT NULL,
  `playerid` int(11) NOT NULL DEFAULT 0,
  `player` varchar(24) DEFAULT NULL,
  `playerip` varchar(24) DEFAULT NULL,
  `gplayerid` int(11) NOT NULL DEFAULT 0,
  `gplayer` varchar(24) DEFAULT NULL,
  `gplayerip` varchar(24) DEFAULT NULL,
  `text` varchar(64) DEFAULT NULL,
  `unix` int(11) NOT NULL DEFAULT 0,
  `date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_achieve`
--

CREATE TABLE `pp_achieve` (
  `user_id` int(11) NOT NULL,
  `a0` mediumblob DEFAULT NULL,
  `a1` mediumblob DEFAULT NULL,
  `a2` mediumblob DEFAULT NULL,
  `a3` mediumblob DEFAULT NULL,
  `a4` mediumblob DEFAULT NULL,
  `a5` mediumblob DEFAULT NULL,
  `a6` mediumblob DEFAULT NULL,
  `a7` mediumblob DEFAULT NULL,
  `a8` mediumblob DEFAULT NULL,
  `a9` mediumblob DEFAULT NULL,
  `a10` mediumblob DEFAULT NULL,
  `a11` mediumblob DEFAULT NULL,
  `a12` mediumblob DEFAULT NULL,
  `a13` mediumblob DEFAULT NULL,
  `a14` mediumblob DEFAULT NULL,
  `a15` mediumblob DEFAULT NULL,
  `a16` mediumblob DEFAULT NULL,
  `a17` mediumblob DEFAULT NULL,
  `a18` mediumblob DEFAULT NULL,
  `a19` mediumblob DEFAULT NULL,
  `a20` mediumblob DEFAULT NULL,
  `a21` mediumblob DEFAULT NULL,
  `a22` mediumblob DEFAULT NULL,
  `a23` mediumblob DEFAULT NULL,
  `a24` mediumblob DEFAULT NULL,
  `a25` mediumblob DEFAULT NULL,
  `a26` mediumblob DEFAULT NULL,
  `a27` mediumblob DEFAULT NULL,
  `a28` mediumblob DEFAULT NULL,
  `a29` mediumblob DEFAULT NULL,
  `a30` mediumblob DEFAULT NULL,
  `a31` mediumblob DEFAULT NULL,
  `a32` mediumblob DEFAULT NULL,
  `a33` mediumblob DEFAULT NULL,
  `a34` mediumblob DEFAULT NULL,
  `a35` mediumblob DEFAULT NULL,
  `a36` mediumblob DEFAULT NULL,
  `a37` mediumblob DEFAULT NULL,
  `a38` mediumblob DEFAULT NULL,
  `a39` mediumblob DEFAULT NULL,
  `a40` mediumblob DEFAULT NULL,
  `a41` mediumblob DEFAULT NULL,
  `a42` mediumblob DEFAULT NULL,
  `a43` mediumblob DEFAULT NULL,
  `a44` mediumblob DEFAULT NULL,
  `a45` mediumblob DEFAULT NULL,
  `a46` mediumblob DEFAULT NULL,
  `a47` mediumblob DEFAULT NULL,
  `a48` mediumblob DEFAULT NULL,
  `a49` mediumblob DEFAULT NULL,
  `a50` mediumblob DEFAULT NULL,
  `a51` mediumblob DEFAULT NULL,
  `a52` mediumblob DEFAULT NULL,
  `a53` mediumblob DEFAULT NULL,
  `a54` mediumblob DEFAULT NULL,
  `a55` mediumblob DEFAULT NULL,
  `a56` mediumblob DEFAULT NULL,
  `a57` mediumblob DEFAULT NULL,
  `a58` mediumblob DEFAULT NULL,
  `a59` mediumblob DEFAULT NULL,
  `a60` mediumblob DEFAULT NULL,
  `a61` mediumblob DEFAULT NULL,
  `a62` mediumblob DEFAULT NULL,
  `a63` mediumblob DEFAULT NULL,
  `a64` mediumblob DEFAULT NULL,
  `a65` mediumblob DEFAULT NULL,
  `a66` mediumblob DEFAULT NULL,
  `a67` mediumblob DEFAULT NULL,
  `a68` mediumblob DEFAULT NULL,
  `a69` mediumblob DEFAULT NULL,
  `a70` mediumblob DEFAULT NULL,
  `a71` mediumblob DEFAULT NULL,
  `a72` mediumblob DEFAULT NULL,
  `a73` mediumblob DEFAULT NULL,
  `a74` mediumblob DEFAULT NULL,
  `a75` mediumblob DEFAULT NULL,
  `a76` mediumblob DEFAULT NULL,
  `a77` mediumblob DEFAULT NULL,
  `a78` mediumblob DEFAULT NULL,
  `a79` mediumblob DEFAULT NULL,
  `a80` mediumblob DEFAULT NULL,
  `a81` mediumblob DEFAULT NULL,
  `a82` mediumblob DEFAULT NULL,
  `a83` mediumblob DEFAULT NULL,
  `a84` mediumblob DEFAULT NULL,
  `a85` mediumblob DEFAULT NULL,
  `a86` mediumblob DEFAULT NULL,
  `a87` mediumblob DEFAULT NULL,
  `a88` mediumblob DEFAULT NULL,
  `a89` mediumblob DEFAULT NULL,
  `a90` mediumblob DEFAULT NULL,
  `a91` mediumblob DEFAULT NULL,
  `a92` mediumblob DEFAULT NULL,
  `a93` mediumblob DEFAULT NULL,
  `a94` mediumblob DEFAULT NULL,
  `a95` mediumblob DEFAULT NULL,
  `a96` mediumblob DEFAULT NULL,
  `a97` mediumblob DEFAULT NULL,
  `a98` mediumblob DEFAULT NULL,
  `a99` mediumblob DEFAULT NULL,
  `a100` mediumblob DEFAULT NULL,
  `a101` mediumblob DEFAULT NULL,
  `a102` mediumblob DEFAULT NULL,
  `a103` mediumblob DEFAULT NULL,
  `a104` mediumblob DEFAULT NULL,
  `a105` mediumblob DEFAULT NULL,
  `a106` mediumblob DEFAULT NULL,
  `a107` mediumblob DEFAULT NULL,
  `a108` mediumblob DEFAULT NULL,
  `a109` mediumblob DEFAULT NULL,
  `a110` mediumblob DEFAULT NULL,
  `a111` mediumblob DEFAULT NULL,
  `a112` mediumblob DEFAULT NULL,
  `a113` mediumblob DEFAULT NULL,
  `a114` mediumblob DEFAULT NULL,
  `a115` mediumblob DEFAULT NULL,
  `a116` mediumblob DEFAULT NULL,
  `a117` mediumblob DEFAULT NULL,
  `a118` mediumblob DEFAULT NULL,
  `a119` mediumblob DEFAULT NULL,
  `a120` mediumblob DEFAULT NULL,
  `a121` mediumblob DEFAULT NULL,
  `a122` mediumblob DEFAULT NULL,
  `a123` mediumblob DEFAULT NULL,
  `a124` mediumblob DEFAULT NULL,
  `a125` mediumblob DEFAULT NULL,
  `a126` mediumblob DEFAULT NULL,
  `a127` mediumblob DEFAULT NULL,
  `a128` mediumblob DEFAULT NULL,
  `a129` mediumblob DEFAULT NULL,
  `a130` mediumblob DEFAULT NULL,
  `a131` mediumblob DEFAULT NULL,
  `a132` mediumblob DEFAULT NULL,
  `a133` mediumblob DEFAULT NULL,
  `a134` mediumblob DEFAULT NULL,
  `a135` mediumblob DEFAULT NULL,
  `a136` mediumblob DEFAULT NULL,
  `a137` mediumblob DEFAULT NULL,
  `a138` mediumblob DEFAULT NULL,
  `a139` mediumblob DEFAULT NULL,
  `a140` mediumblob DEFAULT NULL,
  `a141` blob DEFAULT NULL,
  `a142` blob DEFAULT NULL,
  `a143` blob DEFAULT NULL,
  `a144` blob DEFAULT NULL,
  `a145` blob DEFAULT NULL,
  `a146` blob DEFAULT NULL,
  `a147` blob DEFAULT NULL,
  `a148` blob DEFAULT NULL,
  `a149` blob DEFAULT NULL,
  `a150` blob DEFAULT NULL,
  `a151` blob DEFAULT NULL,
  `a152` blob DEFAULT NULL,
  `a153` blob DEFAULT NULL,
  `a154` blob DEFAULT NULL,
  `a155` blob DEFAULT NULL,
  `a156` blob DEFAULT NULL,
  `a157` blob DEFAULT NULL,
  `a158` blob DEFAULT NULL,
  `a159` blob DEFAULT NULL,
  `a160` blob DEFAULT NULL,
  `a161` blob DEFAULT NULL,
  `a162` blob DEFAULT NULL,
  `a163` blob DEFAULT NULL,
  `a164` blob DEFAULT NULL,
  `a165` blob DEFAULT NULL,
  `a166` blob DEFAULT NULL,
  `a167` blob DEFAULT NULL,
  `a168` blob DEFAULT NULL,
  `a169` blob DEFAULT NULL,
  `a170` blob DEFAULT NULL,
  `a171` blob DEFAULT NULL,
  `a172` blob DEFAULT NULL,
  `a173` blob DEFAULT NULL,
  `a174` blob DEFAULT NULL,
  `a175` blob DEFAULT NULL,
  `a176` blob DEFAULT NULL,
  `a177` blob DEFAULT NULL,
  `a178` blob DEFAULT NULL,
  `a179` blob DEFAULT NULL,
  `a180` blob DEFAULT NULL,
  `a181` blob DEFAULT NULL,
  `a182` blob DEFAULT NULL,
  `a183` blob DEFAULT NULL,
  `a184` blob DEFAULT NULL,
  `a185` blob DEFAULT NULL,
  `a186` blob DEFAULT NULL,
  `a187` blob DEFAULT NULL,
  `a188` blob DEFAULT NULL,
  `a189` blob DEFAULT NULL,
  `a190` blob DEFAULT NULL,
  `a191` blob DEFAULT NULL,
  `a192` blob DEFAULT NULL,
  `a193` blob DEFAULT NULL,
  `a194` blob DEFAULT NULL,
  `a195` blob DEFAULT NULL,
  `a196` blob DEFAULT NULL,
  `a197` blob DEFAULT NULL,
  `a198` blob DEFAULT NULL,
  `a199` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_banip`
--

CREATE TABLE `pp_banip` (
  `ip` varchar(24) DEFAULT NULL,
  `ipname` varchar(24) DEFAULT NULL,
  `admname` varchar(24) DEFAULT NULL,
  `razban` int(11) NOT NULL DEFAULT 0,
  `date` datetime DEFAULT NULL,
  `reason` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_bizz`
--

CREATE TABLE `pp_bizz` (
  `newid` int(11) NOT NULL,
  `Vlad` varchar(24) NOT NULL,
  `Level` int(11) NOT NULL,
  `Sost` int(11) NOT NULL,
  `Data` int(11) NOT NULL,
  `bCost` int(11) NOT NULL,
  `bGold` int(11) NOT NULL,
  `Freeze` int(11) NOT NULL,
  `Arest` int(11) NOT NULL,
  `PriceProd` int(11) NOT NULL,
  `Bablo` int(11) NOT NULL,
  `Schet` int(11) NOT NULL,
  `Sell` int(11) NOT NULL,
  `Fam` int(11) NOT NULL,
  `Pastime` int(11) NOT NULL,
  `Mafunix` int(11) NOT NULL,
  `acc0` int(11) NOT NULL,
  `acc1` int(11) NOT NULL,
  `acc2` int(11) NOT NULL,
  `acc3` int(11) NOT NULL,
  `acc4` int(11) NOT NULL,
  `acc5` int(11) NOT NULL,
  `acc6` int(11) NOT NULL,
  `acc7` int(11) NOT NULL,
  `acc8` int(11) NOT NULL,
  `acc9` int(11) NOT NULL,
  `acc10` int(11) NOT NULL,
  `accrank0` int(11) NOT NULL,
  `accrank1` int(11) NOT NULL,
  `accrank2` int(11) NOT NULL,
  `accrank3` int(11) NOT NULL,
  `accrank4` int(11) NOT NULL,
  `accrank5` int(11) NOT NULL,
  `accrank6` int(11) NOT NULL,
  `accrank7` int(11) NOT NULL,
  `accrank8` int(11) NOT NULL,
  `accrank9` int(11) NOT NULL,
  `accrank10` int(11) NOT NULL,
  `Intorval` int(11) NOT NULL,
  `bcX` float NOT NULL,
  `bcY` float NOT NULL,
  `bcZ` float NOT NULL,
  `Lab` int(11) NOT NULL,
  `Descrip` int(11) NOT NULL,
  `Name` varchar(34) NOT NULL,
  `Taxes` int(11) NOT NULL,
  `Warn` int(11) NOT NULL,
  `Lien` int(11) NOT NULL,
  `ArTime` int(11) NOT NULL,
  `ArReason` varchar(64) NOT NULL,
  `Stat` int(11) NOT NULL,
  `StatReason` varchar(64) NOT NULL,
  `Taxday` int(11) NOT NULL,
  `Deposit` int(11) NOT NULL,
  `Income` int(11) NOT NULL,
  `Hiscome0` int(11) NOT NULL,
  `Hiscome1` int(11) NOT NULL,
  `Hiscome2` int(11) NOT NULL,
  `Hiscome3` int(11) NOT NULL,
  `Hiscome4` int(11) NOT NULL,
  `Hiscome5` int(11) NOT NULL,
  `Hiscome6` int(11) NOT NULL,
  `Hiscome7` int(11) NOT NULL,
  `Hiscome8` int(11) NOT NULL,
  `Hiscome9` int(11) NOT NULL,
  `Hiscome10` int(11) NOT NULL,
  `Hiscome11` int(11) NOT NULL,
  `Hiscome12` int(11) NOT NULL,
  `Hiscome13` int(11) NOT NULL,
  `Hiscome14` int(11) NOT NULL,
  `Hiscome15` int(11) NOT NULL,
  `Hiscome16` int(11) NOT NULL,
  `Hiscome17` int(11) NOT NULL,
  `Hiscome18` int(11) NOT NULL,
  `Hiscome19` int(11) NOT NULL,
  `Hiscome20` int(11) NOT NULL,
  `Hiscome21` int(11) NOT NULL,
  `Hiscome22` int(11) NOT NULL,
  `Hiscome23` int(11) NOT NULL,
  `Hiscome24` int(11) NOT NULL,
  `Hiscome25` int(11) NOT NULL,
  `Hiscome26` int(11) NOT NULL,
  `Hiscome27` int(11) NOT NULL,
  `Hiscome28` int(11) NOT NULL,
  `Hiscome29` int(11) NOT NULL,
  `obX0` float NOT NULL,
  `obY0` float NOT NULL,
  `obZ0` float NOT NULL,
  `obRX0` float NOT NULL,
  `obRY0` float NOT NULL,
  `obRZ0` float NOT NULL,
  `obX1` float NOT NULL,
  `obY1` float NOT NULL,
  `obZ1` float NOT NULL,
  `obRX1` float NOT NULL,
  `obRY1` float NOT NULL,
  `obRZ1` float NOT NULL,
  `EnterX` float NOT NULL,
  `EnterY` float NOT NULL,
  `EnterZ` float NOT NULL,
  `EnterA` float NOT NULL,
  `InteriorX` float NOT NULL,
  `InteriorY` float NOT NULL,
  `InteriorZ` float NOT NULL,
  `InteriorA` float NOT NULL,
  `Inter` int(11) NOT NULL,
  `BizBar` int(11) NOT NULL,
  `BizBarX` float NOT NULL,
  `BizBarY` float NOT NULL,
  `BizBarZ` float NOT NULL,
  `DeliveryPay` int(11) NOT NULL,
  `OrderStatus` int(11) NOT NULL,
  `setting0` int(11) NOT NULL,
  `setting1` int(11) NOT NULL,
  `setting2` int(11) NOT NULL,
  `parthner0` int(11) NOT NULL,
  `parthner1` int(11) NOT NULL,
  `parthner2` int(11) NOT NULL,
  `parthner3` int(11) NOT NULL,
  `parthner4` int(11) NOT NULL,
  `parthner5` int(11) NOT NULL,
  `parthner6` int(11) NOT NULL,
  `parthner7` int(11) NOT NULL,
  `parthner8` int(11) NOT NULL,
  `parthner9` int(11) NOT NULL,
  `bCity` int(11) NOT NULL,
  `bMafiaSchet` int(11) NOT NULL,
  `bZZ` int(1) NOT NULL,
  `p_slot_0` mediumblob DEFAULT NULL,
  `p_slot_1` mediumblob DEFAULT NULL,
  `p_slot_2` mediumblob DEFAULT NULL,
  `p_slot_3` mediumblob DEFAULT NULL,
  `p_slot_4` mediumblob DEFAULT NULL,
  `p_slot_5` mediumblob DEFAULT NULL,
  `p_slot_6` mediumblob DEFAULT NULL,
  `p_slot_7` mediumblob DEFAULT NULL,
  `p_slot_8` mediumblob DEFAULT NULL,
  `p_slot_9` mediumblob DEFAULT NULL,
  `p_slot_10` mediumblob DEFAULT NULL,
  `p_slot_11` mediumblob DEFAULT NULL,
  `p_slot_12` mediumblob DEFAULT NULL,
  `p_slot_13` mediumblob DEFAULT NULL,
  `p_slot_14` mediumblob DEFAULT NULL,
  `p_slot_15` mediumblob DEFAULT NULL,
  `p_slot_16` mediumblob DEFAULT NULL,
  `p_slot_17` mediumblob DEFAULT NULL,
  `p_slot_18` mediumblob DEFAULT NULL,
  `p_slot_19` mediumblob DEFAULT NULL,
  `p_slot_20` mediumblob DEFAULT NULL,
  `p_slot_21` mediumblob DEFAULT NULL,
  `p_slot_22` mediumblob DEFAULT NULL,
  `p_slot_23` mediumblob DEFAULT NULL,
  `p_slot_24` mediumblob DEFAULT NULL,
  `p_slot_25` mediumblob DEFAULT NULL,
  `p_slot_26` mediumblob DEFAULT NULL,
  `p_slot_27` mediumblob DEFAULT NULL,
  `p_slot_28` mediumblob DEFAULT NULL,
  `p_slot_29` mediumblob DEFAULT NULL,
  `p_slot_30` mediumblob DEFAULT NULL,
  `p_slot_31` mediumblob DEFAULT NULL,
  `p_slot_32` mediumblob DEFAULT NULL,
  `p_slot_33` mediumblob DEFAULT NULL,
  `p_slot_34` mediumblob DEFAULT NULL,
  `p_slot_35` mediumblob DEFAULT NULL,
  `p_slot_36` mediumblob DEFAULT NULL,
  `p_slot_37` mediumblob DEFAULT NULL,
  `p_slot_38` mediumblob DEFAULT NULL,
  `p_slot_39` mediumblob DEFAULT NULL,
  `p_slot_40` mediumblob DEFAULT NULL,
  `p_slot_41` mediumblob DEFAULT NULL,
  `p_slot_42` mediumblob DEFAULT NULL,
  `p_slot_43` mediumblob DEFAULT NULL,
  `p_slot_44` mediumblob DEFAULT NULL,
  `p_slot_45` mediumblob DEFAULT NULL,
  `p_slot_46` mediumblob DEFAULT NULL,
  `p_slot_47` mediumblob DEFAULT NULL,
  `p_slot_48` mediumblob DEFAULT NULL,
  `p_slot_49` mediumblob DEFAULT NULL,
  `b_slot_0` mediumblob DEFAULT NULL,
  `b_slot_1` mediumblob DEFAULT NULL,
  `b_slot_2` mediumblob DEFAULT NULL,
  `b_slot_3` mediumblob DEFAULT NULL,
  `b_slot_4` mediumblob DEFAULT NULL,
  `b_slot_5` mediumblob DEFAULT NULL,
  `b_slot_6` mediumblob DEFAULT NULL,
  `b_slot_7` mediumblob DEFAULT NULL,
  `b_slot_8` mediumblob DEFAULT NULL,
  `b_slot_9` mediumblob DEFAULT NULL,
  `b_slot_10` mediumblob DEFAULT NULL,
  `b_slot_11` mediumblob DEFAULT NULL,
  `b_slot_12` mediumblob DEFAULT NULL,
  `b_slot_13` mediumblob DEFAULT NULL,
  `b_slot_14` mediumblob DEFAULT NULL,
  `b_slot_15` mediumblob DEFAULT NULL,
  `b_slot_16` mediumblob DEFAULT NULL,
  `b_slot_17` mediumblob DEFAULT NULL,
  `b_slot_18` mediumblob DEFAULT NULL,
  `b_slot_19` mediumblob DEFAULT NULL,
  `b_slot_20` mediumblob DEFAULT NULL,
  `b_slot_21` mediumblob DEFAULT NULL,
  `b_slot_22` mediumblob DEFAULT NULL,
  `b_slot_23` mediumblob DEFAULT NULL,
  `b_slot_24` mediumblob DEFAULT NULL,
  `b_slot_25` mediumblob DEFAULT NULL,
  `b_slot_26` mediumblob DEFAULT NULL,
  `b_slot_27` mediumblob DEFAULT NULL,
  `b_slot_28` mediumblob DEFAULT NULL,
  `b_slot_29` mediumblob DEFAULT NULL,
  `b_slot_30` mediumblob DEFAULT NULL,
  `b_slot_31` mediumblob DEFAULT NULL,
  `b_slot_32` mediumblob DEFAULT NULL,
  `b_slot_33` mediumblob DEFAULT NULL,
  `b_slot_34` mediumblob DEFAULT NULL,
  `b_slot_35` mediumblob DEFAULT NULL,
  `b_slot_36` mediumblob DEFAULT NULL,
  `b_slot_37` mediumblob DEFAULT NULL,
  `b_slot_38` mediumblob DEFAULT NULL,
  `b_slot_39` mediumblob DEFAULT NULL,
  `b_slot_40` mediumblob DEFAULT NULL,
  `b_slot_41` mediumblob DEFAULT NULL,
  `b_slot_42` mediumblob DEFAULT NULL,
  `b_slot_43` mediumblob DEFAULT NULL,
  `b_slot_44` mediumblob DEFAULT NULL,
  `b_slot_45` mediumblob DEFAULT NULL,
  `b_slot_46` mediumblob DEFAULT NULL,
  `b_slot_47` mediumblob DEFAULT NULL,
  `b_slot_48` mediumblob DEFAULT NULL,
  `b_slot_49` mediumblob DEFAULT NULL,
  `b_slot_50` mediumblob DEFAULT NULL,
  `b_slot_51` mediumblob DEFAULT NULL,
  `b_slot_52` mediumblob DEFAULT NULL,
  `b_slot_53` mediumblob DEFAULT NULL,
  `b_slot_54` mediumblob DEFAULT NULL,
  `b_slot_55` mediumblob DEFAULT NULL,
  `b_slot_56` mediumblob DEFAULT NULL,
  `b_slot_57` mediumblob DEFAULT NULL,
  `b_slot_58` mediumblob DEFAULT NULL,
  `b_slot_59` mediumblob DEFAULT NULL,
  `b_slot_60` mediumblob DEFAULT NULL,
  `b_slot_61` mediumblob DEFAULT NULL,
  `b_slot_62` mediumblob DEFAULT NULL,
  `b_slot_63` mediumblob DEFAULT NULL,
  `b_slot_64` mediumblob DEFAULT NULL,
  `b_slot_65` mediumblob DEFAULT NULL,
  `b_slot_66` mediumblob DEFAULT NULL,
  `b_slot_67` mediumblob DEFAULT NULL,
  `b_slot_68` mediumblob DEFAULT NULL,
  `b_slot_69` mediumblob DEFAULT NULL,
  `b_slot_70` mediumblob DEFAULT NULL,
  `b_slot_71` mediumblob DEFAULT NULL,
  `b_slot_72` mediumblob DEFAULT NULL,
  `b_slot_73` mediumblob DEFAULT NULL,
  `b_slot_74` mediumblob DEFAULT NULL,
  `b_slot_75` mediumblob DEFAULT NULL,
  `b_slot_76` mediumblob DEFAULT NULL,
  `b_slot_77` mediumblob DEFAULT NULL,
  `b_slot_78` mediumblob DEFAULT NULL,
  `b_slot_79` mediumblob DEFAULT NULL,
  `o_slot_0` mediumblob DEFAULT NULL,
  `o_slot_1` mediumblob DEFAULT NULL,
  `o_slot_2` mediumblob DEFAULT NULL,
  `o_slot_3` mediumblob DEFAULT NULL,
  `o_slot_4` mediumblob DEFAULT NULL,
  `o_slot_5` mediumblob DEFAULT NULL,
  `o_slot_6` mediumblob DEFAULT NULL,
  `o_slot_7` mediumblob DEFAULT NULL,
  `o_slot_8` mediumblob DEFAULT NULL,
  `o_slot_9` mediumblob DEFAULT NULL,
  `o_slot_10` mediumblob DEFAULT NULL,
  `o_slot_11` mediumblob DEFAULT NULL,
  `o_slot_12` mediumblob DEFAULT NULL,
  `o_slot_13` mediumblob DEFAULT NULL,
  `o_slot_14` mediumblob DEFAULT NULL,
  `o_slot_15` mediumblob DEFAULT NULL,
  `o_slot_16` mediumblob DEFAULT NULL,
  `o_slot_17` mediumblob DEFAULT NULL,
  `o_slot_18` mediumblob DEFAULT NULL,
  `o_slot_19` mediumblob DEFAULT NULL,
  `o_slot_20` mediumblob DEFAULT NULL,
  `o_slot_21` mediumblob DEFAULT NULL,
  `o_slot_22` mediumblob DEFAULT NULL,
  `o_slot_23` mediumblob DEFAULT NULL,
  `o_slot_24` mediumblob DEFAULT NULL,
  `o_slot_25` mediumblob DEFAULT NULL,
  `o_slot_26` mediumblob DEFAULT NULL,
  `o_slot_27` mediumblob DEFAULT NULL,
  `o_slot_28` mediumblob DEFAULT NULL,
  `o_slot_29` mediumblob DEFAULT NULL,
  `o_slot_30` mediumblob DEFAULT NULL,
  `o_slot_31` mediumblob DEFAULT NULL,
  `o_slot_32` mediumblob DEFAULT NULL,
  `o_slot_33` mediumblob DEFAULT NULL,
  `o_slot_34` mediumblob DEFAULT NULL,
  `o_slot_35` mediumblob DEFAULT NULL,
  `o_slot_36` mediumblob DEFAULT NULL,
  `o_slot_37` mediumblob DEFAULT NULL,
  `o_slot_38` mediumblob DEFAULT NULL,
  `o_slot_39` mediumblob DEFAULT NULL,
  `o_slot_40` mediumblob DEFAULT NULL,
  `o_slot_41` mediumblob DEFAULT NULL,
  `o_slot_42` mediumblob DEFAULT NULL,
  `o_slot_43` mediumblob DEFAULT NULL,
  `o_slot_44` mediumblob DEFAULT NULL,
  `o_slot_45` mediumblob DEFAULT NULL,
  `o_slot_46` mediumblob DEFAULT NULL,
  `o_slot_47` mediumblob DEFAULT NULL,
  `o_slot_48` mediumblob DEFAULT NULL,
  `o_slot_49` mediumblob DEFAULT NULL,
  `BizShluhaX` float NOT NULL DEFAULT 0,
  `BizShluhaY` float NOT NULL DEFAULT 0,
  `BizShluhaZ` float NOT NULL DEFAULT 0,
  `BizShluhaA` float NOT NULL DEFAULT 0,
  `BizShluha` int(1) NOT NULL DEFAULT 0,
  `bAtmCollector` int(11) NOT NULL DEFAULT 0,
  `bElectroPayForConnect` int(11) NOT NULL DEFAULT 0,
  `bElectroPayForRepair` int(11) NOT NULL DEFAULT 0,
  `bChipsFee` int(11) NOT NULL DEFAULT 0,
  `bInteriorPack` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_bizzakses`
--

CREATE TABLE `pp_bizzakses` (
  `newid` int(11) NOT NULL,
  `ai0` int(11) NOT NULL,
  `ai1` int(11) NOT NULL,
  `ai2` int(11) NOT NULL,
  `ai3` int(11) NOT NULL,
  `ai4` int(11) NOT NULL,
  `ai5` int(11) NOT NULL,
  `ai6` int(11) NOT NULL,
  `ai7` int(11) NOT NULL,
  `ai8` int(11) NOT NULL,
  `ai9` int(11) NOT NULL,
  `ai10` int(11) NOT NULL,
  `ai11` int(11) NOT NULL,
  `ai12` int(11) NOT NULL,
  `ai13` int(11) NOT NULL,
  `ai14` int(11) NOT NULL,
  `ai15` int(11) NOT NULL,
  `ai16` int(11) NOT NULL,
  `ai17` int(11) NOT NULL,
  `ai18` int(11) NOT NULL,
  `ai19` int(11) NOT NULL,
  `ai20` int(11) NOT NULL,
  `ai21` int(11) NOT NULL,
  `ai22` int(11) NOT NULL,
  `ai23` int(11) NOT NULL,
  `ai24` int(11) NOT NULL,
  `ai25` int(11) NOT NULL,
  `ai26` int(11) NOT NULL,
  `ai27` int(11) NOT NULL,
  `ai28` int(11) NOT NULL,
  `ai29` int(11) NOT NULL,
  `ai30` int(11) NOT NULL,
  `ai31` int(11) NOT NULL,
  `ai32` int(11) NOT NULL,
  `ai33` int(11) NOT NULL,
  `ai34` int(11) NOT NULL,
  `ai35` int(11) NOT NULL,
  `ai36` int(11) NOT NULL,
  `ai37` int(11) NOT NULL,
  `ai38` int(11) NOT NULL,
  `ai39` int(11) NOT NULL,
  `ai40` int(11) NOT NULL,
  `ai41` int(11) NOT NULL,
  `ai42` int(11) NOT NULL,
  `ai43` int(11) NOT NULL,
  `ai44` int(11) NOT NULL,
  `ai45` int(11) NOT NULL,
  `ai46` int(11) NOT NULL,
  `ai47` int(11) NOT NULL,
  `ai48` int(11) NOT NULL,
  `ai49` int(11) NOT NULL,
  `ai50` int(11) NOT NULL,
  `ai51` int(11) NOT NULL,
  `ai52` int(11) NOT NULL,
  `ai53` int(11) NOT NULL,
  `ai54` int(11) NOT NULL,
  `ai55` int(11) NOT NULL,
  `ai56` int(11) NOT NULL,
  `ai57` int(11) NOT NULL,
  `ai58` int(11) NOT NULL,
  `ai59` int(11) NOT NULL,
  `ai60` int(11) NOT NULL,
  `ai61` int(11) NOT NULL,
  `ai62` int(11) NOT NULL,
  `ai63` int(11) NOT NULL,
  `ai64` int(11) NOT NULL,
  `ai65` int(11) NOT NULL,
  `ai66` int(11) NOT NULL,
  `ai67` int(11) NOT NULL,
  `ai68` int(11) NOT NULL,
  `ai69` int(11) NOT NULL,
  `ai70` int(11) NOT NULL,
  `ai71` int(11) NOT NULL,
  `ai72` int(11) NOT NULL,
  `ai73` int(11) NOT NULL,
  `ai74` int(11) NOT NULL,
  `ai75` int(11) NOT NULL,
  `ai76` int(11) NOT NULL,
  `ai77` int(11) NOT NULL,
  `ai78` int(11) NOT NULL,
  `ai79` int(11) NOT NULL,
  `ai80` int(11) NOT NULL,
  `ai81` int(11) NOT NULL,
  `ai82` int(11) NOT NULL,
  `ai83` int(11) NOT NULL,
  `ai84` int(11) NOT NULL,
  `ai85` int(11) NOT NULL,
  `ai86` int(11) NOT NULL,
  `ai87` int(11) NOT NULL,
  `ai88` int(11) NOT NULL,
  `ai89` int(11) NOT NULL,
  `ai90` int(11) NOT NULL,
  `ai91` int(11) NOT NULL,
  `ai92` int(11) NOT NULL,
  `ai93` int(11) NOT NULL,
  `ai94` int(11) NOT NULL,
  `ai95` int(11) NOT NULL,
  `ai96` int(11) NOT NULL,
  `ai97` int(11) NOT NULL,
  `ai98` int(11) NOT NULL,
  `ai99` int(11) NOT NULL,
  `ap0` int(11) NOT NULL,
  `ap1` int(11) NOT NULL,
  `ap2` int(11) NOT NULL,
  `ap3` int(11) NOT NULL,
  `ap4` int(11) NOT NULL,
  `ap5` int(11) NOT NULL,
  `ap6` int(11) NOT NULL,
  `ap7` int(11) NOT NULL,
  `ap8` int(11) NOT NULL,
  `ap9` int(11) NOT NULL,
  `ap10` int(11) NOT NULL,
  `ap11` int(11) NOT NULL,
  `ap12` int(11) NOT NULL,
  `ap13` int(11) NOT NULL,
  `ap14` int(11) NOT NULL,
  `ap15` int(11) NOT NULL,
  `ap16` int(11) NOT NULL,
  `ap17` int(11) NOT NULL,
  `ap18` int(11) NOT NULL,
  `ap19` int(11) NOT NULL,
  `ap20` int(11) NOT NULL,
  `ap21` int(11) NOT NULL,
  `ap22` int(11) NOT NULL,
  `ap23` int(11) NOT NULL,
  `ap24` int(11) NOT NULL,
  `ap25` int(11) NOT NULL,
  `ap26` int(11) NOT NULL,
  `ap27` int(11) NOT NULL,
  `ap28` int(11) NOT NULL,
  `ap29` int(11) NOT NULL,
  `ap30` int(11) NOT NULL,
  `ap31` int(11) NOT NULL,
  `ap32` int(11) NOT NULL,
  `ap33` int(11) NOT NULL,
  `ap34` int(11) NOT NULL,
  `ap35` int(11) NOT NULL,
  `ap36` int(11) NOT NULL,
  `ap37` int(11) NOT NULL,
  `ap38` int(11) NOT NULL,
  `ap39` int(11) NOT NULL,
  `ap40` int(11) NOT NULL,
  `ap41` int(11) NOT NULL,
  `ap42` int(11) NOT NULL,
  `ap43` int(11) NOT NULL,
  `ap44` int(11) NOT NULL,
  `ap45` int(11) NOT NULL,
  `ap46` int(11) NOT NULL,
  `ap47` int(11) NOT NULL,
  `ap48` int(11) NOT NULL,
  `ap49` int(11) NOT NULL,
  `ap50` int(11) NOT NULL,
  `ap51` int(11) NOT NULL,
  `ap52` int(11) NOT NULL,
  `ap53` int(11) NOT NULL,
  `ap54` int(11) NOT NULL,
  `ap55` int(11) NOT NULL,
  `ap56` int(11) NOT NULL,
  `ap57` int(11) NOT NULL,
  `ap58` int(11) NOT NULL,
  `ap59` int(11) NOT NULL,
  `ap60` int(11) NOT NULL,
  `ap61` int(11) NOT NULL,
  `ap62` int(11) NOT NULL,
  `ap63` int(11) NOT NULL,
  `ap64` int(11) NOT NULL,
  `ap65` int(11) NOT NULL,
  `ap66` int(11) NOT NULL,
  `ap67` int(11) NOT NULL,
  `ap68` int(11) NOT NULL,
  `ap69` int(11) NOT NULL,
  `ap70` int(11) NOT NULL,
  `ap71` int(11) NOT NULL,
  `ap72` int(11) NOT NULL,
  `ap73` int(11) NOT NULL,
  `ap74` int(11) NOT NULL,
  `ap75` int(11) NOT NULL,
  `ap76` int(11) NOT NULL,
  `ap77` int(11) NOT NULL,
  `ap78` int(11) NOT NULL,
  `ap79` int(11) NOT NULL,
  `ap80` int(11) NOT NULL,
  `ap81` int(11) NOT NULL,
  `ap82` int(11) NOT NULL,
  `ap83` int(11) NOT NULL,
  `ap84` int(11) NOT NULL,
  `ap85` int(11) NOT NULL,
  `ap86` int(11) NOT NULL,
  `ap87` int(11) NOT NULL,
  `ap88` int(11) NOT NULL,
  `ap89` int(11) NOT NULL,
  `ap90` int(11) NOT NULL,
  `ap91` int(11) NOT NULL,
  `ap92` int(11) NOT NULL,
  `ap93` int(11) NOT NULL,
  `ap94` int(11) NOT NULL,
  `ap95` int(11) NOT NULL,
  `ap96` int(11) NOT NULL,
  `ap97` int(11) NOT NULL,
  `ap98` int(11) NOT NULL,
  `ap99` int(11) NOT NULL,
  `aq0` int(11) NOT NULL,
  `aq1` int(11) NOT NULL,
  `aq2` int(11) NOT NULL,
  `aq3` int(11) NOT NULL,
  `aq4` int(11) NOT NULL,
  `aq5` int(11) NOT NULL,
  `aq6` int(11) NOT NULL,
  `aq7` int(11) NOT NULL,
  `aq8` int(11) NOT NULL,
  `aq9` int(11) NOT NULL,
  `aq10` int(11) NOT NULL,
  `aq11` int(11) NOT NULL,
  `aq12` int(11) NOT NULL,
  `aq13` int(11) NOT NULL,
  `aq14` int(11) NOT NULL,
  `aq15` int(11) NOT NULL,
  `aq16` int(11) NOT NULL,
  `aq17` int(11) NOT NULL,
  `aq18` int(11) NOT NULL,
  `aq19` int(11) NOT NULL,
  `aq20` int(11) NOT NULL,
  `aq21` int(11) NOT NULL,
  `aq22` int(11) NOT NULL,
  `aq23` int(11) NOT NULL,
  `aq24` int(11) NOT NULL,
  `aq25` int(11) NOT NULL,
  `aq26` int(11) NOT NULL,
  `aq27` int(11) NOT NULL,
  `aq28` int(11) NOT NULL,
  `aq29` int(11) NOT NULL,
  `aq30` int(11) NOT NULL,
  `aq31` int(11) NOT NULL,
  `aq32` int(11) NOT NULL,
  `aq33` int(11) NOT NULL,
  `aq34` int(11) NOT NULL,
  `aq35` int(11) NOT NULL,
  `aq36` int(11) NOT NULL,
  `aq37` int(11) NOT NULL,
  `aq38` int(11) NOT NULL,
  `aq39` int(11) NOT NULL,
  `aq40` int(11) NOT NULL,
  `aq41` int(11) NOT NULL,
  `aq42` int(11) NOT NULL,
  `aq43` int(11) NOT NULL,
  `aq44` int(11) NOT NULL,
  `aq45` int(11) NOT NULL,
  `aq46` int(11) NOT NULL,
  `aq47` int(11) NOT NULL,
  `aq48` int(11) NOT NULL,
  `aq49` int(11) NOT NULL,
  `aq50` int(11) NOT NULL,
  `aq51` int(11) NOT NULL,
  `aq52` int(11) NOT NULL,
  `aq53` int(11) NOT NULL,
  `aq54` int(11) NOT NULL,
  `aq55` int(11) NOT NULL,
  `aq56` int(11) NOT NULL,
  `aq57` int(11) NOT NULL,
  `aq58` int(11) NOT NULL,
  `aq59` int(11) NOT NULL,
  `aq60` int(11) NOT NULL,
  `aq61` int(11) NOT NULL,
  `aq62` int(11) NOT NULL,
  `aq63` int(11) NOT NULL,
  `aq64` int(11) NOT NULL,
  `aq65` int(11) NOT NULL,
  `aq66` int(11) NOT NULL,
  `aq67` int(11) NOT NULL,
  `aq68` int(11) NOT NULL,
  `aq69` int(11) NOT NULL,
  `aq70` int(11) NOT NULL,
  `aq71` int(11) NOT NULL,
  `aq72` int(11) NOT NULL,
  `aq73` int(11) NOT NULL,
  `aq74` int(11) NOT NULL,
  `aq75` int(11) NOT NULL,
  `aq76` int(11) NOT NULL,
  `aq77` int(11) NOT NULL,
  `aq78` int(11) NOT NULL,
  `aq79` int(11) NOT NULL,
  `aq80` int(11) NOT NULL,
  `aq81` int(11) NOT NULL,
  `aq82` int(11) NOT NULL,
  `aq83` int(11) NOT NULL,
  `aq84` int(11) NOT NULL,
  `aq85` int(11) NOT NULL,
  `aq86` int(11) NOT NULL,
  `aq87` int(11) NOT NULL,
  `aq88` int(11) NOT NULL,
  `aq89` int(11) NOT NULL,
  `aq90` int(11) NOT NULL,
  `aq91` int(11) NOT NULL,
  `aq92` int(11) NOT NULL,
  `aq93` int(11) NOT NULL,
  `aq94` int(11) NOT NULL,
  `aq95` int(11) NOT NULL,
  `aq96` int(11) NOT NULL,
  `aq97` int(11) NOT NULL,
  `aq98` int(11) NOT NULL,
  `aq99` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_bizzobject`
--

CREATE TABLE `pp_bizzobject` (
  `bizid` int(11) NOT NULL COMMENT 'ID бизнеса',
  `slot` int(11) NOT NULL COMMENT 'Слот объекта (тип)',
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `rX` float NOT NULL,
  `rY` float NOT NULL,
  `rZ` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pp_bizzstore`
--

CREATE TABLE `pp_bizzstore` (
  `newid` int(11) NOT NULL,
  `si0` int(11) NOT NULL,
  `si1` int(11) NOT NULL,
  `si2` int(11) NOT NULL,
  `si3` int(11) NOT NULL,
  `si4` int(11) NOT NULL,
  `si5` int(11) NOT NULL,
  `si6` int(11) NOT NULL,
  `si7` int(11) NOT NULL,
  `si8` int(11) NOT NULL,
  `si9` int(11) NOT NULL,
  `si10` int(11) NOT NULL,
  `si11` int(11) NOT NULL,
  `si12` int(11) NOT NULL,
  `si13` int(11) NOT NULL,
  `si14` int(11) NOT NULL,
  `si15` int(11) NOT NULL,
  `si16` int(11) NOT NULL,
  `si17` int(11) NOT NULL,
  `si18` int(11) NOT NULL,
  `si19` int(11) NOT NULL,
  `si20` int(11) NOT NULL,
  `si21` int(11) NOT NULL,
  `si22` int(11) NOT NULL,
  `si23` int(11) NOT NULL,
  `si24` int(11) NOT NULL,
  `si25` int(11) NOT NULL,
  `si26` int(11) NOT NULL,
  `si27` int(11) NOT NULL,
  `si28` int(11) NOT NULL,
  `si29` int(11) NOT NULL,
  `si30` int(11) NOT NULL,
  `si31` int(11) NOT NULL,
  `si32` int(11) NOT NULL,
  `si33` int(11) NOT NULL,
  `si34` int(11) NOT NULL,
  `si35` int(11) NOT NULL,
  `si36` int(11) NOT NULL,
  `si37` int(11) NOT NULL,
  `si38` int(11) NOT NULL,
  `si39` int(11) NOT NULL,
  `si40` int(11) NOT NULL,
  `si41` int(11) NOT NULL,
  `si42` int(11) NOT NULL,
  `si43` int(11) NOT NULL,
  `si44` int(11) NOT NULL,
  `si45` int(11) NOT NULL,
  `si46` int(11) NOT NULL,
  `si47` int(11) NOT NULL,
  `si48` int(11) NOT NULL,
  `si49` int(11) NOT NULL,
  `sp0` int(11) NOT NULL,
  `sp1` int(11) NOT NULL,
  `sp2` int(11) NOT NULL,
  `sp3` int(11) NOT NULL,
  `sp4` int(11) NOT NULL,
  `sp5` int(11) NOT NULL,
  `sp6` int(11) NOT NULL,
  `sp7` int(11) NOT NULL,
  `sp8` int(11) NOT NULL,
  `sp9` int(11) NOT NULL,
  `sp10` int(11) NOT NULL,
  `sp11` int(11) NOT NULL,
  `sp12` int(11) NOT NULL,
  `sp13` int(11) NOT NULL,
  `sp14` int(11) NOT NULL,
  `sp15` int(11) NOT NULL,
  `sp16` int(11) NOT NULL,
  `sp17` int(11) NOT NULL,
  `sp18` int(11) NOT NULL,
  `sp19` int(11) NOT NULL,
  `sp20` int(11) NOT NULL,
  `sp21` int(11) NOT NULL,
  `sp22` int(11) NOT NULL,
  `sp23` int(11) NOT NULL,
  `sp24` int(11) NOT NULL,
  `sp25` int(11) NOT NULL,
  `sp26` int(11) NOT NULL,
  `sp27` int(11) NOT NULL,
  `sp28` int(11) NOT NULL,
  `sp29` int(11) NOT NULL,
  `sp30` int(11) NOT NULL,
  `sp31` int(11) NOT NULL,
  `sp32` int(11) NOT NULL,
  `sp33` int(11) NOT NULL,
  `sp34` int(11) NOT NULL,
  `sp35` int(11) NOT NULL,
  `sp36` int(11) NOT NULL,
  `sp37` int(11) NOT NULL,
  `sp38` int(11) NOT NULL,
  `sp39` int(11) NOT NULL,
  `sp40` int(11) NOT NULL,
  `sp41` int(11) NOT NULL,
  `sp42` int(11) NOT NULL,
  `sp43` int(11) NOT NULL,
  `sp44` int(11) NOT NULL,
  `sp45` int(11) NOT NULL,
  `sp46` int(11) NOT NULL,
  `sp47` int(11) NOT NULL,
  `sp48` int(11) NOT NULL,
  `sp49` int(11) NOT NULL,
  `sq0` int(11) NOT NULL,
  `sq1` int(11) NOT NULL,
  `sq2` int(11) NOT NULL,
  `sq3` int(11) NOT NULL,
  `sq4` int(11) NOT NULL,
  `sq5` int(11) NOT NULL,
  `sq6` int(11) NOT NULL,
  `sq7` int(11) NOT NULL,
  `sq8` int(11) NOT NULL,
  `sq9` int(11) NOT NULL,
  `sq10` int(11) NOT NULL,
  `sq11` int(11) NOT NULL,
  `sq12` int(11) NOT NULL,
  `sq13` int(11) NOT NULL,
  `sq14` int(11) NOT NULL,
  `sq15` int(11) NOT NULL,
  `sq16` int(11) NOT NULL,
  `sq17` int(11) NOT NULL,
  `sq18` int(11) NOT NULL,
  `sq19` int(11) NOT NULL,
  `sq20` int(11) NOT NULL,
  `sq21` int(11) NOT NULL,
  `sq22` int(11) NOT NULL,
  `sq23` int(11) NOT NULL,
  `sq24` int(11) NOT NULL,
  `sq25` int(11) NOT NULL,
  `sq26` int(11) NOT NULL,
  `sq27` int(11) NOT NULL,
  `sq28` int(11) NOT NULL,
  `sq29` int(11) NOT NULL,
  `sq30` int(11) NOT NULL,
  `sq31` int(11) NOT NULL,
  `sq32` int(11) NOT NULL,
  `sq33` int(11) NOT NULL,
  `sq34` int(11) NOT NULL,
  `sq35` int(11) NOT NULL,
  `sq36` int(11) NOT NULL,
  `sq37` int(11) NOT NULL,
  `sq38` int(11) NOT NULL,
  `sq39` int(11) NOT NULL,
  `sq40` int(11) NOT NULL,
  `sq41` int(11) NOT NULL,
  `sq42` int(11) NOT NULL,
  `sq43` int(11) NOT NULL,
  `sq44` int(11) NOT NULL,
  `sq45` int(11) NOT NULL,
  `sq46` int(11) NOT NULL,
  `sq47` int(11) NOT NULL,
  `sq48` int(11) NOT NULL,
  `sq49` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_busstation`
--

CREATE TABLE `pp_busstation` (
  `idbusstation` int(11) NOT NULL,
  `bsActive` int(11) DEFAULT 0,
  `bsName` varchar(34) CHARACTER SET utf8mb4 DEFAULT NULL,
  `bsCordX` float NOT NULL DEFAULT 0,
  `bsCordY` float NOT NULL DEFAULT 0,
  `bsCordZ` float NOT NULL DEFAULT 0,
  `bsCordRX` float NOT NULL DEFAULT 0,
  `bsCordRY` float NOT NULL DEFAULT 0,
  `bsCordRZ` float NOT NULL DEFAULT 0,
  `bsVlad` int(11) NOT NULL DEFAULT 0,
  `bsPlayerName` varchar(24) CHARACTER SET utf8mb4 DEFAULT NULL,
  `bsUnix` int(11) NOT NULL DEFAULT 0,
  `bsCity` int(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_camera`
--

CREATE TABLE `pp_camera` (
  `newid` int(11) NOT NULL,
  `Stat` int(11) NOT NULL DEFAULT 0,
  `Account` int(11) NOT NULL DEFAULT 0,
  `Vlad` varchar(24) DEFAULT NULL,
  `Name` varchar(24) DEFAULT NULL,
  `Date` int(11) NOT NULL DEFAULT 0,
  `cX` float NOT NULL DEFAULT 0,
  `cY` float NOT NULL DEFAULT 0,
  `cZ` float NOT NULL DEFAULT 0,
  `cRX` float NOT NULL DEFAULT 0,
  `cRY` float NOT NULL DEFAULT 0,
  `cRZ` float NOT NULL DEFAULT 0,
  `World` int(11) NOT NULL DEFAULT 0,
  `Interior` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_cars`
--

CREATE TABLE `pp_cars` (
  `newid` int(11) NOT NULL,
  `slot` int(11) NOT NULL DEFAULT 0,
  `name` varchar(24) DEFAULT NULL,
  `sost` int(11) NOT NULL DEFAULT 0,
  `model` int(11) NOT NULL DEFAULT 0,
  `vArmor` float NOT NULL DEFAULT 0,
  `koordinatx` float NOT NULL DEFAULT 0,
  `koordinaty` float NOT NULL DEFAULT 0,
  `koordinatz` float NOT NULL DEFAULT 0,
  `koordinata` float NOT NULL DEFAULT 0,
  `vehcol1` int(11) NOT NULL DEFAULT 0,
  `vehcol2` int(11) NOT NULL DEFAULT 0,
  `keyveh` int(11) NOT NULL DEFAULT 0,
  `keyunix` int(11) NOT NULL DEFAULT 0,
  `numer` varchar(24) DEFAULT NULL,
  `arest` int(11) NOT NULL DEFAULT 0,
  `lock` int(11) NOT NULL DEFAULT 0,
  `health` float NOT NULL DEFAULT 0,
  `panels` int(11) NOT NULL DEFAULT 0,
  `doors` int(11) NOT NULL DEFAULT 0,
  `fara` int(11) NOT NULL DEFAULT 0,
  `tires` int(11) NOT NULL DEFAULT 0,
  `death` tinyint(1) NOT NULL DEFAULT 0,
  `comp1` int(11) NOT NULL DEFAULT 0,
  `comp2` int(11) NOT NULL DEFAULT 0,
  `comp3` int(11) NOT NULL DEFAULT 0,
  `comp4` int(11) NOT NULL DEFAULT 0,
  `comp5` int(11) NOT NULL DEFAULT 0,
  `comp6` int(11) NOT NULL DEFAULT 0,
  `comp7` int(11) NOT NULL DEFAULT 0,
  `comp8` int(11) NOT NULL DEFAULT 0,
  `comp9` int(11) NOT NULL DEFAULT 0,
  `comp10` int(11) NOT NULL DEFAULT 0,
  `comp11` int(11) NOT NULL DEFAULT 0,
  `benz` int(11) NOT NULL DEFAULT 0,
  `benz2` int(11) NOT NULL DEFAULT 0,
  `god` int(11) NOT NULL DEFAULT 0,
  `upgrade` int(11) NOT NULL DEFAULT 0,
  `fine` int(11) NOT NULL DEFAULT 0,
  `finelien` int(11) NOT NULL DEFAULT 0,
  `finetime` int(11) NOT NULL DEFAULT 0,
  `finereason` varchar(64) DEFAULT NULL,
  `finename` varchar(24) DEFAULT NULL,
  `fixa` int(11) NOT NULL DEFAULT 0,
  `nosell` int(11) NOT NULL DEFAULT 0,
  `Unixload` int(11) NOT NULL DEFAULT 0,
  `Sklad` int(11) NOT NULL DEFAULT 0,
  `Alarm` int(11) NOT NULL DEFAULT 0,
  `AlarmUnix` int(11) NOT NULL DEFAULT 0,
  `v_slot_0` mediumblob DEFAULT NULL,
  `v_slot_1` mediumblob DEFAULT NULL,
  `v_slot_2` mediumblob DEFAULT NULL,
  `v_slot_3` mediumblob DEFAULT NULL,
  `v_slot_4` mediumblob DEFAULT NULL,
  `v_slot_5` mediumblob DEFAULT NULL,
  `v_slot_6` mediumblob DEFAULT NULL,
  `v_slot_7` mediumblob DEFAULT NULL,
  `v_slot_8` mediumblob DEFAULT NULL,
  `v_slot_9` mediumblob DEFAULT NULL,
  `v_slot_10` mediumblob DEFAULT NULL,
  `v_slot_11` mediumblob DEFAULT NULL,
  `v_slot_12` mediumblob DEFAULT NULL,
  `v_slot_13` mediumblob DEFAULT NULL,
  `v_slot_14` mediumblob DEFAULT NULL,
  `v_slot_15` mediumblob DEFAULT NULL,
  `v_slot_16` mediumblob DEFAULT NULL,
  `v_slot_17` mediumblob DEFAULT NULL,
  `v_slot_18` mediumblob DEFAULT NULL,
  `v_slot_19` mediumblob DEFAULT NULL,
  `vHandlingModel` int(11) DEFAULT 0,
  `t_slot_0` mediumblob DEFAULT NULL,
  `t_slot_1` mediumblob DEFAULT NULL,
  `t_slot_2` mediumblob DEFAULT NULL,
  `t_slot_3` mediumblob DEFAULT NULL,
  `t_slot_4` mediumblob DEFAULT NULL,
  `t_slot_5` mediumblob DEFAULT NULL,
  `t_slot_6` mediumblob DEFAULT NULL,
  `t_slot_7` mediumblob DEFAULT NULL,
  `t_slot_8` mediumblob DEFAULT NULL,
  `t_slot_9` mediumblob DEFAULT NULL,
  `t_slot_10` mediumblob DEFAULT NULL,
  `t_slot_11` mediumblob DEFAULT NULL,
  `t_slot_12` mediumblob DEFAULT NULL,
  `t_slot_13` mediumblob DEFAULT NULL,
  `t_slot_14` mediumblob DEFAULT NULL,
  `t_slot_15` mediumblob DEFAULT NULL,
  `t_slot_16` mediumblob DEFAULT NULL,
  `t_slot_17` mediumblob DEFAULT NULL,
  `t_slot_18` mediumblob DEFAULT NULL,
  `t_slot_19` mediumblob DEFAULT NULL,
  `vTunningBPAN` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_config`
--

CREATE TABLE `pp_config` (
  `stuff` varchar(360) NOT NULL,
  `vibor` varchar(360) NOT NULL,
  `nned` float NOT NULL,
  `ntra` float NOT NULL,
  `ndoh` float NOT NULL,
  `nbiz` float NOT NULL DEFAULT 10,
  `nimy` float NOT NULL,
  `nkoo` float NOT NULL,
  `vet` varchar(8) NOT NULL,
  `kas1` int(24) NOT NULL,
  `kas2` int(24) NOT NULL,
  `freezereproof` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_continental`
--

CREATE TABLE `pp_continental` (
  `id` int(11) NOT NULL DEFAULT 0,
  `exchange_rate` int(11) DEFAULT 0,
  `reward_ship_win` int(11) DEFAULT 0,
  `reward_ship_lose` int(11) DEFAULT 0,
  `reward_shoot_win` int(11) DEFAULT 0,
  `reward_shoot_lose` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pp_crime`
--

CREATE TABLE `pp_crime` (
  `newid` int(11) NOT NULL,
  `Status` int(11) NOT NULL DEFAULT 0,
  `Type` int(11) NOT NULL DEFAULT 0,
  `SenderID` int(11) NOT NULL DEFAULT 0,
  `SenderName` varchar(24) DEFAULT NULL,
  `TargetID` int(11) NOT NULL DEFAULT 0,
  `TargetName` varchar(24) DEFAULT NULL,
  `TargetZalupa` int(11) NOT NULL DEFAULT 0,
  `Unix` int(11) NOT NULL DEFAULT 0,
  `StatusCrime` int(11) NOT NULL DEFAULT 0,
  `TargetZalupaParam` int(11) NOT NULL DEFAULT 0,
  `Sklad` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_dom`
--

CREATE TABLE `pp_dom` (
  `newid` int(10) UNSIGNED NOT NULL,
  `nama` varchar(5) NOT NULL,
  `Ids` int(11) NOT NULL,
  `Vlad` varchar(24) NOT NULL,
  `Name` varchar(34) NOT NULL,
  `Komp` varchar(24) NOT NULL,
  `Level` int(11) NOT NULL,
  `Sost` int(11) NOT NULL,
  `Sost2` int(11) NOT NULL,
  `dGold` int(11) NOT NULL,
  `Data` int(11) NOT NULL,
  `Freeze` int(11) NOT NULL,
  `Arest` int(11) NOT NULL,
  `PriceProd` int(11) NOT NULL,
  `KoordinatX` float NOT NULL,
  `KoordinatY` float NOT NULL,
  `KoordinatZ` float NOT NULL,
  `KoordinatA` float NOT NULL,
  `EnterX` float NOT NULL,
  `EnterY` float NOT NULL,
  `EnterZ` float NOT NULL,
  `EnterA` float NOT NULL,
  `Interior` int(11) NOT NULL,
  `Lock` int(11) NOT NULL,
  `Schet` int(11) NOT NULL,
  `Rentroom` int(11) NOT NULL,
  `Prod0` int(11) NOT NULL,
  `Prod1` int(11) NOT NULL,
  `Prod2` int(11) NOT NULL,
  `Prod3` int(11) NOT NULL,
  `Prod4` int(11) NOT NULL,
  `Prod5` int(11) NOT NULL,
  `Prod6` int(11) NOT NULL,
  `Prod7` int(11) NOT NULL,
  `Prod8` int(11) NOT NULL,
  `Prod9` int(11) NOT NULL,
  `GarageX` float NOT NULL,
  `GarageY` float NOT NULL,
  `GarageZ` float NOT NULL,
  `DefaultX` float NOT NULL,
  `DefaultY` float NOT NULL,
  `DefaultZ` float NOT NULL,
  `DefaultA` float NOT NULL,
  `DefInt` int(11) NOT NULL,
  `Sell` int(11) NOT NULL,
  `Lodger` int(11) NOT NULL,
  `Pastime` int(11) NOT NULL,
  `Incup` int(11) NOT NULL,
  `CupX` float NOT NULL,
  `CupY` float NOT NULL,
  `CupZ` float NOT NULL,
  `Inspa` int(11) NOT NULL,
  `SpaX` float NOT NULL,
  `SpaY` float NOT NULL,
  `SpaZ` float NOT NULL,
  `SpaA` float NOT NULL,
  `Intoi` int(11) NOT NULL,
  `ToiX` float NOT NULL,
  `ToiY` float NOT NULL,
  `ToiZ` float NOT NULL,
  `ToiA` float NOT NULL,
  `Insin` int(11) NOT NULL,
  `SinX` float NOT NULL,
  `SinY` float NOT NULL,
  `SinZ` float NOT NULL,
  `SinA` float NOT NULL,
  `Insou` int(11) NOT NULL,
  `SouX` float NOT NULL,
  `SouY` float NOT NULL,
  `SouZ` float NOT NULL,
  `InbedL` int(11) NOT NULL,
  `InbedLX` float NOT NULL,
  `InbedLY` float NOT NULL,
  `InbedLZ` float NOT NULL,
  `InbedLA` float NOT NULL,
  `InbedR` int(11) NOT NULL,
  `InbedRX` float NOT NULL,
  `InbedRY` float NOT NULL,
  `InbedRZ` float NOT NULL,
  `InbedRA` float NOT NULL,
  `AcccupO` int(11) NOT NULL,
  `AcccupP` int(11) NOT NULL,
  `AcccupG` int(11) NOT NULL,
  `AcccupD` int(11) NOT NULL,
  `Accgar` int(11) NOT NULL,
  `Accdoo` int(11) NOT NULL,
  `Accfur` int(11) NOT NULL,
  `Acctex` int(11) NOT NULL,
  `Accint` int(11) NOT NULL,
  `Frame` int(11) NOT NULL,
  `Vipint` int(11) NOT NULL,
  `Descrip` int(11) NOT NULL,
  `Famcar` int(11) NOT NULL,
  `Taxes` int(11) NOT NULL,
  `Taxday` int(11) NOT NULL,
  `Class` int(11) NOT NULL,
  `dMapDistance` float NOT NULL,
  `d_slot_0` mediumblob DEFAULT NULL,
  `d_slot_1` mediumblob DEFAULT NULL,
  `d_slot_2` mediumblob DEFAULT NULL,
  `d_slot_3` mediumblob DEFAULT NULL,
  `d_slot_4` mediumblob DEFAULT NULL,
  `d_slot_5` mediumblob DEFAULT NULL,
  `d_slot_6` mediumblob DEFAULT NULL,
  `d_slot_7` mediumblob DEFAULT NULL,
  `d_slot_8` mediumblob DEFAULT NULL,
  `d_slot_9` mediumblob DEFAULT NULL,
  `d_slot_10` mediumblob DEFAULT NULL,
  `d_slot_11` mediumblob DEFAULT NULL,
  `d_slot_12` mediumblob DEFAULT NULL,
  `d_slot_13` mediumblob DEFAULT NULL,
  `d_slot_14` mediumblob DEFAULT NULL,
  `d_slot_15` mediumblob DEFAULT NULL,
  `d_slot_16` mediumblob DEFAULT NULL,
  `d_slot_17` mediumblob DEFAULT NULL,
  `d_slot_18` mediumblob DEFAULT NULL,
  `d_slot_19` mediumblob DEFAULT NULL,
  `d_slot_20` mediumblob DEFAULT NULL,
  `d_slot_21` mediumblob DEFAULT NULL,
  `d_slot_22` mediumblob DEFAULT NULL,
  `d_slot_23` mediumblob DEFAULT NULL,
  `d_slot_24` mediumblob DEFAULT NULL,
  `d_slot_25` mediumblob DEFAULT NULL,
  `d_slot_26` mediumblob DEFAULT NULL,
  `d_slot_27` mediumblob DEFAULT NULL,
  `d_slot_28` mediumblob DEFAULT NULL,
  `d_slot_29` mediumblob DEFAULT NULL,
  `d_slot_30` mediumblob DEFAULT NULL,
  `d_slot_31` mediumblob DEFAULT NULL,
  `d_slot_32` mediumblob DEFAULT NULL,
  `d_slot_33` mediumblob DEFAULT NULL,
  `d_slot_34` mediumblob DEFAULT NULL,
  `d_slot_35` mediumblob DEFAULT NULL,
  `d_slot_36` mediumblob DEFAULT NULL,
  `d_slot_37` mediumblob DEFAULT NULL,
  `d_slot_38` mediumblob DEFAULT NULL,
  `d_slot_39` mediumblob DEFAULT NULL,
  `d_slot_40` mediumblob DEFAULT NULL,
  `d_slot_41` mediumblob DEFAULT NULL,
  `d_slot_42` mediumblob DEFAULT NULL,
  `d_slot_43` mediumblob DEFAULT NULL,
  `d_slot_44` mediumblob DEFAULT NULL,
  `d_slot_45` mediumblob DEFAULT NULL,
  `d_slot_46` mediumblob DEFAULT NULL,
  `d_slot_47` mediumblob DEFAULT NULL,
  `d_slot_48` mediumblob DEFAULT NULL,
  `d_slot_49` mediumblob DEFAULT NULL,
  `d_slot_50` mediumblob DEFAULT NULL,
  `d_slot_51` mediumblob DEFAULT NULL,
  `d_slot_52` mediumblob DEFAULT NULL,
  `d_slot_53` mediumblob DEFAULT NULL,
  `d_slot_54` mediumblob DEFAULT NULL,
  `d_slot_55` mediumblob DEFAULT NULL,
  `d_slot_56` mediumblob DEFAULT NULL,
  `d_slot_57` mediumblob DEFAULT NULL,
  `d_slot_58` mediumblob DEFAULT NULL,
  `d_slot_59` mediumblob DEFAULT NULL,
  `d_slot_60` mediumblob DEFAULT NULL,
  `d_slot_61` mediumblob DEFAULT NULL,
  `d_slot_62` mediumblob DEFAULT NULL,
  `d_slot_63` mediumblob DEFAULT NULL,
  `d_slot_64` mediumblob DEFAULT NULL,
  `d_slot_65` mediumblob DEFAULT NULL,
  `d_slot_66` mediumblob DEFAULT NULL,
  `d_slot_67` mediumblob DEFAULT NULL,
  `d_slot_68` mediumblob DEFAULT NULL,
  `d_slot_69` mediumblob DEFAULT NULL,
  `d_slot_70` mediumblob DEFAULT NULL,
  `d_slot_71` mediumblob DEFAULT NULL,
  `d_slot_72` mediumblob DEFAULT NULL,
  `d_slot_73` mediumblob DEFAULT NULL,
  `d_slot_74` mediumblob DEFAULT NULL,
  `d_slot_75` mediumblob DEFAULT NULL,
  `d_slot_76` mediumblob DEFAULT NULL,
  `d_slot_77` mediumblob DEFAULT NULL,
  `d_slot_78` mediumblob DEFAULT NULL,
  `d_slot_79` mediumblob DEFAULT NULL,
  `dDoorInt0` int(11) NOT NULL DEFAULT 0,
  `dDoorInt1` int(11) NOT NULL DEFAULT 0,
  `dDoor0` int(11) NOT NULL DEFAULT 0,
  `dDoor1` int(11) NOT NULL DEFAULT 0,
  `dCoordDopDoorOneX` float NOT NULL DEFAULT 0,
  `dCoordDopDoorOneY` float NOT NULL DEFAULT 0,
  `dCoordDopDoorOneZ` float NOT NULL DEFAULT 0,
  `dCoordDopDoorTwoX` float NOT NULL DEFAULT 0,
  `dCoordDopDoorTwoY` float NOT NULL DEFAULT 0,
  `dCoordDopDoorTwoZ` float NOT NULL DEFAULT 0,
  `dCoordDopDoorOneIntX` float NOT NULL DEFAULT 0,
  `dCoordDopDoorOneIntY` float NOT NULL DEFAULT 0,
  `dCoordDopDoorOneIntZ` float NOT NULL DEFAULT 0,
  `dCoordDopDoorTwoIntX` float NOT NULL DEFAULT 0,
  `dCoordDopDoorTwoIntY` float NOT NULL DEFAULT 0,
  `dCoordDopDoorTwoIntZ` float NOT NULL DEFAULT 0,
  `dElectroStatus` int(11) NOT NULL DEFAULT 0,
  `dElectroConnect` int(11) NOT NULL DEFAULT 0,
  `dElectroUnix` int(11) NOT NULL DEFAULT 0,
  `MoreIntObjects` int(11) NOT NULL DEFAULT 0,
  `dInteriorPack` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_economy`
--

CREATE TABLE `pp_economy` (
  `newid` int(11) NOT NULL,
  `m0` int(11) NOT NULL,
  `m1` int(11) NOT NULL,
  `m2` int(11) NOT NULL,
  `m3` int(11) NOT NULL,
  `m4` int(11) NOT NULL,
  `m5` int(11) NOT NULL,
  `m6` int(11) NOT NULL,
  `m7` int(11) NOT NULL,
  `m8` int(11) NOT NULL,
  `m9` int(11) NOT NULL,
  `m10` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_family`
--

CREATE TABLE `pp_family` (
  `newid` int(11) NOT NULL,
  `id` int(11) NOT NULL DEFAULT 0,
  `bd` varchar(6) DEFAULT NULL,
  `akka` int(11) NOT NULL DEFAULT 0,
  `sost` int(11) NOT NULL DEFAULT 0,
  `name` varchar(70) DEFAULT NULL,
  `osn` varchar(24) DEFAULT NULL,
  `fRanks` int(11) NOT NULL DEFAULT 0,
  `rank0` varchar(31) DEFAULT NULL,
  `rank1` varchar(34) DEFAULT NULL,
  `rank2` varchar(34) DEFAULT NULL,
  `rank3` varchar(34) DEFAULT NULL,
  `rank4` varchar(34) DEFAULT NULL,
  `rank5` varchar(34) DEFAULT NULL,
  `rank6` varchar(64) DEFAULT NULL,
  `rank7` varchar(64) DEFAULT NULL,
  `rank8` varchar(64) DEFAULT NULL,
  `rank9` varchar(64) DEFAULT NULL,
  `rank10` varchar(64) DEFAULT NULL,
  `rank11` varchar(31) DEFAULT NULL,
  `rank12` varchar(31) DEFAULT NULL,
  `rank13` varchar(31) DEFAULT NULL,
  `rank14` varchar(31) DEFAULT NULL,
  `rank15` varchar(31) DEFAULT NULL,
  `rank16` varchar(31) DEFAULT NULL,
  `rank17` varchar(31) DEFAULT NULL,
  `rank18` varchar(31) DEFAULT NULL,
  `rank19` varchar(31) DEFAULT NULL,
  `rank20` varchar(31) DEFAULT NULL,
  `rank21` varchar(31) DEFAULT NULL,
  `rank22` varchar(31) DEFAULT NULL,
  `rank23` varchar(31) DEFAULT NULL,
  `rank24` varchar(31) DEFAULT NULL,
  `rank25` varchar(31) DEFAULT NULL,
  `rank26` varchar(31) DEFAULT NULL,
  `rank27` varchar(31) DEFAULT NULL,
  `rank28` varchar(31) DEFAULT NULL,
  `rank29` varchar(31) DEFAULT NULL,
  `spawnx` float NOT NULL DEFAULT 0,
  `spawny` float NOT NULL DEFAULT 0,
  `spawnz` float NOT NULL DEFAULT 0,
  `spawna` float NOT NULL DEFAULT 0,
  `int` int(11) NOT NULL DEFAULT 0,
  `world` int(11) NOT NULL DEFAULT 0,
  `statusuch` int(11) NOT NULL DEFAULT 0,
  `statusrank` int(11) NOT NULL DEFAULT 0,
  `statusspawn` int(11) NOT NULL DEFAULT 0,
  `statusgarage` int(11) NOT NULL DEFAULT 0,
  `dop1` int(11) NOT NULL DEFAULT 0,
  `dop2` int(11) NOT NULL DEFAULT 0,
  `dop3` int(11) NOT NULL DEFAULT 0,
  `dop4` int(11) NOT NULL DEFAULT 0,
  `dop5` int(11) NOT NULL DEFAULT 0,
  `Mon` int(11) NOT NULL DEFAULT 0,
  `Accoff` int(11) NOT NULL DEFAULT 0,
  `Accdip` int(11) NOT NULL DEFAULT 0,
  `Accmoninv` int(11) NOT NULL DEFAULT 0,
  `Accmonget` int(11) NOT NULL DEFAULT 0,
  `Accdom` int(11) NOT NULL DEFAULT 0,
  `Accbiz` int(11) NOT NULL DEFAULT 0,
  `Accname` int(11) NOT NULL DEFAULT 0,
  `Accrank` int(11) NOT NULL DEFAULT 0,
  `Accspawn` int(11) NOT NULL DEFAULT 0,
  `Accgarage` int(11) NOT NULL DEFAULT 0,
  `Acclog` int(11) NOT NULL DEFAULT 0,
  `Accdon` int(11) NOT NULL DEFAULT 0,
  `Accveh` int(11) NOT NULL DEFAULT 0,
  `Accinv` int(11) NOT NULL DEFAULT 0,
  `Accuninv` int(11) NOT NULL DEFAULT 0,
  `Accgiver` int(11) NOT NULL DEFAULT 0,
  `Accfammu` int(11) NOT NULL DEFAULT 0,
  `Accfamfo` int(11) NOT NULL DEFAULT 0,
  `Lossf` int(11) NOT NULL DEFAULT 0,
  `war1` int(11) NOT NULL DEFAULT 0,
  `war2` int(11) NOT NULL DEFAULT 0,
  `war3` int(11) NOT NULL DEFAULT 0,
  `war4` int(11) NOT NULL DEFAULT 0,
  `war5` int(11) NOT NULL DEFAULT 0,
  `war6` int(11) NOT NULL DEFAULT 0,
  `war7` int(11) NOT NULL DEFAULT 0,
  `war8` int(11) NOT NULL DEFAULT 0,
  `war9` int(11) NOT NULL DEFAULT 0,
  `war10` int(11) NOT NULL DEFAULT 0,
  `union1` int(11) NOT NULL DEFAULT 0,
  `union2` int(11) NOT NULL DEFAULT 0,
  `union3` int(11) NOT NULL DEFAULT 0,
  `union4` int(11) NOT NULL DEFAULT 0,
  `union5` int(11) NOT NULL DEFAULT 0,
  `union6` int(11) NOT NULL DEFAULT 0,
  `union7` int(11) NOT NULL DEFAULT 0,
  `union8` int(11) NOT NULL DEFAULT 0,
  `union9` int(11) NOT NULL DEFAULT 0,
  `union10` int(11) NOT NULL DEFAULT 0,
  `fveh0` int(11) NOT NULL DEFAULT 0,
  `fveh1` int(11) NOT NULL DEFAULT 0,
  `fveh2` int(11) NOT NULL DEFAULT 0,
  `fveh3` int(11) NOT NULL DEFAULT 0,
  `fveh4` int(11) NOT NULL DEFAULT 0,
  `fveh5` int(11) NOT NULL DEFAULT 0,
  `fveh6` int(11) NOT NULL DEFAULT 0,
  `fveh7` int(11) NOT NULL DEFAULT 0,
  `fveh8` int(11) NOT NULL DEFAULT 0,
  `fveh9` int(11) NOT NULL DEFAULT 0,
  `fbiz0` int(11) NOT NULL DEFAULT 0,
  `fbiz1` int(11) NOT NULL DEFAULT 0,
  `fbiz2` int(11) NOT NULL DEFAULT 0,
  `fbiz3` int(11) NOT NULL DEFAULT 0,
  `fbiz4` int(11) NOT NULL DEFAULT 0,
  `fbiz5` int(11) NOT NULL DEFAULT 0,
  `fbiz6` int(11) NOT NULL DEFAULT 0,
  `fbiz7` int(11) NOT NULL DEFAULT 0,
  `fbiz8` int(11) NOT NULL DEFAULT 0,
  `fbiz9` int(11) NOT NULL DEFAULT 0,
  `vehcol1` int(11) NOT NULL DEFAULT 0,
  `vehcol2` int(11) NOT NULL DEFAULT 0,
  `type` int(1) NOT NULL DEFAULT 0,
  `parthnerMarket` int(3) NOT NULL DEFAULT 0,
  `parthnerBenz` int(3) NOT NULL DEFAULT 0,
  `parthnerService` int(3) NOT NULL DEFAULT 0,
  `Rout1X` varchar(600) DEFAULT NULL,
  `Rout1Y` varchar(600) DEFAULT NULL,
  `Rout1Z` varchar(600) DEFAULT NULL,
  `Rout2X` varchar(600) DEFAULT NULL,
  `Rout2Y` varchar(600) DEFAULT NULL,
  `Rout2Z` varchar(600) DEFAULT NULL,
  `Rout3X` varchar(600) DEFAULT NULL,
  `Rout3Y` varchar(600) DEFAULT NULL,
  `Rout3Z` varchar(600) DEFAULT NULL,
  `Rout4X` varchar(600) DEFAULT NULL,
  `Rout4Y` varchar(600) DEFAULT NULL,
  `Rout4Z` varchar(600) DEFAULT NULL,
  `Rout5X` varchar(600) DEFAULT NULL,
  `Rout5Y` varchar(600) DEFAULT NULL,
  `Rout5Z` varchar(600) DEFAULT NULL,
  `routNameCreator1` varchar(24) DEFAULT NULL,
  `routNameEditor1` varchar(24) DEFAULT NULL,
  `routIdEditor1` int(111) NOT NULL DEFAULT 0,
  `routIdCreator1` int(11) NOT NULL DEFAULT 0,
  `routUnix1` int(11) NOT NULL DEFAULT 0,
  `routNameCreator2` varchar(24) DEFAULT NULL,
  `routNameEditor2` varchar(24) DEFAULT NULL,
  `routIdEditor2` int(11) NOT NULL DEFAULT 0,
  `routIdCreator2` int(11) NOT NULL DEFAULT 0,
  `routUnix2` int(11) NOT NULL DEFAULT 0,
  `routNameCreator3` varchar(24) DEFAULT NULL,
  `routNameEditor3` varchar(24) DEFAULT NULL,
  `routIdEditor3` int(11) NOT NULL DEFAULT 0,
  `routIdCreator3` int(11) NOT NULL DEFAULT 0,
  `routUnix3` int(11) NOT NULL DEFAULT 0,
  `routNameCreator4` varchar(24) DEFAULT NULL,
  `routNameEditor4` varchar(24) DEFAULT NULL,
  `routIdEditor4` int(11) NOT NULL DEFAULT 0,
  `routIdCreator4` int(11) NOT NULL DEFAULT 0,
  `routUnix4` int(11) NOT NULL DEFAULT 0,
  `routNameCreator5` varchar(24) DEFAULT NULL,
  `routNameEditor5` varchar(24) DEFAULT NULL,
  `routIdEditor5` int(11) NOT NULL DEFAULT 0,
  `routIdCreator5` int(11) NOT NULL DEFAULT 0,
  `routUnix5` int(11) NOT NULL DEFAULT 0,
  `influence` int(11) NOT NULL DEFAULT 0,
  `unixcnn` int(11) NOT NULL DEFAULT 0,
  `influenceTemp` int(11) NOT NULL DEFAULT 0,
  `unixrite` int(11) NOT NULL DEFAULT 0,
  `altarPosX` int(11) NOT NULL DEFAULT 0,
  `altarPosY` int(11) NOT NULL DEFAULT 0,
  `altarPosZ` int(11) NOT NULL DEFAULT 0,
  `altarPosXR` int(11) NOT NULL DEFAULT 0,
  `altarPosYR` int(11) NOT NULL DEFAULT 0,
  `altarPosZR` int(11) NOT NULL DEFAULT 0,
  `unixAltar` int(11) NOT NULL DEFAULT 0,
  `altarStatus` int(11) NOT NULL DEFAULT 0,
  `vehPlate` varchar(32) DEFAULT '',
  `statusplate` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_frame`
--

CREATE TABLE `pp_frame` (
  `newid` int(11) NOT NULL DEFAULT 0,
  `Model` int(11) NOT NULL DEFAULT 0,
  `Type` int(11) NOT NULL DEFAULT 0,
  `Price` int(11) NOT NULL DEFAULT 0,
  `Class` int(11) NOT NULL DEFAULT 0,
  `Name` varchar(34) DEFAULT NULL,
  `Quantextures` int(11) NOT NULL DEFAULT 0,
  `Sale` int(11) NOT NULL DEFAULT 0,
  `Gold` int(11) NOT NULL DEFAULT 0,
  `X` float NOT NULL DEFAULT 0,
  `Y` float NOT NULL DEFAULT 0,
  `Z` float NOT NULL DEFAULT 0,
  `RX` float NOT NULL DEFAULT 0,
  `RY` float NOT NULL DEFAULT 0,
  `RZ` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_graphiti`
--

CREATE TABLE `pp_graphiti` (
  `gnewid` int(11) NOT NULL,
  `gstring` varchar(48) DEFAULT NULL,
  `gunix` int(11) NOT NULL DEFAULT 0,
  `gplayernumber` int(1) NOT NULL DEFAULT 0,
  `gorg` int(2) NOT NULL DEFAULT 0,
  `gStatus` int(1) NOT NULL DEFAULT 0,
  `gZone` int(3) NOT NULL DEFAULT 0,
  `gName` varchar(24) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_igroki`
--

CREATE TABLE `pp_igroki` (
  `user_id` int(24) NOT NULL,
  `Name` varchar(24) DEFAULT NULL,
  `Key` varchar(64) DEFAULT NULL,
  `Level` int(24) NOT NULL DEFAULT 0,
  `Banned` int(24) NOT NULL DEFAULT 0,
  `BanAdmin` varchar(24) DEFAULT NULL,
  `BanResult` varchar(64) DEFAULT NULL,
  `BanData` varchar(24) DEFAULT NULL,
  `Soska` int(24) NOT NULL DEFAULT 0,
  `Mail` varchar(84) DEFAULT NULL,
  `MailStat` int(11) NOT NULL DEFAULT 0,
  `Media` int(11) NOT NULL DEFAULT 0,
  `DonateRank` int(24) NOT NULL DEFAULT 0,
  `Upgrade` int(24) NOT NULL DEFAULT 0,
  `ConnectTime` int(24) NOT NULL DEFAULT 0,
  `pQwestMessageOff` tinyint(1) NOT NULL DEFAULT 0,
  `Sex` int(24) NOT NULL DEFAULT 0,
  `Age` int(24) NOT NULL DEFAULT 0,
  `Origin` int(24) NOT NULL DEFAULT 0,
  `Komnata` int(24) NOT NULL DEFAULT 0,
  `Exp` int(24) NOT NULL DEFAULT 0,
  `Money` int(24) NOT NULL DEFAULT 0,
  `Account` int(24) NOT NULL DEFAULT 0,
  `Crimes` int(24) NOT NULL DEFAULT 0,
  `Kills` int(24) NOT NULL DEFAULT 0,
  `Deaths` int(24) NOT NULL DEFAULT 0,
  `HeadValue` int(24) NOT NULL DEFAULT 0,
  `Jailed` int(24) NOT NULL DEFAULT 0,
  `JailTime` int(24) NOT NULL DEFAULT 0,
  `MuteTime` int(24) NOT NULL DEFAULT 0,
  `Leader` int(24) NOT NULL DEFAULT 0,
  `Member` int(24) NOT NULL DEFAULT 0,
  `Rank` int(24) NOT NULL DEFAULT 0,
  `Vig` int(24) NOT NULL DEFAULT 0,
  `BoxSkill` int(24) NOT NULL DEFAULT 0,
  `LawSkill` int(24) NOT NULL DEFAULT 0,
  `MechSkill` int(24) NOT NULL DEFAULT 0,
  `Team` int(24) NOT NULL DEFAULT 0,
  `Model` int(24) NOT NULL DEFAULT 0,
  `Houserent` int(24) NOT NULL DEFAULT 0,
  `CarLic` float NOT NULL DEFAULT 0,
  `FlyLic` float NOT NULL DEFAULT 0,
  `BoatLic` float NOT NULL DEFAULT 0,
  `MotoLic` float NOT NULL DEFAULT 0,
  `GunLic` int(124) NOT NULL DEFAULT 0,
  `HeliLic` float NOT NULL DEFAULT 0,
  `Model2` int(24) NOT NULL DEFAULT 0,
  `Model3` int(11) NOT NULL DEFAULT 0,
  `MyVeh0` int(11) NOT NULL DEFAULT 0,
  `MyVeh1` int(11) NOT NULL DEFAULT 0,
  `MyVeh2` int(11) NOT NULL DEFAULT 0,
  `MyVeh3` int(11) NOT NULL DEFAULT 0,
  `MyVeh4` int(11) NOT NULL DEFAULT 0,
  `MyVeh5` int(11) NOT NULL DEFAULT 0,
  `MyVeh6` int(11) NOT NULL DEFAULT 0,
  `MyVeh7` int(11) NOT NULL DEFAULT 0,
  `MyVeh8` int(11) NOT NULL DEFAULT 0,
  `MyVeh9` int(11) NOT NULL DEFAULT 0,
  `MyVeh10` int(11) NOT NULL DEFAULT 0,
  `MyVeh11` int(11) NOT NULL DEFAULT 0,
  `MyVeh12` int(11) NOT NULL DEFAULT 0,
  `MyVeh13` int(11) NOT NULL DEFAULT 0,
  `MyVeh14` int(11) NOT NULL DEFAULT 0,
  `MyVeh15` int(11) NOT NULL DEFAULT 0,
  `MyVeh16` int(11) NOT NULL DEFAULT 0,
  `MyVeh17` int(11) NOT NULL DEFAULT 0,
  `MyVeh18` int(11) NOT NULL DEFAULT 0,
  `MyVeh19` int(11) NOT NULL DEFAULT 0,
  `MyVehSlot0` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot1` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot2` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot3` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot4` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot5` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot6` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot7` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot8` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot9` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot10` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot11` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot12` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot13` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot14` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot15` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot16` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot17` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot18` tinyint(1) NOT NULL DEFAULT 0,
  `MyVehSlot19` tinyint(1) NOT NULL DEFAULT 0,
  `Ammo1` int(24) NOT NULL DEFAULT 0,
  `Ammo2` int(24) NOT NULL DEFAULT 0,
  `Ammo5` int(24) NOT NULL DEFAULT 0,
  `Ammo6` int(24) NOT NULL DEFAULT 0,
  `Ammo7` int(24) NOT NULL DEFAULT 0,
  `Ammo8` int(24) NOT NULL DEFAULT 0,
  `PayDay` int(24) NOT NULL DEFAULT 0,
  `PayDayHad` int(24) NOT NULL DEFAULT 0,
  `DrugPerk` int(24) NOT NULL DEFAULT 0,
  `TraderPerk` int(24) NOT NULL DEFAULT 0,
  `Tut` int(24) NOT NULL DEFAULT 0,
  `AdmWarns` int(24) NOT NULL DEFAULT 0,
  `Married` int(24) NOT NULL DEFAULT 0,
  `Newname` int(24) NOT NULL DEFAULT 0,
  `MarriedTo` varchar(24) DEFAULT NULL,
  `SetName` varchar(24) DEFAULT NULL,
  `Neon` int(24) NOT NULL DEFAULT 0,
  `Style` int(24) NOT NULL DEFAULT 0,
  `Cap` int(24) NOT NULL DEFAULT 0,
  `Beret` int(24) NOT NULL DEFAULT 0,
  `Voennik` int(24) NOT NULL DEFAULT 0,
  `Repaa` int(24) NOT NULL DEFAULT 0,
  `RepTime` int(24) NOT NULL DEFAULT 0,
  `Warns` int(24) NOT NULL DEFAULT 0,
  `Bkyrenie` int(24) NOT NULL DEFAULT 0,
  `Meshk1` int(24) NOT NULL DEFAULT 0,
  `Meshk11` int(24) NOT NULL DEFAULT 0,
  `Fmute` int(24) NOT NULL DEFAULT 0,
  `FmuteTime` int(24) NOT NULL DEFAULT 0,
  `DonateMoney` int(24) NOT NULL DEFAULT 0,
  `DonateAll` int(11) NOT NULL DEFAULT 0,
  `BanDayz` int(11) NOT NULL DEFAULT 0,
  `BanMonzz` int(24) NOT NULL DEFAULT 0,
  `BdPoletDayz` int(24) NOT NULL DEFAULT 0,
  `BdLodkaDayz` int(24) NOT NULL DEFAULT 0,
  `Typoihyi` int(24) NOT NULL DEFAULT 0,
  `Djpears` int(24) NOT NULL DEFAULT 0,
  `Rusk` int(24) NOT NULL DEFAULT 0,
  `Yapon` int(24) NOT NULL DEFAULT 0,
  `Italy` int(24) NOT NULL DEFAULT 0,
  `Kitai` int(24) NOT NULL DEFAULT 0,
  `Ispan` int(24) NOT NULL DEFAULT 0,
  `Debil` int(24) NOT NULL DEFAULT 0,
  `Ranentors` int(24) NOT NULL DEFAULT 0,
  `Arab` int(24) NOT NULL DEFAULT 0,
  `Rab` int(24) NOT NULL DEFAULT 0,
  `Victim` varchar(24) DEFAULT NULL,
  `Razok` int(24) NOT NULL DEFAULT 0,
  `Worked1` int(24) NOT NULL DEFAULT 0,
  `Worked2` int(24) NOT NULL DEFAULT 0,
  `Worked3` int(24) NOT NULL DEFAULT 0,
  `Worked4` int(24) NOT NULL DEFAULT 0,
  `Worked5` int(24) NOT NULL DEFAULT 0,
  `Infoload` int(24) NOT NULL DEFAULT 0,
  `Sped` int(24) NOT NULL DEFAULT 0,
  `Family` int(24) NOT NULL DEFAULT 0,
  `Famrank` int(24) NOT NULL DEFAULT 0,
  `Spawnchange` int(24) NOT NULL DEFAULT 0,
  `HataCena` int(24) NOT NULL DEFAULT 0,
  `LeadData` datetime DEFAULT NULL,
  `Offtime` datetime DEFAULT NULL,
  `Gun11` int(11) NOT NULL DEFAULT 0,
  `Gun13` int(11) NOT NULL DEFAULT 0,
  `Ammo11` int(11) NOT NULL DEFAULT 0,
  `Ammo13` int(11) NOT NULL DEFAULT 0,
  `Worked6` int(11) NOT NULL DEFAULT 0,
  `Fbi` int(11) NOT NULL DEFAULT 0,
  `RukzWorld` int(11) NOT NULL DEFAULT 0,
  `Babki` int(11) NOT NULL DEFAULT 0,
  `Odet1` int(11) NOT NULL DEFAULT 0,
  `Odet_X1` float NOT NULL DEFAULT 0,
  `Odet_Y1` float NOT NULL DEFAULT 0,
  `Odet_Z1` float NOT NULL DEFAULT 0,
  `Odet_rX1` float NOT NULL DEFAULT 0,
  `Odet_rY1` float NOT NULL DEFAULT 0,
  `Odet_rZ1` float NOT NULL DEFAULT 0,
  `Odet_sX1` float NOT NULL DEFAULT 0,
  `Odet_sY1` float NOT NULL DEFAULT 0,
  `Odet_sZ1` float NOT NULL DEFAULT 0,
  `Odet2` int(11) NOT NULL DEFAULT 0,
  `Odet_X2` float NOT NULL DEFAULT 0,
  `Odet_Y2` float NOT NULL DEFAULT 0,
  `Odet_Z2` float NOT NULL DEFAULT 0,
  `Odet_rX2` float NOT NULL DEFAULT 0,
  `Odet_rY2` float NOT NULL DEFAULT 0,
  `Odet_rZ2` float NOT NULL DEFAULT 0,
  `Odet_sX2` float NOT NULL DEFAULT 0,
  `Odet_sY2` float NOT NULL DEFAULT 0,
  `Odet_sZ2` float NOT NULL DEFAULT 0,
  `Odet3` int(11) NOT NULL DEFAULT 0,
  `Odet_X3` float NOT NULL DEFAULT 0,
  `Odet_Y3` float NOT NULL DEFAULT 0,
  `Odet_Z3` float NOT NULL DEFAULT 0,
  `Odet_rX3` float NOT NULL DEFAULT 0,
  `Odet_rY3` float NOT NULL DEFAULT 0,
  `Odet_rZ3` float NOT NULL DEFAULT 0,
  `Odet_sX3` float NOT NULL DEFAULT 0,
  `Odet_sY3` float NOT NULL DEFAULT 0,
  `Odet_sZ3` float NOT NULL DEFAULT 0,
  `Odet4` int(11) NOT NULL DEFAULT 0,
  `Odet_X4` float NOT NULL DEFAULT 0,
  `Odet_Y4` float NOT NULL DEFAULT 0,
  `Odet_Z4` float NOT NULL DEFAULT 0,
  `Odet_rX4` float NOT NULL DEFAULT 0,
  `Odet_rY4` float NOT NULL DEFAULT 0,
  `Odet_rZ4` float NOT NULL DEFAULT 0,
  `Odet_sX4` float NOT NULL DEFAULT 0,
  `Odet_sY4` float NOT NULL DEFAULT 0,
  `Odet_sZ4` float NOT NULL DEFAULT 0,
  `Odet5` int(11) NOT NULL DEFAULT 0,
  `Odet_X5` float NOT NULL DEFAULT 0,
  `Odet_Y5` float NOT NULL DEFAULT 0,
  `Odet_Z5` float NOT NULL DEFAULT 0,
  `Odet_rX5` float NOT NULL DEFAULT 0,
  `Odet_rY5` float NOT NULL DEFAULT 0,
  `Odet_rZ5` float NOT NULL DEFAULT 0,
  `Odet_sX5` float NOT NULL DEFAULT 0,
  `Odet_sY5` float NOT NULL DEFAULT 0,
  `Odet_sZ5` float NOT NULL DEFAULT 0,
  `OdetPara1` int(11) NOT NULL DEFAULT 0,
  `OdetPara2` int(11) NOT NULL DEFAULT 0,
  `OdetPara3` int(11) NOT NULL DEFAULT 0,
  `OdetPara4` int(11) NOT NULL DEFAULT 0,
  `OdetPara5` int(11) NOT NULL DEFAULT 0,
  `OdetQara1` int(11) NOT NULL DEFAULT 0,
  `OdetQara2` int(11) NOT NULL DEFAULT 0,
  `OdetQara3` int(11) NOT NULL DEFAULT 0,
  `OdetQara4` int(11) NOT NULL DEFAULT 0,
  `OdetQara5` int(11) NOT NULL DEFAULT 0,
  `OdetBone1` int(11) NOT NULL DEFAULT 0,
  `OdetBone2` int(11) NOT NULL DEFAULT 0,
  `OdetBone3` int(11) NOT NULL DEFAULT 0,
  `OdetBone4` int(11) NOT NULL DEFAULT 0,
  `OdetBone5` int(11) NOT NULL DEFAULT 0,
  `Bilet` int(11) NOT NULL DEFAULT 0,
  `Hit` int(11) NOT NULL DEFAULT 0,
  `Qwest` int(11) NOT NULL DEFAULT 0,
  `Salary` int(11) NOT NULL DEFAULT 0,
  `Placement` int(11) NOT NULL DEFAULT 0,
  `Anima` int(11) NOT NULL DEFAULT 0,
  `Animb` int(11) NOT NULL DEFAULT 0,
  `Animc` int(11) NOT NULL DEFAULT 0,
  `Animd` int(11) NOT NULL DEFAULT 0,
  `Anime` int(11) NOT NULL DEFAULT 0,
  `Animf` int(11) NOT NULL DEFAULT 0,
  `PrisonRank` int(11) NOT NULL DEFAULT 0,
  `Hodka` int(11) NOT NULL DEFAULT 0,
  `Referal` varchar(24) DEFAULT NULL,
  `Google` int(11) NOT NULL DEFAULT 0,
  `Gokey` varchar(24) DEFAULT NULL,
  `BonHour` int(11) NOT NULL DEFAULT 0,
  `Today` int(11) NOT NULL DEFAULT 0,
  `Plaip` varchar(24) DEFAULT NULL,
  `Online` int(11) NOT NULL DEFAULT 0,
  `Expert` int(11) NOT NULL DEFAULT 0,
  `Question` int(11) NOT NULL DEFAULT 0,
  `Exchat` int(11) NOT NULL DEFAULT 0,
  `Pame` int(11) NOT NULL DEFAULT 0,
  `PameText` varchar(84) DEFAULT NULL,
  `PameText2` varchar(84) DEFAULT NULL,
  `Sty` int(11) NOT NULL DEFAULT 0,
  `StyBack` int(11) NOT NULL DEFAULT 0,
  `AdmPoint` int(11) NOT NULL DEFAULT 0,
  `AdmScore` int(11) NOT NULL DEFAULT 0,
  `AdmNorm` int(11) NOT NULL DEFAULT 0,
  `Reproof` int(11) NOT NULL DEFAULT 0,
  `GameDay` int(11) NOT NULL DEFAULT 0,
  `GameTime` int(11) NOT NULL DEFAULT 0,
  `GameAfk` int(11) NOT NULL DEFAULT 0,
  `VacBeg` int(11) NOT NULL DEFAULT 0,
  `VacEnd` int(11) NOT NULL DEFAULT 0,
  `ReferalID` int(11) NOT NULL DEFAULT 0,
  `RefReg` int(11) NOT NULL DEFAULT 0,
  `Ref5` int(11) NOT NULL DEFAULT 0,
  `Promoreg` int(11) NOT NULL DEFAULT 0,
  `Promoins` int(11) NOT NULL DEFAULT 0,
  `Abandoned` int(11) NOT NULL DEFAULT 0,
  `AData` int(11) NOT NULL DEFAULT 0,
  `TrackSm` int(11) NOT NULL DEFAULT 0,
  `TrackRac` int(11) NOT NULL DEFAULT 0,
  `RegData` int(11) NOT NULL DEFAULT 0,
  `SafeIP` varchar(24) DEFAULT NULL,
  `SafeUnix` int(11) NOT NULL DEFAULT 0,
  `Gpci` varchar(64) DEFAULT NULL,
  `Gacc0` int(11) NOT NULL DEFAULT 0,
  `Gacc1` int(11) NOT NULL DEFAULT 0,
  `Gacc2` int(11) NOT NULL DEFAULT 0,
  `Gacc3` int(11) NOT NULL DEFAULT 0,
  `Gacc4` int(11) NOT NULL DEFAULT 0,
  `Gacc5` int(11) NOT NULL DEFAULT 0,
  `Gacc6` int(11) NOT NULL DEFAULT 0,
  `Gacc7` int(11) NOT NULL DEFAULT 0,
  `Gacc8` int(11) NOT NULL DEFAULT 0,
  `Unit` int(11) NOT NULL DEFAULT 0,
  `X2exp` int(11) NOT NULL DEFAULT 0,
  `MyWar` int(11) NOT NULL DEFAULT 0,
  `MyCapt` int(11) NOT NULL DEFAULT 0,
  `GangCapt0` int(11) NOT NULL DEFAULT 0,
  `GangCapt1` int(11) NOT NULL DEFAULT 0,
  `GangCapt2` int(11) NOT NULL DEFAULT 0,
  `GangCapt3` int(11) NOT NULL DEFAULT 0,
  `GangCapt4` int(11) NOT NULL DEFAULT 0,
  `GangCapt5` int(11) NOT NULL DEFAULT 0,
  `GangCapt6` int(11) NOT NULL DEFAULT 0,
  `GangCapt7` int(11) NOT NULL DEFAULT 0,
  `GangCapt8` int(11) NOT NULL DEFAULT 0,
  `GangCapt9` int(11) NOT NULL DEFAULT 0,
  `GangCapt10` int(11) NOT NULL DEFAULT 0,
  `GangCapt11` int(11) NOT NULL DEFAULT 0,
  `GangCapt12` int(11) NOT NULL DEFAULT 0,
  `GangCapt13` int(11) NOT NULL DEFAULT 0,
  `GangCapt14` int(11) NOT NULL DEFAULT 0,
  `GangCapt15` int(11) NOT NULL DEFAULT 0,
  `GangAll0` int(11) NOT NULL DEFAULT 0,
  `GangAll1` int(11) NOT NULL DEFAULT 0,
  `GangAll2` int(11) NOT NULL DEFAULT 0,
  `GangAll3` int(11) NOT NULL DEFAULT 0,
  `GangAll4` int(11) NOT NULL DEFAULT 0,
  `GangAll5` int(11) NOT NULL DEFAULT 0,
  `GangAll6` int(11) NOT NULL DEFAULT 0,
  `GangAll7` int(11) NOT NULL DEFAULT 0,
  `GangAll8` int(11) NOT NULL DEFAULT 0,
  `GangAll9` int(11) NOT NULL DEFAULT 0,
  `GangAll10` int(11) NOT NULL DEFAULT 0,
  `GangAll11` int(11) NOT NULL DEFAULT 0,
  `GangAll12` int(11) NOT NULL DEFAULT 0,
  `GangAll13` int(11) NOT NULL DEFAULT 0,
  `GangAll14` int(11) NOT NULL DEFAULT 0,
  `GangAll15` int(11) NOT NULL DEFAULT 0,
  `GangTemp0` int(11) NOT NULL DEFAULT 0,
  `GangTemp1` int(11) NOT NULL DEFAULT 0,
  `GangTemp2` int(11) NOT NULL DEFAULT 0,
  `GangTemp3` int(11) NOT NULL DEFAULT 0,
  `GangTemp4` int(11) NOT NULL DEFAULT 0,
  `GangTemp5` int(11) NOT NULL DEFAULT 0,
  `GangTemp6` int(11) NOT NULL DEFAULT 0,
  `GangTemp7` int(11) NOT NULL DEFAULT 0,
  `GangTemp8` int(11) NOT NULL DEFAULT 0,
  `GangTemp9` int(11) NOT NULL DEFAULT 0,
  `GangTemp10` int(11) NOT NULL DEFAULT 0,
  `GangTemp11` int(11) NOT NULL DEFAULT 0,
  `GangTemp12` int(11) NOT NULL DEFAULT 0,
  `GangTemp13` int(11) NOT NULL DEFAULT 0,
  `GangTemp14` int(11) NOT NULL DEFAULT 0,
  `GangTemp15` int(11) NOT NULL DEFAULT 0,
  `Cashu` int(11) NOT NULL DEFAULT 0,
  `Power` int(11) NOT NULL DEFAULT 0,
  `Amute` int(11) NOT NULL DEFAULT 0,
  `Insult` int(11) NOT NULL DEFAULT 0,
  `Taxes0` int(11) NOT NULL DEFAULT 0,
  `Taxes1` int(11) NOT NULL DEFAULT 0,
  `VehTax0` int(11) NOT NULL DEFAULT 0,
  `VehTax1` int(11) NOT NULL DEFAULT 0,
  `VehTax2` int(11) NOT NULL DEFAULT 0,
  `VehTax3` int(11) NOT NULL DEFAULT 0,
  `VehTax4` int(11) NOT NULL DEFAULT 0,
  `VehTax5` int(11) NOT NULL DEFAULT 0,
  `VehTax6` int(11) NOT NULL DEFAULT 0,
  `VehTax7` int(11) NOT NULL DEFAULT 0,
  `VehTax8` int(11) NOT NULL DEFAULT 0,
  `VehTax9` int(11) NOT NULL DEFAULT 0,
  `VehTax10` int(11) NOT NULL DEFAULT 0,
  `VehTax11` int(11) NOT NULL DEFAULT 0,
  `VehTax12` int(11) NOT NULL DEFAULT 0,
  `VehTax13` int(11) NOT NULL DEFAULT 0,
  `VehTax14` int(11) NOT NULL DEFAULT 0,
  `VehTax15` int(11) NOT NULL DEFAULT 0,
  `VehTax16` int(11) NOT NULL DEFAULT 0,
  `VehTax17` int(11) NOT NULL DEFAULT 0,
  `VehTax18` int(11) NOT NULL DEFAULT 0,
  `VehTax19` int(11) NOT NULL DEFAULT 0,
  `AutoTax` int(11) NOT NULL DEFAULT 0,
  `PlaTax` int(11) NOT NULL DEFAULT 0,
  `Ability0` int(11) NOT NULL DEFAULT 0,
  `AbilStat0` int(11) NOT NULL DEFAULT 0,
  `Ability1` int(11) NOT NULL DEFAULT 0,
  `AbilStat1` int(11) NOT NULL DEFAULT 0,
  `AbilStat2` int(11) NOT NULL DEFAULT 0,
  `Ability3` int(11) NOT NULL DEFAULT 0,
  `AbilStat3` int(11) NOT NULL DEFAULT 0,
  `Ability4` int(11) NOT NULL DEFAULT 0,
  `AbilStat4` int(11) NOT NULL DEFAULT 0,
  `Ability5` int(11) NOT NULL DEFAULT 0,
  `AbilStat5` int(11) NOT NULL DEFAULT 0,
  `Ability6` int(11) NOT NULL DEFAULT 0,
  `AbilStat6` int(11) NOT NULL DEFAULT 0,
  `Ability7` int(11) NOT NULL DEFAULT 0,
  `AbilStat7` int(11) NOT NULL DEFAULT 0,
  `Ability8` int(11) NOT NULL DEFAULT 0,
  `AbilStat8` int(11) NOT NULL DEFAULT 0,
  `Ability9` int(11) NOT NULL DEFAULT 0,
  `AbilStat9` int(11) NOT NULL DEFAULT 0,
  `Ability10` int(11) NOT NULL DEFAULT 0,
  `AbilStat10` int(11) NOT NULL DEFAULT 0,
  `Ability11` int(11) NOT NULL DEFAULT 0,
  `AbilStat11` int(11) NOT NULL DEFAULT 0,
  `Ability12` int(11) NOT NULL DEFAULT 0,
  `AbilStat12` int(11) NOT NULL DEFAULT 0,
  `Rent0` int(11) NOT NULL DEFAULT 0,
  `RentVeh0` int(11) NOT NULL DEFAULT 0,
  `RentCol0` int(11) NOT NULL DEFAULT 0,
  `RentBenz0` int(11) NOT NULL DEFAULT 0,
  `RentModel0` int(11) NOT NULL DEFAULT 0,
  `RentBiz0` int(11) NOT NULL DEFAULT 0,
  `RentItem0` int(11) NOT NULL DEFAULT 0,
  `R_X0` float NOT NULL DEFAULT 0,
  `R_Y0` float NOT NULL DEFAULT 0,
  `R_Z0` float NOT NULL DEFAULT 0,
  `R_A0` float NOT NULL DEFAULT 0,
  `RentW0` int(11) NOT NULL DEFAULT 0,
  `RentI0` int(11) NOT NULL DEFAULT 0,
  `Rent1` int(11) NOT NULL DEFAULT 0,
  `RentVeh1` int(11) NOT NULL DEFAULT 0,
  `RentCol1` int(11) NOT NULL DEFAULT 0,
  `RentBenz1` int(11) NOT NULL DEFAULT 0,
  `RentModel1` int(11) NOT NULL DEFAULT 0,
  `RentBiz1` int(11) NOT NULL DEFAULT 0,
  `RentItem1` int(11) NOT NULL DEFAULT 0,
  `R_X1` float NOT NULL DEFAULT 0,
  `R_Y1` float NOT NULL DEFAULT 0,
  `R_Z1` float NOT NULL DEFAULT 0,
  `R_A1` float NOT NULL DEFAULT 0,
  `RentW1` int(11) NOT NULL DEFAULT 0,
  `RentI1` int(11) NOT NULL DEFAULT 0,
  `Support` int(11) NOT NULL DEFAULT 0,
  `Shop` int(11) NOT NULL DEFAULT 0,
  `Armour` float NOT NULL DEFAULT 0,
  `Message` int(11) NOT NULL DEFAULT 0,
  `MessUnix` int(11) NOT NULL DEFAULT 0,
  `Sim` int(11) NOT NULL DEFAULT 0,
  `pCustomLabel` int(11) NOT NULL DEFAULT 0,
  `Honing0` int(11) NOT NULL DEFAULT 0,
  `SexBreak` int(11) NOT NULL DEFAULT 0,
  `Illness0` int(11) NOT NULL DEFAULT 0,
  `Illness1` int(11) NOT NULL DEFAULT 0,
  `Illness2` int(11) NOT NULL DEFAULT 0,
  `Illness3` int(11) NOT NULL DEFAULT 0,
  `Illness4` int(11) NOT NULL DEFAULT 0,
  `IllnessStat0` int(11) NOT NULL DEFAULT 0,
  `IllnessStat1` int(11) NOT NULL DEFAULT 0,
  `IllnessStat2` int(11) NOT NULL DEFAULT 0,
  `IllnessStat3` int(11) NOT NULL DEFAULT 0,
  `IllnessStat4` int(11) NOT NULL DEFAULT 0,
  `IllnessProg0` int(11) NOT NULL DEFAULT 0,
  `IllnessProg1` int(11) NOT NULL DEFAULT 0,
  `IllnessProg2` int(11) NOT NULL DEFAULT 0,
  `IllnessProg3` int(11) NOT NULL DEFAULT 0,
  `IllnessProg4` int(11) NOT NULL DEFAULT 0,
  `Remedy` int(11) NOT NULL DEFAULT 0,
  `Maze2` int(11) NOT NULL DEFAULT 0,
  `Maze3` int(11) NOT NULL DEFAULT 0,
  `KasBlock` int(11) NOT NULL DEFAULT 0,
  `KasStat` int(11) NOT NULL DEFAULT 0,
  `Arob` int(11) NOT NULL DEFAULT 0,
  `Buyoc` int(11) NOT NULL DEFAULT 0,
  `Progless` int(11) NOT NULL DEFAULT 0,
  `Stopoc` int(11) NOT NULL DEFAULT 0,
  `Driveby` int(11) NOT NULL DEFAULT 0,
  `Achievequan` int(11) NOT NULL DEFAULT 0,
  `draw_x0` float NOT NULL DEFAULT 0,
  `draw_y0` float NOT NULL DEFAULT 0,
  `draw_sx0` float NOT NULL DEFAULT 0,
  `draw_sy0` float NOT NULL DEFAULT 0,
  `draw_x1` float NOT NULL DEFAULT 0,
  `draw_y1` float NOT NULL DEFAULT 0,
  `draw_sx1` float NOT NULL DEFAULT 0,
  `draw_sy1` float NOT NULL DEFAULT 0,
  `draw_x2` float NOT NULL DEFAULT 0,
  `draw_y2` float NOT NULL DEFAULT 0,
  `draw_sx2` float NOT NULL DEFAULT 0,
  `draw_sy2` float NOT NULL DEFAULT 0,
  `draw_x3` float NOT NULL DEFAULT 0,
  `draw_y3` float NOT NULL DEFAULT 0,
  `draw_sx3` float NOT NULL DEFAULT 0,
  `draw_sy3` float NOT NULL DEFAULT 0,
  `draw_x4` float NOT NULL DEFAULT 0,
  `draw_y4` float NOT NULL DEFAULT 0,
  `draw_sx4` float NOT NULL DEFAULT 0,
  `draw_sy4` float NOT NULL DEFAULT 0,
  `draw_x5` float NOT NULL DEFAULT 0,
  `draw_y5` float NOT NULL DEFAULT 0,
  `draw_sx5` float NOT NULL DEFAULT 0,
  `draw_sy5` float NOT NULL DEFAULT 0,
  `draw_x6` float NOT NULL DEFAULT 0,
  `draw_y6` float NOT NULL DEFAULT 0,
  `draw_sx6` float NOT NULL DEFAULT 0,
  `draw_sy6` float NOT NULL DEFAULT 0,
  `draw_x7` float NOT NULL DEFAULT 0,
  `draw_y7` float NOT NULL DEFAULT 0,
  `draw_sx7` float NOT NULL DEFAULT 0,
  `draw_sy7` float NOT NULL DEFAULT 0,
  `draw_x8` float NOT NULL DEFAULT 0,
  `draw_y8` float NOT NULL DEFAULT 0,
  `draw_sx8` float NOT NULL DEFAULT 0,
  `draw_sy8` float NOT NULL DEFAULT 0,
  `draw_x9` float NOT NULL DEFAULT 0,
  `draw_y9` float NOT NULL DEFAULT 0,
  `draw_sx9` float NOT NULL DEFAULT 0,
  `draw_sy9` float NOT NULL DEFAULT 0,
  `draw_x10` float NOT NULL DEFAULT 0,
  `draw_y10` float NOT NULL DEFAULT 0,
  `draw_sx10` float NOT NULL DEFAULT 0,
  `draw_sy10` float NOT NULL DEFAULT 0,
  `draw_x11` float NOT NULL DEFAULT 0,
  `draw_y11` float NOT NULL DEFAULT 0,
  `draw_sx11` float NOT NULL DEFAULT 0,
  `draw_sy11` float NOT NULL DEFAULT 0,
  `draw_x12` float NOT NULL DEFAULT 0,
  `draw_y12` float NOT NULL DEFAULT 0,
  `draw_sx12` float NOT NULL DEFAULT 0,
  `draw_sy12` float NOT NULL DEFAULT 0,
  `draw_x13` float NOT NULL DEFAULT 0,
  `draw_y13` float NOT NULL DEFAULT 0,
  `draw_sx13` float NOT NULL DEFAULT 0,
  `draw_sy13` float NOT NULL DEFAULT 0,
  `draw_vis2` int(11) NOT NULL DEFAULT 0,
  `draw_vis3` int(11) NOT NULL DEFAULT 0,
  `draw_vis7` int(11) NOT NULL DEFAULT 0,
  `draw_vis9` int(11) NOT NULL DEFAULT 0,
  `draw_vis10` int(11) NOT NULL DEFAULT 0,
  `typespeed` int(11) NOT NULL DEFAULT 0,
  `aspblock1` int(11) NOT NULL DEFAULT 0,
  `aspblock2` int(11) NOT NULL DEFAULT 0,
  `aspblock3` int(11) NOT NULL DEFAULT 0,
  `asptext` int(11) NOT NULL DEFAULT 0,
  `aspcol` int(11) NOT NULL DEFAULT 0,
  `draw_lang` tinyint(1) NOT NULL DEFAULT 0,
  `CallSign` varchar(24) DEFAULT NULL,
  `Keyhidden` varchar(64) DEFAULT NULL,
  `AccessoryReload` int(11) NOT NULL DEFAULT 0,
  `Division0` int(11) NOT NULL DEFAULT 0,
  `Division1` int(11) NOT NULL DEFAULT 0,
  `SignTransmitter` tinyint(1) NOT NULL DEFAULT 0,
  `KomnataCity` int(1) NOT NULL DEFAULT 0,
  `KeyVeh0` int(11) NOT NULL DEFAULT 0,
  `KeyVeh1` int(11) NOT NULL DEFAULT 0,
  `KeyVeh2` int(11) NOT NULL DEFAULT 0,
  `KeyVeh3` int(11) NOT NULL DEFAULT 0,
  `pLastPos0` float NOT NULL DEFAULT 0,
  `pLastPos1` float NOT NULL DEFAULT 0,
  `pLastPos2` float NOT NULL DEFAULT 0,
  `pLastPos3` float NOT NULL DEFAULT 0,
  `pLastWorld` int(11) NOT NULL DEFAULT 0,
  `pLastInt` int(11) NOT NULL DEFAULT 0,
  `find_X` float NOT NULL DEFAULT 0,
  `find_Y` float NOT NULL DEFAULT 0,
  `find_Z` float NOT NULL DEFAULT 0,
  `pBottlePoint` int(11) NOT NULL DEFAULT 0,
  `LastRank` int(11) NOT NULL DEFAULT 0,
  `LastFrak` int(11) NOT NULL DEFAULT 0,
  `Quest` varchar(60) DEFAULT NULL,
  `pColdCD` int(11) NOT NULL DEFAULT 0,
  `PrisonPipeUnix` int(11) NOT NULL DEFAULT 0,
  `PrisonSpoonUnix` int(11) NOT NULL DEFAULT 0,
  `pTrailer` int(11) NOT NULL DEFAULT 0,
  `pNamazCD` int(11) NOT NULL DEFAULT 0,
  `deathStatus` tinyint(1) NOT NULL DEFAULT 0,
  `deathTime` int(11) NOT NULL DEFAULT 0,
  `deathUnix` int(11) NOT NULL DEFAULT 0,
  `deathReason` int(11) NOT NULL DEFAULT 0,
  `pTransmitter` mediumblob DEFAULT NULL,
  `gun_0` mediumblob DEFAULT NULL,
  `gun_1` mediumblob DEFAULT NULL,
  `gun_2` mediumblob DEFAULT NULL,
  `gun_3` mediumblob DEFAULT NULL,
  `gun_4` mediumblob DEFAULT NULL,
  `gun_5` mediumblob DEFAULT NULL,
  `gun_6` mediumblob DEFAULT NULL,
  `gun_7` mediumblob DEFAULT NULL,
  `gun_8` mediumblob DEFAULT NULL,
  `gun_9` mediumblob DEFAULT NULL,
  `gun_10` mediumblob DEFAULT NULL,
  `gun_11` mediumblob DEFAULT NULL,
  `gun_12` mediumblob DEFAULT NULL,
  `pAutoFlipOff` tinyint(1) NOT NULL DEFAULT 0,
  `pCourtsStatus` int(1) NOT NULL DEFAULT 0,
  `pCourtsDeposit` int(11) NOT NULL DEFAULT 0,
  `pDominicUnix` int(11) NOT NULL DEFAULT 0,
  `pTaxesUnix` int(11) NOT NULL DEFAULT 0,
  `pNotCloseVeh` tinyint(1) NOT NULL DEFAULT 0,
  `pSharkTrap` blob DEFAULT NULL,
  `pDivRank0` int(11) NOT NULL DEFAULT 0,
  `pDivRank1` int(11) NOT NULL DEFAULT 0,
  `pDiscordID` varchar(18) DEFAULT NULL,
  `pCourtsDepositUnix` int(11) NOT NULL DEFAULT 0,
  `pSunScreen` int(11) NOT NULL DEFAULT 0,
  `pManiacCD` int(11) NOT NULL DEFAULT 0,
  `pGymUnix` int(11) NOT NULL DEFAULT 0,
  `pUnixRename` int(11) NOT NULL DEFAULT 0,
  `pRadioInterceptorFindCd` int(11) NOT NULL DEFAULT 0,
  `pCDVillage` int(11) NOT NULL DEFAULT 0,
  `pDatabaseActive` int(11) NOT NULL DEFAULT 0,
  `pCDKatana` int(11) NOT NULL DEFAULT 0,
  `pCDAd` int(11) NOT NULL DEFAULT 0,
  `pApartmentsRoom0` int(11) NOT NULL DEFAULT 0,
  `pApartmentsRoom1` int(11) NOT NULL DEFAULT 0,
  `pApartmentsRoom2` int(11) NOT NULL DEFAULT 0,
  `pApartmentsRoom3` int(11) NOT NULL DEFAULT 0,
  `pApartmentsRoom4` int(11) NOT NULL DEFAULT 0,
  `pApartmentsRoom5` int(11) NOT NULL DEFAULT 0,
  `pApartmentsRoom6` int(11) NOT NULL DEFAULT 0,
  `pApartmentsRoom7` int(11) NOT NULL DEFAULT 0,
  `pApartmentsRoom8` int(11) NOT NULL DEFAULT 0,
  `pApartmentsRoom9` int(11) NOT NULL DEFAULT 0,
  `pJobHint` int(11) NOT NULL DEFAULT 0,
  `pSpawnChangeDop` int(11) NOT NULL DEFAULT 0,
  `pCDGraves` int(11) NOT NULL DEFAULT 0,
  `pHankServices` int(11) NOT NULL DEFAULT 0,
  `pMenstrDay` int(11) NOT NULL DEFAULT 0,
  `pMenstrProkl` int(11) NOT NULL DEFAULT 0,
  `WarnClearTime` int(11) NOT NULL DEFAULT 0,
  `GunWarns` int(11) NOT NULL DEFAULT 0,
  `GunWarnsZZTime` int(11) NOT NULL DEFAULT 0,
  `GunWarnsDonateCD` int(11) NOT NULL DEFAULT 0,
  `pPackInteriors` int(11) NOT NULL DEFAULT 0,
  `pDamagInf` tinyint(1) NOT NULL DEFAULT 0,
  `Fame` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_igroki_contacts`
--

CREATE TABLE `pp_igroki_contacts` (
  `user_id` int(11) NOT NULL,
  `c0` mediumblob DEFAULT NULL,
  `c1` mediumblob DEFAULT NULL,
  `c2` mediumblob DEFAULT NULL,
  `c3` mediumblob DEFAULT NULL,
  `c4` mediumblob DEFAULT NULL,
  `c5` mediumblob DEFAULT NULL,
  `c6` mediumblob DEFAULT NULL,
  `c7` mediumblob DEFAULT NULL,
  `c8` mediumblob DEFAULT NULL,
  `c9` mediumblob DEFAULT NULL,
  `c10` mediumblob DEFAULT NULL,
  `c11` mediumblob DEFAULT NULL,
  `c12` mediumblob DEFAULT NULL,
  `c13` mediumblob DEFAULT NULL,
  `c14` mediumblob DEFAULT NULL,
  `c15` mediumblob DEFAULT NULL,
  `c16` mediumblob DEFAULT NULL,
  `c17` mediumblob DEFAULT NULL,
  `c18` mediumblob DEFAULT NULL,
  `c19` mediumblob DEFAULT NULL,
  `c20` mediumblob DEFAULT NULL,
  `c21` mediumblob DEFAULT NULL,
  `c22` mediumblob DEFAULT NULL,
  `c23` mediumblob DEFAULT NULL,
  `c24` mediumblob DEFAULT NULL,
  `c25` mediumblob DEFAULT NULL,
  `c26` mediumblob DEFAULT NULL,
  `c27` mediumblob DEFAULT NULL,
  `c28` mediumblob DEFAULT NULL,
  `c29` mediumblob DEFAULT NULL,
  `c30` mediumblob DEFAULT NULL,
  `c31` mediumblob DEFAULT NULL,
  `c32` mediumblob DEFAULT NULL,
  `c33` mediumblob DEFAULT NULL,
  `c34` mediumblob DEFAULT NULL,
  `c35` mediumblob DEFAULT NULL,
  `c36` mediumblob DEFAULT NULL,
  `c37` mediumblob DEFAULT NULL,
  `c38` mediumblob DEFAULT NULL,
  `c39` mediumblob DEFAULT NULL,
  `c40` mediumblob DEFAULT NULL,
  `c41` mediumblob DEFAULT NULL,
  `c42` mediumblob DEFAULT NULL,
  `c43` mediumblob DEFAULT NULL,
  `c44` mediumblob DEFAULT NULL,
  `c45` mediumblob DEFAULT NULL,
  `c46` mediumblob DEFAULT NULL,
  `c47` mediumblob DEFAULT NULL,
  `c48` mediumblob DEFAULT NULL,
  `c49` mediumblob DEFAULT NULL,
  `c50` mediumblob DEFAULT NULL,
  `c51` mediumblob DEFAULT NULL,
  `c52` mediumblob DEFAULT NULL,
  `c53` mediumblob DEFAULT NULL,
  `c54` mediumblob DEFAULT NULL,
  `c55` mediumblob DEFAULT NULL,
  `c56` mediumblob DEFAULT NULL,
  `c57` mediumblob DEFAULT NULL,
  `c58` mediumblob DEFAULT NULL,
  `c59` mediumblob DEFAULT NULL,
  `b0` mediumblob DEFAULT NULL,
  `b1` mediumblob DEFAULT NULL,
  `b2` mediumblob DEFAULT NULL,
  `b3` mediumblob DEFAULT NULL,
  `b4` mediumblob DEFAULT NULL,
  `b5` mediumblob DEFAULT NULL,
  `b6` mediumblob DEFAULT NULL,
  `b7` mediumblob DEFAULT NULL,
  `b8` mediumblob DEFAULT NULL,
  `b9` mediumblob DEFAULT NULL,
  `b10` mediumblob DEFAULT NULL,
  `b11` mediumblob DEFAULT NULL,
  `b12` mediumblob DEFAULT NULL,
  `b13` mediumblob DEFAULT NULL,
  `b14` mediumblob DEFAULT NULL,
  `b15` mediumblob DEFAULT NULL,
  `b16` mediumblob DEFAULT NULL,
  `b17` mediumblob DEFAULT NULL,
  `b18` mediumblob DEFAULT NULL,
  `b19` mediumblob DEFAULT NULL,
  `b20` mediumblob DEFAULT NULL,
  `b21` mediumblob DEFAULT NULL,
  `b22` mediumblob DEFAULT NULL,
  `b23` mediumblob DEFAULT NULL,
  `b24` mediumblob DEFAULT NULL,
  `b25` mediumblob DEFAULT NULL,
  `b26` mediumblob DEFAULT NULL,
  `b27` mediumblob DEFAULT NULL,
  `b28` mediumblob DEFAULT NULL,
  `b29` mediumblob DEFAULT NULL,
  `b30` mediumblob DEFAULT NULL,
  `b31` mediumblob DEFAULT NULL,
  `b32` mediumblob DEFAULT NULL,
  `b33` mediumblob DEFAULT NULL,
  `b34` mediumblob DEFAULT NULL,
  `b35` mediumblob DEFAULT NULL,
  `b36` mediumblob DEFAULT NULL,
  `b37` mediumblob DEFAULT NULL,
  `b38` mediumblob DEFAULT NULL,
  `b39` mediumblob DEFAULT NULL,
  `b40` mediumblob DEFAULT NULL,
  `b41` mediumblob DEFAULT NULL,
  `b42` mediumblob DEFAULT NULL,
  `b43` mediumblob DEFAULT NULL,
  `b44` mediumblob DEFAULT NULL,
  `b45` mediumblob DEFAULT NULL,
  `b46` mediumblob DEFAULT NULL,
  `b47` mediumblob DEFAULT NULL,
  `b48` mediumblob DEFAULT NULL,
  `b49` mediumblob DEFAULT NULL,
  `b50` mediumblob DEFAULT NULL,
  `b51` mediumblob DEFAULT NULL,
  `b52` mediumblob DEFAULT NULL,
  `b53` mediumblob DEFAULT NULL,
  `b54` mediumblob DEFAULT NULL,
  `b55` mediumblob DEFAULT NULL,
  `b56` mediumblob DEFAULT NULL,
  `b57` mediumblob DEFAULT NULL,
  `b58` mediumblob DEFAULT NULL,
  `b59` mediumblob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_igroki_hint`
--

CREATE TABLE `pp_igroki_hint` (
  `user_id` int(11) NOT NULL DEFAULT 0,
  `hint0` int(11) NOT NULL DEFAULT 0,
  `hint1` int(11) NOT NULL DEFAULT 0,
  `hint2` int(11) NOT NULL DEFAULT 0,
  `hint3` int(11) NOT NULL DEFAULT 0,
  `hint4` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_igroki_inventory`
--

CREATE TABLE `pp_igroki_inventory` (
  `user_id` int(11) NOT NULL,
  `i_slot_0` mediumblob DEFAULT NULL,
  `i_slot_1` mediumblob DEFAULT NULL,
  `i_slot_2` mediumblob DEFAULT NULL,
  `i_slot_3` mediumblob DEFAULT NULL,
  `i_slot_4` mediumblob DEFAULT NULL,
  `i_slot_5` mediumblob DEFAULT NULL,
  `i_slot_6` mediumblob DEFAULT NULL,
  `i_slot_7` mediumblob DEFAULT NULL,
  `i_slot_8` mediumblob DEFAULT NULL,
  `i_slot_9` mediumblob DEFAULT NULL,
  `i_slot_10` mediumblob DEFAULT NULL,
  `i_slot_11` mediumblob DEFAULT NULL,
  `i_slot_12` mediumblob DEFAULT NULL,
  `i_slot_13` mediumblob DEFAULT NULL,
  `i_slot_14` mediumblob DEFAULT NULL,
  `i_slot_15` mediumblob DEFAULT NULL,
  `i_slot_16` mediumblob DEFAULT NULL,
  `i_slot_17` mediumblob DEFAULT NULL,
  `i_slot_18` mediumblob DEFAULT NULL,
  `i_slot_19` mediumblob DEFAULT NULL,
  `i_slot_20` mediumblob DEFAULT NULL,
  `i_slot_21` mediumblob DEFAULT NULL,
  `i_slot_22` mediumblob DEFAULT NULL,
  `i_slot_23` mediumblob DEFAULT NULL,
  `i_slot_24` mediumblob DEFAULT NULL,
  `i_slot_25` mediumblob DEFAULT NULL,
  `i_slot_26` mediumblob DEFAULT NULL,
  `i_slot_27` mediumblob DEFAULT NULL,
  `i_slot_28` mediumblob DEFAULT NULL,
  `i_slot_29` mediumblob DEFAULT NULL,
  `i_slot_30` mediumblob DEFAULT NULL,
  `i_slot_31` mediumblob DEFAULT NULL,
  `i_slot_32` mediumblob DEFAULT NULL,
  `i_slot_33` mediumblob DEFAULT NULL,
  `i_slot_34` mediumblob DEFAULT NULL,
  `i_slot_35` mediumblob DEFAULT NULL,
  `i_slot_36` mediumblob DEFAULT NULL,
  `i_slot_37` mediumblob DEFAULT NULL,
  `i_slot_38` mediumblob DEFAULT NULL,
  `i_slot_39` mediumblob DEFAULT NULL,
  `m_slot_0` mediumblob DEFAULT NULL,
  `m_slot_1` mediumblob DEFAULT NULL,
  `m_slot_2` mediumblob DEFAULT NULL,
  `m_slot_3` mediumblob DEFAULT NULL,
  `m_slot_4` mediumblob DEFAULT NULL,
  `m_slot_5` mediumblob DEFAULT NULL,
  `m_slot_6` mediumblob DEFAULT NULL,
  `m_slot_7` mediumblob DEFAULT NULL,
  `m_slot_8` mediumblob DEFAULT NULL,
  `m_slot_9` mediumblob DEFAULT NULL,
  `m_slot_10` mediumblob DEFAULT NULL,
  `m_slot_11` mediumblob DEFAULT NULL,
  `m_slot_12` mediumblob DEFAULT NULL,
  `m_slot_13` mediumblob DEFAULT NULL,
  `m_slot_14` mediumblob DEFAULT NULL,
  `m_slot_15` mediumblob DEFAULT NULL,
  `m_slot_16` mediumblob DEFAULT NULL,
  `m_slot_17` mediumblob DEFAULT NULL,
  `m_slot_18` mediumblob DEFAULT NULL,
  `m_slot_19` mediumblob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_igroki_maniac`
--

CREATE TABLE `pp_igroki_maniac` (
  `user_id` int(11) NOT NULL,
  `mask` mediumblob DEFAULT NULL,
  `pManiacQwest` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_igroki_top`
--

CREATE TABLE `pp_igroki_top` (
  `user_id` int(11) NOT NULL,
  `Name` varchar(24) CHARACTER SET cp1251 DEFAULT NULL,
  `pKilledManiac` int(11) NOT NULL DEFAULT 0,
  `pKilledVillage` int(11) NOT NULL DEFAULT 0,
  `pKilledZombie` int(11) NOT NULL DEFAULT 0,
  `pCraftCount` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `pp_ikea`
--

CREATE TABLE `pp_ikea` (
  `newid` int(11) NOT NULL,
  `Model` int(11) NOT NULL DEFAULT 0,
  `Price` int(11) NOT NULL DEFAULT 0,
  `Name` varchar(24) DEFAULT NULL,
  `Pavilion` int(11) NOT NULL DEFAULT 0,
  `Quantextures` int(11) NOT NULL DEFAULT 0,
  `Sale` int(11) NOT NULL DEFAULT 0,
  `Gold` int(11) NOT NULL DEFAULT 0,
  `X` float NOT NULL DEFAULT 0,
  `Y` float NOT NULL DEFAULT 0,
  `Z` float NOT NULL DEFAULT 0,
  `RX` float NOT NULL DEFAULT 0,
  `RY` float NOT NULL DEFAULT 0,
  `RZ` float NOT NULL DEFAULT 0,
  `BuyX` float NOT NULL DEFAULT 0,
  `BuyY` float NOT NULL DEFAULT 0,
  `BuyZ` float NOT NULL DEFAULT 0,
  `iStreetObject` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_map`
--

CREATE TABLE `pp_map` (
  `newid` int(10) UNSIGNED NOT NULL,
  `id` int(11) NOT NULL DEFAULT 0,
  `namemap` varchar(64) NOT NULL,
  `option` varchar(144) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_mapfrak`
--

CREATE TABLE `pp_mapfrak` (
  `newid` int(11) NOT NULL,
  `frakid` int(11) NOT NULL DEFAULT 0,
  `mapid` int(11) NOT NULL DEFAULT 0,
  `user` int(11) NOT NULL DEFAULT 0,
  `model` int(11) NOT NULL DEFAULT 0,
  `slot` int(11) NOT NULL DEFAULT 0,
  `ox` float NOT NULL DEFAULT 0,
  `oy` float NOT NULL DEFAULT 0,
  `oz` float NOT NULL DEFAULT 0,
  `orx` float NOT NULL DEFAULT 0,
  `ory` float NOT NULL DEFAULT 0,
  `orz` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_menumusic`
--

CREATE TABLE `pp_menumusic` (
  `newid` int(11) NOT NULL,
  `musStat` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Используется или нет',
  `musLink` varchar(120) DEFAULT NULL COMMENT 'Ссылка на трек',
  `musName` varchar(65) DEFAULT NULL COMMENT 'Название трека',
  `musType` int(11) NOT NULL DEFAULT 0 COMMENT 'Тип меню',
  `musTime` int(11) NOT NULL DEFAULT 0 COMMENT 'Время использования на сервере'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Музыка при заходе в игру и в менюшках';

-- --------------------------------------------------------

--
-- Table structure for table `pp_message`
--

CREATE TABLE `pp_message` (
  `newid` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `type` int(11) NOT NULL DEFAULT 0,
  `senderid` int(11) NOT NULL DEFAULT 0,
  `sender` varchar(21) DEFAULT NULL,
  `playerid` int(11) NOT NULL DEFAULT 0,
  `player` varchar(21) DEFAULT NULL,
  `unix` int(11) NOT NULL DEFAULT 0,
  `text` varchar(144) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `pp_name`
--

CREATE TABLE `pp_name` (
  `newid` int(11) NOT NULL,
  `name` varchar(24) DEFAULT NULL,
  `acc` int(11) NOT NULL DEFAULT 0,
  `unix` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_narco_farms`
--

CREATE TABLE `pp_narco_farms` (
  `id` int(11) NOT NULL DEFAULT 0,
  `fraction` int(11) DEFAULT 0,
  `info_pickup_x` float DEFAULT 0,
  `info_pickup_y` float DEFAULT 0,
  `info_pickup_z` float DEFAULT 0,
  `area_min_x` float DEFAULT 0,
  `area_min_y` float DEFAULT 0,
  `area_min_z` float DEFAULT 0,
  `area_max_x` float DEFAULT 0,
  `area_max_y` float DEFAULT 0,
  `area_max_z` float DEFAULT 0,
  `seller_pos_x` float DEFAULT 0,
  `seller_pos_y` float DEFAULT 0,
  `seller_pos_z` float DEFAULT 0,
  `seller_pos_a` float DEFAULT 0,
  `booth_rent_price` int(11) DEFAULT 0,
  `booth_mafia` int(11) DEFAULT 0,
  `defenders_pos_x` float DEFAULT 0,
  `defenders_pos_y` float DEFAULT 0,
  `defenders_pos_z` float DEFAULT 0,
  `defenders_pos_a` float DEFAULT 0,
  `attackers_pos_x` float DEFAULT 0,
  `attackers_pos_y` float DEFAULT 0,
  `attackers_pos_z` float DEFAULT 0,
  `attackers_pos_a` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pp_narco_spots`
--

CREATE TABLE `pp_narco_spots` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `fraction` int(11) NOT NULL DEFAULT 0,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `a` float NOT NULL DEFAULT 0,
  `rx` float DEFAULT 0,
  `ry` float DEFAULT 0,
  `rz` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pp_organization`
--

CREATE TABLE `pp_organization` (
  `newid` int(11) NOT NULL,
  `frakid` int(11) NOT NULL,
  `frakname` varchar(64) NOT NULL,
  `lave` bigint(20) NOT NULL,
  `benz` int(11) NOT NULL,
  `mats` int(11) NOT NULL,
  `depozit` int(11) NOT NULL,
  `sklad` int(11) NOT NULL,
  `car1` int(11) NOT NULL,
  `car2` int(11) NOT NULL,
  `car3` int(11) NOT NULL,
  `car4` int(11) NOT NULL,
  `car5` int(11) NOT NULL,
  `car6` int(11) NOT NULL,
  `car7` int(11) NOT NULL,
  `car8` int(11) NOT NULL,
  `car9` int(11) NOT NULL,
  `car10` int(11) NOT NULL,
  `car11` int(11) NOT NULL,
  `car12` int(11) NOT NULL,
  `car13` int(11) NOT NULL,
  `car14` int(11) NOT NULL,
  `car15` int(11) NOT NULL,
  `car16` int(11) NOT NULL,
  `car17` int(11) NOT NULL,
  `car18` int(11) NOT NULL,
  `car19` int(11) NOT NULL,
  `car20` int(11) NOT NULL,
  `car21` int(11) NOT NULL,
  `car22` int(11) NOT NULL,
  `car23` int(11) NOT NULL,
  `car24` int(11) NOT NULL,
  `car25` int(11) NOT NULL,
  `car26` int(11) NOT NULL,
  `car27` int(11) NOT NULL,
  `car28` int(11) NOT NULL,
  `car29` int(11) NOT NULL,
  `car30` int(11) NOT NULL,
  `war1` int(11) NOT NULL,
  `war2` int(11) NOT NULL,
  `war3` int(11) NOT NULL,
  `war4` int(11) NOT NULL,
  `war5` int(11) NOT NULL,
  `union1` int(11) NOT NULL,
  `union2` int(11) NOT NULL,
  `union3` int(11) NOT NULL,
  `union4` int(11) NOT NULL,
  `union5` int(11) NOT NULL,
  `neutral1` int(11) NOT NULL,
  `neutral2` int(11) NOT NULL,
  `neutral3` int(11) NOT NULL,
  `neutral4` int(11) NOT NULL,
  `neutral5` int(11) NOT NULL,
  `drugs1` int(20) NOT NULL,
  `drugs2` int(20) NOT NULL,
  `drugs3` int(11) NOT NULL,
  `drugs4` int(11) NOT NULL,
  `apt` int(11) NOT NULL,
  `food` int(11) NOT NULL,
  `cvetcar` int(11) NOT NULL,
  `acc0` int(11) NOT NULL,
  `acc1` int(11) NOT NULL,
  `acc2` int(11) NOT NULL,
  `acc3` int(11) NOT NULL,
  `acc4` int(11) NOT NULL,
  `acc5` int(11) NOT NULL,
  `acc6` int(11) NOT NULL,
  `acc7` int(11) NOT NULL,
  `acc8` int(11) NOT NULL,
  `acc9` int(11) NOT NULL,
  `acc10` int(11) NOT NULL,
  `acc11` int(11) NOT NULL,
  `acc12` int(11) NOT NULL,
  `acc13` int(11) NOT NULL,
  `acc14` int(11) NOT NULL,
  `acc15` int(11) NOT NULL,
  `interval` int(11) NOT NULL,
  `acc16` int(11) NOT NULL,
  `acc17` int(11) NOT NULL,
  `acc18` int(11) NOT NULL,
  `acc19` int(11) NOT NULL,
  `acc20` int(11) NOT NULL,
  `acc21` int(11) NOT NULL,
  `acc22` int(11) NOT NULL,
  `acc23` int(11) NOT NULL,
  `acc24` int(11) NOT NULL,
  `acc25` int(11) NOT NULL,
  `acc26` int(11) NOT NULL,
  `acc27` int(11) NOT NULL,
  `acc28` int(11) NOT NULL,
  `acc29` int(11) NOT NULL,
  `acc30` int(11) NOT NULL,
  `acc31` int(11) NOT NULL,
  `acc32` int(11) NOT NULL,
  `acc33` int(11) NOT NULL,
  `acc34` int(11) NOT NULL,
  `acc35` int(11) NOT NULL,
  `acc36` int(11) NOT NULL,
  `acc37` int(11) NOT NULL,
  `acc38` int(11) NOT NULL,
  `acc39` int(11) NOT NULL,
  `acc40` int(11) NOT NULL,
  `acc41` int(11) NOT NULL,
  `acc42` int(11) NOT NULL,
  `acc43` int(11) NOT NULL,
  `acc44` int(11) NOT NULL,
  `acc45` int(11) NOT NULL,
  `acc46` int(11) NOT NULL,
  `acc47` int(11) NOT NULL,
  `acc48` int(11) NOT NULL,
  `acc49` int(11) NOT NULL,
  `acc50` int(11) NOT NULL,
  `acc51` int(11) NOT NULL,
  `acc52` int(11) NOT NULL,
  `acc53` int(11) NOT NULL,
  `acc54` int(11) NOT NULL,
  `acc55` int(11) NOT NULL,
  `acc56` int(11) NOT NULL,
  `acc57` int(11) NOT NULL,
  `acc58` int(11) NOT NULL,
  `acc59` int(11) NOT NULL,
  `acc60` int(11) NOT NULL,
  `acc61` int(11) NOT NULL,
  `acc62` int(11) NOT NULL,
  `acc63` int(11) NOT NULL,
  `acc64` int(11) NOT NULL,
  `acc65` int(11) NOT NULL,
  `acc66` int(11) NOT NULL,
  `acc67` int(11) NOT NULL,
  `acc68` int(11) NOT NULL,
  `acc69` int(11) NOT NULL,
  `acc70` int(11) NOT NULL,
  `acc71` int(11) NOT NULL,
  `acc72` int(11) NOT NULL,
  `acc73` int(11) NOT NULL,
  `acc74` int(11) NOT NULL,
  `acc75` int(11) NOT NULL,
  `acc76` int(11) NOT NULL,
  `acc77` int(11) NOT NULL,
  `acc78` int(11) NOT NULL,
  `acc79` int(11) NOT NULL,
  `acc80` int(11) NOT NULL,
  `gustat0` int(11) NOT NULL,
  `gux0` float NOT NULL,
  `guy0` float NOT NULL,
  `guz0` float NOT NULL,
  `guint0` int(11) NOT NULL,
  `guworld0` int(11) NOT NULL,
  `gustat1` int(11) NOT NULL,
  `gux1` float NOT NULL,
  `guy1` float NOT NULL,
  `guz1` float NOT NULL,
  `guint1` int(11) NOT NULL,
  `guworld1` int(11) NOT NULL,
  `gustat2` int(11) NOT NULL,
  `gux2` float NOT NULL,
  `guy2` float NOT NULL,
  `guz2` float NOT NULL,
  `guint2` int(11) NOT NULL,
  `guworld2` int(11) NOT NULL,
  `gustat3` int(11) NOT NULL,
  `gux3` float NOT NULL,
  `guy3` float NOT NULL,
  `guz3` float NOT NULL,
  `guint3` int(11) NOT NULL,
  `guworld3` int(11) NOT NULL,
  `gustat4` int(11) NOT NULL,
  `gux4` float NOT NULL,
  `guy4` float NOT NULL,
  `guz4` float NOT NULL,
  `guint4` int(11) NOT NULL,
  `guworld4` int(11) NOT NULL,
  `gustat5` int(11) NOT NULL,
  `gux5` float NOT NULL,
  `guy5` float NOT NULL,
  `guz5` float NOT NULL,
  `guint5` int(11) NOT NULL,
  `guworld5` int(11) NOT NULL,
  `gustat6` int(11) NOT NULL,
  `gux6` float NOT NULL,
  `guy6` float NOT NULL,
  `guz6` float NOT NULL,
  `guint6` int(11) NOT NULL,
  `guworld6` int(11) NOT NULL,
  `gustat7` int(11) NOT NULL,
  `gux7` float NOT NULL,
  `guy7` float NOT NULL,
  `guz7` float NOT NULL,
  `guint7` int(11) NOT NULL,
  `guworld7` int(11) NOT NULL,
  `gustat8` int(11) NOT NULL,
  `gux8` float NOT NULL,
  `guy8` float NOT NULL,
  `guz8` float NOT NULL,
  `guint8` int(11) NOT NULL,
  `guworld8` int(11) NOT NULL,
  `gustat9` int(11) NOT NULL,
  `gux9` float NOT NULL,
  `guy9` float NOT NULL,
  `guz9` float NOT NULL,
  `guint9` int(11) NOT NULL,
  `guworld9` int(11) NOT NULL,
  `gustat10` int(11) NOT NULL,
  `gux10` float NOT NULL,
  `guy10` float NOT NULL,
  `guz10` float NOT NULL,
  `guint10` int(11) NOT NULL,
  `guworld10` int(11) NOT NULL,
  `gustat11` int(11) NOT NULL,
  `gux11` float NOT NULL,
  `guy11` float NOT NULL,
  `guz11` float NOT NULL,
  `guint11` int(11) NOT NULL,
  `guworld11` int(11) NOT NULL,
  `gustat12` int(11) NOT NULL,
  `gux12` float NOT NULL,
  `guy12` float NOT NULL,
  `guz12` float NOT NULL,
  `guint12` int(11) NOT NULL,
  `guworld12` int(11) NOT NULL,
  `gustat13` int(11) NOT NULL,
  `gux13` float NOT NULL,
  `guy13` float NOT NULL,
  `guz13` float NOT NULL,
  `guint13` int(11) NOT NULL,
  `guworld13` int(11) NOT NULL,
  `gustat14` int(11) NOT NULL,
  `gux14` float NOT NULL,
  `guy14` float NOT NULL,
  `guz14` float NOT NULL,
  `guint14` int(11) NOT NULL,
  `guworld14` int(11) NOT NULL,
  `gustat15` int(11) NOT NULL,
  `gux15` float NOT NULL,
  `guy15` float NOT NULL,
  `guz15` float NOT NULL,
  `guint15` int(11) NOT NULL,
  `guworld15` int(11) NOT NULL,
  `gustat16` int(11) NOT NULL,
  `gux16` float NOT NULL,
  `guy16` float NOT NULL,
  `guz16` float NOT NULL,
  `guint16` int(11) NOT NULL,
  `guworld16` int(11) NOT NULL,
  `gustat17` int(11) NOT NULL,
  `gux17` float NOT NULL,
  `guy17` float NOT NULL,
  `guz17` float NOT NULL,
  `guint17` int(11) NOT NULL,
  `guworld17` int(11) NOT NULL,
  `gustat18` int(11) NOT NULL,
  `gux18` float NOT NULL,
  `guy18` float NOT NULL,
  `guz18` float NOT NULL,
  `guint18` int(11) NOT NULL,
  `guworld18` int(11) NOT NULL,
  `gustat19` int(11) NOT NULL,
  `gux19` float NOT NULL,
  `guy19` float NOT NULL,
  `guz19` float NOT NULL,
  `guint19` int(11) NOT NULL,
  `guworld19` int(11) NOT NULL,
  `Shead` int(11) NOT NULL,
  `SCbug` int(11) NOT NULL,
  `SanHead` int(11) NOT NULL,
  `SanCbug` int(11) NOT NULL,
  `Rejim1` int(11) NOT NULL,
  `Rejim2` int(11) NOT NULL,
  `rank0` varchar(31) NOT NULL,
  `rank1` varchar(34) NOT NULL,
  `rank2` varchar(34) NOT NULL,
  `rank3` varchar(34) NOT NULL,
  `rank4` varchar(34) NOT NULL,
  `rank5` varchar(34) NOT NULL,
  `rank6` varchar(34) NOT NULL,
  `rank7` varchar(34) NOT NULL,
  `rank8` varchar(34) NOT NULL,
  `rank9` varchar(34) NOT NULL,
  `rank10` varchar(34) NOT NULL,
  `rank11` varchar(34) NOT NULL,
  `rank12` varchar(34) NOT NULL,
  `rank13` varchar(34) NOT NULL,
  `rank14` varchar(34) NOT NULL,
  `rank15` varchar(34) NOT NULL,
  `rank16` varchar(34) NOT NULL,
  `rank17` varchar(34) NOT NULL,
  `rank18` varchar(34) NOT NULL,
  `rank19` varchar(34) NOT NULL,
  `rank20` varchar(34) NOT NULL,
  `rank21` varchar(34) NOT NULL,
  `rank22` varchar(34) NOT NULL,
  `rank23` varchar(31) NOT NULL,
  `rank24` varchar(31) NOT NULL,
  `rank25` varchar(31) NOT NULL,
  `rank26` varchar(31) NOT NULL,
  `rank27` varchar(31) NOT NULL,
  `rank28` varchar(31) NOT NULL,
  `rank29` varchar(31) NOT NULL,
  `capt0` int(11) NOT NULL,
  `capt1` int(11) NOT NULL,
  `capt2` int(11) NOT NULL,
  `capt3` int(11) NOT NULL,
  `capt4` int(11) NOT NULL,
  `capt5` int(11) NOT NULL,
  `capt6` int(11) NOT NULL,
  `capt7` int(11) NOT NULL,
  `capt8` int(11) NOT NULL,
  `capt9` int(11) NOT NULL,
  `capt10` int(11) NOT NULL,
  `capt11` int(11) NOT NULL,
  `capt12` int(11) NOT NULL,
  `capt13` int(11) NOT NULL,
  `capt14` int(11) NOT NULL,
  `capt15` int(11) NOT NULL,
  `capt16` int(11) NOT NULL,
  `capt17` int(11) NOT NULL,
  `capt18` int(11) NOT NULL,
  `capt19` int(11) NOT NULL,
  `capt20` int(11) NOT NULL,
  `unitstat0` int(11) NOT NULL,
  `unitstat1` int(11) NOT NULL,
  `unitstat2` int(11) NOT NULL,
  `unitstat3` int(11) NOT NULL,
  `unitstat4` int(11) NOT NULL,
  `unitstat5` int(11) NOT NULL,
  `unitstat6` int(11) NOT NULL,
  `unitstat7` int(11) NOT NULL,
  `unitstat8` int(11) NOT NULL,
  `unitstat9` int(11) NOT NULL,
  `unitstat10` int(11) NOT NULL,
  `unitstat11` int(11) NOT NULL,
  `unitstat12` int(11) NOT NULL,
  `unitstat13` int(11) NOT NULL,
  `unitstat14` int(11) NOT NULL,
  `unitstat15` int(11) NOT NULL,
  `unitstat16` int(11) NOT NULL,
  `unitstat17` int(11) NOT NULL,
  `unitstat18` int(11) NOT NULL,
  `unitstat19` int(11) NOT NULL,
  `unitstat20` int(11) NOT NULL,
  `unitstat21` int(11) NOT NULL,
  `unitstat22` int(11) NOT NULL,
  `unitstat23` int(11) NOT NULL,
  `cash` int(11) NOT NULL,
  `caracc0` int(11) NOT NULL,
  `caracc1` int(11) NOT NULL,
  `caracc2` int(11) NOT NULL,
  `caracc3` int(11) NOT NULL,
  `caracc4` int(11) NOT NULL,
  `caracc5` int(11) NOT NULL,
  `caracc6` int(11) NOT NULL,
  `caracc7` int(11) NOT NULL,
  `caracc8` int(11) NOT NULL,
  `caracc9` int(11) NOT NULL,
  `map` int(11) NOT NULL,
  `acc81` int(11) NOT NULL,
  `acc82` int(11) NOT NULL,
  `acc83` int(11) NOT NULL,
  `acc84` int(11) NOT NULL,
  `acc85` int(11) NOT NULL,
  `acc86` int(11) NOT NULL,
  `acc87` int(11) NOT NULL,
  `acc88` int(11) NOT NULL,
  `acc89` int(11) NOT NULL,
  `acc90` int(11) NOT NULL,
  `acc91` int(11) NOT NULL,
  `acc92` int(11) NOT NULL,
  `acc93` int(11) NOT NULL,
  `acc94` int(11) NOT NULL,
  `acc95` int(11) NOT NULL,
  `acc96` int(11) NOT NULL,
  `acc97` int(11) NOT NULL,
  `acc98` int(11) NOT NULL,
  `acc99` int(11) NOT NULL,
  `gMaxRanks` int(11) NOT NULL,
  `Order0` int(11) NOT NULL,
  `Order1` int(11) NOT NULL,
  `Order2` int(11) NOT NULL,
  `Order3` int(11) NOT NULL,
  `Order4` int(11) NOT NULL,
  `Order5` int(11) NOT NULL,
  `Order6` int(11) NOT NULL,
  `Order7` int(11) NOT NULL,
  `Order8` int(11) NOT NULL,
  `Order9` int(11) NOT NULL,
  `OrderQuan0` int(11) NOT NULL,
  `OrderQuan1` int(11) NOT NULL,
  `OrderQuan2` int(11) NOT NULL,
  `OrderQuan3` int(11) NOT NULL,
  `OrderQuan4` int(11) NOT NULL,
  `OrderQuan5` int(11) NOT NULL,
  `OrderQuan6` int(11) NOT NULL,
  `OrderQuan7` int(11) NOT NULL,
  `OrderQuan8` int(11) NOT NULL,
  `OrderQuan9` int(11) NOT NULL,
  `OrderType0` int(11) NOT NULL,
  `OrderType1` int(11) NOT NULL,
  `OrderType2` int(11) NOT NULL,
  `OrderType3` int(11) NOT NULL,
  `OrderType4` int(11) NOT NULL,
  `OrderType5` int(11) NOT NULL,
  `OrderType6` int(11) NOT NULL,
  `OrderType7` int(11) NOT NULL,
  `OrderType8` int(11) NOT NULL,
  `OrderType9` int(11) NOT NULL,
  `OrderStatus` int(11) NOT NULL,
  `gDeliveryPay` int(11) NOT NULL,
  `gTax` int(11) NOT NULL,
  `accdiv0` int(11) NOT NULL,
  `accdiv1` int(11) NOT NULL,
  `accdiv2` int(11) NOT NULL,
  `accdiv3` int(11) NOT NULL,
  `accdiv4` int(11) NOT NULL,
  `accdiv5` int(11) NOT NULL,
  `accdiv6` int(11) NOT NULL,
  `accdiv7` int(11) NOT NULL,
  `accdiv8` int(11) NOT NULL,
  `accdiv9` int(11) NOT NULL,
  `accdiv10` int(11) NOT NULL,
  `accdiv11` int(11) NOT NULL,
  `accdiv12` int(11) NOT NULL,
  `accdiv13` int(11) NOT NULL,
  `accdiv14` int(11) NOT NULL,
  `accdiv15` int(11) NOT NULL,
  `accdiv16` int(11) NOT NULL,
  `accdiv17` int(11) NOT NULL,
  `accdiv18` int(11) NOT NULL,
  `accdiv19` int(11) NOT NULL,
  `accdiv20` int(11) NOT NULL,
  `accdiv21` int(11) NOT NULL,
  `accdiv22` int(11) NOT NULL,
  `accdiv23` int(11) NOT NULL,
  `accdiv24` int(11) NOT NULL,
  `accdiv25` int(11) NOT NULL,
  `accdiv26` int(11) NOT NULL,
  `accdiv27` int(11) NOT NULL,
  `accdiv28` int(11) NOT NULL,
  `accdiv29` int(11) NOT NULL,
  `accdiv30` int(11) NOT NULL,
  `accdiv31` int(11) NOT NULL,
  `accdiv32` int(11) NOT NULL,
  `accdiv33` int(11) NOT NULL,
  `accdiv34` int(11) NOT NULL,
  `accdiv35` int(11) NOT NULL,
  `accdiv36` int(11) NOT NULL,
  `accdiv37` int(11) NOT NULL,
  `accdiv38` int(11) NOT NULL,
  `accdiv39` int(11) NOT NULL,
  `accdiv40` int(11) NOT NULL,
  `accdiv41` int(11) NOT NULL,
  `accdiv42` int(11) NOT NULL,
  `accdiv43` int(11) NOT NULL,
  `accdiv44` int(11) NOT NULL,
  `accdiv45` int(11) NOT NULL,
  `accdiv46` int(11) NOT NULL,
  `accdiv47` int(11) NOT NULL,
  `accdiv48` int(11) NOT NULL,
  `accdiv49` int(11) NOT NULL,
  `accdiv50` int(11) NOT NULL,
  `accdiv51` int(11) NOT NULL,
  `accdiv52` int(11) NOT NULL,
  `accdiv53` int(11) NOT NULL,
  `accdiv54` int(11) NOT NULL,
  `accdiv55` int(11) NOT NULL,
  `accdiv56` int(11) NOT NULL,
  `accdiv57` int(11) NOT NULL,
  `accdiv58` int(11) NOT NULL,
  `accdiv59` int(11) NOT NULL,
  `accdiv60` int(11) NOT NULL,
  `accdiv61` int(11) NOT NULL,
  `accdiv62` int(11) NOT NULL,
  `accdiv63` int(11) NOT NULL,
  `accdiv64` int(11) NOT NULL,
  `accdiv65` int(11) NOT NULL,
  `accdiv66` int(11) NOT NULL,
  `accdiv67` int(11) NOT NULL,
  `accdiv68` int(11) NOT NULL,
  `accdiv69` int(11) NOT NULL,
  `accdiv70` int(11) NOT NULL,
  `accdiv71` int(11) NOT NULL,
  `accdiv72` int(11) NOT NULL,
  `accdiv73` int(11) NOT NULL,
  `accdiv74` int(11) NOT NULL,
  `accdiv75` int(11) NOT NULL,
  `accdiv76` int(11) NOT NULL,
  `accdiv77` int(11) NOT NULL,
  `accdiv78` int(11) NOT NULL,
  `accdiv79` int(11) NOT NULL,
  `accdiv80` int(11) NOT NULL,
  `accdiv81` int(11) NOT NULL,
  `accdiv82` int(11) NOT NULL,
  `accdiv83` int(11) NOT NULL,
  `accdiv84` int(11) NOT NULL,
  `accdiv85` int(11) NOT NULL,
  `accdiv86` int(11) NOT NULL,
  `accdiv87` int(11) NOT NULL,
  `accdiv88` int(11) NOT NULL,
  `accdiv89` int(11) NOT NULL,
  `accdiv90` int(11) NOT NULL,
  `accdiv91` int(11) NOT NULL,
  `accdiv92` int(11) NOT NULL,
  `accdiv93` int(11) NOT NULL,
  `accdiv94` int(11) NOT NULL,
  `accdiv95` int(11) NOT NULL,
  `accdiv96` int(11) NOT NULL,
  `accdiv97` int(11) NOT NULL,
  `accdiv98` int(11) NOT NULL,
  `accdiv99` int(11) NOT NULL,
  `g_slot_0` mediumblob DEFAULT NULL,
  `g_slot_1` mediumblob DEFAULT NULL,
  `g_slot_2` mediumblob DEFAULT NULL,
  `g_slot_3` mediumblob DEFAULT NULL,
  `g_slot_4` mediumblob DEFAULT NULL,
  `g_slot_5` mediumblob DEFAULT NULL,
  `g_slot_6` mediumblob DEFAULT NULL,
  `g_slot_7` mediumblob DEFAULT NULL,
  `g_slot_8` mediumblob DEFAULT NULL,
  `g_slot_9` mediumblob DEFAULT NULL,
  `g_slot_10` mediumblob DEFAULT NULL,
  `g_slot_11` mediumblob DEFAULT NULL,
  `g_slot_12` mediumblob DEFAULT NULL,
  `g_slot_13` mediumblob DEFAULT NULL,
  `g_slot_14` mediumblob DEFAULT NULL,
  `g_slot_15` mediumblob DEFAULT NULL,
  `g_slot_16` mediumblob DEFAULT NULL,
  `g_slot_17` mediumblob DEFAULT NULL,
  `g_slot_18` mediumblob DEFAULT NULL,
  `g_slot_19` mediumblob DEFAULT NULL,
  `s_slot_0` mediumblob DEFAULT NULL,
  `s_slot_1` mediumblob DEFAULT NULL,
  `s_slot_2` mediumblob DEFAULT NULL,
  `s_slot_3` mediumblob DEFAULT NULL,
  `s_slot_4` mediumblob DEFAULT NULL,
  `s_slot_5` mediumblob DEFAULT NULL,
  `s_slot_6` mediumblob DEFAULT NULL,
  `s_slot_7` mediumblob DEFAULT NULL,
  `s_slot_8` mediumblob DEFAULT NULL,
  `s_slot_9` mediumblob DEFAULT NULL,
  `s_slot_10` mediumblob DEFAULT NULL,
  `s_slot_11` mediumblob DEFAULT NULL,
  `s_slot_12` mediumblob DEFAULT NULL,
  `s_slot_13` mediumblob DEFAULT NULL,
  `s_slot_14` mediumblob DEFAULT NULL,
  `s_slot_15` mediumblob DEFAULT NULL,
  `s_slot_16` mediumblob DEFAULT NULL,
  `s_slot_17` mediumblob DEFAULT NULL,
  `s_slot_18` mediumblob DEFAULT NULL,
  `s_slot_19` mediumblob DEFAULT NULL,
  `s_slot_20` mediumblob DEFAULT NULL,
  `s_slot_21` mediumblob DEFAULT NULL,
  `s_slot_22` mediumblob DEFAULT NULL,
  `s_slot_23` mediumblob DEFAULT NULL,
  `s_slot_24` mediumblob DEFAULT NULL,
  `s_slot_25` mediumblob DEFAULT NULL,
  `s_slot_26` mediumblob DEFAULT NULL,
  `s_slot_27` mediumblob DEFAULT NULL,
  `s_slot_28` mediumblob DEFAULT NULL,
  `s_slot_29` mediumblob DEFAULT NULL,
  `s_slot_30` mediumblob DEFAULT NULL,
  `s_slot_31` mediumblob DEFAULT NULL,
  `s_slot_32` mediumblob DEFAULT NULL,
  `s_slot_33` mediumblob DEFAULT NULL,
  `s_slot_34` mediumblob DEFAULT NULL,
  `s_slot_35` mediumblob DEFAULT NULL,
  `s_slot_36` mediumblob DEFAULT NULL,
  `s_slot_37` mediumblob DEFAULT NULL,
  `s_slot_38` mediumblob DEFAULT NULL,
  `s_slot_39` mediumblob DEFAULT NULL,
  `s_slot_40` mediumblob DEFAULT NULL,
  `s_slot_41` mediumblob DEFAULT NULL,
  `s_slot_42` mediumblob DEFAULT NULL,
  `s_slot_43` mediumblob DEFAULT NULL,
  `s_slot_44` mediumblob DEFAULT NULL,
  `s_slot_45` mediumblob DEFAULT NULL,
  `s_slot_46` mediumblob DEFAULT NULL,
  `s_slot_47` mediumblob DEFAULT NULL,
  `s_slot_48` mediumblob DEFAULT NULL,
  `s_slot_49` mediumblob DEFAULT NULL,
  `gUnit0` int(11) NOT NULL,
  `gUnit1` int(11) NOT NULL,
  `gUnit2` int(11) NOT NULL,
  `gUnit3` int(11) NOT NULL,
  `gUnit4` int(11) NOT NULL,
  `gUnit5` int(11) NOT NULL,
  `gUnit6` int(11) NOT NULL,
  `gUnit7` int(11) NOT NULL,
  `gUnit8` int(11) NOT NULL,
  `gUnit9` int(11) NOT NULL,
  `gUnit10` int(11) NOT NULL,
  `gUnit11` int(11) NOT NULL,
  `gUnit12` int(11) NOT NULL,
  `gUnit13` int(11) NOT NULL,
  `gUnit14` int(11) NOT NULL,
  `gUnit15` int(11) NOT NULL,
  `gUnit16` int(11) NOT NULL,
  `gUnit17` int(11) NOT NULL,
  `gUnit18` int(11) NOT NULL,
  `gUnit19` int(11) NOT NULL,
  `gUnit20` int(11) NOT NULL,
  `gUnit21` int(11) NOT NULL,
  `gUnit22` int(11) NOT NULL,
  `gUnit23` int(11) NOT NULL,
  `gUnit24` int(11) NOT NULL,
  `gUnit25` int(11) NOT NULL,
  `gUnit26` int(11) NOT NULL,
  `gUnit27` int(11) NOT NULL,
  `gUnit28` int(11) NOT NULL,
  `gUnit29` int(11) NOT NULL,
  `gUnit30` int(11) NOT NULL,
  `gUnit31` int(11) NOT NULL,
  `gUnit32` int(11) NOT NULL,
  `gUnit33` int(11) NOT NULL,
  `gUnit34` int(11) NOT NULL,
  `gUnit35` int(11) NOT NULL,
  `gUnit36` int(11) NOT NULL,
  `gUnit37` int(11) NOT NULL,
  `gUnit38` int(11) NOT NULL,
  `gUnit39` int(11) NOT NULL,
  `gUnit40` int(11) NOT NULL,
  `gUnit41` int(11) NOT NULL,
  `gUnit42` int(11) NOT NULL,
  `gUnit43` int(11) NOT NULL,
  `gUnit44` int(11) NOT NULL,
  `gUnit45` int(11) NOT NULL,
  `gUnit46` int(11) NOT NULL,
  `gUnit47` int(11) NOT NULL,
  `gUnit48` int(11) NOT NULL,
  `gUnit49` int(11) NOT NULL,
  `gAvailableWeapons` varchar(256) NOT NULL,
  `gMedMoney` int(11) NOT NULL DEFAULT 0,
  `gWarehouse` tinyint(1) NOT NULL DEFAULT 0,
  `offshore` int(11) NOT NULL DEFAULT 0,
  `continental_0` int(11) NOT NULL DEFAULT 0,
  `continental_1` int(11) NOT NULL DEFAULT 0,
  `continental_2` int(11) NOT NULL DEFAULT 0,
  `continental_3` int(11) NOT NULL DEFAULT 0,
  `continental_4` int(11) NOT NULL DEFAULT 0,
  `continental_5` int(11) NOT NULL DEFAULT 0,
  `continental_6` int(11) NOT NULL DEFAULT 0,
  `continental_reward_0` int(11) NOT NULL DEFAULT 0,
  `continental_reward_1` int(11) NOT NULL DEFAULT 0,
  `continental_last_update` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_owner_objects`
--

CREATE TABLE `pp_owner_objects` (
  `newid` int(11) NOT NULL,
  `owner_type` int(11) NOT NULL COMMENT '0 дом, 1 биз',
  `owner_id` int(11) NOT NULL DEFAULT 0 COMMENT 'Номер дома или биза',
  `slot` int(11) NOT NULL DEFAULT 0 COMMENT 'Номер слота объекта',
  `data` mediumblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_pack_interiors`
--

CREATE TABLE `pp_pack_interiors` (
  `piNewid` int(11) NOT NULL,
  `slot` int(11) NOT NULL DEFAULT 0,
  `piName` varchar(44) NOT NULL,
  `piCreateUnix` int(11) NOT NULL DEFAULT 0,
  `piEditUnix` int(11) NOT NULL DEFAULT 0,
  `piPrice` int(11) NOT NULL DEFAULT 0,
  `piObjects` int(11) NOT NULL DEFAULT 0,
  `piTypeInterior` int(11) NOT NULL DEFAULT 0,
  `piUserid` int(11) NOT NULL DEFAULT 0,
  `piClass` int(11) NOT NULL DEFAULT 0,
  `data` mediumblob NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_parties`
--

CREATE TABLE `pp_parties` (
  `newid` int(1) NOT NULL,
  `partiesUnix` int(11) NOT NULL DEFAULT 0,
  `partiesFam0` int(3) NOT NULL DEFAULT 0,
  `partiesSlots0` int(3) NOT NULL DEFAULT 0,
  `partiesFam1` int(3) NOT NULL DEFAULT 0,
  `partiesSlots1` int(3) NOT NULL DEFAULT 0,
  `partiesFam2` int(3) NOT NULL DEFAULT 0,
  `partiesSlots2` int(3) NOT NULL DEFAULT 0,
  `partiesFam3` int(3) NOT NULL DEFAULT 0,
  `partiesSlots3` int(3) NOT NULL DEFAULT 0,
  `partiesFam4` int(3) NOT NULL DEFAULT 0,
  `partiesSlots4` int(3) NOT NULL DEFAULT 0,
  `partiesFam5` int(3) NOT NULL DEFAULT 0,
  `partiesSlots5` int(3) NOT NULL DEFAULT 0,
  `partiesFam6` int(3) NOT NULL DEFAULT 0,
  `partiesSlots6` int(3) NOT NULL DEFAULT 0,
  `partiesFam7` int(3) NOT NULL DEFAULT 0,
  `partiesSlots7` int(3) NOT NULL DEFAULT 0,
  `partiesFam8` int(3) NOT NULL DEFAULT 0,
  `partiesSlots8` int(3) NOT NULL DEFAULT 0,
  `partiesFam9` int(3) NOT NULL DEFAULT 0,
  `partiesSlots9` int(3) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_peo_information`
--

CREATE TABLE `pp_peo_information` (
  `newid` int(11) NOT NULL,
  `userId` int(11) NOT NULL DEFAULT 0,
  `peoName` varchar(34) DEFAULT NULL,
  `peoPriceInterior` int(11) NOT NULL DEFAULT 0,
  `peoPublicationStatus` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_peo_objects`
--

CREATE TABLE `pp_peo_objects` (
  `newid` int(11) NOT NULL,
  `userId` int(11) NOT NULL DEFAULT 0,
  `slotId` int(11) NOT NULL DEFAULT 0,
  `peoModel` int(11) NOT NULL DEFAULT 0,
  `peoX` float NOT NULL DEFAULT 0,
  `peoY` float NOT NULL DEFAULT 0,
  `peoZ` float NOT NULL DEFAULT 0,
  `peoRX` float NOT NULL DEFAULT 0,
  `peoRY` float NOT NULL DEFAULT 0,
  `peoRZ` float NOT NULL DEFAULT 0,
  `txt0` int(11) NOT NULL DEFAULT 0,
  `txt1` int(11) NOT NULL DEFAULT 0,
  `txt2` int(11) NOT NULL DEFAULT 0,
  `txt3` int(11) NOT NULL DEFAULT 0,
  `txt4` int(11) NOT NULL DEFAULT 0,
  `txt5` int(11) NOT NULL DEFAULT 0,
  `txt6` int(11) NOT NULL DEFAULT 0,
  `txt7` int(11) NOT NULL DEFAULT 0,
  `txt8` int(11) NOT NULL DEFAULT 0,
  `txt9` int(11) NOT NULL DEFAULT 0,
  `txt10` int(11) NOT NULL DEFAULT 0,
  `txt11` int(11) NOT NULL DEFAULT 0,
  `txt12` int(11) NOT NULL DEFAULT 0,
  `txt13` int(11) NOT NULL DEFAULT 0,
  `txt14` int(11) NOT NULL DEFAULT 0,
  `txt15` int(11) NOT NULL DEFAULT 0,
  `txt16` int(11) NOT NULL DEFAULT 0,
  `txt17` int(11) NOT NULL DEFAULT 0,
  `txt18` int(11) NOT NULL DEFAULT 0,
  `txt19` int(11) NOT NULL DEFAULT 0,
  `txt20` int(11) NOT NULL DEFAULT 0,
  `txt21` int(11) NOT NULL DEFAULT 0,
  `txt22` int(11) NOT NULL DEFAULT 0,
  `txt23` int(11) NOT NULL DEFAULT 0,
  `txt24` int(11) NOT NULL DEFAULT 0,
  `txt25` int(11) NOT NULL DEFAULT 0,
  `txt26` int(11) NOT NULL DEFAULT 0,
  `txt27` int(11) NOT NULL DEFAULT 0,
  `txt28` int(11) NOT NULL DEFAULT 0,
  `txt29` int(11) NOT NULL DEFAULT 0,
  `txt30` int(11) NOT NULL DEFAULT 0,
  `txt31` int(11) NOT NULL DEFAULT 0,
  `txt32` int(11) NOT NULL DEFAULT 0,
  `txt33` int(11) NOT NULL DEFAULT 0,
  `txt34` int(11) NOT NULL DEFAULT 0,
  `txt35` int(11) NOT NULL DEFAULT 0,
  `txt36` int(11) NOT NULL DEFAULT 0,
  `txt37` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_places_narco_spots`
--

CREATE TABLE `pp_places_narco_spots` (
  `id` int(11) NOT NULL DEFAULT 0,
  `spot_id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) DEFAULT 0,
  `rent_time` int(11) DEFAULT 0,
  `riped` int(11) DEFAULT 0,
  `earned` int(11) DEFAULT 0,
  `earned_times` int(11) DEFAULT 0,
  `water_time` int(11) DEFAULT 0,
  `waterings` int(11) DEFAULT 0,
  `player_exit_time` int(11) DEFAULT 0,
  `soil_placed` int(11) DEFAULT 0,
  `dummy_powder` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pp_pricegun`
--

CREATE TABLE `pp_pricegun` (
  `newid` int(11) NOT NULL,
  `g0` int(11) DEFAULT NULL,
  `g1` int(11) DEFAULT NULL,
  `g2` int(11) DEFAULT NULL,
  `g3` int(11) DEFAULT NULL,
  `g4` int(11) DEFAULT NULL,
  `g5` int(11) DEFAULT NULL,
  `g6` int(11) DEFAULT NULL,
  `g7` int(11) DEFAULT NULL,
  `g8` int(11) DEFAULT NULL,
  `g9` int(11) DEFAULT NULL,
  `g10` int(11) DEFAULT NULL,
  `g11` int(11) DEFAULT NULL,
  `g12` int(11) DEFAULT NULL,
  `g13` int(11) DEFAULT NULL,
  `g14` int(11) DEFAULT NULL,
  `g15` int(11) DEFAULT NULL,
  `g16` int(11) DEFAULT NULL,
  `g17` int(11) DEFAULT NULL,
  `g18` int(11) DEFAULT NULL,
  `g19` int(11) DEFAULT NULL,
  `g20` int(11) DEFAULT NULL,
  `g21` int(11) DEFAULT NULL,
  `g22` int(11) DEFAULT NULL,
  `g23` int(11) DEFAULT NULL,
  `g24` int(11) DEFAULT NULL,
  `g25` int(11) DEFAULT NULL,
  `g26` int(11) DEFAULT NULL,
  `g27` int(11) DEFAULT NULL,
  `g28` int(11) DEFAULT NULL,
  `g29` int(11) DEFAULT NULL,
  `g30` int(11) DEFAULT NULL,
  `g31` int(11) DEFAULT NULL,
  `g32` int(11) DEFAULT NULL,
  `g33` int(11) DEFAULT NULL,
  `g34` int(11) DEFAULT NULL,
  `g35` int(11) DEFAULT NULL,
  `g36` int(11) DEFAULT NULL,
  `g37` int(11) DEFAULT NULL,
  `g38` int(11) DEFAULT NULL,
  `g39` int(11) DEFAULT NULL,
  `g40` int(11) DEFAULT NULL,
  `g41` int(11) DEFAULT NULL,
  `g42` int(11) DEFAULT NULL,
  `g43` int(11) DEFAULT NULL,
  `g44` int(11) DEFAULT NULL,
  `g45` int(11) DEFAULT NULL,
  `g46` int(11) DEFAULT NULL,
  `g47` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_priceskin`
--

CREATE TABLE `pp_priceskin` (
  `skin` int(11) NOT NULL,
  `SkinGos` int(11) NOT NULL DEFAULT 0 COMMENT 'Гос стоимость',
  `SkinGold` int(11) NOT NULL DEFAULT 0 COMMENT 'Gold стоимость',
  `SkinBuy` int(11) NOT NULL DEFAULT 0 COMMENT 'Покупок за вирты',
  `SkinBuyGold` int(11) NOT NULL DEFAULT 0 COMMENT 'Покупок за голду',
  `SkinSale` int(11) NOT NULL DEFAULT 0 COMMENT 'Статус продажи',
  `SkinName` varchar(34) DEFAULT NULL COMMENT 'Название',
  `SkinTop` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Топовый или нет (для кейсов)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_pricething`
--

CREATE TABLE `pp_pricething` (
  `thingid` int(11) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_priceveh`
--

CREATE TABLE `pp_priceveh` (
  `model` int(11) NOT NULL DEFAULT 0,
  `VehGos` int(11) NOT NULL DEFAULT 0 COMMENT 'Гос стоимость',
  `VehGold` int(11) NOT NULL DEFAULT 0 COMMENT 'Gold стоимость',
  `VehBuy` int(11) NOT NULL DEFAULT 0 COMMENT 'Покупок за вирты',
  `VehBuyGold` int(11) NOT NULL DEFAULT 0 COMMENT 'Покупок за gold',
  `VehLimited` int(11) NOT NULL DEFAULT 0 COMMENT 'Лимитированный тс',
  `VehQuan` int(11) NOT NULL DEFAULT 0 COMMENT 'Количество тс на руках',
  `VehSale` int(11) NOT NULL DEFAULT 0 COMMENT 'Статус продажи',
  `VehLimitedCase` int(11) NOT NULL DEFAULT 0 COMMENT 'Количество лимитированного тс в кейсах у игроков',
  `VehCaseOff` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_promo`
--

CREATE TABLE `pp_promo` (
  `newid` int(11) NOT NULL,
  `loading` int(11) NOT NULL DEFAULT 0,
  `name` varchar(64) DEFAULT NULL,
  `activ` int(11) NOT NULL DEFAULT 0,
  `unixcreate` int(11) NOT NULL DEFAULT 0,
  `unixbegin` int(11) NOT NULL DEFAULT 0,
  `unixend` int(11) NOT NULL DEFAULT 0,
  `unixstart` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 0,
  `roinsert` int(11) NOT NULL DEFAULT 0,
  `par0` int(11) NOT NULL DEFAULT 0,
  `par1` int(11) NOT NULL DEFAULT 0,
  `par2` int(11) NOT NULL DEFAULT 0,
  `par3` int(11) NOT NULL DEFAULT 0,
  `par4` int(11) NOT NULL DEFAULT 0,
  `stat0` int(11) NOT NULL DEFAULT 0,
  `stat1` int(11) NOT NULL DEFAULT 0,
  `stat2` int(11) NOT NULL DEFAULT 0,
  `stat3` int(11) NOT NULL DEFAULT 0,
  `stat4` int(11) NOT NULL DEFAULT 0,
  `text` text DEFAULT NULL,
  `number` int(11) NOT NULL DEFAULT 0,
  `voice` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_quests`
--

CREATE TABLE `pp_quests` (
  `user_id` int(11) NOT NULL,
  `daiDay` int(11) DEFAULT NULL,
  `daiFull` int(11) DEFAULT NULL,
  `daiChange` int(1) NOT NULL,
  `daiID_0` int(11) DEFAULT NULL,
  `daiQuanNeed_0` int(11) DEFAULT NULL,
  `daiQuan_0` int(11) DEFAULT NULL,
  `daiStatus_0` tinyint(1) DEFAULT NULL,
  `daiID_1` int(11) DEFAULT NULL,
  `daiQuanNeed_1` int(11) DEFAULT NULL,
  `daiQuan_1` int(11) DEFAULT NULL,
  `daiStatus_1` tinyint(1) DEFAULT NULL,
  `daiID_2` int(11) DEFAULT NULL,
  `daiQuanNeed_2` int(11) DEFAULT NULL,
  `daiQuan_2` int(11) DEFAULT NULL,
  `daiStatus_2` tinyint(1) DEFAULT NULL,
  `daiID_3` int(11) DEFAULT NULL,
  `daiQuanNeed_3` int(11) DEFAULT NULL,
  `daiQuan_3` int(11) DEFAULT NULL,
  `daiStatus_3` tinyint(1) DEFAULT NULL,
  `daiID_4` int(11) DEFAULT NULL,
  `daiQuanNeed_4` int(11) DEFAULT NULL,
  `daiQuan_4` int(11) DEFAULT NULL,
  `daiStatus_4` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_quest_temp`
--

CREATE TABLE `pp_quest_temp` (
  `Ball` blob NOT NULL DEFAULT '',
  `BallStatus` int(11) NOT NULL DEFAULT 0,
  `HalloweenUnix` int(11) NOT NULL DEFAULT 0,
  `HalloweenQuestStatus` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `pDedMorozMessage` int(11) NOT NULL DEFAULT 0,
  `pNewYearQuestComplete` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pp_rally`
--

CREATE TABLE `pp_rally` (
  `rallyStatus` int(2) NOT NULL DEFAULT 0,
  `rallyInfo` varchar(40) DEFAULT NULL,
  `rallyPoint` int(11) NOT NULL DEFAULT 0,
  `rallyUnix` int(11) NOT NULL DEFAULT 0,
  `rallyType` int(11) NOT NULL DEFAULT 0,
  `rallyNewID` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_rentwh`
--

CREATE TABLE `pp_rentwh` (
  `Ids` int(11) NOT NULL,
  `Stat` int(11) NOT NULL DEFAULT 0,
  `r_slot_0` mediumblob DEFAULT NULL,
  `r_slot_1` mediumblob DEFAULT NULL,
  `r_slot_2` mediumblob DEFAULT NULL,
  `r_slot_3` mediumblob DEFAULT NULL,
  `r_slot_4` mediumblob DEFAULT NULL,
  `r_slot_5` mediumblob DEFAULT NULL,
  `r_slot_6` mediumblob DEFAULT NULL,
  `r_slot_7` mediumblob DEFAULT NULL,
  `r_slot_8` mediumblob DEFAULT NULL,
  `r_slot_9` mediumblob DEFAULT NULL,
  `r_slot_10` mediumblob DEFAULT NULL,
  `r_slot_11` mediumblob DEFAULT NULL,
  `r_slot_12` mediumblob DEFAULT NULL,
  `r_slot_13` mediumblob DEFAULT NULL,
  `r_slot_14` mediumblob DEFAULT NULL,
  `r_slot_15` mediumblob DEFAULT NULL,
  `r_slot_16` mediumblob DEFAULT NULL,
  `r_slot_17` mediumblob DEFAULT NULL,
  `r_slot_18` mediumblob DEFAULT NULL,
  `r_slot_19` mediumblob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_room`
--

CREATE TABLE `pp_room` (
  `bd` varchar(5) NOT NULL,
  `id` int(11) NOT NULL DEFAULT 0,
  `Vlad` varchar(24) DEFAULT NULL,
  `Level` int(11) NOT NULL DEFAULT 0,
  `Sost` int(11) NOT NULL DEFAULT 0,
  `Sost2` int(11) NOT NULL DEFAULT 0,
  `Data` int(11) NOT NULL DEFAULT 0,
  `Freeze` int(11) NOT NULL DEFAULT 0,
  `Arest` int(11) NOT NULL DEFAULT 0,
  `Schet1` int(11) NOT NULL DEFAULT 0,
  `Schet2` int(11) NOT NULL DEFAULT 0,
  `Schet3` int(11) NOT NULL DEFAULT 0,
  `Schet4` int(11) NOT NULL DEFAULT 0,
  `Schet5` int(11) NOT NULL DEFAULT 0,
  `Weapon1` int(11) NOT NULL DEFAULT 0,
  `Weapon2` int(11) NOT NULL DEFAULT 0,
  `Weapon3` int(11) NOT NULL DEFAULT 0,
  `Weapon4` int(11) NOT NULL DEFAULT 0,
  `Weapon5` int(11) NOT NULL DEFAULT 0,
  `Lock` int(11) NOT NULL DEFAULT 0,
  `Drugs1` int(11) NOT NULL DEFAULT 0,
  `Drugs2` int(11) NOT NULL DEFAULT 0,
  `Drugs3` int(11) NOT NULL DEFAULT 0,
  `Drugs4` int(11) NOT NULL DEFAULT 0,
  `Schet` int(11) NOT NULL DEFAULT 0,
  `slot0` int(11) NOT NULL DEFAULT 0,
  `slot1` int(11) NOT NULL DEFAULT 0,
  `slot2` int(11) NOT NULL DEFAULT 0,
  `slot3` int(11) NOT NULL DEFAULT 0,
  `slot4` int(11) NOT NULL DEFAULT 0,
  `slot5` int(11) NOT NULL DEFAULT 0,
  `slot6` int(11) NOT NULL DEFAULT 0,
  `slot7` int(11) NOT NULL DEFAULT 0,
  `slot8` int(11) NOT NULL DEFAULT 0,
  `slot9` int(11) NOT NULL DEFAULT 0,
  `slot10` int(11) NOT NULL DEFAULT 0,
  `slot11` int(11) NOT NULL DEFAULT 0,
  `slot12` int(11) NOT NULL DEFAULT 0,
  `slot13` int(11) NOT NULL DEFAULT 0,
  `slot14` int(11) NOT NULL DEFAULT 0,
  `slot15` int(11) NOT NULL DEFAULT 0,
  `slot16` int(11) NOT NULL DEFAULT 0,
  `slot17` int(11) NOT NULL DEFAULT 0,
  `slot18` int(11) NOT NULL DEFAULT 0,
  `slot19` int(11) NOT NULL DEFAULT 0,
  `KoordinatX` float NOT NULL DEFAULT 0,
  `KoordinatY` float NOT NULL DEFAULT 0,
  `Taxes` int(11) NOT NULL DEFAULT 0,
  `Taxday` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_rout`
--

CREATE TABLE `pp_rout` (
  `newid` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `type` int(11) NOT NULL DEFAULT 0,
  `brNameCreator` varchar(24) DEFAULT NULL,
  `brNameEditor` varchar(24) DEFAULT NULL,
  `brNameRout` varchar(40) DEFAULT NULL,
  `brIDEditor` int(11) NOT NULL DEFAULT 0,
  `brIDCreator` int(11) NOT NULL DEFAULT 0,
  `brUnixEditor` int(11) NOT NULL DEFAULT 0,
  `brUnix` int(11) NOT NULL DEFAULT 0,
  `brCordX0` float NOT NULL DEFAULT 0,
  `brCordY0` float NOT NULL DEFAULT 0,
  `brCordZ0` float NOT NULL DEFAULT 0,
  `brCordX1` float NOT NULL DEFAULT 0,
  `brCordY1` float NOT NULL DEFAULT 0,
  `brCordZ1` float NOT NULL DEFAULT 0,
  `brCordX2` float NOT NULL DEFAULT 0,
  `brCordY2` float NOT NULL DEFAULT 0,
  `brCordZ2` float NOT NULL DEFAULT 0,
  `brCordX3` float NOT NULL DEFAULT 0,
  `brCordY3` float NOT NULL DEFAULT 0,
  `brCordZ3` float NOT NULL DEFAULT 0,
  `brCordX4` float NOT NULL DEFAULT 0,
  `brCordY4` float NOT NULL DEFAULT 0,
  `brCordZ4` float NOT NULL DEFAULT 0,
  `brCordX5` float NOT NULL DEFAULT 0,
  `brCordY5` float NOT NULL DEFAULT 0,
  `brCordZ5` float NOT NULL DEFAULT 0,
  `brCordX6` float NOT NULL DEFAULT 0,
  `brCordY6` float NOT NULL DEFAULT 0,
  `brCordZ6` float NOT NULL DEFAULT 0,
  `brCordX7` float NOT NULL DEFAULT 0,
  `brCordY7` float NOT NULL DEFAULT 0,
  `brCordZ7` float NOT NULL DEFAULT 0,
  `brCordX8` float NOT NULL DEFAULT 0,
  `brCordY8` float NOT NULL DEFAULT 0,
  `brCordZ8` float NOT NULL DEFAULT 0,
  `brCordX9` float NOT NULL DEFAULT 0,
  `brCordY9` float NOT NULL DEFAULT 0,
  `brCordZ9` float NOT NULL DEFAULT 0,
  `brCordX10` float NOT NULL DEFAULT 0,
  `brCordY10` float NOT NULL DEFAULT 0,
  `brCordZ10` float NOT NULL DEFAULT 0,
  `brCordX11` float NOT NULL DEFAULT 0,
  `brCordY11` float NOT NULL DEFAULT 0,
  `brCordZ11` float NOT NULL DEFAULT 0,
  `brCordX12` float NOT NULL DEFAULT 0,
  `brCordY12` float NOT NULL DEFAULT 0,
  `brCordZ12` float NOT NULL DEFAULT 0,
  `brCordX13` float NOT NULL DEFAULT 0,
  `brCordY13` float NOT NULL DEFAULT 0,
  `brCordZ13` float NOT NULL DEFAULT 0,
  `brCordX14` float NOT NULL DEFAULT 0,
  `brCordY14` float NOT NULL DEFAULT 0,
  `brCordZ14` float NOT NULL DEFAULT 0,
  `brCordX15` float NOT NULL DEFAULT 0,
  `brCordY15` float NOT NULL DEFAULT 0,
  `brCordZ15` float NOT NULL DEFAULT 0,
  `brCordX16` float NOT NULL DEFAULT 0,
  `brCordY16` float NOT NULL DEFAULT 0,
  `brCordZ16` float NOT NULL DEFAULT 0,
  `brCordX17` float NOT NULL DEFAULT 0,
  `brCordY17` float NOT NULL DEFAULT 0,
  `brCordZ17` float NOT NULL DEFAULT 0,
  `brCordX18` float NOT NULL DEFAULT 0,
  `brCordY18` float NOT NULL DEFAULT 0,
  `brCordZ18` float NOT NULL DEFAULT 0,
  `brCordX19` float NOT NULL DEFAULT 0,
  `brCordY19` float NOT NULL DEFAULT 0,
  `brCordZ19` float NOT NULL DEFAULT 0,
  `brCordX20` float NOT NULL DEFAULT 0,
  `brCordY20` float NOT NULL DEFAULT 0,
  `brCordZ20` float NOT NULL DEFAULT 0,
  `brCordX21` float NOT NULL DEFAULT 0,
  `brCordY21` float NOT NULL DEFAULT 0,
  `brCordZ21` float NOT NULL DEFAULT 0,
  `brCordX22` float NOT NULL DEFAULT 0,
  `brCordY22` float NOT NULL DEFAULT 0,
  `brCordZ22` float NOT NULL DEFAULT 0,
  `brCordX23` float NOT NULL DEFAULT 0,
  `brCordY23` float NOT NULL DEFAULT 0,
  `brCordZ23` float NOT NULL DEFAULT 0,
  `brCordX24` float NOT NULL DEFAULT 0,
  `brCordY24` float NOT NULL DEFAULT 0,
  `brCordZ24` float NOT NULL DEFAULT 0,
  `brCordX25` float NOT NULL DEFAULT 0,
  `brCordY25` float NOT NULL DEFAULT 0,
  `brCordZ25` float NOT NULL DEFAULT 0,
  `brCordX26` float NOT NULL DEFAULT 0,
  `brCordY26` float NOT NULL DEFAULT 0,
  `brCordZ26` float NOT NULL DEFAULT 0,
  `brCordX27` float NOT NULL DEFAULT 0,
  `brCordY27` float NOT NULL DEFAULT 0,
  `brCordZ27` float NOT NULL DEFAULT 0,
  `brCordX28` float NOT NULL DEFAULT 0,
  `brCordY28` float NOT NULL DEFAULT 0,
  `brCordZ28` float NOT NULL DEFAULT 0,
  `brCordX29` float NOT NULL DEFAULT 0,
  `brCordY29` float NOT NULL DEFAULT 0,
  `brCordZ29` float NOT NULL DEFAULT 0,
  `brCordX30` float NOT NULL DEFAULT 0,
  `brCordY30` float NOT NULL DEFAULT 0,
  `brCordZ30` float NOT NULL DEFAULT 0,
  `brCordX31` float NOT NULL DEFAULT 0,
  `brCordY31` float NOT NULL DEFAULT 0,
  `brCordZ31` float NOT NULL DEFAULT 0,
  `brCordX32` float NOT NULL DEFAULT 0,
  `brCordY32` float NOT NULL DEFAULT 0,
  `brCordZ32` float NOT NULL DEFAULT 0,
  `brCordX33` float NOT NULL DEFAULT 0,
  `brCordY33` float NOT NULL DEFAULT 0,
  `brCordZ33` float NOT NULL DEFAULT 0,
  `brCordX34` float NOT NULL DEFAULT 0,
  `brCordY34` float NOT NULL DEFAULT 0,
  `brCordZ34` float NOT NULL DEFAULT 0,
  `brCordX35` float NOT NULL DEFAULT 0,
  `brCordY35` float NOT NULL DEFAULT 0,
  `brCordZ35` float NOT NULL DEFAULT 0,
  `brCordX36` float NOT NULL DEFAULT 0,
  `brCordY36` float NOT NULL DEFAULT 0,
  `brCordZ36` float NOT NULL DEFAULT 0,
  `brCordX37` float NOT NULL DEFAULT 0,
  `brCordY37` float NOT NULL DEFAULT 0,
  `brCordZ37` float NOT NULL DEFAULT 0,
  `brCordX38` float NOT NULL DEFAULT 0,
  `brCordY38` float NOT NULL DEFAULT 0,
  `brCordZ38` float NOT NULL DEFAULT 0,
  `brCordX39` float NOT NULL DEFAULT 0,
  `brCordY39` float NOT NULL DEFAULT 0,
  `brCordZ39` float NOT NULL DEFAULT 0,
  `brCordX40` float NOT NULL DEFAULT 0,
  `brCordY40` float NOT NULL DEFAULT 0,
  `brCordZ40` float NOT NULL DEFAULT 0,
  `brCordX41` float NOT NULL DEFAULT 0,
  `brCordY41` float NOT NULL DEFAULT 0,
  `brCordZ41` float NOT NULL DEFAULT 0,
  `brCordX42` float NOT NULL DEFAULT 0,
  `brCordY42` float NOT NULL DEFAULT 0,
  `brCordZ42` float NOT NULL DEFAULT 0,
  `brCordX43` float NOT NULL DEFAULT 0,
  `brCordY43` float NOT NULL DEFAULT 0,
  `brCordZ43` float NOT NULL DEFAULT 0,
  `brCordX44` float NOT NULL DEFAULT 0,
  `brCordY44` float NOT NULL DEFAULT 0,
  `brCordZ44` float NOT NULL DEFAULT 0,
  `brCordX45` float NOT NULL DEFAULT 0,
  `brCordY45` float NOT NULL DEFAULT 0,
  `brCordZ45` float NOT NULL DEFAULT 0,
  `brCordX46` float NOT NULL DEFAULT 0,
  `brCordY46` float NOT NULL DEFAULT 0,
  `brCordZ46` float NOT NULL DEFAULT 0,
  `brCordX47` float NOT NULL DEFAULT 0,
  `brCordY47` float NOT NULL DEFAULT 0,
  `brCordZ47` float NOT NULL DEFAULT 0,
  `brCordX48` float NOT NULL DEFAULT 0,
  `brCordY48` float NOT NULL DEFAULT 0,
  `brCordZ48` float NOT NULL DEFAULT 0,
  `brCordX49` float NOT NULL DEFAULT 0,
  `brCordY49` float NOT NULL DEFAULT 0,
  `brCordZ49` float NOT NULL DEFAULT 0,
  `brCordX50` float NOT NULL DEFAULT 0,
  `brCordY50` float NOT NULL DEFAULT 0,
  `brCordZ50` float NOT NULL DEFAULT 0,
  `brCordX51` float NOT NULL DEFAULT 0,
  `brCordY51` float NOT NULL DEFAULT 0,
  `brCordZ51` float NOT NULL DEFAULT 0,
  `brCordX52` float NOT NULL DEFAULT 0,
  `brCordY52` float NOT NULL DEFAULT 0,
  `brCordZ52` float NOT NULL DEFAULT 0,
  `brCordX53` float NOT NULL DEFAULT 0,
  `brCordY53` float NOT NULL DEFAULT 0,
  `brCordZ53` float NOT NULL DEFAULT 0,
  `brCordX54` float NOT NULL DEFAULT 0,
  `brCordY54` float NOT NULL DEFAULT 0,
  `brCordZ54` float NOT NULL DEFAULT 0,
  `brCordX55` float NOT NULL DEFAULT 0,
  `brCordY55` float NOT NULL DEFAULT 0,
  `brCordZ55` float NOT NULL DEFAULT 0,
  `brCordX56` float NOT NULL DEFAULT 0,
  `brCordY56` float NOT NULL DEFAULT 0,
  `brCordZ56` float NOT NULL DEFAULT 0,
  `brCordX57` float NOT NULL DEFAULT 0,
  `brCordY57` float NOT NULL DEFAULT 0,
  `brCordZ57` float NOT NULL DEFAULT 0,
  `brCordX58` float NOT NULL DEFAULT 0,
  `brCordY58` float NOT NULL DEFAULT 0,
  `brCordZ58` float NOT NULL DEFAULT 0,
  `brCordX59` float NOT NULL DEFAULT 0,
  `brCordY59` float NOT NULL DEFAULT 0,
  `brCordZ59` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `pp_server`
--

CREATE TABLE `pp_server` (
  `newid` int(11) NOT NULL,
  `serv0` int(11) NOT NULL DEFAULT 0,
  `serv1` int(11) NOT NULL DEFAULT 0,
  `serv2` int(11) NOT NULL DEFAULT 0,
  `serv3` int(11) NOT NULL DEFAULT 0,
  `serv4` int(11) NOT NULL DEFAULT 0,
  `serv5` int(11) NOT NULL DEFAULT 0,
  `serv6` int(11) NOT NULL DEFAULT 0,
  `serv7` int(11) NOT NULL DEFAULT 0,
  `serv8` int(11) NOT NULL DEFAULT 0,
  `serv9` int(11) NOT NULL DEFAULT 0,
  `serv10` int(11) NOT NULL DEFAULT 0,
  `serv11` int(11) NOT NULL DEFAULT 0,
  `serv12` int(11) NOT NULL DEFAULT 0,
  `serv13` int(11) NOT NULL DEFAULT 0,
  `serv14` int(11) NOT NULL DEFAULT 0,
  `serv15` int(11) NOT NULL DEFAULT 0,
  `serv16` int(11) NOT NULL DEFAULT 0,
  `serv17` int(11) NOT NULL DEFAULT 0,
  `serv18` int(11) NOT NULL DEFAULT 0,
  `serv19` int(11) NOT NULL DEFAULT 0,
  `serv20` int(11) NOT NULL DEFAULT 0,
  `serv21` int(11) NOT NULL DEFAULT 0,
  `serv22` int(11) NOT NULL DEFAULT 0,
  `serv23` int(11) NOT NULL DEFAULT 0,
  `serv24` int(11) NOT NULL DEFAULT 0,
  `serv25` int(11) NOT NULL DEFAULT 0,
  `serv26` int(11) NOT NULL DEFAULT 0,
  `serv27` int(11) NOT NULL DEFAULT 0,
  `serv28` int(11) NOT NULL DEFAULT 0,
  `serv29` int(11) NOT NULL DEFAULT 0,
  `serv30` int(11) NOT NULL DEFAULT 0,
  `serv31` int(11) NOT NULL DEFAULT 0,
  `serv32` int(11) NOT NULL DEFAULT 0,
  `serv33` int(11) NOT NULL DEFAULT 0,
  `serv34` int(11) NOT NULL DEFAULT 0,
  `serv35` int(11) NOT NULL DEFAULT 0,
  `serv36` int(11) NOT NULL DEFAULT 0,
  `serv37` int(11) NOT NULL DEFAULT 0,
  `serv38` int(11) NOT NULL DEFAULT 0,
  `serv39` int(11) NOT NULL DEFAULT 0,
  `serv40` int(11) NOT NULL DEFAULT 0,
  `serv41` int(11) NOT NULL DEFAULT 0,
  `serv42` int(11) NOT NULL DEFAULT 0,
  `serv43` int(11) NOT NULL DEFAULT 0,
  `serv44` int(11) NOT NULL DEFAULT 0,
  `serv46` int(11) NOT NULL DEFAULT 0,
  `serv47` int(11) NOT NULL DEFAULT 0,
  `serv48` int(11) NOT NULL DEFAULT 0,
  `serv49` int(11) NOT NULL DEFAULT 0,
  `po0` int(11) NOT NULL DEFAULT 0,
  `pi0` int(11) NOT NULL DEFAULT 0,
  `po1` int(11) NOT NULL DEFAULT 0,
  `pi1` int(11) NOT NULL DEFAULT 0,
  `serv45` int(11) NOT NULL DEFAULT 0,
  `serv50` int(11) NOT NULL DEFAULT 0,
  `serv51` int(11) NOT NULL DEFAULT 0,
  `serv52` int(11) NOT NULL DEFAULT 0,
  `serv53` int(11) NOT NULL DEFAULT 0,
  `serv54` int(11) NOT NULL DEFAULT 0,
  `serv55` int(11) NOT NULL DEFAULT 0,
  `serv56` int(11) NOT NULL DEFAULT 0,
  `serv57` int(11) NOT NULL DEFAULT 0,
  `serv58` int(11) NOT NULL DEFAULT 0,
  `serv59` int(11) NOT NULL DEFAULT 0,
  `serv60` int(11) NOT NULL DEFAULT 0,
  `serv61` int(11) NOT NULL DEFAULT 0,
  `serv62` int(11) NOT NULL DEFAULT 0,
  `serv63` int(11) NOT NULL DEFAULT 0,
  `serv64` int(11) NOT NULL DEFAULT 0,
  `serv65` int(11) NOT NULL DEFAULT 0,
  `serv66` int(11) NOT NULL DEFAULT 0,
  `serv67` int(11) NOT NULL DEFAULT 0,
  `serv68` int(11) NOT NULL DEFAULT 0,
  `serv69` int(11) NOT NULL DEFAULT 0,
  `serv70` int(11) NOT NULL DEFAULT 0,
  `serv71` int(11) NOT NULL DEFAULT 0,
  `serv72` int(11) NOT NULL DEFAULT 0,
  `serv73` int(11) NOT NULL DEFAULT 0,
  `serv74` int(11) NOT NULL DEFAULT 0,
  `serv75` int(11) NOT NULL DEFAULT 0,
  `serv76` int(11) NOT NULL DEFAULT 0,
  `serv77` int(11) NOT NULL DEFAULT 0,
  `serv78` int(11) NOT NULL DEFAULT 0,
  `serv79` int(11) NOT NULL DEFAULT 0,
  `serv80` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_tradecrypto`
--

CREATE TABLE `pp_tradecrypto` (
  `newid` int(11) NOT NULL,
  `active` int(11) NOT NULL DEFAULT 0,
  `vlad` int(24) NOT NULL DEFAULT 0,
  `playername` varchar(24) DEFAULT NULL,
  `count` int(11) NOT NULL DEFAULT 0,
  `cource` int(11) NOT NULL DEFAULT 0,
  `unix` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pp_user_continental`
--

CREATE TABLE `pp_user_continental` (
  `userid` int(11) NOT NULL DEFAULT 0,
  `coins_0` int(11) DEFAULT 0,
  `coins_1` int(11) DEFAULT 0,
  `coins_2` int(11) DEFAULT 0,
  `coins_3` int(11) DEFAULT 0,
  `coins_4` int(11) DEFAULT 0,
  `coins_5` int(11) DEFAULT 0,
  `coins_6` int(11) DEFAULT 0,
  `last_update` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pp_user_narco_spots`
--

CREATE TABLE `pp_user_narco_spots` (
  `user_id` int(11) NOT NULL DEFAULT 0,
  `rent_cooldown` int(11) DEFAULT 0,
  `current_action` int(11) DEFAULT 0,
  `spot_id` int(11) DEFAULT 0,
  `pot_id` int(11) DEFAULT 0,
  `hangout_cutscene` int(11) DEFAULT 0,
  `place_id` int(11) DEFAULT 0,
  `laboratory_cutscene` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pp_wanted`
--

CREATE TABLE `pp_wanted` (
  `newid` int(11) NOT NULL,
  `playerid` int(11) NOT NULL DEFAULT 0,
  `wanCrime0` int(11) NOT NULL DEFAULT 0,
  `wanPoliceId0` int(11) NOT NULL DEFAULT 0,
  `wanUnix0` int(11) NOT NULL DEFAULT 0,
  `WantedPolice0` varchar(24) DEFAULT NULL,
  `wanCrime1` int(11) NOT NULL DEFAULT 0,
  `wanPoliceId1` int(11) NOT NULL DEFAULT 0,
  `wanUnix1` int(11) NOT NULL DEFAULT 0,
  `WantedPolice1` varchar(24) DEFAULT NULL,
  `wanCrime2` int(11) NOT NULL DEFAULT 0,
  `wanPoliceId2` int(11) NOT NULL DEFAULT 0,
  `wanUnix2` int(11) NOT NULL DEFAULT 0,
  `WantedPolice2` varchar(24) DEFAULT NULL,
  `wanCrime3` int(11) NOT NULL DEFAULT 0,
  `wanPoliceId3` int(11) NOT NULL DEFAULT 0,
  `wanUnix3` int(11) NOT NULL DEFAULT 0,
  `WantedPolice3` varchar(24) DEFAULT NULL,
  `wanCrime4` int(11) NOT NULL DEFAULT 0,
  `wanPoliceId4` int(11) NOT NULL DEFAULT 0,
  `wanUnix4` int(11) NOT NULL DEFAULT 0,
  `WantedPolice4` varchar(24) DEFAULT NULL,
  `wanCrime5` int(11) NOT NULL DEFAULT 0,
  `wanPoliceId5` int(11) NOT NULL DEFAULT 0,
  `wanUnix5` int(11) NOT NULL DEFAULT 0,
  `WantedPolice5` varchar(24) DEFAULT NULL,
  `wanCrime6` int(11) NOT NULL DEFAULT 0,
  `wanPoliceId6` int(11) NOT NULL DEFAULT 0,
  `wanUnix6` int(11) NOT NULL DEFAULT 0,
  `WantedPolice6` varchar(24) DEFAULT NULL,
  `wanCrime7` int(11) NOT NULL DEFAULT 0,
  `wanPoliceId7` int(11) NOT NULL DEFAULT 0,
  `wanUnix7` int(11) NOT NULL DEFAULT 0,
  `WantedPolice7` varchar(24) DEFAULT NULL,
  `wanCrime8` int(11) NOT NULL DEFAULT 0,
  `wanPoliceId8` int(11) NOT NULL DEFAULT 0,
  `wanUnix8` int(11) NOT NULL DEFAULT 0,
  `WantedPolice8` varchar(24) DEFAULT NULL,
  `wanCrime9` int(11) NOT NULL DEFAULT 0,
  `wanPoliceId9` int(11) NOT NULL DEFAULT 0,
  `wanUnix9` int(11) NOT NULL DEFAULT 0,
  `WantedPolice9` varchar(24) DEFAULT NULL,
  `wanTicketCrime1` int(11) NOT NULL DEFAULT 0,
  `wanTicketPoliceId1` int(11) NOT NULL DEFAULT 0,
  `wanTicketUnix1` int(11) NOT NULL DEFAULT 0,
  `WantedTicketPolice1` varchar(24) DEFAULT NULL,
  `wanTicketPoliceId0` int(11) NOT NULL DEFAULT 0,
  `wanTicketUnix0` int(11) NOT NULL DEFAULT 0,
  `WantedTicketPolice0` varchar(24) DEFAULT NULL,
  `wanTicketPoliceId2` int(11) NOT NULL DEFAULT 0,
  `wanTicketUnix2` int(11) NOT NULL DEFAULT 0,
  `WantedTicketPolice2` varchar(24) DEFAULT NULL,
  `wanTicketPoliceId3` int(11) NOT NULL DEFAULT 0,
  `wanTicketUnix3` int(11) NOT NULL DEFAULT 0,
  `WantedTicketPolice3` varchar(24) DEFAULT NULL,
  `wanTicketPoliceId4` int(11) NOT NULL DEFAULT 0,
  `wanTicketUnix4` int(11) NOT NULL DEFAULT 0,
  `WantedTicketPolice4` varchar(24) DEFAULT NULL,
  `wanTicketPoliceId5` int(11) NOT NULL DEFAULT 0,
  `wanTicketUnix5` int(11) NOT NULL DEFAULT 0,
  `WantedTicketPolice5` varchar(24) DEFAULT NULL,
  `wanTicketPoliceId6` int(11) NOT NULL DEFAULT 0,
  `wanTicketUnix6` int(11) NOT NULL DEFAULT 0,
  `WantedTicketPolice6` varchar(24) DEFAULT NULL,
  `wanTicketPoliceId7` int(11) NOT NULL DEFAULT 0,
  `wanTicketUnix7` int(11) NOT NULL DEFAULT 0,
  `WantedTicketPolice7` varchar(24) DEFAULT NULL,
  `wanTicketPoliceId8` int(11) NOT NULL DEFAULT 0,
  `wanTicketUnix8` int(11) NOT NULL DEFAULT 0,
  `WantedTicketPolice8` varchar(24) DEFAULT NULL,
  `wanTicketPoliceId9` int(11) NOT NULL DEFAULT 0,
  `wanTicketUnix9` int(11) NOT NULL DEFAULT 0,
  `WantedTicketPolice9` varchar(24) DEFAULT NULL,
  `wanTicketCrime0` int(11) NOT NULL DEFAULT 0,
  `wanTicketCrime2` int(11) NOT NULL DEFAULT 0,
  `wanTicketCrime3` int(11) NOT NULL DEFAULT 0,
  `wanTicketCrime4` int(11) NOT NULL DEFAULT 0,
  `wanTicketCrime5` int(11) NOT NULL DEFAULT 0,
  `wanTicketCrime6` int(11) NOT NULL DEFAULT 0,
  `wanTicketCrime7` int(11) NOT NULL DEFAULT 0,
  `wanTicketCrime8` int(11) NOT NULL DEFAULT 0,
  `wanTicketCrime9` int(11) NOT NULL DEFAULT 0,
  `wanSubentry0` int(11) NOT NULL DEFAULT 0,
  `wanSubentry1` int(11) NOT NULL DEFAULT 0,
  `wanSubentry2` int(11) NOT NULL DEFAULT 0,
  `wanSubentry3` int(11) NOT NULL DEFAULT 0,
  `wanSubentry4` int(11) NOT NULL DEFAULT 0,
  `wanSubentry5` int(11) NOT NULL DEFAULT 0,
  `wanSubentry6` int(11) NOT NULL DEFAULT 0,
  `wanSubentry7` int(11) NOT NULL DEFAULT 0,
  `wanSubentry8` int(11) NOT NULL DEFAULT 0,
  `wanSubentry9` int(11) NOT NULL DEFAULT 0,
  `wanTicketSubentry0` int(11) NOT NULL DEFAULT 0,
  `wanTicketSubentry1` int(11) NOT NULL DEFAULT 0,
  `wanTicketSubentry2` int(11) NOT NULL DEFAULT 0,
  `wanTicketSubentry3` int(11) NOT NULL DEFAULT 0,
  `wanTicketSubentry4` int(11) NOT NULL DEFAULT 0,
  `wanTicketSubentry5` int(11) NOT NULL DEFAULT 0,
  `wanTicketSubentry6` int(11) NOT NULL DEFAULT 0,
  `wanTicketSubentry7` int(11) NOT NULL DEFAULT 0,
  `wanTicketSubentry8` int(11) NOT NULL DEFAULT 0,
  `wanTicketSubentry9` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_work`
--

CREATE TABLE `pp_work` (
  `today` int(11) NOT NULL DEFAULT 0,
  `admin` varchar(24) DEFAULT NULL,
  `online` int(11) NOT NULL DEFAULT 0,
  `afk` int(11) NOT NULL DEFAULT 0,
  `sleep` int(11) NOT NULL DEFAULT 0,
  `activity` int(11) NOT NULL DEFAULT 0,
  `givegungro` int(11) NOT NULL DEFAULT 0,
  `sp` int(11) NOT NULL DEFAULT 0,
  `otv` int(11) NOT NULL DEFAULT 0,
  `re` int(11) NOT NULL DEFAULT 0,
  `com` int(11) NOT NULL DEFAULT 0,
  `vzlom` int(11) NOT NULL DEFAULT 0,
  `jail` int(11) NOT NULL DEFAULT 0,
  `prison` int(11) NOT NULL DEFAULT 0,
  `unprison` int(11) NOT NULL DEFAULT 0,
  `givegun` int(11) NOT NULL DEFAULT 0,
  `mute` int(11) NOT NULL DEFAULT 0,
  `kick` int(11) NOT NULL DEFAULT 0,
  `ban` int(11) NOT NULL DEFAULT 0,
  `warn` int(11) NOT NULL DEFAULT 0,
  `gamewarn` int(11) NOT NULL DEFAULT 0,
  `gunwarn` int(11) NOT NULL DEFAULT 0,
  `map` int(11) NOT NULL DEFAULT 0,
  `date` varchar(14) DEFAULT NULL,
  `date2` varchar(14) DEFAULT NULL,
  `admin2` varchar(24) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_wrong`
--

CREATE TABLE `pp_wrong` (
  `id` int(11) NOT NULL,
  `admid` int(11) NOT NULL DEFAULT 0,
  `planame` varchar(24) DEFAULT NULL,
  `cod` int(11) NOT NULL DEFAULT 0,
  `amount` int(11) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 0,
  `day` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pp_zones`
--

CREATE TABLE `pp_zones` (
  `newid` int(11) NOT NULL,
  `id` int(11) NOT NULL DEFAULT 0,
  `FrakVlad` int(11) NOT NULL DEFAULT 0,
  `data` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `promo_log`
--

CREATE TABLE `promo_log` (
  `newid` int(11) NOT NULL,
  `promoid` int(11) NOT NULL DEFAULT 0,
  `promo` varchar(64) NOT NULL DEFAULT '0',
  `playerid` int(11) NOT NULL DEFAULT 0,
  `player` varchar(24) NOT NULL DEFAULT '0',
  `playerip` varchar(24) NOT NULL DEFAULT '0',
  `unix` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Table structure for table `radars`
--

CREATE TABLE `radars` (
  `id` int(11) NOT NULL,
  `fraction` int(11) NOT NULL COMMENT 'ID организации',
  `owner` int(11) NOT NULL COMMENT 'ID аккаунта создателя',
  `placed` int(1) NOT NULL COMMENT 'Установлен ли радар',
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rx` float NOT NULL,
  `ry` float NOT NULL,
  `rz` float NOT NULL,
  `radius` float NOT NULL COMMENT 'Радиус действия',
  `max_speed` int(11) NOT NULL COMMENT 'Максимально допустимая скорость',
  `fine` int(11) NOT NULL COMMENT 'Размер штрафа',
  `tickets_issued` int(11) NOT NULL COMMENT 'Количество выписанных штрафов',
  `fine_total` int(11) NOT NULL COMMENT 'Общая сумма штрафов',
  `fine_total_before_units` int(11) NOT NULL COMMENT 'Сумма штрафов до вывода юнитов'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `refrigerator`
--

CREATE TABLE `refrigerator` (
  `id` int(11) NOT NULL,
  `rf_slot0` blob DEFAULT NULL,
  `rf_slot1` blob DEFAULT NULL,
  `rf_slot2` blob DEFAULT NULL,
  `rf_slot3` blob DEFAULT NULL,
  `rf_slot4` blob DEFAULT NULL,
  `rf_slot5` blob DEFAULT NULL,
  `rf_slot6` blob DEFAULT NULL,
  `rf_slot7` blob DEFAULT NULL,
  `rf_slot8` blob DEFAULT NULL,
  `rf_slot9` blob DEFAULT NULL,
  `rf_slot10` blob DEFAULT NULL,
  `rf_slot11` blob DEFAULT NULL,
  `rf_slot12` blob DEFAULT NULL,
  `rf_slot13` blob DEFAULT NULL,
  `rf_slot14` blob DEFAULT NULL,
  `rf_slot15` blob DEFAULT NULL,
  `rf_slot16` blob DEFAULT NULL,
  `rf_slot17` blob DEFAULT NULL,
  `rf_slot18` blob DEFAULT NULL,
  `rf_slot19` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `server_status`
--

CREATE TABLE `server_status` (
  `newid` int(11) NOT NULL,
  `unix` int(11) NOT NULL DEFAULT 0,
  `online` int(11) NOT NULL DEFAULT 0,
  `registr` int(11) NOT NULL DEFAULT 0,
  `hosted` int(11) NOT NULL DEFAULT 0,
  `youtube` int(11) NOT NULL DEFAULT 0,
  `friend` int(11) NOT NULL DEFAULT 0,
  `vk` int(11) NOT NULL DEFAULT 0,
  `find` int(11) NOT NULL DEFAULT 0,
  `other` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `setname_logs`
--

CREATE TABLE `setname_logs` (
  `action` varchar(24) NOT NULL,
  `admin` varchar(24) NOT NULL,
  `adminIP` varchar(24) NOT NULL,
  `player` varchar(24) NOT NULL,
  `playerIP` varchar(24) NOT NULL,
  `amount` varchar(24) NOT NULL,
  `newname` varchar(24) NOT NULL,
  `date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `s_maps`
--

CREATE TABLE `s_maps` (
  `newid` int(11) NOT NULL,
  `namemap` varchar(64) NOT NULL,
  `objects` int(11) NOT NULL,
  `autoload` int(11) NOT NULL DEFAULT 0,
  `unix` int(11) NOT NULL,
  `world` int(11) NOT NULL,
  `interior` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `terminal_bank`
--

CREATE TABLE `terminal_bank` (
  `newid` int(11) NOT NULL,
  `RentPos_X0` float NOT NULL DEFAULT 0,
  `RentPos_Y0` float NOT NULL DEFAULT 0,
  `RentPos_Z0` float NOT NULL DEFAULT 0,
  `RentPos_RX0` float NOT NULL DEFAULT 0,
  `RentPos_RY0` float NOT NULL DEFAULT 0,
  `RentPos_RZ0` float NOT NULL DEFAULT 0,
  `RentPos_X1` float NOT NULL DEFAULT 0,
  `RentPos_Y1` float NOT NULL DEFAULT 0,
  `RentPos_Z1` float NOT NULL DEFAULT 0,
  `RentPos_RX1` float NOT NULL DEFAULT 0,
  `RentPos_RY1` float NOT NULL DEFAULT 0,
  `RentPos_RZ1` float NOT NULL DEFAULT 0,
  `RentPos_X2` float NOT NULL DEFAULT 0,
  `RentPos_Y2` float NOT NULL DEFAULT 0,
  `RentPos_Z2` float NOT NULL DEFAULT 0,
  `RentPos_RX2` float NOT NULL DEFAULT 0,
  `RentPos_RY2` float NOT NULL DEFAULT 0,
  `RentPos_RZ2` float NOT NULL DEFAULT 0,
  `RentPos_X3` float NOT NULL DEFAULT 0,
  `RentPos_Y3` float NOT NULL DEFAULT 0,
  `RentPos_Z3` float NOT NULL DEFAULT 0,
  `RentPos_RX3` float NOT NULL DEFAULT 0,
  `RentPos_RY3` float NOT NULL DEFAULT 0,
  `RentPos_RZ3` float NOT NULL DEFAULT 0,
  `RentPos_X4` float NOT NULL DEFAULT 0,
  `RentPos_Y4` float NOT NULL DEFAULT 0,
  `RentPos_Z4` float NOT NULL DEFAULT 0,
  `RentPos_RX4` float NOT NULL DEFAULT 0,
  `RentPos_RY4` float NOT NULL DEFAULT 0,
  `RentPos_RZ4` float NOT NULL DEFAULT 0,
  `RentStat0` int(11) NOT NULL DEFAULT 0,
  `RentStat1` int(11) NOT NULL DEFAULT 0,
  `RentStat2` int(11) NOT NULL DEFAULT 0,
  `RentStat3` int(11) NOT NULL DEFAULT 0,
  `RentStat4` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `terminal_com`
--

CREATE TABLE `terminal_com` (
  `newid` int(11) NOT NULL,
  `put` float NOT NULL DEFAULT 0,
  `take` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tomb`
--

CREATE TABLE `tomb` (
  `user_id` int(11) NOT NULL COMMENT 'ID аккаунта',
  `date` int(11) NOT NULL COMMENT 'Дата последней игры'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trailers`
--

CREATE TABLE `trailers` (
  `newid` int(11) NOT NULL,
  `id` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL DEFAULT 0,
  `model` int(11) NOT NULL DEFAULT 0,
  `pos_x` float NOT NULL DEFAULT 0,
  `pos_y` float NOT NULL DEFAULT 0,
  `pos_z` float NOT NULL DEFAULT 0,
  `pic_x` float NOT NULL DEFAULT 0,
  `pic_y` float NOT NULL DEFAULT 0,
  `pic_z` float NOT NULL DEFAULT 0,
  `rot_x` float NOT NULL DEFAULT 0,
  `rot_y` float NOT NULL DEFAULT 0,
  `rot_z` float NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `locked` tinyint(1) NOT NULL DEFAULT 0,
  `stol` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `weather`
--

CREATE TABLE `weather` (
  `newid` int(11) NOT NULL,
  `lastday` int(11) NOT NULL DEFAULT 0,
  `d0` int(11) NOT NULL DEFAULT 0,
  `d1` int(11) NOT NULL DEFAULT 0,
  `d2` int(11) NOT NULL DEFAULT 0,
  `d3` int(11) NOT NULL DEFAULT 0,
  `d4` int(11) NOT NULL DEFAULT 0,
  `d5` int(11) NOT NULL DEFAULT 0,
  `d6` int(11) NOT NULL DEFAULT 0,
  `d7` int(11) NOT NULL DEFAULT 0,
  `d8` int(11) NOT NULL DEFAULT 0,
  `d9` int(11) NOT NULL DEFAULT 0,
  `d10` int(11) NOT NULL DEFAULT 0,
  `d11` int(11) NOT NULL DEFAULT 0,
  `d12` int(11) NOT NULL DEFAULT 0,
  `d13` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `word`
--

CREATE TABLE `word` (
  `newid` int(11) NOT NULL,
  `text` varchar(24) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `aa_test`
--
ALTER TABLE `aa_test`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `accessory`
--
ALTER TABLE `accessory`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `achieve_server`
--
ALTER TABLE `achieve_server`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `apartments`
--
ALTER TABLE `apartments`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `apartmentsroom`
--
ALTER TABLE `apartmentsroom`
  ADD PRIMARY KEY (`aprID`);

--
-- Indexes for table `aquarium`
--
ALTER TABLE `aquarium`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `backpacks`
--
ALTER TABLE `backpacks`
  ADD PRIMARY KEY (`backpackid`) USING BTREE;

--
-- Indexes for table `battlepass`
--
ALTER TABLE `battlepass`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `blacklist`
--
ALTER TABLE `blacklist`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `court_decisions`
--
ALTER TABLE `court_decisions`
  ADD UNIQUE KEY `slot` (`slot`,`suspect`);

--
-- Indexes for table `criminal_code`
--
ALTER TABLE `criminal_code`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `crypto_log`
--
ALTER TABLE `crypto_log`
  ADD PRIMARY KEY (`tradecryptoNewid`);

--
-- Indexes for table `depart_weapons`
--
ALTER TABLE `depart_weapons`
  ADD UNIQUE KEY `newid` (`frakid`,`weapon`);

--
-- Indexes for table `division`
--
ALTER TABLE `division`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `editmodel`
--
ALTER TABLE `editmodel`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `fund_logs`
--
ALTER TABLE `fund_logs`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `fund_raisers`
--
ALTER TABLE `fund_raisers`
  ADD PRIMARY KEY (`fundNewid`);

--
-- Indexes for table `honorboard`
--
ALTER TABLE `honorboard`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `labor_log`
--
ALTER TABLE `labor_log`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `minewar`
--
ALTER TABLE `minewar`
  ADD UNIQUE KEY `id` (`user_id`);

--
-- Indexes for table `myname_log`
--
ALTER TABLE `myname_log`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `obstacles`
--
ALTER TABLE `obstacles`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `offense`
--
ALTER TABLE `offense`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `player_logs`
--
ALTER TABLE `player_logs`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_achieve`
--
ALTER TABLE `pp_achieve`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `pp_bizz`
--
ALTER TABLE `pp_bizz`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_bizzakses`
--
ALTER TABLE `pp_bizzakses`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_bizzobject`
--
ALTER TABLE `pp_bizzobject`
  ADD UNIQUE KEY `newid` (`bizid`,`slot`);

--
-- Indexes for table `pp_bizzstore`
--
ALTER TABLE `pp_bizzstore`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_busstation`
--
ALTER TABLE `pp_busstation`
  ADD PRIMARY KEY (`idbusstation`);

--
-- Indexes for table `pp_camera`
--
ALTER TABLE `pp_camera`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_cars`
--
ALTER TABLE `pp_cars`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_continental`
--
ALTER TABLE `pp_continental`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pp_crime`
--
ALTER TABLE `pp_crime`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_dom`
--
ALTER TABLE `pp_dom`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_economy`
--
ALTER TABLE `pp_economy`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_family`
--
ALTER TABLE `pp_family`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_graphiti`
--
ALTER TABLE `pp_graphiti`
  ADD PRIMARY KEY (`gnewid`);

--
-- Indexes for table `pp_igroki`
--
ALTER TABLE `pp_igroki`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `Name` (`Name`);

--
-- Indexes for table `pp_igroki_contacts`
--
ALTER TABLE `pp_igroki_contacts`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `pp_igroki_hint`
--
ALTER TABLE `pp_igroki_hint`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `pp_igroki_inventory`
--
ALTER TABLE `pp_igroki_inventory`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `pp_igroki_top`
--
ALTER TABLE `pp_igroki_top`
  ADD PRIMARY KEY (`user_id`) USING BTREE;

--
-- Indexes for table `pp_ikea`
--
ALTER TABLE `pp_ikea`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_map`
--
ALTER TABLE `pp_map`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_mapfrak`
--
ALTER TABLE `pp_mapfrak`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_menumusic`
--
ALTER TABLE `pp_menumusic`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_message`
--
ALTER TABLE `pp_message`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_name`
--
ALTER TABLE `pp_name`
  ADD PRIMARY KEY (`newid`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `pp_narco_farms`
--
ALTER TABLE `pp_narco_farms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pp_narco_spots`
--
ALTER TABLE `pp_narco_spots`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `pp_organization`
--
ALTER TABLE `pp_organization`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_owner_objects`
--
ALTER TABLE `pp_owner_objects`
  ADD PRIMARY KEY (`newid`),
  ADD UNIQUE KEY `owner_type` (`owner_type`,`owner_id`,`slot`);

--
-- Indexes for table `pp_pack_interiors`
--
ALTER TABLE `pp_pack_interiors`
  ADD PRIMARY KEY (`piNewid`),
  ADD UNIQUE KEY `slot` (`slot`,`piUserid`);

--
-- Indexes for table `pp_parties`
--
ALTER TABLE `pp_parties`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_peo_information`
--
ALTER TABLE `pp_peo_information`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_peo_objects`
--
ALTER TABLE `pp_peo_objects`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_places_narco_spots`
--
ALTER TABLE `pp_places_narco_spots`
  ADD UNIQUE KEY `id` (`id`,`spot_id`);

--
-- Indexes for table `pp_pricegun`
--
ALTER TABLE `pp_pricegun`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_priceskin`
--
ALTER TABLE `pp_priceskin`
  ADD PRIMARY KEY (`skin`),
  ADD UNIQUE KEY `skin` (`skin`);

--
-- Indexes for table `pp_pricething`
--
ALTER TABLE `pp_pricething`
  ADD PRIMARY KEY (`thingid`);

--
-- Indexes for table `pp_priceveh`
--
ALTER TABLE `pp_priceveh`
  ADD PRIMARY KEY (`model`),
  ADD UNIQUE KEY `model` (`model`);

--
-- Indexes for table `pp_promo`
--
ALTER TABLE `pp_promo`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_quests`
--
ALTER TABLE `pp_quests`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `pp_rally`
--
ALTER TABLE `pp_rally`
  ADD PRIMARY KEY (`rallyNewID`);

--
-- Indexes for table `pp_rentwh`
--
ALTER TABLE `pp_rentwh`
  ADD PRIMARY KEY (`Ids`);

--
-- Indexes for table `pp_rout`
--
ALTER TABLE `pp_rout`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_server`
--
ALTER TABLE `pp_server`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_tradecrypto`
--
ALTER TABLE `pp_tradecrypto`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_user_continental`
--
ALTER TABLE `pp_user_continental`
  ADD PRIMARY KEY (`userid`);

--
-- Indexes for table `pp_user_narco_spots`
--
ALTER TABLE `pp_user_narco_spots`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `pp_wanted`
--
ALTER TABLE `pp_wanted`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `pp_wrong`
--
ALTER TABLE `pp_wrong`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pp_zones`
--
ALTER TABLE `pp_zones`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `promo_log`
--
ALTER TABLE `promo_log`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `radars`
--
ALTER TABLE `radars`
  ADD UNIQUE KEY `newid` (`id`);

--
-- Indexes for table `refrigerator`
--
ALTER TABLE `refrigerator`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `server_status`
--
ALTER TABLE `server_status`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `s_maps`
--
ALTER TABLE `s_maps`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `terminal_bank`
--
ALTER TABLE `terminal_bank`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `terminal_com`
--
ALTER TABLE `terminal_com`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `tomb`
--
ALTER TABLE `tomb`
  ADD UNIQUE KEY `id` (`user_id`);

--
-- Indexes for table `trailers`
--
ALTER TABLE `trailers`
  ADD PRIMARY KEY (`newid`),
  ADD UNIQUE KEY `id` (`id`,`owner`);

--
-- Indexes for table `weather`
--
ALTER TABLE `weather`
  ADD PRIMARY KEY (`newid`);

--
-- Indexes for table `word`
--
ALTER TABLE `word`
  ADD PRIMARY KEY (`newid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `aa_test`
--
ALTER TABLE `aa_test`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `accessory`
--
ALTER TABLE `accessory`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=336;
--
-- AUTO_INCREMENT for table `achieve_server`
--
ALTER TABLE `achieve_server`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `apartments`
--
ALTER TABLE `apartments`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `apartmentsroom`
--
ALTER TABLE `apartmentsroom`
  MODIFY `aprID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1601;
--
-- AUTO_INCREMENT for table `aquarium`
--
ALTER TABLE `aquarium`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `backpacks`
--
ALTER TABLE `backpacks`
  MODIFY `backpackid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `battlepass`
--
ALTER TABLE `battlepass`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=269;
--
-- AUTO_INCREMENT for table `blacklist`
--
ALTER TABLE `blacklist`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `criminal_code`
--
ALTER TABLE `criminal_code`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=116;
--
-- AUTO_INCREMENT for table `crypto_log`
--
ALTER TABLE `crypto_log`
  MODIFY `tradecryptoNewid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `division`
--
ALTER TABLE `division`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=230;
--
-- AUTO_INCREMENT for table `editmodel`
--
ALTER TABLE `editmodel`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;
--
-- AUTO_INCREMENT for table `fund_logs`
--
ALTER TABLE `fund_logs`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `fund_raisers`
--
ALTER TABLE `fund_raisers`
  MODIFY `fundNewid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;
--
-- AUTO_INCREMENT for table `honorboard`
--
ALTER TABLE `honorboard`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `labor_log`
--
ALTER TABLE `labor_log`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `myname_log`
--
ALTER TABLE `myname_log`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `player_logs`
--
ALTER TABLE `player_logs`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `pp_bizz`
--
ALTER TABLE `pp_bizz`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=222;
--
-- AUTO_INCREMENT for table `pp_bizzakses`
--
ALTER TABLE `pp_bizzakses`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `pp_bizzstore`
--
ALTER TABLE `pp_bizzstore`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `pp_busstation`
--
ALTER TABLE `pp_busstation`
  MODIFY `idbusstation` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=208;
--
-- AUTO_INCREMENT for table `pp_camera`
--
ALTER TABLE `pp_camera`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=538;
--
-- AUTO_INCREMENT for table `pp_cars`
--
ALTER TABLE `pp_cars`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=326;
--
-- AUTO_INCREMENT for table `pp_crime`
--
ALTER TABLE `pp_crime`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;
--
-- AUTO_INCREMENT for table `pp_dom`
--
ALTER TABLE `pp_dom`
  MODIFY `newid` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1001;
--
-- AUTO_INCREMENT for table `pp_economy`
--
ALTER TABLE `pp_economy`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `pp_family`
--
ALTER TABLE `pp_family`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `pp_igroki`
--
ALTER TABLE `pp_igroki`
  MODIFY `user_id` int(24) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=269;
--
-- AUTO_INCREMENT for table `pp_igroki_contacts`
--
ALTER TABLE `pp_igroki_contacts`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=269;
--
-- AUTO_INCREMENT for table `pp_igroki_top`
--
ALTER TABLE `pp_igroki_top`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=269;
--
-- AUTO_INCREMENT for table `pp_map`
--
ALTER TABLE `pp_map`
  MODIFY `newid` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77776;
--
-- AUTO_INCREMENT for table `pp_mapfrak`
--
ALTER TABLE `pp_mapfrak`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2056;
--
-- AUTO_INCREMENT for table `pp_menumusic`
--
ALTER TABLE `pp_menumusic`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;
--
-- AUTO_INCREMENT for table `pp_message`
--
ALTER TABLE `pp_message`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=302;
--
-- AUTO_INCREMENT for table `pp_name`
--
ALTER TABLE `pp_name`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `pp_organization`
--
ALTER TABLE `pp_organization`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;
--
-- AUTO_INCREMENT for table `pp_owner_objects`
--
ALTER TABLE `pp_owner_objects`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32168;
--
-- AUTO_INCREMENT for table `pp_pack_interiors`
--
ALTER TABLE `pp_pack_interiors`
  MODIFY `piNewid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `pp_peo_information`
--
ALTER TABLE `pp_peo_information`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `pp_peo_objects`
--
ALTER TABLE `pp_peo_objects`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `pp_pricegun`
--
ALTER TABLE `pp_pricegun`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `pp_promo`
--
ALTER TABLE `pp_promo`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;
--
-- AUTO_INCREMENT for table `pp_rentwh`
--
ALTER TABLE `pp_rentwh`
  MODIFY `Ids` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `pp_rout`
--
ALTER TABLE `pp_rout`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;
--
-- AUTO_INCREMENT for table `pp_server`
--
ALTER TABLE `pp_server`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `pp_tradecrypto`
--
ALTER TABLE `pp_tradecrypto`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2473;
--
-- AUTO_INCREMENT for table `pp_wanted`
--
ALTER TABLE `pp_wanted`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=230;
--
-- AUTO_INCREMENT for table `pp_wrong`
--
ALTER TABLE `pp_wrong`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=210;
--
-- AUTO_INCREMENT for table `pp_zones`
--
ALTER TABLE `pp_zones`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=134;
--
-- AUTO_INCREMENT for table `promo_log`
--
ALTER TABLE `promo_log`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=251;
--
-- AUTO_INCREMENT for table `refrigerator`
--
ALTER TABLE `refrigerator`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3601;
--
-- AUTO_INCREMENT for table `server_status`
--
ALTER TABLE `server_status`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1052;
--
-- AUTO_INCREMENT for table `s_maps`
--
ALTER TABLE `s_maps`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;
--
-- AUTO_INCREMENT for table `terminal_bank`
--
ALTER TABLE `terminal_bank`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;
--
-- AUTO_INCREMENT for table `terminal_com`
--
ALTER TABLE `terminal_com`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `trailers`
--
ALTER TABLE `trailers`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `weather`
--
ALTER TABLE `weather`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `word`
--
ALTER TABLE `word`
  MODIFY `newid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
