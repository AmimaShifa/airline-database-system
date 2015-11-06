
DROP DATABASE IF EXISTS FLIGHT_RESERVATION;
CREATE DATABASE FLIGHT_RESERVATION;
USE FLIGHT_RESERVATION;

DROP TABLE IF EXISTs PASSENGER;
CREATE TABLE PASSENGER
(
    passengerID     INT AUTO_INCREMENT,
    firstName       VARCHAR(45),
    lastName        VARCHAR(45),
    email           VARCHAR(45),
    age             INT,
    
    PRIMARY KEY(passengerID)
);

DROP TABLE IF EXISTS AIRPLANE;
CREATE TABLE AIRPLANE
(
    airplaneID      INT AUTO_INCREMENT,
    carrier         VARCHAR(45),
    tailNum         VARCHAR(10),
    
    PRIMARY KEY(airplaneID)
);

DROP TABLE IF EXISTS FLIGHT;
CREATE TABLE FLIGHT
(
    flightID        INT AUTO_INCREMENT,
    departureTime   TIME DEFAULT '00:00:00',
    departureDate   DATE DEFAULT '0000-00-00',
    arrivalTime     TIME DEFAULT '00:00:00',
    arrivalDate     DATE DEFAULT '0000-00-00',
    origin          VARCHAR(45),
    destination     VARCHAR(45),
    airplaneID      INT,
    
    PRIMARY KEY(flightID),
    FOREIGN KEY(airplaneID) 	REFERENCES AIRPLANE(airplaneID)   
);

DROP TABLE IF EXISTS BOOKING;
CREATE TABLE BOOKING
(
    ticketID        INT AUTO_INCREMENT,
    seatNum         VARCHAR(5),
    class           VARCHAR(45),
    flightID        INT,
    passengerID     INT,
    
    PRIMARY KEY(ticketID),
    FOREIGN KEY(flightID) 		REFERENCES FLIGHT(flightID),
    FOREIGN KEY(passengerID) 	REFERENCES PASSENGER(passengerID)
);


DROP TABLE IF EXISTS PILOT;
CREATE TABLE PILOT
(
    pilotID         INT AUTO_INCREMENT,
    firstName       VARCHAR(45),
    lastName        VARCHAR(45),
    experience      INT,
    
    PRIMARY KEY(pilotID)

);

DROP TABLE IF EXISTS FLIGHT_PILOT;
CREATE TABLE FLIGHT_PILOT
(
    flightID        INT,
    pilotID         INT,
    
    FOREIGN KEY(flightID) 		REFERENCES FLIGHT(flightID),
    FOREIGN KEY(pilotID) 		REFERENCES PILOT(pilotID)
);

DROP TRIGGER IF EXISTS DeletePassenger;
delimiter //
CREATE TRIGGER DeletePassenger
AFTER DELETE ON PASSENGER 
FOR EACH ROW
BEGIN
	DELETE FROM BOOKING WHERE passengerID = OLD.passengerID;
END;
//
delimiter ;


DROP TRIGGER IF EXISTS DeleteFlight;
delimiter //
CREATE TRIGGER DeleteFlight
AFTER DELETE ON FLIGHT
FOR EACH ROW
BEGIN
	DELETE FROM BOOKING WHERE flightID = OLD.flightID;
END;
//
delimiter ;

DROP TRIGGER IF EXISTS DeletePilot;
delimiter //
CREATE TRIGGER DeletePilot
AFTER DELETE ON PILOT
FOR EACH ROW
BEGIN
	DELETE FROM FLIGHT_PILOT WHERE pilotID = OLD.pilotID;
END; 
//
delimiter ;

