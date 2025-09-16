-- -------------------------------------------------------------
-- TablePlus 6.1.8(574)
--
-- https://tableplus.com/
--
-- Database: its4dh
-- Generation Time: 2024-11-07 09:45:52.0460
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE TABLE `Affiliated_With` (
  `Physician` int(11) NOT NULL,
  `Department` int(11) NOT NULL,
  `PrimaryAffiliation` bit(1) NOT NULL,
  PRIMARY KEY (`Physician`,`Department`),
  KEY `fk_Affiliated_With_Department_DepartmentID` (`Department`),
  CONSTRAINT `fk_Affiliated_With_Department_DepartmentID` FOREIGN KEY (`Department`) REFERENCES `Department` (`DepartmentID`),
  CONSTRAINT `fk_Affiliated_With_Physician_EmployeeID` FOREIGN KEY (`Physician`) REFERENCES `Physician` (`EmployeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Appointment` (
  `AppointmentID` int(11) NOT NULL,
  `Patient` int(11) NOT NULL,
  `PrepNurse` int(11) DEFAULT NULL,
  `Physician` int(11) NOT NULL,
  `Starto` datetime NOT NULL,
  `Endo` datetime NOT NULL,
  `ExaminationRoom` text NOT NULL,
  PRIMARY KEY (`AppointmentID`),
  KEY `fk_Appointment_Patient_SSN` (`Patient`),
  KEY `fk_Appointment_Nurse_EmployeeID` (`PrepNurse`),
  KEY `fk_Appointment_Physician_EmployeeID` (`Physician`),
  CONSTRAINT `fk_Appointment_Nurse_EmployeeID` FOREIGN KEY (`PrepNurse`) REFERENCES `Nurse` (`EmployeeID`),
  CONSTRAINT `fk_Appointment_Patient_SSN` FOREIGN KEY (`Patient`) REFERENCES `Patient` (`SSN`),
  CONSTRAINT `fk_Appointment_Physician_EmployeeID` FOREIGN KEY (`Physician`) REFERENCES `Physician` (`EmployeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Block` (
  `BlockFloor` int(11) NOT NULL,
  `BlockCode` int(11) NOT NULL,
  PRIMARY KEY (`BlockFloor`,`BlockCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Department` (
  `DepartmentID` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Head` int(11) NOT NULL,
  PRIMARY KEY (`DepartmentID`),
  KEY `fk_Department_Physician_EmployeeID` (`Head`),
  CONSTRAINT `fk_Department_Physician_EmployeeID` FOREIGN KEY (`Head`) REFERENCES `Physician` (`EmployeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Medication` (
  `Code` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Brand` varchar(30) NOT NULL,
  `Description` varchar(30) NOT NULL,
  PRIMARY KEY (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Nurse` (
  `EmployeeID` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Position` varchar(30) NOT NULL,
  `Registered` bit(1) NOT NULL,
  `SSN` int(11) NOT NULL,
  PRIMARY KEY (`EmployeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `On_Call` (
  `Nurse` int(11) NOT NULL,
  `BlockFloor` int(11) NOT NULL,
  `BlockCode` int(11) NOT NULL,
  `OnCallStart` datetime NOT NULL,
  `OnCallEnd` datetime NOT NULL,
  PRIMARY KEY (`Nurse`,`BlockFloor`,`BlockCode`,`OnCallStart`,`OnCallEnd`),
  KEY `fk_OnCall_Block_Floor` (`BlockFloor`,`BlockCode`),
  CONSTRAINT `fk_OnCall_Block_Floor` FOREIGN KEY (`BlockFloor`, `BlockCode`) REFERENCES `Block` (`BlockFloor`, `BlockCode`),
  CONSTRAINT `fk_OnCall_Nurse_EmployeeID` FOREIGN KEY (`Nurse`) REFERENCES `Nurse` (`EmployeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Patient` (
  `SSN` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Address` varchar(30) NOT NULL,
  `Phone` varchar(30) NOT NULL,
  `InsuranceID` int(11) NOT NULL,
  `PCP` int(11) NOT NULL,
  PRIMARY KEY (`SSN`),
  KEY `fk_Patient_Physician_EmployeeID` (`PCP`),
  FULLTEXT KEY `fulltext` (`Name`,`Address`),
  CONSTRAINT `fk_Patient_Physician_EmployeeID` FOREIGN KEY (`PCP`) REFERENCES `Physician` (`EmployeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Physician` (
  `EmployeeID` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Position` varchar(30) NOT NULL,
  `SSN` int(11) NOT NULL,
  PRIMARY KEY (`EmployeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Prescribes` (
  `Physician` int(11) NOT NULL,
  `Patient` int(11) NOT NULL,
  `Medication` int(11) NOT NULL,
  `Date` datetime NOT NULL,
  `Appointment` int(11) DEFAULT NULL,
  `Dose` varchar(30) NOT NULL,
  PRIMARY KEY (`Physician`,`Patient`,`Medication`,`Date`),
  KEY `fk_Prescribes_Patient_SSN` (`Patient`),
  KEY `fk_Prescribes_Medication_Code` (`Medication`),
  KEY `fk_Prescribes_Appointment_AppointmentID` (`Appointment`),
  CONSTRAINT `fk_Prescribes_Appointment_AppointmentID` FOREIGN KEY (`Appointment`) REFERENCES `Appointment` (`AppointmentID`),
  CONSTRAINT `fk_Prescribes_Medication_Code` FOREIGN KEY (`Medication`) REFERENCES `Medication` (`Code`),
  CONSTRAINT `fk_Prescribes_Patient_SSN` FOREIGN KEY (`Patient`) REFERENCES `Patient` (`SSN`),
  CONSTRAINT `fk_Prescribes_Physician_EmployeeID` FOREIGN KEY (`Physician`) REFERENCES `Physician` (`EmployeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Procedures` (
  `Code` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Cost` double NOT NULL,
  PRIMARY KEY (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Room` (
  `RoomNumber` int(11) NOT NULL,
  `RoomType` varchar(30) NOT NULL,
  `BlockFloor` int(11) NOT NULL,
  `BlockCode` int(11) NOT NULL,
  `Unavailable` bit(1) NOT NULL,
  PRIMARY KEY (`RoomNumber`),
  KEY `fk_Room_Block_PK` (`BlockFloor`,`BlockCode`),
  CONSTRAINT `fk_Room_Block_PK` FOREIGN KEY (`BlockFloor`, `BlockCode`) REFERENCES `Block` (`BlockFloor`, `BlockCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Stay` (
  `StayID` int(11) NOT NULL,
  `Patient` int(11) NOT NULL,
  `Room` int(11) NOT NULL,
  `StayStart` datetime NOT NULL,
  `StayEnd` datetime NOT NULL,
  PRIMARY KEY (`StayID`),
  KEY `fk_Stay_Patient_SSN` (`Patient`),
  KEY `fk_Stay_Room_Number` (`Room`),
  CONSTRAINT `fk_Stay_Patient_SSN` FOREIGN KEY (`Patient`) REFERENCES `Patient` (`SSN`),
  CONSTRAINT `fk_Stay_Room_Number` FOREIGN KEY (`Room`) REFERENCES `Room` (`RoomNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Trained_In` (
  `Physician` int(11) NOT NULL,
  `Treatment` int(11) NOT NULL,
  `CertificationDate` datetime NOT NULL,
  `CertificationExpires` datetime NOT NULL,
  PRIMARY KEY (`Physician`,`Treatment`),
  KEY `fk_Trained_In_Procedures_Code` (`Treatment`),
  CONSTRAINT `fk_Trained_In_Physician_EmployeeID` FOREIGN KEY (`Physician`) REFERENCES `Physician` (`EmployeeID`),
  CONSTRAINT `fk_Trained_In_Procedures_Code` FOREIGN KEY (`Treatment`) REFERENCES `Procedures` (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Undergoes` (
  `Patient` int(11) NOT NULL,
  `Procedures` int(11) NOT NULL,
  `Stay` int(11) NOT NULL,
  `DateUndergoes` datetime NOT NULL,
  `Physician` int(11) NOT NULL,
  `AssistingNurse` int(11) DEFAULT NULL,
  PRIMARY KEY (`Patient`,`Procedures`,`Stay`,`DateUndergoes`),
  KEY `fk_Undergoes_Procedures_Code` (`Procedures`),
  KEY `fk_Undergoes_Stay_StayID` (`Stay`),
  KEY `fk_Undergoes_Physician_EmployeeID` (`Physician`),
  KEY `fk_Undergoes_Nurse_EmployeeID` (`AssistingNurse`),
  CONSTRAINT `fk_Undergoes_Nurse_EmployeeID` FOREIGN KEY (`AssistingNurse`) REFERENCES `Nurse` (`EmployeeID`),
  CONSTRAINT `fk_Undergoes_Patient_SSN` FOREIGN KEY (`Patient`) REFERENCES `Patient` (`SSN`),
  CONSTRAINT `fk_Undergoes_Physician_EmployeeID` FOREIGN KEY (`Physician`) REFERENCES `Physician` (`EmployeeID`),
  CONSTRAINT `fk_Undergoes_Procedures_Code` FOREIGN KEY (`Procedures`) REFERENCES `Procedures` (`Code`),
  CONSTRAINT `fk_Undergoes_Stay_StayID` FOREIGN KEY (`Stay`) REFERENCES `Stay` (`StayID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `Affiliated_With` (`Physician`, `Department`, `PrimaryAffiliation`) VALUES
(1, 1, b'1'),
(2, 1, b'1'),
(3, 1, b'0'),
(3, 2, b'1'),
(4, 1, b'1'),
(5, 1, b'1'),
(6, 2, b'1'),
(7, 1, b'0'),
(7, 2, b'1'),
(8, 1, b'1'),
(9, 3, b'1');

INSERT INTO `Appointment` (`AppointmentID`, `Patient`, `PrepNurse`, `Physician`, `Starto`, `Endo`, `ExaminationRoom`) VALUES
(13216584, 100000001, 101, 1, '2008-04-24 10:00:00', '2008-04-24 11:00:00', 'A'),
(26548913, 100000002, 101, 2, '2008-04-24 10:00:00', '2008-04-24 11:00:00', 'B'),
(36549879, 100000001, 102, 1, '2008-04-25 10:00:00', '2008-04-25 11:00:00', 'A'),
(46846589, 100000004, 103, 4, '2008-04-25 10:00:00', '2008-04-25 11:00:00', 'B'),
(59871321, 100000004, NULL, 4, '2008-04-26 10:00:00', '2008-04-26 11:00:00', 'C'),
(69879231, 100000003, 103, 2, '2008-04-26 11:00:00', '2008-04-26 12:00:00', 'C'),
(76983231, 100000001, NULL, 3, '2008-04-26 12:00:00', '2008-04-26 13:00:00', 'C'),
(86213939, 100000004, 102, 9, '2008-04-27 10:00:00', '2008-04-21 11:00:00', 'A'),
(93216548, 100000002, 101, 2, '2008-04-27 10:00:00', '2008-04-27 11:00:00', 'B');

INSERT INTO `Block` (`BlockFloor`, `BlockCode`) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 2),
(2, 3),
(3, 1),
(3, 2),
(3, 3),
(4, 1),
(4, 2),
(4, 3);

INSERT INTO `Department` (`DepartmentID`, `Name`, `Head`) VALUES
(1, 'General Medicine', 4),
(2, 'Surgery', 7),
(3, 'Psychiatry', 9);

INSERT INTO `Medication` (`Code`, `Name`, `Brand`, `Description`) VALUES
(1, 'Procrastin-X', 'X', 'N/A'),
(2, 'Thesisin', 'Foo Labs', 'N/A'),
(3, 'Awakin', 'Bar Laboratories', 'N/A'),
(4, 'Crescavitin', 'Baz Industries', 'N/A'),
(5, 'Melioraurin', 'Snafu Pharmaceuticals', 'N/A');

INSERT INTO `Nurse` (`EmployeeID`, `Name`, `Position`, `Registered`, `SSN`) VALUES
(101, 'Carla Espinosa', 'Head Nurse', b'1', 111111110),
(102, 'Laverne Roberts', 'Nurse', b'1', 222222220),
(103, 'Paul Flowers', 'Nurse', b'0', 333333330);

INSERT INTO `On_Call` (`Nurse`, `BlockFloor`, `BlockCode`, `OnCallStart`, `OnCallEnd`) VALUES
(101, 1, 1, '2008-11-04 11:00:00', '2008-11-04 19:00:00'),
(101, 1, 2, '2008-11-04 11:00:00', '2008-11-04 19:00:00'),
(102, 1, 3, '2008-11-04 11:00:00', '2008-11-04 19:00:00'),
(103, 1, 1, '2008-11-04 19:00:00', '2008-11-05 03:00:00'),
(103, 1, 2, '2008-11-04 19:00:00', '2008-11-05 03:00:00'),
(103, 1, 3, '2008-11-04 19:00:00', '2008-11-05 03:00:00');

INSERT INTO `Patient` (`SSN`, `Name`, `Address`, `Phone`, `InsuranceID`, `PCP`) VALUES
(100000001, 'John Smith', '42 Foobar Lane', '555-0256', 68476213, 1),
(100000002, 'Grace Ritchie', '37 Snafu Drive', '555-0512', 36546321, 2),
(100000003, 'Random J. Patient', '101 Omgbbq Street', '555-1204', 65465421, 2),
(100000004, 'Dennis Doe', '1100 Foobaz Avenue', '555-2048', 68421879, 3),
(100000005, 'Matthieu Schapranow', 'Prof.-Dr.-Helmert-Str. 2-3', '555-0815', 96255511, 1);

INSERT INTO `Physician` (`EmployeeID`, `Name`, `Position`, `SSN`) VALUES
(1, 'John Dorian', 'Staff Internist', 111111111),
(2, 'Elliot Reid', 'Attending Physician', 222222222),
(3, 'Christopher Turk', 'Surgical Attending Physician', 333333333),
(4, 'Percival Cox', 'Senior Attending Physician', 444444444),
(5, 'Bob Kelso', 'Head Chief of Medicine', 555555555),
(6, 'Todd Quinlan', 'Surgical Attending Physician', 666666666),
(7, 'John Wen', 'Surgical Attending Physician', 777777777),
(8, 'Keith Dudemeister', 'MD Resident', 888888888),
(9, 'Molly Clock', 'Attending Psychiatrist', 999999999);

INSERT INTO `Prescribes` (`Physician`, `Patient`, `Medication`, `Date`, `Appointment`, `Dose`) VALUES
(1, 100000001, 1, '2008-04-24 10:47:00', 13216584, '5'),
(9, 100000004, 2, '2008-04-27 10:53:00', 86213939, '10'),
(9, 100000004, 2, '2008-04-30 16:53:00', NULL, '5');

INSERT INTO `Room` (`RoomNumber`, `RoomType`, `BlockFloor`, `BlockCode`, `Unavailable`) VALUES
(101, 'Single', 1, 1, b'0'),
(102, 'Single', 1, 1, b'0'),
(103, 'Single', 1, 1, b'0'),
(111, 'Single', 1, 2, b'0'),
(112, 'Single', 1, 2, b'1'),
(113, 'Single', 1, 2, b'0'),
(121, 'Single', 1, 3, b'0'),
(122, 'Single', 1, 3, b'0'),
(123, 'Single', 1, 3, b'0'),
(201, 'Single', 2, 1, b'1'),
(202, 'Single', 2, 1, b'0'),
(203, 'Single', 2, 1, b'0'),
(211, 'Single', 2, 2, b'0'),
(212, 'Single', 2, 2, b'0'),
(213, 'Single', 2, 2, b'1'),
(221, 'Single', 2, 3, b'0'),
(222, 'Single', 2, 3, b'0'),
(223, 'Single', 2, 3, b'0'),
(301, 'Single', 3, 1, b'0'),
(302, 'Single', 3, 1, b'1'),
(303, 'Single', 3, 1, b'0'),
(311, 'Single', 3, 2, b'0'),
(312, 'Single', 3, 2, b'0'),
(313, 'Single', 3, 2, b'0'),
(321, 'Single', 3, 3, b'1'),
(322, 'Single', 3, 3, b'0'),
(323, 'Single', 3, 3, b'0'),
(401, 'Single', 4, 1, b'0'),
(402, 'Single', 4, 1, b'1'),
(403, 'Single', 4, 1, b'0'),
(411, 'Single', 4, 2, b'0'),
(412, 'Single', 4, 2, b'0'),
(413, 'Single', 4, 2, b'0'),
(421, 'Single', 4, 3, b'1'),
(422, 'Single', 4, 3, b'0'),
(423, 'Single', 4, 3, b'0');

INSERT INTO `Stay` (`StayID`, `Patient`, `Room`, `StayStart`, `StayEnd`) VALUES
(3215, 100000001, 111, '2008-05-01 00:00:00', '2008-05-04 00:00:00'),
(3216, 100000003, 123, '2008-05-03 00:00:00', '2008-05-14 00:00:00'),
(3217, 100000004, 112, '2008-05-02 00:00:00', '2008-05-03 00:00:00');



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;