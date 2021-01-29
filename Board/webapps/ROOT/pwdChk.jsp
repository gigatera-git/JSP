<%@ page language="java" session="false" trimDirectiveWhitespaces="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ page import = "java.sql.*"%>
<%@ page import = "javax.sql.*"%>
<%@ page import = "javax.naming.*"%>

<%@ page import = "java.io.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.net.URLEncoder" %>
<%@ page import = "java.net.URLDecoder" %>

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
String pwd = (request.getParameter("pwd")==null)?"":request.getParameter("pwd").trim().replace("'","''");
//out.println("idx : " + idx + "<br>");
//out.println("pwd : " + pwd + "<br>");  
//out.println("pwd2 : " + URLEncoder.encode(pwd,"UTF-8") + "<br>");

String res = new String("");

if (idx.length()<=0) {
	res = "글번호가 없습니다";
} else if (pwd.length()<=0) {
	res = "비밀번호가 없습니다";
} else {
	
	
	Board board = new Board();
	int cols = board.getCheckPwd(Integer.parseInt(idx),URLEncoder.encode(pwd,"UTF-8"));
	//out.println(cols);
	if (cols<=0) {
		res = "비밀번호가 일치하지 않습니다";
	} else {
		res = "ok";
	}
	
	
}

out.println(res);
%>