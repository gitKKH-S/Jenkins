package com.mten.bylaw.law.controller;

import java.util.ArrayList;

public class LawBean {
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
	
	public String getTotal() {
		return total;
	}
	public void setTotal(String total) {
		this.total = total;
	}
	public String getKeword() {
		return keword;
	}
	public void setKeword(String keword) {
		this.keword = keword;
	}
	public ArrayList getXmlList() {
		return xmlList;
	}
	public void setXmlList(ArrayList xmlList) {
		this.xmlList = xmlList;
	}
	public String getOC() {
		return OC;
	}
	public void setOC(String oc) {
		OC = oc;
	}
	public String getTarget() {
		return target;
	}
	public void setTarget(String target) {
		this.target = target;
	}
	public String getSearch() {
		return search;
	}
	public void setSearch(String search) {
		this.search = search;
	}
	public String getQuery() {
		return query;
	}
	public void setQuery(String query) {
		this.query = query;
	}
	public String getDisplay() {
		return display;
	}
	public void setDisplay(String display) {
		this.display = display;
	}
	public String getPage() {
		return page;
	}
	public void setPage(String page) {
		this.page = page;
	}
	public String getSort() {
		return sort;
	}
	public void setSort(String sort) {
		this.sort = sort;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getEfYd() {
		return efYd;
	}
	public void setEfYd(String efYd) {
		this.efYd = efYd;
	}
	public String getAncYd() {
		return ancYd;
	}
	public void setAncYd(String ancYd) {
		this.ancYd = ancYd;
	}
	public String getAncNo() {
		return ancNo;
	}
	public void setAncNo(String ancNo) {
		this.ancNo = ancNo;
	}
	public String getOrg() {
		return org;
	}
	public void setOrg(String org) {
		this.org = org;
	}
	public String getKnd() {
		return knd;
	}
	public void setKnd(String knd) {
		this.knd = knd;
	}
	public String getNw() {
		return nw;
	}
	public void setNw(String nw) {
		this.nw = nw;
	}
	public String getRrClsCd() {
		return rrClsCd;
	}
	public void setRrClsCd(String rrClsCd) {
		this.rrClsCd = rrClsCd;
	}
	public String getOrdinFd() {
		return ordinFd;
	}
	public void setOrdinFd(String ordinFd) {
		this.ordinFd = ordinFd;
	}
	public String getGana() {
		return gana;
	}
	public void setGana(String gana) {
		this.gana = gana;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
}
