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

<%@ page import = "org.json.simple.JSONArray"%>
<%@ page import = "org.json.simple.JSONObject"%>

<%@ page import = "gigatera.*" %>

<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
if(request.getProtocol().equals("HTTP/1.1"))
   response.setHeader("Cache-Control", "no-cache");
%>

<%
aUtil autil = new aUtil();

String savePath = request.getRealPath("upload/" + autil.getToday());
autil.setUploadFolder(savePath);
int sizeLimit = 10 * 1024 * 1024 ; //max to 10m

//for ckeditor
Integer uploaded = new Integer(0);
String fileRealName = new String("");
String fileSaveName = new String("");
String url = new String("");

MultipartRequest multi = new MultipartRequest(request,savePath,sizeLimit,"UTF-8",new DefaultFileRenamePolicy());
try 
{
	Enumeration formNames=SortedEnumeration.createSortedEnumeration(multi.getFileNames());
	while (formNames.hasMoreElements())
	{
		String formName = (String)formNames.nextElement(); 
		String fileName = multi.getFilesystemName(formName); 
		fileName = (fileName==null)?"":fileName.trim();
		
		uploaded = 1;
		fileRealName = fileName;
		fileSaveName = autil.getUniqFname(savePath,fileRealName);
		url = "upload"+ "/" + autil.getToday() + "/" + fileSaveName;
	}

	String[] attachDels = multi.getParameterValues("attachDels");
	Integer i=0;
	for (i=0;i<attachDels.length;i++) {
		out.println("<"+i+">");
		out.println(attachDels[i]);
		out.println("<br>");
	}
} 
catch(Exception ex) 
{
	uploaded = 0;
}


JSONObject jsonObject = new JSONObject();
jsonObject.put("uploaded", uploaded);
jsonObject.put("fileName", fileRealName);
jsonObject.put("url", url);

String jsoninfo = jsonObject.toJSONString();
jsoninfo = jsoninfo.replaceAll("\\\\", "");
out.println(jsoninfo);
%>
