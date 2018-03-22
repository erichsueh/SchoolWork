import java.sql.*;

public class javatooricle
{
    public static void main(String[] args)
    {
	try
	    {
		Class.forName("oracle.jdbc.driver.OracleDriver");
		System.out.println("Driver Loaded");
		Connection con = DriverManager.getConnection(
							     "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS",
							     "ehsueh",
							     "");
		System.out.println("Database Connected");

		Statement stmt = con.createStatement();
		
		//stmt.executeUpdate
		//    ("create table movie(title char(20), movie_number integer, primary key(movie_number))");
		//System.out.println("Table created");
		//stmt.executeUpdate("insert into movie values('Chicago',1)");
		//System.out.println("Inserted value");
		ResultSet rs = stmt.executeQuery("select title,movie_number from movie");
		System.out.println("Got Query");
		//stmt.executeQuery(“SQL statement”);
		//System.out.println(ResultSet);
	    }
	catch(Exception e)
	    {
		System.out.println(e.getMessage() );
	    }
    }
}
