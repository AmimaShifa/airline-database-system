/*================================================================================
1. Create/Reserve flight to bookingInput: flightID, seat, class, userID)
=================================================================================*/
DROP PROCEDURE IF EXISTS bookFlight;
DELIMITER //
CREATE PROCEDURE bookFlight(
IN Flight_ID INT,
IN SeatNum_sel VARCHAR(45),
IN Class_sel VARCHAR(45),
IN User_ID INT)
BEGIN
	INSERT INTO Booking (flightID, seatNum, class, userID)
    VALUES(FLight_ID, SeatNum_sel, Class_sel, User_ID);
END//
DELIMITER ;

/*================================================================================
Delete/Cancel flight from booking(Input: flightID and User_ID )
=================================================================================*/
DROP PROCEDURE IF EXISTS cancelFlightReservation;
DELIMITER //
CREATE PROCEDURE cancelFlightReservation(
IN Flight_ID INT,
IN User_ID INT)
BEGIN
    DELETE FROM Booking
	WHERE flightID = FLight_ID 
	AND userID = User_ID;
END//
DELIMITER ;



/*================================================================================
15. Search for flights with given departure city, arrival city, and departure date
=================================================================================*/
DROP PROCEDURE IF EXISTS searchFlightsByRouteDate;
DELIMITER //
CREATE PROCEDURE searchFlightsByRouteDate(
IN ORIGIN VARCHAR(45), IN DESTINATION VARCHAR(45), IN DATE VARCHAR(45))
BEGIN
	SELECT flightID as flightNumber, departureTime, r.departureAirport, 
			arrivalTime, r. arrivalAirport, r.airlineName
	FROM flight, (SELECT routeID, airline.name as airlineName, 
						a1.name as departureAirport, a2.name as arrivalAirport
					FROM route, airline, airport as a1, airport as a2
					WHERE a1.city = ORIGIN
					AND a2.city = DESTINATION
					AND route.departureAirportID = a1.airportID
					AND route.arrivalAirportID = a2.airportID
					AND route.airlineID = airline.airlineID) r
	WHERE flight.routeID = r.routeID
	AND flight.departureDate = DATE;
END//
DELIMITER ;


/*================================================================================
Search for flights with given flight number input
=================================================================================*/
DROP PROCEDURE IF EXISTS searchFlightsByFlightID;
DELIMITER //
CREATE PROCEDURE searchFlightsByFlightID(
IN flight_ID INT(10))
BEGIN
	SELECT flightID as flightNumber, departureTime, r.departureAirport, 
			arrivalTime, r. arrivalAirport, r.airlineName
	FROM flight, (SELECT routeID, airline.name as airlineName, 
						a1.name as departureAirport, a2.name as arrivalAirport
					FROM route, airline, airport as a1, airport as a2
					WHERE route.departureAirportID = a1.airportID
					AND route.arrivalAirportID = a2.airportID
					AND route.airlineID = airline.airlineID) r
	WHERE flight.routeID = r.routeID
	AND flight.flightID = flight_ID;
END//
DELIMITER ;


/*================================================================================
Get ticket number for passenger after booking (Input: flightID, seat, class, User_ID)
=================================================================================*/
DROP PROCEDURE IF EXISTS getTicketNumber;
DELIMITER //
CREATE PROCEDURE getTicketNumber(
IN Flight_ID INT,
IN User_ID INT)
BEGIN
	SELECT ticketID
	FROM Booking
	WHERE flightID = Flight_ID
	AND userID = User_ID;
END//
DELIMITER ;

/*================================================================================
Get booking flights by userID (Input: User_ID)
=================================================================================*/
DROP PROCEDURE IF EXISTS getBookingByUserID;
DELIMITER //
CREATE PROCEDURE getBookingByUserID(
IN User_ID INT)
BEGIN
	SELECT *
	FROM Booking
	WHERE userID = User_ID;
END//
DELIMITER ;


/*================================================================================
Get flights by flightID (Input: flightID)
=================================================================================*/
DROP PROCEDURE IF EXISTS getBookingByUserID;
DELIMITER //
CREATE PROCEDURE getBookingByUserID(
IN User_ID INT)
BEGIN
	SELECT *
	FROM Booking
	WHERE userID = User_ID;
END//
DELIMITER ;

