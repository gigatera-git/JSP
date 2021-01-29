<%@ page language="java" session="false" trimDirectiveWhitespaces="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ page import = "java.sql.*"%>
<%@ page import = "javax.sql.*"%>
<%@ page import = "javax.naming.*"%>

<%@ page import = "java.io.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.text.SimpleDateFormat" %>

<%@ page import = "javax.servlet.http.Cookie" %>

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

aUtil autil = new aUtil();
String count_done = autil.getCookieValue(request,"count_done");
//out.println("count_done : " + count_done + "<br>");

Board board = new Board();
Article article = board.getBoardView(Integer.parseInt(idx),count_done);
ArrayList<ArticleUP> articleUP = board.getBoardUploads(Integer.parseInt(idx));

if (count_done.length()>0) {
	Cookie info = new Cookie("count_done", idx); 
	response.addCookie(info);  
}
%>

<!doctype html>
<html lang="ko">
 <head>
  <meta charset="UTF-8">
  <title>상세보기</title>
  <script language="javascript" type="text/javascript" src="./config/js/jquery-3.1.0.js"></script>
  <script language="javascript" type="text/javascript" src="./config/js/jquery.bpopup.min.js"></script>
  <script language="javascript" type="text/javascript" src="./config/js/extend.js?v=2020-07-23-001"></script>
  <script language="javascript" type="text/javascript">
  $(document).ready(function(){
		
		var $idx = $("#idx").val();
		var $Page = $("#Page").val();
		var $SearchOpt = $("#SearchOpt").val();
		var $SearchVal = $("#SearchVal").val();
		var $ref = $("#ref").val();
		var $re_step = $("#re_step").val();
		var $re_lvl = $("#re_lvl").val();

		$("#btnList").on("click",function(){
			location.href = "list.jsp?Page="+$Page+"&SearchOpt="+$SearchOpt+"&SearchVal="+$SearchVal;
		});

		$("#btnReply").on("click",function(){
			location.href = "reply.jsp?idx="+$idx+"&Page="+$Page+"&SearchOpt="+$SearchOpt+"&SearchVal="+$SearchVal+"&ref="+$ref+"&re_step="+$re_step+"&re_lvl="+$re_lvl;
		});

		$("#btnDel").on("click",function(){
			$('#popPwd').bPopup(
				{modalClose: true},
				function(){ $("#pwdChk").val('').focus(); }
			);
		});

		$("#btnMod").on("click",function(){
			location.href = "mod.jsp?idx="+$idx+"&Page="+$Page+"&SearchOpt="+$SearchOpt+"&SearchVal="+$SearchVal;
		});

		$("#btnPwdChkOk").on("click",function(e){
			var $res = "";
			var $pwd = $("#pwdChk");
			if (!$pwd.getRightPwd()) {
				alert("비밀번호가 올바르지 않습니다\n\n- 영문,숫자,특수문자 조합으로 8~16자이어야합니다");
				$pwd.focus();
				return false;
			}
			//alert("idx="+$idx+"&pwd="+escape($pwd.val()));
			//location.href = "pwdChk.jsp?idx="+$idx+"&pwd="+escape($pwd.val());
			//return;
			$.ajax({
				type: "GET",
				async: false,
				url: "pwdChk.jsp",
				data: "idx="+$idx+"&pwd="+escape($pwd.val())
			}).fail(function(request,status,error) {  //error
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}).done(function(msg) {
				$res = $.trim(msg);
			});

			//alert($res);return;
			if ($res!='ok') {
				alert("error : " + $res);
			} else {
				alert("비밀번호가 확인되었습니다")
				$("#pwd").val($("#pwdChk").val());
				$("#frmBoard").attr({'action':'del_ok.jsp','method':'post'}).submit();
			}
		});

   });
  </script>
  <style type="text/css">
  #popPwd {
	width:500px;
	height:160px;
	border:1px solid gray;
	display:none;
	background-color:white;
	position:relative;
  }
  #popPwd #bClose {
	position:absolute;
	right:-10px;
	top:-30px;
	font:arial-black;
	font-size:36px;
	font-weight:bold;
	color:black;
	background-color:yellow;
	width:40px;
	height:40px;
	line-height:40px;
	text-align:center;
	cursor:pointer;
  }

  #popPwd #pwdcheckbody {
	margin-left:20px;
	margin-top:20px;
  }

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

	<form name="frmBoard" id="frmBoard">
		<input type="hidden" name="idx" id="idx" value="<%=idx%>">
		<input type="hidden" name="Page" id="Page" value="<%=Page%>">
		<input type="hidden" name="SearchOpt" id="SearchOpt" value="<%=SearchOpt%>">
		<input type="hidden" name="SearchVal" id="SearchVal" value="<%=SearchVal%>">
		<input type="hidden" name="ref" id="ref" value="<%=article.getRef()%>">
		<input type="hidden" name="re_step" id="re_step" value="<%=article.getRe_step()%>">
		<input type="hidden" name="re_lvl" id="re_lvl" value="<%=article.getRe_lvl()%>">
		<input type="hidden" name="pwd" id="pwd" value="">

		<table border="1">
		<tr>
		<td align="center"><b>작성자</b></td><td><%=article.getUname()%></td>
		</tr>
		<tr>
		<td align="center"><b>제목</b></td><td><%=article.getTitle()%></td>
		</tr>
		<tr>
		<td align="center"><b>내용</b></td><td><%=article.getContents()%></td>
		</tr>
		<tr>
		<td align="center"><b>클릭수</b></td><td><%=article.getClick()%></td>
		</tr>
		<tr>
		<td align="center"><b>아이피</b></td><td><%=article.getReg_ip()%></td>
		</tr>
		<tr>
		<td align="center"><b>아이피(m)</b></td><td><%=article.getMod_ip()%></td>
		</tr>
		<tr>
		<td align="center"><b>등록일</b></td><td><%=article.getReg_date()%></td>
		</tr>
		<tr>
		<td align="center"><b>수정일</b></td><td><%=article.getMod_date()%></td>
		</tr>
		<tr>
		<td align="center"><b>첨부파일</b></td><td>
		
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
			
			out.println("</div>");

			Cnt++;
		}
		%>

			
		
		</td>
		</tr>
		</table>
		<div>
			<input type="button" value="리스트" id="btnList" />
			<input type="button" value="답글" id="btnReply" />
			<input type="button" value="수정" id="btnMod" alt="수정" />
			<input type="button" value="삭제" id="btnDel" alt="삭제" />
		</div>

		<div id="popPwd" class="b-close">
			<div id="bClose" class="b-close">
				X
			</div>
			<div id="pwdcheckbody">
				<b>● 비밀번호 확인</b> <br><br>
				해당글 삭제를 위해 글 비밀번호를 입력하세요<br><br>

				<input type="password" name="pwdChk" id="pwdChk" value="" placeholder="비밀번호" minlength="8" maxlength="16">
				<input type="button" value="확인" id="btnPwdChkOk">
			</div>
		</div>

	</form>
  
 </body>
</html>
