<%@ page language="java" session="false" trimDirectiveWhitespaces="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ page import = "java.sql.*"%>
<%@ page import = "javax.sql.*"%>
<%@ page import = "javax.naming.*"%>

<%@ page import = "java.io.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>

<%@ page import = "gigatera.*" %>

<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
if(request.getProtocol().equals("HTTP/1.1"))
   response.setHeader("Cache-Control", "no-cache");
%>

<!doctype html>
<html lang="ko">
 <head>
  <meta charset="UTF-8">
  <title>글쓰기</title>
  <script language="javascript" type="text/javascript" src="./config/js/jquery-3.1.0.js"></script>
  <script language="javascript" type="text/javascript" src="./config/js/extend.js"></script>
  <script language="javascript" type="text/javascript" src="./ckeditor/ckeditor.js"></script>
  <script language="javascript" type="text/javascript">
  $(document).ready(function(){


	$("#frmBoard").submit(function(e){

		if (confirm("저장할까요?")) {
			$("#frmBoard").attr({'action':'upload_ckeditor.jsp'});
		}
	});


  });
  </script>
 </head>
 <body>

	<form name="frmBoard" id="frmBoard" method="post" enctype="multipart/form-data">


		<table border="1">
		
		<tr>
		<td align="center"><b>첨부</b></td>
		<td>

			<input type="file" name="upload" class="file">
		</td>
		</tr>

		<tr>
		<td align="center"><b>check</b></td>
		<td>

			<input type="checkbox" name="attachDels" class="file" value="aaa">aaa
			<input type="checkbox" name="attachDels" class="file" value="bbb">bbb
		</td>
		</tr>

		</table>
		
		<table border="0">
		<tr>
		<td>
			<input type="submit" value="등록" id="btnOk">
			<input type="button" value="취소" id="btnCancel">
		</td>
		</tr>
		</table>

	</form>
  
 </body>
</html>