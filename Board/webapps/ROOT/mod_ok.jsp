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
String referer = request.getHeader("referer");
URL urls = new URL(referer);
String mod_ip = request.getRemoteAddr();

if (!(urls.getHost().equals("localhost") && urls.getPath().equals("/mod.jsp"))) {
	out.println("<li>("+mod_ip+")에서 비정상 접근이 감지되었습니다</li>");
} else {
	
	Integer iok = -1;
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
				articleup.setReg_ip(mod_ip);

				articleUP.add(articleup);
			}
		}

		//-----------------------------
		String Page = (multi.getParameter("Page")==null)?"":multi.getParameter("Page").trim();
		String SearchOpt = (multi.getParameter("SearchOpt")==null)?"":multi.getParameter("SearchOpt").trim();
		String SearchVal = (multi.getParameter("SearchVal")==null)?"":multi.getParameter("SearchVal").trim();

		String idx = (multi.getParameter("idx")==null)?"":multi.getParameter("idx").trim();
		String uname = (multi.getParameter("uname")==null)?"":multi.getParameter("uname").trim();
		String title = (multi.getParameter("title")==null)?"":multi.getParameter("title").trim().replace("'","''");
		String pwd = (multi.getParameter("pwd")==null)?"":multi.getParameter("pwd").trim().replace("'","''");
		String contents = (multi.getParameter("contents")==null)?"":multi.getParameter("contents").trim().replace("'","''");

		String[] attachDels = multi.getParameterValues("attachDels");
		//out.println("uname : " + uname + "<br>");
		if (idx.length()<=0) {
			out.println("<li>글번호가 없습니다</li>");
		} else if (uname.length()<=0) {
			out.println("<li>이름이 없습니다</li>");
		} else if (title.length()<=0) {
			out.println("<li>제목이 없습니다</li>");
		} else if (pwd.length()<=0) {
			out.println("<li>비밀번호가 없습니다</li>");
		} else if (contents.length()<=0) {
			out.println("<li>내용이 없습니다</li>");
		} else {
			Article article = new Article();
			article.setIdx(Integer.parseInt(idx));
			article.setUname(uname);
			article.setTitle(title);
			article.setPwd(URLEncoder.encode(pwd,"UTF-8"));
			article.setContents(contents);
			article.setMod_ip(mod_ip);
			article.setAttachDels(attachDels);

			Board board = new Board();
			iok = board.setBoardUpdate(article,articleUP,request);
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
		  <title>글수정</title>
		  <script language="javascript" type="text/javascript" src="./config/js/jquery-3.1.0.js"></script>
		  <script language="javascript" type="text/javascript" src="./config/js/extend.js"></script>
		  <script language="javascript" type="text/javascript">
			$(document).ready(function(){
				setTimeout(function(){
					location.href = "view.jsp?idx=<%=idx%>&Page=<%=Page%>&SearchOpt=<%=SearchOpt%>&SearchVal=<%=SearchVal%>";
				},5000);
			});
		  </script>
		 </head>
			<body>
				<%
				if (iok==0) {
					out.println("<li>정상적으로 수정되었습니다</li>");
			    } else if (iok==1) {
					out.println("<li>비밀번호가 일치하지 않습니다</li>");
				} else {
					out.println("<li>수정처리중 에러가 발생하였습니다. 관리자에게 문의하세요</li>");
				}
				out.println("<li>잠시후 이동합니다</li>");
				%>
			</body>
		</html>
		<%

	} 
	catch(Exception ex) 
	{
		out.println("MultipartRequest multi Exception:" + ex);
	}
}
%>