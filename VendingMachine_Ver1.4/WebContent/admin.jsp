<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%
	Connection conn=null;
	Statement stmt = null;
	ResultSet rs = null;
	int count=0;
	
	String url="jdbc:mysql://localhost:3309/vm";
	String id="root";
	String password = "pjc0129";
	String sql = "SELECT pname, COUNT(PCOUNT) AS COUNT," +
			"SUM(pprice) AS total" +
			" FROM sales GROUP BY pname;";
	
	Class.forName("org.mariadb.jdbc.Driver");
	conn = DriverManager.getConnection(url,id,password);
	System.out.println("연결성공");	
	
	stmt = conn.createStatement();
	rs = stmt.executeQuery(sql);
%>
<!DOCTYPE html>
<html>
<head>
<style>

#wrapper {
	width: 600px;
  	margin: 50px auto;
}

#customers {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

#customers td, #customers th {
  border: 1px solid #ddd;
  padding: 8px;
  padding-right: 20px;
  text-align: center
}

#customers tr:nth-child(even){background-color: #f2f2f2;}

#customers tr:hover {background-color: #ddd;}

#customers th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: center;
  background-color: #04AA6D;
  color: white;  
}

.total {
	padding-right: 20px;
}
.center {
	text-align: center;
}
</style>

<meta charset="UTF-8">
<title>관리자 기능</title>
</head>
<body>
	<div id="wrapper">
		<h1 class="center">커피 자판기 상품별 판매 현황</h1>
		<table id="customers">		
		<tr>
			<th>상품명</th>
			<th>판매수량</th>
			<th>총판매금액</th>
		</tr>
		<% while(rs.next()) {%>
			<tr>
				<td><%=rs.getString("pname")%></td>
				<td><%=rs.getInt("COUNT")%></td>
				<td style="text-align:right"><%=rs.getInt("total")%></td>
			 </tr>
		<%} %>
		<tr>
		<td colspan="3"><a href="index.jsp">자판기 메인</a></td>
		</tr>
		<%
			rs.close();
			conn.close();
			stmt.close();
		%>
		</table>
	</div>

</body>
</html>