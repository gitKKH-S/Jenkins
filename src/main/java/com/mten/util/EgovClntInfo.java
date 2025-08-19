package com.mten.util;

import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;

//import egovframework.com.cmm.service.EgovProperties;

/**
 * 클라이언트(Client)의 IP주소, OS정보, 웹브라우저정보를 조회하는 Business Interface class
 * @author 공통서비스개발팀 박지욱
 * @since 2009.01.19
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.01.19  박지욱          최초 생성
 *   2011.08.31  JJY            경량환경 템플릿 커스터마이징버전 생성 
 *
 * </pre>
 */
public class EgovClntInfo {
	
	protected  final static Logger LOGGER = Logger.getLogger(EgovClntInfo.class);
	
	/**
	 * 클라이언트(Client)의 IP주소를 조회하는 기능
	 * @param HttpServletRequest request Request객체
	 * @return String ipAddr IP주소
	 * @exception Exception
	*/
	public static String getClntIP(HttpServletRequest request) throws Exception {
		
		// IP주소
		String ipAddr = request.getRemoteAddr();
		return ipAddr;
	}
	
	
	/**
	 * 클라이언트(Client)의 웹브라우저 종류를 조회하는 기능
	 * @param HttpServletRequest request Request객체
	 * @return String webKind 웹브라우저 종류
	 * @exception Exception
	*/
	public static String getClntWebKind(HttpServletRequest request) throws Exception {
		
		String useragent = request.getHeader("user-agent");
		
		// 웹브라우저 종류 조회
		String webKind = "";
		if (useragent.toUpperCase().indexOf("GECKO") != -1) {
			if (useragent.toUpperCase().indexOf("NESCAPE") != -1) {
				webKind = "Netscape (Gecko/Netscape)";
			} else if (useragent.toUpperCase().indexOf("FIREFOX") != -1) {
				webKind = "Mozilla Firefox (Gecko/Firefox)";
			} else {
				webKind = "Mozilla (Gecko/Mozilla)";
			}
		} else if (useragent.toUpperCase().indexOf("MSIE") != -1) {
			if (useragent.toUpperCase().indexOf("OPERA") != -1) {
				webKind = "Opera (MSIE/Opera/Compatible)";
			} else {
				webKind = "Internet Explorer (MSIE/Compatible)";
			}
		} else if (useragent.toUpperCase().indexOf("SAFARI") != -1) {
			if (useragent.toUpperCase().indexOf("CHROME") != -1) {
				webKind = "Google Chrome";
			} else {
				webKind = "Safari";
			}
		} else if (useragent.toUpperCase().indexOf("THUNDERBIRD") != -1) {
			webKind = "Thunderbird";
		} else {
			webKind = "Other Web Browsers";
		}
		return webKind;
	}
	
	/**
	 * 클라이언트(Client)의 웹브라우저 버전을 조회하는 기능
	 * @param HttpServletRequest request Request객체
	 * @return String webVer 웹브라우저 버전
	 * @exception Exception
	*/
	public static String getClntWebVer(HttpServletRequest request) throws Exception {
		
		String useragent = request.getHeader("user-agent");
		
		// 웹브라우저 버전 조회
		String webVer = "";
		String [] arr = {"MSIE", "OPERA", "NETSCAPE", "FIREFOX", "SAFARI"};
		for (int i = 0; i < arr.length; i++) {
			int sloc = useragent.toUpperCase().indexOf(arr[i]);
			if (sloc != -1) {
				int floc = sloc + arr[i].length();
				webVer = useragent.toUpperCase().substring(floc, floc+5);
				webVer = webVer.replaceAll("/", "").replaceAll(";", "").replaceAll("^", "").replaceAll(",", "").replaceAll("//.", "");
			}
		}
		return webVer;
	}
	
	public static String getClientMacAddress(HttpServletRequest request) throws Exception {
		String ipAddr = request.getRemoteAddr();
		
		String clientMacAddr = "";
		if (ipAddr.equals("127.0.0.1")){
			ipAddr = Inet4Address.getLocalHost().getHostAddress();
		}
		
		InetAddress ip = InetAddress.getByName(ipAddr);
		NetworkInterface ni = NetworkInterface.getByInetAddress(ip);
		
		if (ni != null ) {
				byte []  mac = ni.getHardwareAddress();
				
				
				if (mac != null) {
					StringBuilder sb = new StringBuilder();
					for(int i=0 ; i < mac.length; i++) {
						if (sb.length() > 0)
							sb.append("-");
						sb.append(String.format("%02X", mac[i]));
					}
					clientMacAddr = sb.toString();
				}
				else {
					LOGGER.debug("################  Address dosen't exist or is not accessible" );
				}
		}
		else {
			LOGGER.debug("##############  Network Inferface for the Specified Address is not Found...");
		}
		
		return clientMacAddr;
	}
}
