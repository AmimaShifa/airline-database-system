
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
    password        VARCHAR(45),
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
    FOREIGN KEY(arrivalAirportID) 		REFERENCES Airport(airportID)
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
    updatedOn       TIMESTAMP NOT NULL 
    ON UPDATE       CURRENT_TIMESTAMP,
    
    PRIMARY KEY(flightID),
    FOREIGN KEY(routeID) 	REFERENCES Route(routeID)   
    ON UPDATE CASCADE
);

#This is the archive relation for flights. 
#Store Procedure archiveFlights will take tuples in flights and add it to flightsarchive
DROP TABLE IF EXISTS FlightsArchive;
CREATE TABLE FlightsArchive
(
    flightID        INT AUTO_INCREMENT,
    departureTime   TIME DEFAULT '00:00:00',
    departureDate   DATE DEFAULT '0000-00-00',
    arrivalTime     TIME DEFAULT '00:00:00',
    arrivalDate     DATE DEFAULT '0000-00-00',
    routeID         INT,

    PRIMARY KEY(flightID)
);

DROP TABLE IF EXISTS Booking;
CREATE TABLE Booking
(
    ticketID        INT AUTO_INCREMENT,
    flightID        INT,
    seatNum         INT,
    class           VARCHAR(45),
    passengerID     INT,
    updatedOn       TIMESTAMP NOT NULL 
    ON UPDATE       CURRENT_TIMESTAMP,
    
    PRIMARY KEY(ticketID),
    FOREIGN KEY(flightID) REFERENCES Flight(flightID) 
    ON UPDATE CASCADE,
    FOREIGN KEY(passengerID) REFERENCES Passenger(passengerID)
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS BookingArchive;
CREATE TABLE BookingArchive
(
    ticketID        INT AUTO_INCREMENT,
    flightID        INT,
    seatNum         INT,
    class           VARCHAR(45),
    passengerID     INT,    

    PRIMARY KEY(ticketID)
);

DROP TABLE IF EXISTS Flight_Pilot;
CREATE TABLE Flight_Pilot
(
    flightID        INT,
    pilotID         INT,
    
    FOREIGN KEY(flightID) 		REFERENCES Flight(flightID),
    FOREIGN KEY(pilotID) 		REFERENCES Pilot(pilotID)
);



