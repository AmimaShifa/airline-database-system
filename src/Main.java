import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
 
public class Main
{
 
  public static void main(String[] argv) throws SQLException {
 
	Connection connection = null;
	try {
		//Change connection according to root info
		connection = DriverManager
		.getConnection("jdbc:mysql://localhost:3306/flight_reservation","root", "Spongebob12#");
	} catch (SQLException e) {
		System.out.println("Connection Failed! Check output console");
		e.printStackTrace();
		return;
	}
	if (connection != null) {
		System.out.println("Welcome to the SEK Airline Reservation System");
	} else {
		System.out.println("Failed to make connection!");
	}	
	//Map<seatNum, PassengerID>
	Map<Integer, Integer> seatMap = new HashMap<Integer, Integer>();
	Boolean loop = false;
	while(!loop){
		Scanner in = new Scanner(System.in);
		System.out.println("-Press 1 to Book/Reserve Flight for Passenger");
		System.out.println("-Press 2 to Cancel Flight for Passenger");
		System.out.println("-Press 3 to See Passengers by Flight");
		System.out.println("-Press X to Exit");
		String input = in.nextLine();
		if(input.equals("1")){
			loop = bookFlight(in, connection);
		}else if (input.equals("2")){
			loop = cancelFlight(in, connection);
		}else if (input.equals("3")){
			loop = getPassengersByFlight(in, connection);
		}else if (input.equals("X")){
			loop = true;
		}
	}		
	
  }
  
  //seatNum should be apart of primary Key so no two ticketIDs can have the same seatNum
  //add this later
  public static boolean bookFlight(Scanner in, Connection connection) throws SQLException{
	  System.out.println("User Request: Create/Reserve flight for Passenger");
		CallableStatement cs = connection.prepareCall("{CALL bookFlight(?, ?, ? , ?)}");
		System.out.print("passengerID?: ");
		int pID = Integer.parseInt(in.nextLine());
		cs.setInt(4, pID);
		System.out.print("Class?: ");
		cs.setString(3, in.nextLine());
		System.out.print("FlightID?: ");
		cs.setInt(1, Integer.parseInt(in.nextLine()));
		System.out.print("SeatNum?: ");
		int sID = Integer.parseInt(in.nextLine());
		cs.setInt(2, sID);
		ResultSet rs = cs.executeQuery();
		System.out.println("\nBooking Created! Check DB to verify.\n");
	  return false;
  }
  
  public static boolean cancelFlight(Scanner in, Connection connection) throws SQLException{
	  System.out.println("User Request: Cancel flight for Passenger");
		CallableStatement cs = connection.prepareCall("{CALL cancelFlight(?, ?, ? , ?)}");
		System.out.print("passengerID?: ");
		int pID = Integer.parseInt(in.nextLine());
		cs.setInt(4, pID);
		System.out.print("Class?: ");
		cs.setString(3, in.nextLine());
		System.out.print("FlightID?: ");
		cs.setInt(1, Integer.parseInt(in.nextLine()));
		System.out.print("SeatNum?: ");
		int sID = Integer.parseInt(in.nextLine());
		cs.setInt(2, sID);
		ResultSet rs = cs.executeQuery();
		System.out.println("\nBooking Cancelled! Check DB to verify.\n");
	  return false;
  }
  
  public static boolean getPassengersByFlight(Scanner in, Connection connection) throws SQLException{
	  System.out.println("User Request - See Passengers By Flight");
	  	CallableStatement cs = connection.prepareCall("{CALL getPassengersbyFlight(?)}");
	  	System.out.print("FlightID?: ");
	  	int fID = Integer.parseInt(in.nextLine());
	  	cs.setInt(1, fID);
	  	ResultSet rs = cs.executeQuery();
	  	if (!rs.isBeforeFirst() ) {    
	  		 System.out.println("\nThere are no passengers on Flight " + fID + " yet.\n");
	  	}else{
	  		System.out.println("\nHere is the list of passengers on Flight " + fID + ":");
	  		printPassengersbyFlight(rs);
	  	}	
	  	
	  return false;
  }
  
  public static void printPassengersbyFlight(ResultSet rs) throws SQLException
  {
	  while(rs.next())
	  {
		  int fID = rs.getInt("flightID");
		  String fName = rs.getString("firstName");
		  String lName = rs.getString("lastName");
		  System.out.println("Name: " + fName + " " + lName);
	  }
  }
  
}