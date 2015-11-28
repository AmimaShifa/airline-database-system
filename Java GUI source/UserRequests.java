import java.sql.*;


public class UserRequests {
	
	//3
	public ResultSet getPassengersByFlight(Connection conn, int flight_ID) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		PreparedStatement preparedStatement = null;

		sql = "SELECT flightID, firstName, LastName FROM Passenger, Booking " + 
			"WHERE Booking.flightID = ? AND "+
			"Booking.passengerID = Passenger.passengerID;";
		preparedStatement = conn.prepareStatement(sql);
		preparedStatement.setInt(1, flight_ID);
		rs = preparedStatement.executeQuery();
		return rs;
	}

	//4
	public ResultSet getFlightsWithTenPlusPassengers(Connection conn) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		Statement statement = null;

		sql = "SELECT FlightID, PassengerCount " +
				"FROM( SELECT FlightID, COUNT(ticketID) AS PassengerCount  " +
				"FROM Booking " +
				"GROUP BY flightID) AS PassengerCount "+
				"WHERE PassengerCount >= 10";
		statement = conn.createStatement();
		rs = statement.executeQuery(sql);
		return rs;
	}

	//5
	public ResultSet getFlightWithMaxAverageAge(Connection conn) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		Statement statement = null;

		sql = "SELECT flightID, MAX(avg_age) " +
				"FROM(SELECT Flight.flightID, avg(age) AS avg_age " +
					"FROM Passenger, Booking, Flight " +
					"WHERE Booking.userID = Passenger.userID AND Booking.flightID = Flight.flightID "+
				"GROUP BY flightID) as AverageAgePerFlight";
		statement = conn.createStatement();
		rs = statement.executeQuery(sql);
		return rs;
	}

	//6
	public ResultSet getFlightsByDestination(Connection conn, String destination) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		PreparedStatement preparedStatement = null;

		sql = "SELECT flightID, departureDate, departureTime, arrivalTime, A1.city, A2.city " +
			"FROM Flight, Route, Airport A1, Airport A2 "+
			"Where Flight.routeID = Route.routeID AND " +
			"Route.departureAirportID =  A1.airportID AND " +
			"Route.arrivalAirportID =  A2.airportID AND " +
			"A2.city = ?;";

	    preparedStatement = conn.prepareStatement(sql);
	    preparedStatement.setString(1, destination);
	    rs = preparedStatement.executeQuery();
	    while(rs.next()){
	    	System.out.println(rs.getString("flightID"));
	    }
	    return rs;
	}


	//7
	public ResultSet getEconomyPassengers(Connection conn) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		Statement statement = null;

		sql = "Select flightID, firstName, lastName " +
				"From Passenger LEFT OUTER JOIN Booking " +
				"On Booking.userID = Passenger.userID " +
				"Where class = 'Economy';";
		statement = conn.createStatement();
		rs = statement.executeQuery(sql);
		return rs;
	}

	//8
	public ResultSet getFirstPassengers(Connection conn) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		Statement statement = null;

		sql = "Select flightID, firstName, lastName " +
				"From Passenger " +
				"LEFT OUTER JOIN Booking " +
				"On Booking.userID = Passenger.userID " +
				"Where class = 'First';";
		statement = conn.createStatement();
		rs = statement.executeQuery(sql);
		return rs;
	}

	//9
	public ResultSet getPilotsByDestination(Connection conn, String destination) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		PreparedStatement preparedStatement = null;

		sql = "Select pilot.pilotID, pilot.firstName, pilot.lastName " +
			"From flight, route, flight_pilot, pilot, airport A1, airport A2 "+
			"WHERE flight.routeID = route.routeID AND " +
	   		 	"route.departureAirportID = A1.airportID AND "+
			 	"route.arrivalAirportID = A2.airportID AND "+
	    	 	"flight.flightID = flight_Pilot.flightID AND " +
	    	 	"pilot.pilotID = flight_pilot.pilotID AND "+
	    	 	"A2.city = ?;";

	    preparedStatement = conn.prepareStatement(sql);
	    preparedStatement.setString(1, destination);
	    rs = preparedStatement.executeQuery();
	    return rs;
	}

	//10
	public ResultSet flightsByMostPassengers(Connection conn) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		Statement statement = null;

		sql = "select flightID, count(*) as num_tickets "+
			"From Booking " +
			"group by flightID " +
			"order by num_tickets DESC, flightID DESC;";
		statement = conn.createStatement();
		rs = statement.executeQuery(sql);
		/*
		while(rs.next()){
			System.out.println("flightID: " + rs.getInt("flightID") + "Passenger Count: " + rs.getInt("num_tickets"));	
		}
		*/
		return rs;
	}

	//11
	 public ResultSet flightsByShortestDuration(Connection conn) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		Statement statement = conn.createStatement();

		sql = "select flightID, timestampdiff(MINUTE, departureTime, arrivalTime) as timeDiff " +
			"from flight " +
			"group by flightID " +
			"order by timeDiff DESC;";
		rs = statement.executeQuery(sql);
		/*
		while(rs.next()){
			System.out.println("FlightID: " + rs.getInt("flightID") + "timeDiff: " + rs.getInt("timeDiff"));
		}
		*/
		return rs;
	}

	//12 use Southwest Airlines
	public ResultSet getFlightsByAirline(Connection conn, String airlineName) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		PreparedStatement preparedStatement = null;

		sql = "select flight.flightID " +
			"from flight, route, airline " +
			"where flight.routeID = route.routeID AND " +
			"airline.name = ?;";
		preparedStatement = conn.prepareStatement(sql);
		preparedStatement.setString(1, airlineName);
		rs = preparedStatement.executeQuery();

		System.out.println("Airlinesflights for: " + airlineName);
		while(rs.next()){
			System.out.println("flightID: " + rs.getInt("flightID"));
		}
		return rs;
	}

	//13
	public ResultSet getFlightsByRouteDate(Connection conn, String origin, String destination, String date) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		PreparedStatement preparedStatement = null;

		sql = "SELECT flightID as flightNumber, departureTime, r.departureAirport, arrivalTime, r. arrivalAirport, r.airlineName "+
				"FROM flight, (SELECT routeID, airline.name as airlineName, "+
							"a1.name as departureAirport, a2.name as arrivalAirport "+
						"FROM route, airline, airport as a1, airport as a2 "+
						"WHERE a1.city = ? "+
						"AND a2.city = ? "+
						"AND route.departureAirportID = a1.airportID "+
						"AND route.arrivalAirportID = a2.airportID "+
						"AND route.airlineID = airline.airlineID) r " +
				"WHERE flight.routeID = r.routeID "+
				"AND flight.departureDate = ?;";
		preparedStatement = conn.prepareStatement(sql);
		preparedStatement.setString(1, origin);
		preparedStatement.setString(2, destination);
		preparedStatement.setString(3, date);
		rs = preparedStatement.executeQuery();
		/*
		while(rs.next()){
			System.out.println(rs.getString("flightNumber") +" " + rs.getString("departureTime"));
		}
		*/	
		return rs;
	}

	//14
	public ResultSet getFlightsByFlightID(Connection conn, int flightID) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		PreparedStatement preparedStatement = null;

		sql = "SELECT flightID as flightNumber, departureTime, r.departureAirport, arrivalTime, r. arrivalAirport, r.airlineName " +
			"FROM flight, (SELECT routeID, airline.name as airlineName, a1.name as departureAirport, a2.name as arrivalAirport " +
						  "FROM route, airline, airport as a1, airport as a2 " +
						  "WHERE route.departureAirportID = a1.airportID " +
						  "AND route.arrivalAirportID = a2.airportID " +
						  "AND route.airlineID = airline.airlineID) r " +
			"WHERE flight.routeID = r.routeID " +
			"AND flight.flightID = ?;";
		preparedStatement = conn.prepareStatement(sql);
		preparedStatement.setString(1, Integer.toString(flightID));
		rs = preparedStatement.executeQuery();
		/*
		while(rs.next()){
			System.out.println(rs.getString("flightNumber"));
		}
		*/
		return rs;
	}

	//15
	public ResultSet getTicketNumber(Connection conn, int flight_ID, int user_ID) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		PreparedStatement preparedStatement = null;

		sql = "SELECT ticketID FROM Booking WHERE flightID = ? AND userID = ?;";
		preparedStatement = conn.prepareStatement(sql);
		preparedStatement.setInt(1, flight_ID);
		preparedStatement.setInt(2, user_ID);
		rs = preparedStatement.executeQuery();
		/*
		while(rs.next()){
			System.out.println(rs.getString("ticketID"));
		}
		*/
		return rs;
	}

	//16
	public ResultSet getBookingByUser(Connection conn, int user_ID) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		PreparedStatement preparedStatement = null;

		sql = "SELECT * FROM Booking WHERE userID = ?";
		preparedStatement = conn.prepareStatement(sql);
		preparedStatement.setInt(1, user_ID);
		rs = preparedStatement.executeQuery();
		return rs;
	}

	//17
	public ResultSet getBookingOrderedByUserID(Connection conn) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		Statement statement = conn.createStatement();

		sql = "SELECT Passenger.userID, Passenger.firstname, Passenger.lastname, Booking.ticketID, Booking.flightID" +
			"FROM Passenger " +
			"LEFT OUTER JOIN Booking " +
			"ON Passenger.passengerID = Booking.passengerID "+
			"ORDER BY Passenger.passengerID;";
		rs = statement.executeQuery(sql);
		return rs;
	}

	//18 set operation
	public ResultSet getTotalBookingPerPassenger(Connection conn) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		Statement statement = conn.createStatement();

		sql = "SELECT Passenger.passengerID, Passenger.firstname, Passenger.lastname, count(ticketID) AS totalBookings " +
			"FROM Passenger, Booking " +
			"WHERE Passenger.passengerID = Booking.passengerID " +
			"GROUP BY Passenger.passengerID "+
			"UNION "+
			"SELECT Passenger.passengerID, Passenger.firstname, Passenger.lastname, 0 " +
			"FROM Passenger "+
			"WHERE passengerID NOT IN (SELECT passengerID FROM Booking);";
		rs = statement.executeQuery(sql);
		return rs;
	}

	//19 set operation
	public ResultSet getTotalFlightsPerAirline(Connection conn) throws SQLException{
		String sql = null;
		ResultSet rs = null;
		Statement statement = conn.createStatement();

		sql = "SELECT Airline.airlineID, Airline.name, count(flightID) AS totalFlights " +
			"FROM Airline, Route, Flight " +
			"WHERE Airline.airlineID = Route.routeID AND Route.routeID = flight.flightID " +
			"GROUP BY Airline.airlineID "+
			"UNION "+
			"SELECT Airline.airlineID, Airline.name, 0 " +
			"FROM Airline "+
			"WHERE airlineID NOT IN (SELECT airlineID FROM Route, Flight WHERE Route.airlineID = Route.airlineID);";
		rs = statement.executeQuery(sql);
		return rs;
	}

	//put this in the main method. IDK why it doesn't work when we put it in the ddl.
	public void createFlightArchive(Connection conn) throws SQLException{
		Statement statement = conn.createStatement();
		String sql = "DROP TABLE IF EXISTS FlightsArchive1;";
		statement.execute(sql);
		sql= "CREATE TABLE FlightsArchive1( " +
			"flightID        INT AUTO_INCREMENT, "+
			"departureTime   TIME DEFAULT '00:00:00', "+
	    	"departureDate   DATE DEFAULT '0000-00-00', "+
	    	"arrivalTime     TIME DEFAULT '00:00:00', "+
	    	"arrivalDate     DATE DEFAULT '0000-00-00', "+
	    	"routeID         INT, "+
	    	"PRIMARY KEY(flightID)); ";
		statement.execute(sql);
	}

	//Archive Stored Procedure
	public ResultSet archiveFlights(Connection conn, String date) throws SQLException{
		CallableStatement cs = conn.prepareCall("{CALL archiveFlights(?)}");
		String timestamp = date + " 00:00:00";
		cs.setString(1, timestamp);
		ResultSet rs = cs.executeQuery();
		return rs;
	}

}
