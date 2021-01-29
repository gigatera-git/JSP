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
String Page = (request.getParameter("Page")==null)?"":request.getParameter("Page").trim().replace("'","''");

String ref = (request.getParameter("ref")==null)?"":request.getParameter("ref").trim().replace("'","''");
String re_step = (request.getParameter("re_step")==null)?"":request.getParameter("re_step").trim().replace("'","''");
String re_lvl = (request.getParameter("re_lvl")==null)?"":request.getParameter("re_lvl").trim().replace("'","''");

if (idx.length()<=0) {
	out.println("<li>글번호가 없습니다</li>");
} else if (Page.length()<=0) {
	out.println("<li>페이지 번호가 없습니다</li>");
} else if (ref.length()<=0) {
	out.println("<li>ref가 없습니다</li>");
} else if (re_step.length()<=0) {
	out.println("<li>re_step이 없습니다</li>");
} else if (re_lvl.length()<=0) {
	out.println("<li>re_lvl이 없습니다</li>");
} else {

	%>
	<!doctype html>
	<html lang="ko">
	 <head>
	  <meta charset="UTF-8">
	  <title>답글</title>
	  <script language="javascript" type="text/javascript" src="./config/js/jquery-3.1.0.js"></script>
	  <script language="javascript" type="text/javascript" src="./config/js/extend.js"></script>
	  <script language="javascript" type="text/javascript" src="./ckeditor/ckeditor.js"></script>
	  <script language="javascript" type="text/javascript">
	  $(document).ready(function(){
		
		CKEDITOR.replace('contents',{
			filebrowserUploadUrl:'upload_ckeditor.jsp'
		});
		
		//var $uname = $("#uname");
		//var $title = $("#title");
		var $pwd = $("#pwd");
		var $pwd2 = $("#pwd2");
		//var $content = $("#content");
		
		/*
		//html4 일때 작성
		//console.log( $uname.getRightPwd() );
		//블라블라 일일이 작성한다
		
		$("#btnOk").on("click",function(e){
			e.preventDefault();
			if (confirm("저장할까요?")) {
				$("#frmBoard").attr({'action':'write_ok.jsp','method':'post'}).submit();
			}
		});
		
		*/


		//html5 required 속성 이용
		$("input, textarea").on('focus, keyup',function(){
			$lval = $(this).ltrim();
			$(this).val($lval);
		});
		
		$("#frmBoard").submit(function(e){
			//e.preventDefault();
			if (!$pwd.getRightPwd($pwd2)) {
				alert("비밀번호가 올바르지 않습니다\n\n1. 영문,숫자,특수문자 조합으로 8~16자이어야합니다\n2. 비밀번호 확인이 다를수 있습니다");
				$pwd2.focus();
				return false;
			}
			if (confirm("저장할까요?")) {
				$("#frmBoard").attr({'action':'reply_ok.jsp'});
			}
		});

		var $idx = $("#idx").val();
		var $Page = $("#Page").val();
		var $SearchOpt = $("#SearchOpt").val();
		var $SearchVal = $("#SearchVal").val();
		var $ref = $("#ref").val();
		var $re_step = $("#re_step").val();
		var $re_lvl = $("#re_lvl").val();

		$("#btnCancel").on("click",function(){
			location.href = "view.jsp?idx="+$idx+"&Page="+$Page+"&SearchOpt="+$SearchOpt+"&SearchVal="+$SearchVal;
		});

	  });
	  </script>
	 </head>
	 <body>

		<form name="frmBoard" id="frmBoard" method="post" enctype="multipart/form-data">
			
			<input type="hidden" name="idx" id="idx" value="<%=idx%>">
			<input type="hidden" name="Page" id="Page" value="<%=Page%>">
			<input type="hidden" name="SearchOpt" id="SearchOpt" value="<%=SearchOpt%>">
			<input type="hidden" name="SearchVal" id="SearchVal" value="<%=SearchVal%>">
			<input type="hidden" name="ref" id="ref" value="<%=ref%>">
			<input type="hidden" name="re_step" id="re_step" value="<%=re_step%>">
			<input type="hidden" name="re_lvl" id="re_lvl" value="<%=re_lvl%>">

			<table border="1">
			<tr>
			<td align="center"><b>글쓴이</b></td>
			<td><input type="text" name="uname" id="uname" value="글쓴利" size="10" maxlength="10" placeholder="글쓴이" autofocus required oninvalid="this.setCustomValidity('글쓴이를 입력하세요')" oninput="setCustomValidity('')"></td>
			</tr>
			<tr>
			<td align="center"><b>제목</b></td>
			<td><input type="text" name="title" id="title" value="제牧" size="30" maxlength="30" placeholder="제목" required oninvalid="this.setCustomValidity('제목을 입력하세요')" oninput="setCustomValidity('')"></td>
			</tr>
			<tr>
			<td align="center"><b>비밀번호</b></td>
			<td><input type="password" name="pwd" id="pwd" value="12345678#a" size="16" minlength="8" maxlength="16" placeholder="비밀번호" required oninvalid="this.setCustomValidity('비밀번호를 입력하세요')" oninput="setCustomValidity('')"></td>
			</tr>
			<tr>
			<td align="center"><b>비번확인</b></td>
			<td><input type="password" name="pwd2" id="pwd2" value="12345678#a" size="16" minlength="8" maxlength="16" placeholder="비밀번호 확인" required oninvalid="this.setCustomValidity('비밀번호 확인을 입력하세요')" oninput="setCustomValidity('')"></td>
			</tr>
			<tr>
			<td align="center"><b>내용</b></td>
			<td><textarea name="contents" id="contents" cols="20" rows="10" required oninvalid="this.setCustomValidity('글내용을 입력하세요')" oninput="setCustomValidity('')">내용내용내용내용내용내용내용내용柰용</textarea></td>
			</tr>
			<tr>
			<td align="center"><b>첨부</b></td>
			<td>
				<input type="file" name="files1" class="file"><br>
				<input type="file" name="files2" class="file">
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
	<%
}
%>