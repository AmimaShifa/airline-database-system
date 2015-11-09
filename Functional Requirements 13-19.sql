/*=========================================================================
13. See the list of flights on a specific date
=========================================================================*/
DROP PROCEDURE IF EXISTS getFlightsByDate;
DELIMITER //
CREATE PROCEDURE getFlightsByDate(IN DATE VARCHAR(45))
BEGIN
	SELECT departureDate, a1.name as origin, a1.code, departureTime, 
		a2.name as destination, a2.code, arrivalTime, airline.name as airline
	FROM flight, route, airport as a1, airport as a2, airline
	WHERE departureDate = DATE
	AND flight.routeID = route.routeID
	AND route.departureAirportID = a1.airportID
	AND route.arrivalAirportID = a2.airportID
	AND route.airlineID = airline.airlineID;
END//
DELIMITER ;

CALL getFlightsByDate('2015-12-25');

/*=========================================================================
14. See the list of flights leaving a specific city
=========================================================================*/
DROP PROCEDURE IF EXISTS getFlightsByCity;
DELIMITER //
CREATE PROCEDURE getFlightsByCity(IN ORIGIN VARCHAR(45))
BEGIN
	SELECT a1.city, departureDate, a1.name as origin, departureTime, 
			a2.name as destination, arrivalTime, airline.name as airline
	FROM flight, route, airport as a1, airport as a2, airline
	WHERE a1.city = ORIGIN
	AND flight.routeID = route.routeID
	AND route.departureAirportID = a1.airportID
	AND route.arrivalAirportID = a2.airportID
	AND route.airlineID = airline.airlineID;
END//
DELIMITER ;

CALL getFlightsByCity('San Jose');

/*=========================================================================
15. See the list of flights with given origin, destination, and date
=========================================================================*/
DROP PROCEDURE IF EXISTS getFlightsByRouteDate;
DELIMITER //
CREATE PROCEDURE getFlightsByRouteDate(
IN ORIGIN VARCHAR(45), IN DESTINATION VARCHAR(45), IN DATE VARCHAR(45))
BEGIN
	SELECT a1.city, departureDate, a1.name as origin, departureTime, 
			a2.name as destination, arrivalTime, airline.name as airline
	FROM flight, route, airport as a1, airport as a2, airline
	WHERE a1.city = ORIGIN
    AND a2.city = DESTINATION
    AND departureDate = DATE
	AND flight.routeID = route.routeID
	AND route.departureAirportID = a1.airportID
	AND route.arrivalAirportID = a2.airportID
	AND route.airlineID = airline.airlineID;
END//
DELIMITER ;

CALL getFlightsByRouteDate('San Jose', 'Los Angeles', '2015-12-25');

/*=========================================================================
16. See the list of airlines that operates from a (city,country) to another (city,country)
=========================================================================*/
DROP PROCEDURE IF EXISTS getAirlinesByRoute;
DELIMITER //
CREATE PROCEDURE getAirlinesByRoute(
IN FROMCITY VARCHAR(45),IN FROMCOUNTRY VARCHAR(45), IN TOCITY VARCHAR(45), IN TOCOUNTRY VARCHAR(45))
BEGIN
	SELECT airline.name, a1.name as origin, a1.city, a1.country,
	a2.name as destination, a2.city, a2.country
	FROM route, airline, airport as a1, airport as a2
	WHERE a1.country = FROMCOUNTRY
	AND a1.city = FROMCITY
	AND a2.country = TOCOUNTRY
	AND a2.city = TOCITY
	AND route.departureAirportID = a1.airportID
	AND route.arrivalAirportID = a2.airportID
	AND route.airlineID = airline.airlineID
	ORDER BY airline.name;
END//
DELIMITER ;

CALL getAirlinesByRoute ('San Francisco', 'United States', 'Paris', 'France');

/*=========================================================================
17. See the list of airports in a city, country order by name
=========================================================================*/
DROP PROCEDURE IF EXISTS getAirportByCityCountry;
DELIMITER //
CREATE PROCEDURE getAirportByCityCountry(IN CITYIN VARCHAR(45), IN COUNTRYIN VARCHAR(45))
BEGIN
	SELECT name, code, airportID
	FROM airport
	WHERE city = CITYIN
    AND country = COUNTRYIN
	ORDER BY name;
END//
DELIMITER ;

CALL getAirportByCityCountry ('New York', 'United States');


/*=========================================================================
18. See number of passengers for each flight given airline and date
=========================================================================*/

DROP PROCEDURE IF EXISTS GetPassengerNumberByAirlineOnDate;
DELIMITER //
CREATE PROCEDURE GetPassengerNumberByAirlineOnDate(IN AIRLINENAME VARCHAR(45), IN DATE VARCHAR(45))
BEGIN
	SELECT a1.name as origin, flight.departureTime, a2.name as destination, flight.arrivalTime, 
			count(passenger.passengerID) as passengerNumber
	FROM passenger, booking, flight, route, airline, airport as a1, airport as a2
	WHERE booking.flightID = flight.flightID
    AND booking.passengerID = passenger.passengerID
    AND flight.routeID = route.routeID
    AND route.airlineID = airline.airlineID
    AND route.departureAirportID = a1.airportID
    AND route.arrivalAirportID = a2.airportID
    AND airline.name = AIRLINENAME
    AND flight.departureDate = DATE
	group by flight.flightID;
END//
DELIMITER ;

CALL GetPassengerNumberByAirlineOnDate ('Southwest Airlines', '2015-12-25');

/*=========================================================================
19. See the list of passengers arriving to a airport
=========================================================================*/
DROP PROCEDURE IF EXISTS GetPassengerNumberAiportOnDate;
DELIMITER //
CREATE PROCEDURE GetPassengerNumberAiportOnDate(IN AIRPORTNAME VARCHAR(45), IN DATE VARCHAR(45))
BEGIN
	SELECT passenger.lastName, passenger.firstName, passenger.email, passenger.age
	FROM passenger, booking, flight, route, airline, airport as a1, airport as a2
	WHERE booking.flightID = flight.flightID
    AND booking.passengerID = passenger.passengerID
    AND flight.routeID = route.routeID
    AND route.airlineID = airline.airlineID
    AND route.departureAirportID = a1.airportID
    AND route.arrivalAirportID = a2.airportID
    AND a1.code = AIRPORTNAME
    AND flight.departureDate = DATE;
END//
DELIMITER ;

CALL GetPassengerNumberAiportOnDate ('SJC', '2015-12-25');
