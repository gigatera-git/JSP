package gigatera;

import java.io.File;
import java.util.*;
import java.text.*;

import java.sql.*;
import javax.sql.*;
import javax.naming.*;

import java.net.URLEncoder;
import java.net.URLDecoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import gigatera.Db.*;

//BOARD -> xxx, I think it is essential

public class Board
{
	public Board() throws Exception {
	}

	public Connection getDb() throws Exception { //********
		Connection conn = null;
		Context init = new InitialContext();
		DataSource ds = (DataSource) init.lookup("java:comp/env/jdbc/nandakim");
		conn = ds.getConnection();

		return conn;
	}

	public void setPreparePaging(ArticlePS articleps) throws Exception {
		
		Connection conn = getDb();

		String qry = "";
		qry = "Select COUNT(*),CEILING((COUNT(*)+0.0)/"+ String.valueOf(articleps.getIntPageSize()) +") "; //String.valueOf***. not toString()
		qry += "from tbl_board ";
		qry += "where idx<>'' ";
		if (articleps.getSearchOpt()!="" && articleps.getSearchVal()!="")
		{
			qry += "and "+ articleps.getSearchOpt() +" like '%" + articleps.getSearchVal() + "%' ";
		}
		Statement st = conn.createStatement();
		ResultSet rs = null;

		rs = st.executeQuery(qry);
		if (rs.next())
		{
			articleps.setIntTotalCount(rs.getInt(1));
			articleps.setIntTotalPage(rs.getInt(2));
		}

		rs.close();
		st.close();
		conn.close(); 
		/*
		This is better than "try with resources"
		*/
	}
	
	public ArrayList<Article> getBoardList(ArticlePS articleps) throws Exception {

		Connection conn = getDb();

		ArrayList<Article> boardList = new ArrayList<Article>();

		String qry = "";
		qry = "Select idx,uname,title,pwd,click,ref,re_step,re_lvl,reg_ip,reg_date ";
		qry += "from tbl_board ";
		qry += "where idx<>'' ";
		if (articleps.getSearchOpt()!="" && articleps.getSearchVal()!="")
		{
			qry += "and "+ articleps.getSearchOpt() +" like '%" + articleps.getSearchVal() + "%' ";
		}
		qry += "order by ref desc, re_step, re_lvl ";
		qry += "limit " + String.valueOf((articleps.getIntPage()-1)*articleps.getIntPageSize()) + ","+String.valueOf(articleps.getIntPageSize())+";";
		
		Statement st = conn.createStatement();
		ResultSet rs = null;

		rs = st.executeQuery(qry);
		while (rs.next())
		{
			Article article = new Article(); //location***
			article.setIdx(rs.getInt("idx"));
			article.setUname(rs.getString("uname"));
			article.setTitle(rs.getString("title"));
			article.setPwd(rs.getString("pwd"));
			article.setClick(rs.getInt("click"));
			article.setRef(rs.getInt("ref"));
			article.setRe_step(rs.getInt("re_step"));
			article.setRe_lvl(rs.getInt("re_lvl"));
			article.setReg_ip(rs.getString("reg_ip"));
			article.setReg_date(rs.getDate("reg_date")); //rs.getTime

			boardList.add(article);
		}

		rs.close();
		st.close();
		conn.close();

		return boardList;
	}

	public Integer getArticleNum(ArticlePS articleps, Integer cnt) {
		return (articleps.getIntTotalCount()-((articleps.getIntPage() - 1) * articleps.getIntPageSize()))-cnt;
	}

	public boolean setBoardInsert(Article article, ArrayList<ArticleUP> articleUP) throws Exception {

		Connection conn = getDb();
		
		boolean re = false;
		Statement st = conn.createStatement();
		ResultSet rs = null;

		String qry = "";
		qry = "SELECT IFNULL(MAX(ref)+1,1) FROM tbl_board;";
		rs = st.executeQuery(qry);
		if (rs.next()) {
			article.setRef(rs.getInt(1));
		}
		rs.close();

		try {
			conn.setAutoCommit(false);

			qry = "";
			qry = "insert into tbl_board(uname,title,pwd,contents,ref,re_step,re_lvl,reg_ip,reg_date) ";
			qry += "values('"+article.getUname()+"','"+article.getTitle()+"',password('"+article.getPwd()+"'),'"+article.getContents()+"','"+article.getRef()+"','"+article.getRe_step()+"','"+article.getRe_lvl()+"','"+article.getReg_ip()+"',now());";
			int cols = st.executeUpdate(qry);

			if (cols>0) {
				qry = "";
				qry = "SELECT last_insert_id()";
				rs = st.executeQuery(qry);
				if (rs.next()) {
					for (ArticleUP aup:articleUP) {
						aup.setBidx(rs.getInt(1));
					}
				}
				rs.close();
			}
			
			qry = "";
			for (ArticleUP aup:articleUP) {
				qry = "insert into tbl_board_upload(bidx,fileRealName,fileSaveName,fileType,fileSize,reg_ip,reg_date) ";
				qry += "values('"+aup.getBidx()+"','"+aup.getFileRealName()+"','"+aup.getFileSaveName()+"','"+aup.getFileType()+"','"+aup.getFileSize()+"','"+aup.getReg_ip()+"',now());";
				cols += st.executeUpdate(qry);
			}

			conn.commit();

			re = true;
		} catch (SQLException se) {
			conn.rollback();
		} finally {
			conn.setAutoCommit(true);
			st.close();
		}

		conn.close();

		return re;
	}


	public Article getBoardView(Integer idx, String count_done) throws Exception {

		Connection conn = getDb();
		
		Article article = new Article();
		Statement st = conn.createStatement();
		ResultSet rs = null;

		String qry = "";
		if (!count_done.equals(String.valueOf(idx))) {
			qry = "";
			qry = "update tbl_board set click=click+1 where idx=" + String.valueOf(idx);
			int cols = st.executeUpdate(qry);
		}

		qry = "";
		qry = "select idx,uname,title,contents,pwd,click,ref,re_step,re_lvl,reg_ip,reg_date,mod_ip,mod_date ";
		qry += "from tbl_board ";
		qry += "where idx=" + String.valueOf(idx);
		rs = st.executeQuery(qry);
		if (rs.next()) {
			article.setIdx(rs.getInt("idx"));
			article.setUname(rs.getString("uname"));
			article.setTitle(rs.getString("title"));
			article.setContents(rs.getString("contents"));
			//article.setPwd(rs.getString("pwd"));
			article.setClick(rs.getInt("click"));
			article.setRef(rs.getInt("ref"));
			article.setRe_step(rs.getInt("re_step"));
			article.setRe_lvl(rs.getInt("re_lvl"));
			article.setReg_ip(rs.getString("reg_ip"));
			article.setReg_date(rs.getDate("reg_date"));
			article.setMod_ip(rs.getString("mod_ip"));
			article.setMod_date(rs.getDate("mod_date"));
		}

		rs.close();
		st.close();
		conn.close();

		return article;

	}

	public ArrayList<ArticleUP> getBoardUploads(Integer bidx) throws Exception {

		Connection conn = getDb();

		ArrayList<ArticleUP> articleUP = new ArrayList<ArticleUP>();

		Statement st = conn.createStatement();
		ResultSet rs = null;

		String qry = "";
		qry = "select bidx,fileRealName,fileSaveName,fileType,fileSize,reg_ip,reg_date ";
		qry += "from tbl_board_upload ";
		qry += "where bidx="+String.valueOf(bidx)+" order by idx desc limit 2;";
		rs = st.executeQuery(qry);

		while (rs.next()) {
			ArticleUP articleup = new ArticleUP();
			articleup.setBidx(rs.getInt("bidx"));
			articleup.setFileRealName(rs.getString("fileRealName"));
			articleup.setFileSaveName(rs.getString("fileSaveName"));
			articleup.setFileType(rs.getString("fileType"));
			articleup.setFileSize(rs.getString("fileSize"));
			articleup.setReg_ip(rs.getString("reg_ip"));
			articleup.setReg_date(rs.getDate("reg_date"));
	
			articleUP.add(articleup);
		}

		rs.close();
		st.close();
		conn.close();		

		return articleUP;
	}

	public Integer getCheckPwd(Integer idx,String pwd) throws Exception {
		String qry = "";
		int cols = 0;

		Connection conn = getDb();
		Statement st = conn.createStatement();
		ResultSet rs = null;
		
		try {
			qry = "";
			qry = "select count(idx) from tbl_board where idx="+String.valueOf(idx)+" and pwd=PASSWORD('"+ URLDecoder.decode(pwd,"UTF-8") +"');";
			rs = st.executeQuery(qry);
			if (rs.next()) {
				cols = rs.getInt(1);
			}
		} catch (Exception e) {
			cols = 0;
		} finally {
			rs.close();
			st.close();
			conn.close();
		}		

		return cols;
	}

	public boolean setBoardFileDelOk(Integer bidx, HttpServletRequest request) throws Exception {
		
		//String uploadPath = "C:\\apache-tomcat-8.5.50\\webapps\\ROOT\\";

		String qry = "";
		boolean re = true;

		Connection conn = getDb();
		Statement st = conn.createStatement();
		ResultSet rs = null;
		
		try {
			qry = "";
			qry = "select fileSaveName,reg_date from tbl_board_upload where bidx="+String.valueOf(bidx)+";";
			rs = st.executeQuery(qry);
			while (rs.next()) {
				String savefile = "upload/" + rs.getDate("reg_date") + "/" + rs.getString("fileSaveName");
				//String realfile = uploadPath + File.separator + savefile.replace("/", File.separator);
				String realfile = request.getSession().getServletContext().getRealPath(savefile);
				//String realfile = request.getRealPath(savefile); //deprecated
				File file = new File(realfile);
				if (file.exists()) {
					file.delete();
				}
				file = null;
			}
		} catch (Exception e) {
			re = false;
		} finally {
			rs.close();
			st.close();
			conn.close();
		}

		return re;
	}

	public boolean setBoardDelOk(Integer idx) throws Exception {

		String qry = "";
		int cols = 0;
		boolean re = true;

		Connection conn = getDb();
		Statement st = conn.createStatement();
		
		try {
			conn.setAutoCommit(false);

			qry = "";
			qry = "delete from tbl_board_upload where bidx="+String.valueOf(idx)+";";
			cols += st.executeUpdate(qry);

			qry = "";
			qry = "delete from tbl_board where idx="+String.valueOf(idx)+";";
			cols += st.executeUpdate(qry);

			conn.commit();

			conn.setAutoCommit(true);
		} catch (Exception e) {
			conn.rollback();
			re = false;
		} finally {
			st.close();
			conn.close();
		}
			
		return re;
	}


	public boolean setBoardReply(Article article, ArrayList<ArticleUP> articleUP) throws Exception {

		Connection conn = getDb();
		
		boolean re = false;
		Statement st = conn.createStatement();
		ResultSet rs = null;

		String qry = "";

		try {
			conn.setAutoCommit(false);

			qry = "";
			qry = "Update tbl_board SET re_step=re_step+1 where ref="+article.getRef()+" AND re_step > "+article.getRe_step()+";";
			st.executeUpdate(qry);

			qry = "";
			qry = "insert into tbl_board(uname,title,pwd,contents,ref,re_step,re_lvl,reg_ip,reg_date) ";
			qry += "values('"+article.getUname()+"','"+article.getTitle()+"',password('"+article.getPwd()+"'),'"+article.getContents()+"','"+article.getRef()+"','"+(article.getRe_step()+1)+"','"+(article.getRe_lvl()+1)+"','"+article.getReg_ip()+"',now());";
			int cols = st.executeUpdate(qry);

			if (cols>0) {
				qry = "";
				qry = "SELECT last_insert_id()";
				rs = st.executeQuery(qry);
				if (rs.next()) {
					for (ArticleUP aup:articleUP) {
						aup.setBidx(rs.getInt(1));
					}
				}
				rs.close();
			}
			
			qry = "";
			for (ArticleUP aup:articleUP) {
				qry = "insert into tbl_board_upload(bidx,fileRealName,fileSaveName,fileType,fileSize,reg_ip,reg_date) ";
				qry += "values('"+aup.getBidx()+"','"+aup.getFileRealName()+"','"+aup.getFileSaveName()+"','"+aup.getFileType()+"','"+aup.getFileSize()+"','"+aup.getReg_ip()+"',now());";
				cols += st.executeUpdate(qry);
			}

			conn.commit();

			re = true;
		} catch (SQLException se) {
			conn.rollback();
		} finally {
			conn.setAutoCommit(true);
			st.close();
		}

		conn.close();

		return re;
	}



	public Integer setBoardUpdate(Article article, ArrayList<ArticleUP> articleUP, HttpServletRequest request) throws Exception {

		Connection conn = getDb();
		
		Integer re = 0;
		Statement st = conn.createStatement();
		ResultSet rs = null;
		String qry = "";

		qry = "";
		qry = "select count(idx) from tbl_board where idx="+String.valueOf(article.getIdx())+" and pwd=PASSWORD('"+ URLDecoder.decode(article.getPwd(),"UTF-8") +"');";
		rs = st.executeQuery(qry);
		if (rs.next()) {
			if (rs.getInt(1)<=0) {
				re = 1; //incorrect password
			}
		}
		rs.close();
		
		if (re==0) {
			try {
				conn.setAutoCommit(false);

				for (ArticleUP aup:articleUP) {
					aup.setBidx(article.getIdx());
				}

				for (String attach:article.getAttachDels()) {  //   2020-09-01/202009015142.txt
					String savefile = "upload/" + attach;
					String realfile = request.getSession().getServletContext().getRealPath(savefile);
					File file = new File(realfile);
					if (file.exists()) {
						file.delete();
					}
					file = null;

					qry = "";
					qry = "delete from tbl_board_upload where fileSaveName='"+ attach.split("/")[1] +"';";
					st.executeUpdate(qry);
				}

				qry = "";
				qry = "update tbl_board set ";
				qry += "title='"+article.getTitle()+"',";
				qry += "contents='"+article.getContents()+"',";
				qry += "mod_ip='"+article.getMod_ip()+"',";
				qry += "mod_date=now() ";
				qry += "where idx="+article.getIdx()+";";
				int cols = st.executeUpdate(qry);

				if (cols>0) {
					qry = "";
					for (ArticleUP aup:articleUP) {
						qry = "insert into tbl_board_upload(bidx,fileRealName,fileSaveName,fileType,fileSize,reg_ip,reg_date) ";
						qry += "values('"+aup.getBidx()+"','"+aup.getFileRealName()+"','"+aup.getFileSaveName()+"','"+aup.getFileType()+"','"+aup.getFileSize()+"','"+aup.getReg_ip()+"',now());";
						cols += st.executeUpdate(qry);
					}
				}

				conn.commit();

				re = 0; //success
			} catch (SQLException se) {
				conn.rollback();
				re = 2; //query error
			} finally {
				conn.setAutoCommit(true);
				st.close();
			}
		}

		conn.close();

		return re;
	}


}