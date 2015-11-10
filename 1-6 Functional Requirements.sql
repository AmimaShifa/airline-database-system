#1
DROP PROCEDURE IF EXISTS bookFlight;
DELIMITER //
CREATE PROCEDURE bookFlight(
IN Flight_ID INT,
IN SeatNum_sel VARCHAR(45),
IN Class_sel VARCHAR(45),
IN Passenger_ID INT)
BEGIN
	INSERT INTO Booking (flightID, seatNum, class, passengerID)
    VALUES(FLight_ID, SeatNum_sel, Class_sel, Passenger_ID);
END//
DELIMITER ;

CALL bookFlight(1, 1, 'Economy', 1);

#2
DROP PROCEDURE IF EXISTS cancelFlight;
DELIMITER //
CREATE PROCEDURE cancelFlight(
IN Flight_ID INT,
IN SeatNum_sel VARCHAR(45),
IN Class_sel VARCHAR(45),
IN Passenger_ID INT)
BEGIN
    DELETE FROM Booking
	WHERE flightID = FLight_ID AND
    seatNum = SeatNum_sel AND
    class = Class_sel AND
    passengerID = Passenger_ID;
END//
DELIMITER ;

CALL cancelFlight(1, 1, 'Economy', 1);

#3
DROP PROCEDURE IF EXISTS getPassengersbyFlight;
DELIMITER //
CREATE PROCEDURE getPassengersbyFlight(
IN Flight_ID INT)
BEGIN
	SELECT flightID, firstName, LastName
	FROM Passenger, Booking
	WHERE Booking.flightID = Flight_ID AND
	Booking.passengerID = Passenger.passengerID;
END//
DELIMITER ;

CALL getPassengersbyFlight(1);

#4
SELECT FlightID, PassengerCount
FROM(
	SELECT FlightID, COUNT(ticketID) AS PassengerCount 
	FROM Booking
	GROUP BY flightID) AS PassengerCount
WHERE PassengerCount >= 10

#5
SELECT MAX (avg_age) FROM
(
SELECT Flight.flightID, avg(age) AS avg_age
FROM Passenger, Booking, Flight
WHERE Booking.passengerID = Passenger.passengerID AND Booking.flightID = Flight.flightID
GROUP BY flightID
)

#6
DROP PROCEDURE IF EXISTS getFlightByDestination;
DELIMITER //
CREATE PROCEDURE getFlightByDestination(
IN Destination VARCHAR(45))
BEGIN
	SELECT flightID, departureDate, departureTime, arrivalTime, A1.city, A2.city
	FROM Flight, Route, Airport A1, Airport A2
	WHERE 
	Flight.routeID = Route.routeID AND
    Route.departureAirportID =  A1.airportID AND
	Route.arrivalAirportID =  A2.airportID AND
	A2.city = Destination;
END//
DELIMITER ;

CALL getFlightByDestination('Los Angeles');