<%@ page language="java" session="false" trimDirectiveWhitespaces="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ page import = "java.sql.*"%>
<%@ page import = "javax.sql.*"%>
<%@ page import = "javax.naming.*"%>

<%@ page import = "java.io.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.text.SimpleDateFormat" %>

<%@ page import = "gigatera.*" %>

<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
if(request.getProtocol().equals("HTTP/1.1"))
   response.setHeader("Cache-Control", "no-cache");
%>

<%
String idx = (request.getParameter("idx")==null)?"1":request.getParameter("idx").trim().replace("'","''");
String SearchOpt = (request.getParameter("SearchOpt")==null)?"":request.getParameter("SearchOpt").trim().replace("'","''");
String SearchVal = (request.getParameter("SearchVal")==null)?"":request.getParameter("SearchVal").trim().replace("'","''");
String Page = (request.getParameter("Page")==null)?"1":request.getParameter("Page").trim().replace("'","''");

boolean isok = false;

if (idx.length()<=0) {
	out.println("<li>글번호가 없습니다</li>");
} else {
	
	Board board = new Board();

	if (board.setBoardFileDelOk(Integer.parseInt(idx),request)) {
		isok = board.setBoardDelOk(Integer.parseInt(idx));
	}
}
%>

<!doctype html>
<html lang="ko">
 <head>
  <meta charset="UTF-8">
  <title>글삭제</title>
  <script language="javascript" type="text/javascript" src="./config/js/jquery-3.1.0.js"></script>
  <script language="javascript" type="text/javascript" src="./config/js/extend.js"></script>
  <script language="javascript" type="text/javascript">
	$(document).ready(function(){
		setTimeout(function(){
			location.href = "list.jsp?Page=<%=Page%>&SearchOpt=<%=SearchOpt%>&SearchVal=<%=SearchVal%>";
		},5000);
	});
  </script>
 </head>
	<body>
		<%
		if (isok) {
			out.println("<li>정상적으로 삭제되었습니다</li>");
		} else {
			out.println("<li>삭제중 에러가 발생하였습니다. 관리자에게 문의하세요</li>");
		}

		out.println("<li>잠시후 리스트로 이동합니다</li>");
		%>
	</body>
</html>