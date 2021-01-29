package gigatera;

import java.util.*;
import java.text.*;

//for tbl_board_upload

public class ArticleUP {

	private Integer bidx;
	private String fileRealName;
	private String fileSaveName;
	private String fileType;
	private String fileSize;
	private String reg_ip;
	private Date reg_date;

	public Integer getBidx() {
		return bidx;
	}
	public void setBidx(Integer bidx) {
		this.bidx = bidx;
	}
	public String getFileRealName() {
		return fileRealName;
	}
	public void setFileRealName(String fileRealName) {
		this.fileRealName = fileRealName;
	}
	public String getFileSaveName() {
		return fileSaveName;
	}
	public void setFileSaveName(String fileSaveName) {
		this.fileSaveName = fileSaveName;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getFileSize() {
		return fileSize;
	}
	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}
	public String getReg_ip() {
		return reg_ip;
	}
	public void setReg_ip(String reg_ip) {
		this.reg_ip = reg_ip;
	}
	public Date getReg_date() {
		return reg_date;
	}
	public void setReg_date(Date reg_date) {
		this.reg_date = reg_date;
	}
	

	public ArticleUP() throws Exception {
	}
}