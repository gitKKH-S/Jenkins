package com.mten.bylaw.consult;

import java.text.DecimalFormat;

public class StringUtil {
	public static String enterToBr(String origText){
		if(origText==null){
			return "";
		}
		return origText.trim().replaceAll("\n", "<br/>");
	}
	public static String changeSpStr(String origText){
		if(origText==null){
			return "";
		}
		return origText.trim()
			.replaceAll("###nbsp;", " ")
			.replaceAll("###lt;", "&lt;")
			.replaceAll("###gt;", "&gt;")
			.replaceAll("###amp;", "&")
			.replaceAll("###quot;", "\"")
			.replaceAll("###ldquo;", "\"")
			.replaceAll("###rdquo;", "\"")
			.replaceAll("###lsquo;", "'")			
			.replaceAll("###rsquo;", "'") 
			.replaceAll("</WORKG>", "")
			.replaceAll("<PRELAW>", "")
			.replaceAll("</PRELAW>", "")
			.replaceAll("<NOWLAW>", "")
			.replaceAll("</NOWLAW>", "")
			.replaceAll("<BR/>", "\n");
	}
	public static String changeSpStr2(String origText){
		if(origText==null){
			return "";
		}
		return origText.trim()
			.replaceAll("###nbsp;", " ")
			.replaceAll("###lt;", "&lt;")
			.replaceAll("###gt;", "&gt;")
			.replaceAll("###amp;", "&")
			.replaceAll("###quot;", "&quot;")
			.replaceAll("###ldquo;", "&quot;")
			.replaceAll("###rdquo;", "&quot;")
			.replaceAll("###lsquo;", "'")			
			.replaceAll("###rsquo;", "'") 
			.replaceAll("</WORKG>", "")
			.replaceAll("<PRELAW>", "")
			.replaceAll("</PRELAW>", "")
			.replaceAll("<NOWLAW>", "")
			.replaceAll("</NOWLAW>", "")
			.replaceAll("<BR/>", "\n");
	}
	public static String chgstr(String orgStr){
		if(orgStr==null){
			return "";
		}
		orgStr = orgStr.replaceAll("&quot;","\"")
					.replaceAll("&rdquo;","\"")
					.replaceAll("&ldquo;","\"")
					.replaceAll("&beta;","β")
					.replaceAll("&times;","×")
					.replaceAll("&gt;",">")
					.replaceAll("&lt;","<")
					.replaceAll("&middot;","·")
					.replaceAll("&nbsp;","")
					.replaceAll("<p>","")
					.replaceAll("</p>","")
					.replaceAll("&sim;","~")
					.replaceAll("&rArr;","⇒");
		return orgStr;
	}

	public static String changeToDBDate(String date) {
		if (!null2space(date).equals("")) {
			try {
				date = DateUtil
						.changeFormat(date, "yyyy-MM-dd", "yyyyMMdd");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return date;
	}

	public static String changeToWebDate(String date) {
		date = !StringUtil.isEmpty(date) && date.length()>=8? date.substring(0,8):"";
		if (!null2space(date).equals("")) {
			try {
				date = DateUtil
						.changeFormat(date.trim(), "yyyyMMdd", "yyyy-MM-dd");
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			date = null2space(date);
		}
		return date;
	}
	/**
	 * 
	 * @param s
	 * @return
	 */
	public static String null2space(String s) {
		return null2space(s, "");
	}

	/*
	 * 값이 null 이거나 '' 일때, rStr값으로 리턴한다.
	 */
	public static String null2space(String s, String rStr) {
		if (s == null || s.length() == 0)
			return rStr;
		else
			return s.trim();
	}

	/**
	 * 
	 * @param s
	 * @param val
	 * @return
	 */
	public static int null2zero(String s, int val) {
		if (s == null || s.length() == 0)
			return val;
		else
			return Integer.parseInt(s);
	}

	public static int null2zero(String s) {
		return null2zero(s, 0);
	}
	public static int null2zero(int s) {
		return null2zero(String.valueOf(s), 0);
	}
	
	public static String null2nbsp(String org) {
		if (org == null || org.trim().length() == 0)
			return "&nbsp;";
		else
			return org.trim();
	}
	
	
	public static String dispAmt(String amt) {
		String result = "";
		try {
			result = parseAmt(Long.parseLong(amt));
		}
		catch(NumberFormatException fe) {
			result = "";
		}
		return result;
	}
	public static String dispAmt(int amt) {
		return parseAmt(amt);
	}
	
	public static String parseAmt(String amt) {		
		return parseAmt(Integer.parseInt(amt));
	}
	
	public static String parseAmt(int amt) throws NumberFormatException {
		DecimalFormat df = new DecimalFormat("###,###");
		return df.format(amt);
	}
	
	public static String parseAmt(long amt) throws NumberFormatException {
		DecimalFormat df = new DecimalFormat("###,###");
		return df.format(amt);
	}
	
	public static String cutstring(String str, int idx) {
		return str != null && str.length() > idx? str.substring(0, idx) +"...": str;
	}
	
	public static String nvl(String str, String def) {
		return str == null || str.length() <1? def : str;
	}
	
	public static boolean isEmpty(String str) {
		return str == null || str.length() <1 ? true : false;
	}
}

