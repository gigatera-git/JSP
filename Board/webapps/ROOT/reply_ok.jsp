<%@ page language="java" session="false" trimDirectiveWhitespaces="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ page import = "java.sql.*"%>
<%@ page import = "javax.sql.*"%>
<%@ page import = "javax.naming.*"%>

<%@ page import = "java.io.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.net.URL" %>

<%@ page import = "javax.imageio.ImageIO"%>
<%@ page import = "java.awt.image.BufferedImage"%>
<%@ page import = "java.awt.Image"%>
<%@ page import = "javax.swing.ImageIcon"%>
<%@ page import = "com.oreilly.servlet.MultipartRequest"%>
<%@ page import = "com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>

<%@ page import = "gigatera.*" %>

<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
if(request.getProtocol().equals("HTTP/1.1"))
   response.setHeader("Cache-Control", "no-cache");
%>

<%
String referer = request.getHeader("referer");
URL urls = new URL(referer);
String reg_ip = request.getRemoteAddr();

if (!(urls.getHost().equals("localhost") && urls.getPath().equals("/reply.jsp"))) {
	out.println("<li>("+reg_ip+")에서 비정상 접근이 감지되었습니다</li>");
} else {
	
	boolean iok = false;
	aUtil autil = new aUtil();

	String savePath = request.getRealPath("upload/" + autil.getToday());
	autil.setUploadFolder(savePath);
	int sizeLimit = 10 * 1024 * 1024 ; //max to 10m

	MultipartRequest multi = new MultipartRequest(request,savePath,sizeLimit,"UTF-8",new DefaultFileRenamePolicy());
	try 
	{
		ArrayList<ArticleUP> articleUP = new ArrayList<ArticleUP>();
		
		Enumeration formNames=SortedEnumeration.createSortedEnumeration(multi.getFileNames());
		while (formNames.hasMoreElements())
		{
			String formName = (String)formNames.nextElement(); 
			String fileName = multi.getFilesystemName(formName); 
			fileName = (fileName==null)?"":fileName.trim();

			String fileRealName = fileName;
			String fileSaveName = autil.getUniqFname(savePath,fileRealName);
			
			if (fileSaveName.length()>0)
			{
				ArticleUP articleup = new ArticleUP();
				articleup.setBidx(0);
				articleup.setFileRealName(fileRealName);
				articleup.setFileSaveName(fileSaveName);
				articleup.setFileType(multi.getContentType(formName));
				articleup.setFileSize(Integer.toString((int)(new File(savePath + "/" + fileSaveName).length())));
				articleup.setReg_ip(reg_ip);

				articleUP.add(articleup);
			}
		}

		//-----------------------------
		String Page = (multi.getParameter("Page")==null)?"":multi.getParameter("Page").trim();
		String SearchOpt = (multi.getParameter("SearchOpt")==null)?"":multi.getParameter("SearchOpt").trim();
		String SearchVal = (multi.getParameter("SearchVal")==null)?"":multi.getParameter("SearchVal").trim();

		String uname = (multi.getParameter("uname")==null)?"":multi.getParameter("uname").trim();
		String title = (multi.getParameter("title")==null)?"":multi.getParameter("title").trim().replace("'","''");
		String pwd = (multi.getParameter("pwd")==null)?"":multi.getParameter("pwd").trim().replace("'","''");
		String pwd2 = (multi.getParameter("pwd2")==null)?"":multi.getParameter("pwd2").trim().replace("'","''");
		String contents = (multi.getParameter("contents")==null)?"":multi.getParameter("contents").trim().replace("'","''");

		String ref = (multi.getParameter("ref")==null)?"":multi.getParameter("ref").trim().replace("'","''");
		String re_step = (multi.getParameter("re_step")==null)?"":multi.getParameter("re_step").trim().replace("'","''");
		String re_lvl = (multi.getParameter("re_lvl")==null)?"":multi.getParameter("re_lvl").trim().replace("'","''");
		//out.println("uname : " + uname + "<br>");
		if (uname.length()<=0) {
			out.println("<li>이름이 없습니다</li>");
		} else if (title.length()<=0) {
			out.println("<li>제목이 없습니다</li>");
		} else if (pwd.length()<=0) {
			out.println("<li>비밀번호가 없습니다</li>");
		} else if (pwd2.length()<=0) {
			out.println("<li>비밀번호 확인이 없습니다</li>");
		} else if (contents.length()<=0) {
			out.println("<li>내용이 없습니다</li>");
		} else if (!pwd.equals(pwd2)) {
			out.println("<li>비밀번호와 비밀번호 확인이 다릅니다</li>");
		} else if (ref.length()<=0) {
			out.println("<li>ref가 없습니다</li>");
		} else if (re_step.length()<=0) {
			out.println("<li>re_step이 없습니다</li>");
		} else if (re_lvl.length()<=0) {
			out.println("<li>re_lvl이 없습니다</li>");
		} else {
			Article article = new Article();
			article.setUname(uname);
			article.setTitle(title);
			article.setPwd(pwd);
			article.setContents(contents);
			article.setRef(Integer.parseInt(ref));
			article.setRe_step(Integer.parseInt(re_step));
			article.setRe_lvl(Integer.parseInt(re_lvl));
			article.setReg_ip(reg_ip);

			Board board = new Board();
			iok = board.setBoardReply(article,articleUP);
		}

		/*
		for (ArticleUP aup:articleUP) {
			out.println(aup.getBidx());
			out.println(aup.getFileRealName());
			out.println(aup.getFileSaveName());
			out.println(aup.getFileType());
			out.println(aup.getFileSize());
			out.println(aup.getReg_ip());
			out.println("<br><br><br>");
		}
		*/
		%>
		<!doctype html>
		<html lang="ko">
		 <head>
		  <meta charset="UTF-8">
		  <title>글쓰기</title>
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
				if (iok) {
					out.println("<li>답글이 정상적으로 등록되었습니다</li>");
				} else {
					out.println("<li>답글처리중 에러가 발생하였습니다. 관리자에게 문의하세요</li>");
				}
				out.println("<li>잠시후 리스트로 이동합니다</li>");
				%>
			</body>
		</html>
		<%

	} 
	catch(Exception ex) 
	{
		out.println("multi Exception:" + ex);
	}

}
%>