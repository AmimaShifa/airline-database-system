import java.sql.*;
//JavaFX
import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.control.DatePicker;
import javafx.scene.control.Label;
import javafx.scene.control.ScrollBar;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.stage.Stage;

public class Main extends Application
{ 
	//JDBC driver name and database URL
	static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
	static final String DB_URL = "jdbc:mysql://localhost/flight_reservation";

	//Database credentials
	static final String USER = "root";
	static final String PASS = "myfirstDB";
	private static Connection conn = null;
	private static PreparedStatement preparedStatement = null;
	
	static Stage mainWindow;
	private static int userID;
	static Scene loginScene;
	static Scene menuScene;
	
	public static void main(String[] args) throws SQLException {
		
		try{			
			conn = DriverManager.getConnection(DB_URL, USER, PASS);
			if (conn != null) {
				System.out.println("Welcome to the SEK Airline Reservation System");
			}
			launch(args);
			
		}catch(SQLException se){se.printStackTrace(); }
		catch(Exception e){ e.printStackTrace(); }
		finally{
			try{ if(preparedStatement!=null) preparedStatement.close(); }
			catch(SQLException se2){ }// nothing we can do
			
			try{ if(conn!=null) conn.close(); }
			catch(SQLException se){ se.printStackTrace(); }
		}		
	}//main

	@Override
	public void start(Stage primaryStage) throws Exception {
		mainWindow = primaryStage;
		mainWindow.setTitle("SEK Airline System");
		
		//BorderPane borderPane = new BorderPane();
		
		//Log-in and Sign-up Scene
		GridPane loginGrid = new LoginSignup(conn, preparedStatement, this);		
		loginGrid.setAlignment(Pos.CENTER);	
		
		loginScene = new Scene(loginGrid, 970,650);		
		
		BorderPane menuGrid = new Menu(conn, preparedStatement, mainWindow);
		menuScene = new Scene(menuGrid, 970,650);
				

		mainWindow.setScene(loginScene);
		//mainWindow.setScene(menuScene);
		mainWindow.show();
		
				
	}//start


	public void setID(int num){
		userID = num;		
	}
	
	public static int getUserID(){
		return userID;
	}

}//Main