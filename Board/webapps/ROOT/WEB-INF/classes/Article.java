package gigatera;

import java.util.*;
import java.text.*;


//for tbl_board

public class Article
{
	private Integer idx;
	private String uname;
	private String title;
	private String pwd;
	private String contents;
	private Integer click;
	private Integer ref;
	private Integer re_step;
	private Integer re_lvl;
	private String deleted;
	private String reg_ip;
	private String mod_ip;
	private Date reg_date;
	private Date mod_date;
	private String[] attachDels;

	public Integer getIdx() {
		return idx;
	}
	public void setIdx(Integer idx) {
		this.idx = idx;
	}
	public String getUname() {
		return uname;
	}
	public void setUname(String uname) {
		this.uname = uname;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public Integer getClick() {
		return click;
	}
	public void setClick(Integer click) {
		this.click = click;
	}
	public Integer getRef() {
		return ref;
	}
	public void setRef(Integer ref) {
		this.ref = ref;
	}
	public Integer getRe_step() {
		return re_step;
	}
	public void setRe_step(Integer re_step) {
		this.re_step = re_step;
	}
	public Integer getRe_lvl() {
		return re_lvl;
	}
	public void setRe_lvl(Integer re_lvl) {
		this.re_lvl = re_lvl;
	}
	public String getDeleted() {
		return deleted;
	}
	public void setDeleted(String deleted) {
		this.deleted = deleted;
	}
	public String getReg_ip() {
		return reg_ip;
	}
	public void setReg_ip(String reg_ip) {
		this.reg_ip = reg_ip;
	}
	public String getMod_ip() {
		return mod_ip;
	}
	public void setMod_ip(String mod_ip) {
		this.mod_ip = mod_ip;
	}
	public Date getReg_date() {
		return reg_date;
	}
	public void setReg_date(Date reg_date) {
		this.reg_date = reg_date;
	}
	public Date getMod_date() {
		return mod_date;
	}
	public void setMod_date(Date mod_date) {
		this.mod_date = mod_date;
	}

	public String[] getAttachDels() {
		return attachDels;
	}
	public void setAttachDels(String[] attachDels) {
		this.attachDels = attachDels;
	}
	
}