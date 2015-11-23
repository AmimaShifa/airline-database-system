/*================================================================================
Listing of queries that fufill a minimum requirement
Make sure to have at least one:
– Co-related subquery
– Group by and having
– Aggregation
– Outer join
– Set operation
*At least three of them must involve several relations simultaneously
=================================================================================*/

/*================================================================================
Co-related subquery
=================================================================================*/



/*================================================================================
Group by and having
=================================================================================*/

#4 (modified)
SELECT FlightID, COUNT(ticketID) AS PassengerCount
FROM Booking
GROUP BY flightID 
HAVING PassengerCount >= 10

/*================================================================================
Aggregation
=================================================================================*/



/*================================================================================
Outer join
=================================================================================*/

#3 (modified)
DROP PROCEDURE IF EXISTS getPassengersbyFlight;
DELIMITER //
CREATE PROCEDURE getPassengersbyFlight(
IN Flight_ID INT)
BEGIN
	SELECT flightID, firstName, LastName
	FROM Passenger
	LEFT OUTER JOIN Booking
	ON Booking.flightID = flight_ID
	WHERE Booking.passengerID = Passenger.passengerID;
END//
DELIMITER ;

CALL getPassengersbyFlight(1);


#7 (modified)
DROP PROCEDURE IF EXISTS getEconomyPassengers;
DELIMITER //
CREATE PROCEDURE getEconomyPassengers()
BEGIN
	SELECT flightID, firstName, lastName
	FROM Passenger
	LEFT OUTER JOIN Booking
	ON Booking.passengerID = Passenger.passengerID
	WHERE class = 'Economy';
END//
DELIMITER ;

CALL getEconomyPassengers();


#8 (modified)
DROP PROCEDURE IF EXISTS getFirstPassengers;
DELIMITER //
CREATE PROCEDURE getFirstPassengers()
BEGIN
BEGIN
	SELECT flightID, firstName, lastName
	FROM Passenger
	LEFT OUTER JOIN Booking
	ON Booking.passengerID = Passenger.passengerID
	WHERE class = 'First';
END//
DELIMITER ;


# NEW: List all bookings ordered by passenger ID 
SELECT Passenger.passengerID, Passenger.firstname, Passenger.lastname, Booking.ticketID, Booking.flightID
FROM Passenger
LEFT OUTER JOIN Booking
ON Passenger.passengerID = Booking.passengerID
ORDER BY Passenger.passengerID;


/*================================================================================
set operation
=================================================================================*/

# NEW: List the total number of bookings each passenger has
SELECT Passenger.passengerID, Passenger.firstname, Passenger.lastname, count(ticketID) AS totalBookings
FROM Passenger, Booking
WHERE Passenger.passengerID = Booking.passengerID
GROUP BY Passenger.passengerID
UNION
SELECT Passenger.passengerID, Passenger.firstname, Passenger.lastname, 0
FROM Passenger
WHERE passengerID NOT IN (SELECT passengerID FROM Booking);


# NEW: List the total number flights each airline currently offers
SELECT Airline.airlineID, Airline.name, count(flightID) AS totalFlights
FROM Airline, Route, Flight
WHERE Airline.airlineID = Route.routeID AND Route.routeID = flight.flightID
GROUP BY Airline.airlineID
UNION
SELECT Airline.airlineID, Airline.name, 0
FROM Airline
WHERE airlineID NOT IN (SELECT airlineID FROM Route, Flight WHERE Route.airlineID = Route.airlineID);