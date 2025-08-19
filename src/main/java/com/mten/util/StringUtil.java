package com.mten.util;

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

	/**
	 * 날짜 포맷 변경 yyyy-MM-dd => yyyyMMdd
	 * @param date
	 * @return
	 */
	public static String changeToDBDate(String date) {
		if (!null2space(date).equals("")) {
			try {
				date = DateUtil.changeFormat(date, "yyyy-MM-dd", "yyyyMMdd");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return date;
	}

	/**
	 * 날짜 포맷 변경 yyyyMMdd => yyyy-MM-dd
	 * @param date
	 * @return
	 */
	public static String changeToWebDate(String date) {		
		if (!null2space(date).equals("")) {
			try {
				date = DateUtil.changeFormat(date.trim(), "yyyyMMdd", "yyyy-MM-dd");
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			date = null2space(date);
		}
		return date;
	}
	
	/**
	 * null을 공백으로 변경<br/>
	 * 값이 있으면 공백제거(trim)
	 * @param s
	 * @return
	 */
	public static String null2space(String s) {
		return null2space(s, "");
	}

	/**
	 * 값이 null 또는 공백일때, rStr값으로 리턴한다.
	 * @param s
	 * @param rStr
	 * @return
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

	public static int null2zero(int i) {
		return null2zero(String.valueOf(i), 0);
	}
	
	public static String null2nbsp(String org) {
		if (org == null || org.trim().length() == 0)
			return "&nbsp;";
		else
			return org.trim();
	}
	
	/**
	 * #,### 로 출력
	 * @param amt
	 * @return
	 */
	public static String dispAmt(String amt) {
		String result = "";
		try {
			result = parseAmt(Integer.parseInt(amt));
		} catch(NumberFormatException fe) {
			try {
				result = parseAmt(Long.parseLong(amt));
			} catch (Exception e) {
				result = "";
			}
		}
		return result;
	}
	
	
	/**
	 * #,### 로 출력
	 * @param amt
	 * @return
	 */
	public static String dispAmt(int amt) {
		return parseAmt(amt);
	}
	
	public static String parseAmt(String amt) {		
		return parseAmt(Integer.parseInt(amt));
	}

	public static String parseAmt(long amt) throws NumberFormatException {
		DecimalFormat df = new DecimalFormat("#,###");
		return df.format(amt);
	}
	
	public static String parseAmt(int amt) throws NumberFormatException {
		DecimalFormat df = new DecimalFormat("#,###");
		return df.format(amt);
	}
	
	/**
	 * 문자열 str의 길이를 idx 만큼 자르고 "..." 붙인다
	 * @param str
	 * @param idx
	 * @return
	 */
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
