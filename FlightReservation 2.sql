
DROP DATABASE IF EXISTS Flight_Reservation;
CREATE DATABASE Flight_Reservation;
USE Flight_Reservation;

DROP TABLE IF EXISTs Passenger;
CREATE TABLE Passenger
(
    passengerID     INT AUTO_INCREMENT,
    firstName       VARCHAR(45),
    lastName        VARCHAR(45),
    email           VARCHAR(45),
    age             INT,
    
    PRIMARY KEY(passengerID)
);

DROP TABLE IF EXISTS Airline;
CREATE TABLE Airline
(
    airlineID      	INT AUTO_INCREMENT,
    name         	VARCHAR(45),
    code         	VARCHAR(10),
    country         VARCHAR(45),
    
    PRIMARY KEY(airlineID)
);

DROP TABLE IF EXISTS Airport;
CREATE TABLE Airport
(
    airportID      	INT AUTO_INCREMENT,
    name         	VARCHAR(45),
    city         	VARCHAR(45),
    country         VARCHAR(45),
    code         	VARCHAR(10),
    
    PRIMARY KEY(airportID)
);

DROP TABLE IF EXISTS Route;
CREATE TABLE Route
(
	routeID				INT AUTO_INCREMENT,
	airlineID			INT,
    departureAirportID	INT,
    arrivalAirportID	INT,
    
    PRIMARY KEY(routeID),
    FOREIGN KEY(airlineID) 				REFERENCES Airline(airlineID),
    FOREIGN KEY(departureAirportID) 	REFERENCES Airport(airportID),
    FOREIGN KEY(arrivalAiportID) 		REFERENCES Airport(airportID)
);

DROP TABLE IF EXISTS Pilot;
CREATE TABLE Pilot
(
    pilotID         INT AUTO_INCREMENT,
    firstName       VARCHAR(45),
    lastName        VARCHAR(45),
    experience      INT,
    
    PRIMARY KEY(pilotID)

);

DROP TABLE IF EXISTS Flight;
CREATE TABLE Flight
(
    flightID        INT AUTO_INCREMENT,
    departureTime   TIME DEFAULT '00:00:00',
    departureDate   DATE DEFAULT '0000-00-00',
    arrivalTime     TIME DEFAULT '00:00:00',
    arrivalDate     DATE DEFAULT '0000-00-00',
    routeID      	INT,
    
    PRIMARY KEY(flightID),
    FOREIGN KEY(routeID) 	REFERENCES Route(routeID)   
);

DROP TABLE IF EXISTS Booking;
CREATE TABLE Booking
(
    ticketID        INT AUTO_INCREMENT,
    flightID        INT,
    seatNum         INT,
    class           VARCHAR(45),
    passengerID     INT,
    
    PRIMARY KEY(ticketID),
    FOREIGN KEY(flightID) REFERENCES Flight(flightID),
    FOREIGN KEY(passengerID) REFERENCES Passenger(passengerID)
);

DROP TABLE IF EXISTS Flight_Pilot;
CREATE TABLE Flight_Pilot
(
    flightID        INT,
    pilotID         INT,
    
    FOREIGN KEY(flightID) 		REFERENCES Flight(flightID),
    FOREIGN KEY(pilotID) 		REFERENCES Pilot(pilotID)
);

DROP TRIGGER IF EXISTS DeletePassenger;
delimiter //
CREATE TRIGGER DeletePassenger
AFTER DELETE ON Passenger 
FOR EACH ROW
BEGIN
	DELETE FROM Booking WHERE passengerID = OLD.passengerID;
END;
//
delimiter ;

DROP TRIGGER IF EXISTS DeleteFlight;
delimiter //
CREATE TRIGGER DeleteFlight
AFTER DELETE ON Flight
FOR EACH ROW
BEGIN
	DELETE FROM Booking WHERE flightID = OLD.flightID;
END;
//
delimiter ;

DROP TRIGGER IF EXISTS DeletePilot;
delimiter //
CREATE TRIGGER DeletePilot
AFTER DELETE ON Pilot
FOR EACH ROW
BEGIN
	DELETE FROM flight_pilot WHERE pilotID = OLD.pilotID;
END; 
//
delimiter ;

