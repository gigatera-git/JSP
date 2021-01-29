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
String SearchOpt = (request.getParameter("SearchOpt")==null)?"":request.getParameter("SearchOpt").trim().replace("'","''");
String SearchVal = (request.getParameter("SearchVal")==null)?"":request.getParameter("SearchVal").trim().replace("'","''");
String argv="SearchOpt="+SearchOpt+"&SearchVal="+SearchVal;

String Page = (request.getParameter("Page")==null)?"1":request.getParameter("Page").trim().replace("'","''");

ArticlePS articleps = new ArticlePS();
articleps.setIntPage(Integer.parseInt(Page));
articleps.setIntPageSize(10);
articleps.setIntBlockPage(10);
articleps.setSearchOpt(SearchOpt);
articleps.setSearchVal(SearchVal);

Board board = new Board();
board.setPreparePaging(articleps);

ArrayList<Article> boardList = board.getBoardList(articleps);

/*
Date now = new Date();
SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
String today = sf.format(now);
//out.println(today);

String savePath = request.getRealPath("upload/" + today);
//out.println(savePath);

File upDir = new File(savePath);
if (!upDir.exists()) {
	upDir.mkdirs();
}
*/
%>

<!doctype html>
<html lang="ko">
 <head>
  <meta charset="UTF-8">
  <title>리스트</title>
  <script language="javascript" type="text/javascript" src="./config/js/jquery-3.1.0.js"></script>
  <script language="javascript" type="text/javascript" src="./config/js/extend.js"></script>
  <script language="javascript" type="text/javascript">
  $(document).ready(function(){
		
		$("#frmBoard").submit(function(e){
			//e.preventDefault(); //This can interrupt html5 form check system.
			//if (confirm("저장할까요?")) {
				$("#frmBoard").attr({'action':'list.jsp'});
			//}
		});

		$(document).on("click","#btnInit",function(){ //for dynamic event...
			location.href = 'list.jsp';
			//alert('test');
		});

   });
  </script>
 </head>
 <body>

	<form name="frmBoard" id="frmBoard" method="get">
	
	<div id="write">
		[<a href="write.jsp">글등록</a>] ... jsp board with mysql/ckeditor/file upload
	</div>
	<table border="1">
	<tr>
	<td align="center"><b>번호</b></td>
	<td align="center"><b>제목</b></td>
	<td align="center"><b>작성자</b></td>
	<td align="center"><b>클릭수</b></td>
	<td align="center"><b>작성일</b></td>
	</tr>

	<%
	int Cnt = 0;
	for (Article article:boardList) {
		%>
		<tr>
		<td align="center"><%=board.getArticleNum(articleps, Cnt)%></td>
		<td align="left">
		<img src="./images/common/level.gif" border="0" align="absmiddle" width="<%=article.getRe_lvl()*7%>">
		<%if (article.getRe_lvl()>0) {%>
		<img src="./images/common/ico_reply.gif" border="0" align="absmiddle" >
		<%}%>
		<a href="view.jsp?idx=<%=article.getIdx()%>&Page=<%=Page%>&<%=argv%>">
		<%=article.getTitle()%>
		</a>
		</td>
		<td align="center"><%=article.getUname()%></td>
		<td align="center"><%=article.getClick()%></td>
		<td align="center"><%=article.getReg_date()%></td>
		</tr>
		<%
		Cnt++;
	}
	%>
	

	</table>

	<div id="search">
		<select name="SearchOpt" id="SearchOpt" required oninvalid="this.setCustomValidity('검색옵션을 선택하세요')" oninput="setCustomValidity('')">
			<option value=""></option>
			<option value="title" <%if (SearchOpt=="title" && SearchVal!="") { out.println(" selected"); }%>>제목</option>
			<option value="contents" <%if (SearchOpt=="contents" && SearchVal!="") { out.println(" selected"); }%>>내용</option>
		</select>
		<input type="text" name="SearchVal" id="SearchVal" maxlength="10" minlength="2" required oninvalid="this.setCustomValidity('검색어를 입력하세요')" oninput="setCustomValidity('')" value="<%if (SearchOpt!="" && SearchVal!="") { out.println(SearchVal); }%>">
		<input type="submit" value="검색" id="btnSearch" name="btnSearch">
		<%if (SearchOpt!="" && SearchVal!="") { 
			out.println("<input type='button' value='처음' id='btnInit'>");
		}%>
	</div>


	<div id="paging">
		<%=articleps.Paging(argv)%>
	</div>


	</form>

 </body>
</html>


