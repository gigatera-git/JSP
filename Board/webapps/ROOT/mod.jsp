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

<%
String idx = (request.getParameter("idx")==null)?"1":request.getParameter("idx").trim().replace("'","''");
String SearchOpt = (request.getParameter("SearchOpt")==null)?"":request.getParameter("SearchOpt").trim().replace("'","''");
String SearchVal = (request.getParameter("SearchVal")==null)?"":request.getParameter("SearchVal").trim().replace("'","''");
String Page = (request.getParameter("Page")==null)?"1":request.getParameter("Page").trim().replace("'","''");

Board board = new Board();
Article article = board.getBoardView(Integer.parseInt(idx), idx);
ArrayList<ArticleUP> articleUP = board.getBoardUploads(Integer.parseInt(idx));
%>


<!doctype html>
<html lang="ko">
 <head>
  <meta charset="UTF-8">
  <title>글수정</title>
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
	//var $pwd2 = $("#pwd2");
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
		if (!$pwd.getRightPwd()) {
			alert("글 비밀번호가 올바르지 않습니다\n\n1. 영문,숫자,특수문자 조합으로 8~16자이어야합니다");
			$pwd2.focus();
			return false;
		}
		if (confirm("저장할까요?")) {
			$("#frmBoard").attr({'action':'mod_ok.jsp'});
		}
	});

	$("#btnCancel").on("click",function(){
		//history.back();
		location.href = "view.jsp?idx=<%=idx%>&Page=<%=Page%>&SearchOpt=<%=SearchOpt%>&SearchVal=<%=SearchVal%>";
	});

  });
  </script>
  <style type="text/css">
  .attach {
	display:block;
  }
  .attach img {
	width:100px;
	border:1px solid gray;
	margin-right:5px;
  }
  </style>
 </head>
 <body>

	<form name="frmBoard" id="frmBoard" method="post" enctype="multipart/form-data">
		
		<input type="hidden" name="idx" id="idx" value="<%=article.getIdx()%>">
		<input type="hidden" name="Page" id="Page" value="<%=Page%>">
		<input type="hidden" name="SearchOpt" id="SearchOpt" value="<%=SearchOpt%>">
		<input type="hidden" name="SearchVal" id="SearchVal" value="<%=SearchVal%>">

		<table border="1">
		<tr>
		<td align="center"><b>글쓴이</b></td>
		<td><input type="hidden" name="uname" id="uname" value="<%=article.getUname()%>" size="10" maxlength="10" placeholder="글쓴이" autofocus required oninvalid="this.setCustomValidity('글쓴이를 입력하세요')" oninput="setCustomValidity('')">
		<%=article.getUname()%>
		</td>
		</tr>
		<tr>
		<td align="center"><b>제목</b></td>
		<td><input type="text" name="title" id="title" value="<%=article.getTitle()%>" size="30" maxlength="30" placeholder="제목" required oninvalid="this.setCustomValidity('제목을 입력하세요')" oninput="setCustomValidity('')"></td>
		</tr>

		<tr>
		<td align="center"><b>비밀번호</b></td>
		<td><input type="password" name="pwd" id="pwd" value="12345678#a" size="16" minlength="8" maxlength="16" placeholder="비밀번호" required oninvalid="this.setCustomValidity('비밀번호를 입력하세요')" oninput="setCustomValidity('')"></td>
		</tr>

		<tr>
		<td align="center"><b>내용</b></td>
		<td><textarea name="contents" id="contents" cols="20" rows="10" required oninvalid="this.setCustomValidity('글내용을 입력하세요')" oninput="setCustomValidity('')"><%=article.getContents()%></textarea></td>
		</tr>

		<tr>
		<td align="center"><b>첨부</b></td>
		<td>
			<%
			int Cnt = 0;
			for (ArticleUP aup:articleUP) {
				out.println("<div class='attach'>");

				out.println( "("+ String.valueOf(Cnt+1) +")"  );
				if (aup.getFileType().split("/")[0].equals("image")) {
					out.println("<a href='download.jsp?filePath=upload/"+ aup.getReg_date() +"&fileName="+ aup.getFileSaveName() +"'><img src='upload/"+ aup.getReg_date() +"/"+ aup.getFileSaveName() +"' title='"+ aup.getFileRealName() +"' align='absmiddle' /></a>");
				} else {
					out.println("<a href='download.jsp?filePath=upload/"+ aup.getReg_date() +"&fileName="+ aup.getFileSaveName() +"' title='"+ aup.getFileRealName() +"'/>"+ aup.getFileRealName() +"</a>");
				}		
				out.println("<input type='hidden' name='files' class='files' value='"+ aup.getReg_date() +"/"+ aup.getFileSaveName() + "' />");

				out.println("(<input type='checkbox' name='attachDels' class='attachDels' value='"+ aup.getReg_date() +"/"+ aup.getFileSaveName() +"' />삭제)");
				out.println("<br>");
				
				out.println("</div>");

				Cnt++;
			}
			out.println("<input type='hidden' name='attachDels' class='attachDels' value='devnull/devnull.null' />"); //for fake
			
			
			out.println("<hr>");
			for (int i=1;i<=2;i++) {
				out.println("<input type='file' name='files"+i+"' class='file'>");
				out.println("<br>");
			}
			
			%>
		</td>
		</tr>

		</table>
		
		<table border="0">
		<tr>
		<td>
			<input type="submit" value="수정" id="btnOk">
			<input type="button" value="취소" id="btnCancel">
		</td>
		</tr>
		</table>

	</form>
  
 </body>
</html>