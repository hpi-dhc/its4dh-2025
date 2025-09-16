-- -------------------------------------------------------------
-- TablePlus 6.0.8(562)
--
-- https://tableplus.com/
--
-- Database: its4dh
-- Generation Time: 2024-07-08 14:27:28.0420
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE TABLE `Patient` (
  `SSN` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Address` varchar(30) NOT NULL,
  `Phone` varchar(30) NOT NULL,
  `InsuranceID` int(11) NOT NULL,
  `PCP` int(11) NOT NULL,
  PRIMARY KEY (`SSN`),
  KEY `fk_Patient_Physician_EmployeeID` (`PCP`),
  CONSTRAINT `fk_Patient_Physician_EmployeeID` FOREIGN KEY (`PCP`) REFERENCES `Physician` (`EmployeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `Patient` (`SSN`, `Name`, `Address`, `Phone`, `InsuranceID`, `PCP`) VALUES
(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1),
(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2),
(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2),
(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3);


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;