#7
DROP PROCEDURE IF EXISTS getEconomyPassengers;
DELIMITER //
CREATE PROCEDURE getEconomyPassengers()
BEGIN
	SELECT flightID, firstName, lastName
	FROM Passenger, Booking
	WHERE Booking.passengerID = Passenger.passengerID AND
	class = 'Economy';
END//
DELIMITER ;

CALL getEconomyPassengers();

#8
DROP PROCEDURE IF EXISTS getFirstPassengers;
DELIMITER //
CREATE PROCEDURE getFirstPassengers()
BEGIN
	SELECT flightID, firstName, lastName
	FROM Passenger, Booking
	WHERE Booking.passengerID = Passenger.passengerID AND
	class = 'First';
END//
DELIMITER ;

CALL getFirstPassengers();

#9
DROP PROCEDURE IF EXISTS getPilotsByDestination;
DELIMITER //
CREATE PROCEDURE getPilotsByDestination(
IN DESTINATION VARCHAR(45))
BEGIN
	SELECT pilot.pilotID, pilot.firstName, pilot.lastName
	FROM flight, route, flight_pilot, pilot, airport A1, airport A2
	WHERE flight.routeID = route.routeID AND
    route.departureAirportID = A1.airportID AND
	route.arrivalAirportID = A2.airportID AND
    flight.flightID = flight_Pilot.flightID AND
    pilot.pilotID = flight_pilot.pilotID AND
    A2.city = DESTINATION;
END//
DELIMITER ;

CALL getPilotsByDestination('Los Angeles');

#10 pilots with most passengers
select FlightID, COUNT(*) as num_tickets
From Booking
group by flightID
Order By num_tickets DESC, flightID DESC

#11 flights with duratoin from longest to shortest
select flightID, timestampdiff(MINUTE, departureTime, arrivalTime) as timeDiff
from flight
Group by flightID
order by timeDiff DESC

#12  flights from airline
DROP PROCEDURE IF EXISTS getFlightsByAirline;
DELIMITER //
CREATE PROCEDURE getFlightsByAirline(IN airlineName VARCHAR(45))
BEGIN
	select flight.flightID
    from flight, route, airline
    where flight.routeID = route.routeID AND
          route.airlineID = airline.airlineID AND
          airline.name = airlineName;
END//
DELIMITER ;

CALL getFlightsByAirline('American Airlines');

