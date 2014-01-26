package jaxrs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;


public class Service {

	public static String  getinformation(String Name)  {
		// TODO Auto-generated method stub
		// driver
		   String driver = "com.mysql.jdbc.Driver";
		// URL direction :hostname +databasename"huiguang"
		String url = "jdbc:mysql://mysql.stud.hig.no/s120556";
		// MySQL username
		String user = "s120556";
		// Java to MySQL password
		String password = "k72ZvQtY";
		try {
		// loading driver
		Class.forName(driver).newInstance();
		// connecting to the database
		Connection conn = DriverManager.getConnection(url, user, password);
		if(!conn.isClosed())
		System.out.println("Succeeded connecting to the Database!");
		// statement is used for executing SQL commmand
		Statement statement = conn.createStatement();
		// SQL command 
		String sql = "select * from huiguang";
		ResultSet rs = statement.executeQuery(sql);//返回的是一张数据表的所有的行跟列
		//return the row by the augument(int i)
		rs.absolute(3);
	//return the value in certain colum and row (rs.getString(int columIndex)
			Name = rs.getString(1);
		//name=rs.toString();
			rs.close(); 
	conn.close();
	return Name;
		} catch(Exception e){
			Name = "exception";
			return Name;
		}
		  
		
	}

	

	



}
