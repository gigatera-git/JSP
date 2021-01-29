package gigatera;

import java.io.File;
import java.util.*;
import java.text.*;

import java.sql.*;
import javax.sql.*;
import javax.naming.*;

import java.util.Date;
import java.text.SimpleDateFormat;

import java.io.PrintWriter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// javac -d . -cp C:\apache-tomcat-8.5.50\lib\servlet-api.jar aUtil.java

public class aUtil {

	public aUtil() throws Exception {
	}

	public String getToday() throws Exception {
		Date now = new Date();
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");

		String today = sf.format(now);

		return today;
	}

	public boolean setUploadFolder(String savepath) throws Exception {
		boolean r = true;

		try {
			File upDir = new File(savepath);
			if (!upDir.exists()) {
				upDir.mkdirs();
			}
		} catch (Exception e) {
			r = false;
		} finally {
			//nothing to do
		}

		return r;
	}


	public String getUniqFname(String savePath, String files0) throws Exception
	{
		String re = files0;
		
		if (files0!=null && files0.length()>0)
		{
			File f = new File(savePath+ File.separator +files0);
			SimpleDateFormat df = new SimpleDateFormat("yyyyMMddmmss");
			String test = df.format(new java.util.Date());
			int idx = files0.lastIndexOf(".");
			String extention = files0.substring(idx);
			String fname = test + extention;
			f.renameTo(new File(savePath+ File.separator +fname));
			re = fname;
		}
		else
		{
			re = "";
		}
		Thread.sleep(500);

		return re;
	}

	public String getCookieValue(HttpServletRequest request, String name) throws Exception
	{ 
		String _value = new String("");
		
		if (name!=null && name.length()>0)
		{
			Cookie[]  cookies = request.getCookies();

			if (cookies != null)
			{
				for (int i=0;i<cookies.length;i++)
				{
					if (cookies[i].getName().equals(name))
					{
						_value = cookies[i].getValue();
						break;
					}
				}
			}
		}

		return _value;

	}

}


