package com.mten.bylaw.admin.controller;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mten.bylaw.admin.service.UserService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.util.Json4Ajax;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

@Controller
@RequestMapping("/login/")
public class UserlawController extends DefaultController{
	@Resource(name="userService")
	private UserService userService;
	
	
	@SuppressWarnings({"rawtypes", "unchecked"})
	@RequestMapping("/noSSO.do")
	@ResponseBody
	public void getMatch(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setAttribute("logMap", mtenMap);
		
		System.out.println(mtenMap);
		JSONObject result = userService.getMatch(mtenMap,request);
		Json4Ajax.commonAjax(result, response);
	}
	
	@SuppressWarnings({"rawtypes", "unchecked"})
	@RequestMapping("/gpkiLogin.do")
	@ResponseBody
	public void gpkiLogin(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setAttribute("logMap", mtenMap);
		JSONObject result = userService.getGpkiMatch(mtenMap,request);
		Json4Ajax.commonAjax(result, response);
	}
	
	public static SecretKeySpec generateKey(String passPhrase, String salt) throws Exception {
		byte[] keyBytes = passPhrase.getBytes("UTF-8");
		byte[] saltBytes = hexStringToByteArray(salt);
		return new SecretKeySpec(keyBytes, "AES");
	}

	// Encrypt text
	public static String encrypt(String plainText, String passPhrase, String salt, String iv) throws Exception {
		SecretKeySpec key = generateKey(passPhrase, salt);
		IvParameterSpec ivSpec = new IvParameterSpec(hexStringToByteArray(iv));
		Cipher cipher = Cipher.getInstance("AES/CTR/NoPadding");
		cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
		byte[] encrypted = cipher.doFinal(plainText.getBytes("UTF-8"));
		return Base64.encodeBase64String(encrypted);
		//return Base64.getEncoder().encodeToString(encrypted);
	}

	// Decrypt text
	public static String decrypt(String cipherText, String passPhrase, String salt, String iv) throws Exception {
		SecretKeySpec key = generateKey(passPhrase, salt);
		IvParameterSpec ivSpec = new IvParameterSpec(hexStringToByteArray(iv));
		Cipher cipher = Cipher.getInstance("AES/CTR/NoPadding");
		cipher.init(Cipher.DECRYPT_MODE, key, ivSpec);
		byte[] decodedBytes = Base64.decodeBase64(cipherText);
		//byte[] decodedBytes = Base64.getDecoder().decode(cipherText);
		byte[] decrypted = cipher.doFinal(decodedBytes);
		return new String(decrypted, "UTF-8");
	}

	// Helper function to convert hex to byte array
	public static byte[] hexStringToByteArray(String s) {
		int len = s.length();
		byte[] data = new byte[len / 2];
		for (int i = 0; i < len; i += 2) {
			data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4) + Character.digit(s.charAt(i + 1), 16));
		}
		return data;
	}
	
	@RequestMapping("/getSession.do")
	public ModelAndView getSession(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		HttpSession session = request.getSession();
		HashMap se = (HashMap)session.getAttribute("userInfo"); 
		System.out.println("session===>"+se);
		ObjectMapper objectMapper = new ObjectMapper();
		
		JSONObject jr = JSONObject.fromObject(se);
		
		objectMapper.writeValueAsString(jr);
		
		String en = UserlawController.encrypt(jr.toString(), "oingisprettyintheworld1234567890", "a1b2c3d4", "1234567890abcdef1234567890abcdef");
		String de = this.decrypt(en, "oingisprettyintheworld1234567890", "a1b2c3d4", "1234567890abcdef1234567890abcdef");
		System.out.println("====>"+en);
		System.out.println("====>"+de);
		
		Map data = new HashMap();
		data.put("en", en);
		data.put("hkk1", "oingisprettyintheworld1234567890");
		data.put("hkk2", "a1b2c3d4");
		data.put("hkk3", "1234567890abcdef1234567890abcdef");
		return addResponseData(data);	
	}
	
	@RequestMapping("/selectOrg.do")
	public ModelAndView selectOrg(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		System.out.println("시작=============>");
		JSONObject result = userService.selectOrg(mtenMap);
		System.out.println("끝=============>");
		
		return addResponseData(result);	
	}
}
