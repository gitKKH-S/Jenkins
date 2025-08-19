package com.mten.bylaw.mif.serviceSch;

import java.util.ArrayList;

public class Lawif {
	private String OC;			//기관코드
	private String target;		//서비스대상
	private String search;	//검색범위(1:자치법규명,2:본문검색)
	private String query;	//검색범위에서 검색을 원하는 질의(default=*)
	private String display;	//검색된 결과 개수 (default=20)
	private String page;	//검색 결과 페이지 (default=1)
	private String sort;	//정렬옵션(기본 : lasc 자치법규오름차순) ldes:자치법규내림차순,dasc:공포일자 오름차순,ddes:공포일자 내림차순,nasc:공포번호 오름차순,ndes:공포번호 내림차순 
	private String date;	//자치법규 공포일자 검색
	private String efYd;	//시행일자 범위 검색(20090101~20090130)
	private String ancYd;	//공포일자 범위 검색(20090101~20090130)
	private String ancNo;	//공포번호 범위 검색(306~400)
	private String org;	//소관부처별 검색(소관부처코드 제공)
	private String knd;	//법령종류(코드제공)
	private String nw;	//기본 현행, 연혁=1 시행예정=2 현행 = 3 현행+연혁 = 4
	private String rrClsCd;	//법령 제개정 종류(300201-제정/300202-일부개정/300203-전부개정/300204-폐지..)
	private String ordinFd;	//분류코드별 검색. 분류코드는 지자체 분야코드 openAPI 참조 
	private String gana;	//사전식 검색(ga,na,da…,etc)
	private String type;	//출력 형태생략(기본값:XML) HTML : HTML
	private String total;
	private String keword;
	private ArrayList xmlList;
	
	// lawkorea 테이블의 컬럼
	private String id;
	private String lawnum;
	private String promuldt;
	private String promulno;
	private String cs7;
	private String synonym2;
	private String lawname;
	
	// lawkoreaxml 테이블의 컬럼
	
	private String lawid;
	private String statecd;
	private String lawdept;
	private String lawgbn;
	private String lawcd;
	private String startdt;
	private String lawurl;
	private String xmlfilepath;
	private String orderlaw;
	private String lawkey;
	private String updt;
	
	
	private String biz_key;
	private String formname;
	private String snddeptcd;
	private String sndempcd;
	private String titlevalue;
	private String datavalue;
	private String datacont;
	private String aprvstatus;
	private String eaireceived;
	private String gbn;
	private String lawbon;
	
	private String lawsid;
	private String revcd;
	private String deptcode;
	private String dept;
	private String otherlawyn;
	private String insertdt;
	private byte[] filecontent;
	private String num;
	private String subnum;
	private String byultitle;
	private String byulgbn;
	private String byulkey;
	private String plawsid;
	private String bylawid;
	private String pbylawid;
	private String revcha;
	private String bylawno;
	private String bylawname;
	private String bylawcd;
	private String appointdt;
	private String appointno;
	private String bylawdept;
	private String revcdcode;
	private String bylawdid;
	private String bylawurl;
	private String newdt;
	private String bylawbon;
	private String sfilenm;
	
	public String getSfilenm() {
		return sfilenm;
	}
	public void setSfilenm(String sfilenm) {
		if (sfilenm == null) {
			sfilenm = "";
		}
		this.sfilenm = sfilenm;
	}
	public String getPlawsid() {
		return plawsid;
	}
	public void setPlawsid(String plawsid) {
		if (plawsid == null) {
			plawsid = "";
		}
		this.plawsid = plawsid;
	}
	public String getBylawid() {
		return bylawid;
	}
	public void setBylawid(String bylawid) {
		if (bylawid == null) {
			bylawid = "";
		}
		this.bylawid = bylawid;
	}
	public String getPbylawid() {
		return pbylawid;
	}
	public void setPbylawid(String pbylawid) {
		if (pbylawid == null) {
			pbylawid = "";
		}
		this.pbylawid = pbylawid;
	}
	public String getRevcha() {
		return revcha;
	}
	public void setRevcha(String revcha) {
		if (revcha == null) {
			revcha = "";
		}
		this.revcha = revcha;
	}
	public String getBylawno() {
		return bylawno;
	}
	public void setBylawno(String bylawno) {
		if (bylawno == null) {
			bylawno = "";
		}
		this.bylawno = bylawno;
	}
	public String getBylawname() {
		return bylawname;
	}
	public void setBylawname(String bylawname) {
		if (bylawname == null) {
			bylawname = "";
		}
		this.bylawname = bylawname;
	}
	public String getBylawcd() {
		return bylawcd;
	}
	public void setBylawcd(String bylawcd) {
		if (bylawcd == null) {
			bylawcd = "";
		}
		this.bylawcd = bylawcd;
	}
	public String getAppointdt() {
		return appointdt;
	}
	public void setAppointdt(String appointdt) {
		if (appointdt == null) {
			appointdt = "";
		}
		this.appointdt = appointdt;
	}
	public String getAppointno() {
		return appointno;
	}
	public void setAppointno(String appointno) {
		if (appointno == null) {
			appointno = "";
		}
		this.appointno = appointno;
	}
	public String getBylawdept() {
		return bylawdept;
	}
	public void setBylawdept(String bylawdept) {
		if (bylawdept == null) {
			bylawdept = "";
		}
		this.bylawdept = bylawdept;
	}
	public String getRevcdcode() {
		return revcdcode;
	}
	public void setRevcdcode(String revcdcode) {
		if (revcdcode == null) {
			revcdcode = "";
		}
		this.revcdcode = revcdcode;
	}
	public String getBylawdid() {
		return bylawdid;
	}
	public void setBylawdid(String bylawdid) {
		if (bylawdid == null) {
			bylawdid = "";
		}
		this.bylawdid = bylawdid;
	}
	public String getBylawurl() {
		return bylawurl;
	}
	public void setBylawurl(String bylawurl) {
		if (bylawurl == null) {
			bylawurl = "";
		}
		this.bylawurl = bylawurl;
	}
	public String getNewdt() {
		return newdt;
	}
	public void setNewdt(String newdt) {
		if (newdt == null) {
			newdt = "";
		}
		this.newdt = newdt;
	}
	public String getBylawbon() {
		return bylawbon;
	}
	public void setBylawbon(String bylawbon) {
		if (bylawbon == null) {
			bylawbon = "";
		}
		this.bylawbon = bylawbon;
	}
	public String getByulkey() {
		return byulkey;
	}
	public void setByulkey(String byulkey) {
		if (byulkey == null) {
			byulkey = "";
		}
		this.byulkey = byulkey;
	}
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		if (num == null) {
			num = "";
		}
		this.num = num;
	}
	public String getSubnum() {
		return subnum;
	}
	public void setSubnum(String subnum) {
		if (subnum == null) {
			subnum = "";
		}
		this.subnum = subnum;
	}
	public String getByultitle() {
		return byultitle;
	}
	public void setByultitle(String byultitle) {
		if (byultitle == null) {
			byultitle = "";
		}
		this.byultitle = byultitle;
	}
	public String getByulgbn() {
		return byulgbn;
	}
	public void setByulgbn(String byulgbn) {
		if (byulgbn == null) {
			byulgbn = "";
		}
		this.byulgbn = byulgbn;
	}
	public byte[] getFilecontent() {
		return filecontent;
	}
	public void setFilecontent(byte[] filecontent) {
		this.filecontent = filecontent;
	}
	public String getLawsid() {
		return lawsid;
	}
	public void setLawsid(String lawsid) {
		if (lawsid == null) {
			lawsid = "";
		}
		this.lawsid = lawsid;
	}
	public String getRevcd() {
		return revcd;
	}
	public void setRevcd(String revcd) {
		if (revcd == null) {
			revcd = "";
		}
		this.revcd = revcd;
	}
	public String getDeptcode() {
		return deptcode;
	}
	public void setDeptcode(String deptcode) {
		if (deptcode == null) {
			deptcode = "";
		}
		this.deptcode = deptcode;
	}
	public String getDept() {
		return dept;
	}
	public void setDept(String dept) {
		if (dept == null) {
			dept = "";
		}
		this.dept = dept;
	}
	public String getOtherlawyn() {
		return otherlawyn;
	}
	public void setOtherlawyn(String otherlawyn) {
		if (otherlawyn == null) {
			otherlawyn = "";
		}
		this.otherlawyn = otherlawyn;
	}
	public String getInsertdt() {
		return insertdt;
	}
	public void setInsertdt(String insertdt) {
		if (insertdt == null) {
			insertdt = "";
		}
		this.insertdt = insertdt;
	}
	public String getLawbon() {
		return lawbon;
	}
	public void setLawbon(String lawbon) {
		if (lawbon == null) {
			lawbon = "";
		}
		this.lawbon = lawbon;
	}
	//국회 연계
	private String lawtitle;
	private String lawdate;
	
	public String getLawtitle() {
		return lawtitle;
	}
	public void setLawtitle(String lawtitle) {
		this.lawtitle = lawtitle;
	}
	public String getLawdate() {
		return lawdate;
	}
	public void setLawdate(String lawdate) {
		this.lawdate = lawdate;
	}
	
	public String getGbn() {
		return gbn;
	}
	public void setGbn(String gbn) {
		this.gbn = gbn;
	}
	public String getFormname() {
		return formname;
	}
	public void setFormname(String formname) {
		this.formname = formname;
	}
	public String getSnddeptcd() {
		return snddeptcd;
	}
	public void setSnddeptcd(String snddeptcd) {
		this.snddeptcd = snddeptcd;
	}
	public String getSndempcd() {
		return sndempcd;
	}
	public void setSndempcd(String sndempcd) {
		this.sndempcd = sndempcd;
	}
	public String getTitlevalue() {
		return titlevalue;
	}
	public void setTitlevalue(String titlevalue) {
		this.titlevalue = titlevalue;
	}
	public String getDatavalue() {
		return datavalue;
	}
	public void setDatavalue(String datavalue) {
		this.datavalue = datavalue;
	}
	public String getDatacont() {
		return datacont;
	}
	public void setDatacont(String datacont) {
		this.datacont = datacont;
	}
	public String getAprvstatus() {
		return aprvstatus;
	}
	public void setAprvstatus(String aprvstatus) {
		this.aprvstatus = aprvstatus;
	}
	public String getEaireceived() {
		return eaireceived;
	}
	public void setEaireceived(String eaireceived) {
		this.eaireceived = eaireceived;
	}
	public String getBiz_key() {
		return biz_key;
	}
	public void setBiz_key(String bizKey) {
		biz_key = bizKey;
	}
	public String getLawcd() {
		return lawcd;
	}
	public void setLawcd(String lawcd) {
		this.lawcd = lawcd;
	}
	public String getLawdept() {
		return lawdept;
	}
	public void setLawdept(String lawdept) {
		this.lawdept = lawdept;
	}
	public String getLawgbn() {
		return lawgbn;
	}
	public void setLawgbn(String lawgbn) {
		this.lawgbn = lawgbn;
	}
	public String getLawid() {
		return lawid;
	}
	public void setLawid(String lawid) {
		this.lawid = lawid;
	}
	public String getLawkey() {
		return lawkey;
	}
	public void setLawkey(String lawkey) {
		this.lawkey = lawkey;
	}
	public String getLawurl() {
		return lawurl;
	}
	public void setLawurl(String lawurl) {
		this.lawurl = lawurl;
	}
	public String getOrderlaw() {
		return orderlaw;
	}
	public void setOrderlaw(String orderlaw) {
		this.orderlaw = orderlaw;
	}
	public String getStartdt() {
		return startdt;
	}
	public void setStartdt(String startdt) {
		this.startdt = startdt;
	}
	public String getStatecd() {
		return statecd;
	}
	public void setStatecd(String statecd) {
		this.statecd = statecd;
	}
	public String getUpdt() {
		return updt;
	}
	public void setUpdt(String updt) {
		this.updt = updt;
	}
	public String getXmlfilepath() {
		return xmlfilepath;
	}
	public void setXmlfilepath(String xmlfilepath) {
		this.xmlfilepath = xmlfilepath;
	}
	public String getAncNo() {
		return ancNo;
	}
	public void setAncNo(String ancNo) {
		this.ancNo = ancNo;
	}
	public String getAncYd() {
		return ancYd;
	}
	public void setAncYd(String ancYd) {
		this.ancYd = ancYd;
	}
	public String getCs7() {
		return cs7;
	}
	public void setCs7(String cs7) {
		this.cs7 = cs7;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getDisplay() {
		return display;
	}
	public void setDisplay(String display) {
		this.display = display;
	}
	public String getEfYd() {
		return efYd;
	}
	public void setEfYd(String efYd) {
		this.efYd = efYd;
	}
	public String getGana() {
		return gana;
	}
	public void setGana(String gana) {
		this.gana = gana;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getLawnum() {
		return lawnum;
	}
	public void setLawnum(String lawnum) {
		this.lawnum = lawnum;
	}
	public String getKeword() {
		return keword;
	}
	public void setKeword(String keword) {
		this.keword = keword;
	}
	public String getKnd() {
		return knd;
	}
	public void setKnd(String knd) {
		this.knd = knd;
	}
	public String getLawname() {
		return lawname;
	}
	public void setLawname(String lawname) {
		this.lawname = lawname;
	}
	public String getNw() {
		return nw;
	}
	public void setNw(String nw) {
		this.nw = nw;
	}
	public String getOC() {
		return OC;
	}
	public void setOC(String oc) {
		OC = oc;
	}
	public String getOrdinFd() {
		return ordinFd;
	}
	public void setOrdinFd(String ordinFd) {
		this.ordinFd = ordinFd;
	}
	public String getOrg() {
		return org;
	}
	public void setOrg(String org) {
		this.org = org;
	}
	public String getPage() {
		return page;
	}
	public void setPage(String page) {
		this.page = page;
	}
	public String getPromuldt() {
		return promuldt;
	}
	public void setPromuldt(String promuldt) {
		this.promuldt = promuldt;
	}
	public String getPromulno() {
		return promulno;
	}
	public void setPromulno(String promulno) {
		this.promulno = promulno;
	}
	public String getQuery() {
		return query;
	}
	public void setQuery(String query) {
		this.query = query;
	}
	public String getRrClsCd() {
		return rrClsCd;
	}
	public void setRrClsCd(String rrClsCd) {
		this.rrClsCd = rrClsCd;
	}
	public String getSearch() {
		return search;
	}
	public void setSearch(String search) {
		this.search = search;
	}
	public String getSort() {
		return sort;
	}
	public void setSort(String sort) {
		this.sort = sort;
	}
	public String getSynonym2() {
		return synonym2;
	}
	public void setSynonym2(String synonym2) {
		this.synonym2 = synonym2;
	}
	public String getTarget() {
		return target;
	}
	public void setTarget(String target) {
		this.target = target;
	}
	public String getTotal() {
		return total;
	}
	public void setTotal(String total) {
		this.total = total;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public ArrayList getXmlList() {
		return xmlList;
	}
	public void setXmlList(ArrayList xmlList) {
		this.xmlList = xmlList;
	}
	
	
	
}
