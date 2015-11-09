import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
 
public class Main
{
 
  public static void main(String[] argv) throws SQLException {
 
	Connection connection = null;
	Statement statement = null;
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
		System.out.println("You made it, take control your database now!");
	} else {
		System.out.println("Failed to make connection!");
	}	
	/*
	 * 
	 * 
	 * This is where we start to code!
	 * 
	 * 
	 * 
	 */
	
	//1st user request 
	//very rough draft... 
	//There will be a new tuple in booking with flight = 4
	//run a query on mysql to verify
	
	//Map<seatNum, PassengerID>
	Map<Integer, Integer> seatMap = new HashMap<Integer, Integer>();
	Boolean loop = false;
	while(!loop){
			System.out.println("User Request: Create/Reserve flight for Passenger");
			Scanner in = new Scanner(System.in);
			System.out.print("passengerID?: ");
			CallableStatement cs = connection.prepareCall("{CALL bookFlight(?, ?, ? , ?)}");
			int pID = Integer.parseInt(in.nextLine());
			cs.setInt(4, pID);
			System.out.print("Class?: ");
			cs.setString(3, in.nextLine());
			System.out.print("FlightID?: ");
			cs.setInt(1, Integer.parseInt(in.nextLine()));
			System.out.print("SeatNum?: ");
			int sID = Integer.parseInt(in.nextLine());
			cs.setInt(2, sID);
			seatMap.put(sID, pID);
			ResultSet rs = cs.executeQuery();
			System.out.println("Booking Created! Check DB to verify. Press X to exit, or N to reserve another flight\n");
			if(in.nextLine().equals("X")){
				loop = true;
			}
	}		
	
  }
  
  
}