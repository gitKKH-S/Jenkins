package com.mten.util;

import org.apache.commons.codec.binary.Base64;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.math.BigInteger;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.AlgorithmParameterSpec;

/**
 * 클래스에 대한 설명
 * @author hanuhm
 * @since 2016. 2. 18.
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일            수정자           수정내용
 *  ---------------    --------    ---------------------------
 *   2016. 7. 4.           Administrator       최초 작성 
 *
 * </pre>
 */
public class AES256Cipher {
	
	protected static  Logger log = LogManager.getLogger();
	
	public static byte[] ivBytes = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };

	private static String key = getEncryptSHA256("12345").substring(0, 16);

	public static String AES_Encode(String str)	throws java.io.UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,	IllegalBlockSizeException, BadPaddingException {
		
		byte[] textBytes = str.getBytes("UTF-8");
		AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
		     SecretKeySpec newKey = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
		     Cipher cipher = null;
		cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		cipher.init(Cipher.ENCRYPT_MODE, newKey, ivSpec);
		return Base64.encodeBase64String(cipher.doFinal(textBytes));
	}

	public static String AES_Decode(String str)	throws java.io.UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		
		byte[] textBytes = Base64.decodeBase64(str);
		//byte[] textBytes = str.getBytes("UTF-8");
		AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
		SecretKeySpec newKey = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		cipher.init(Cipher.DECRYPT_MODE, newKey, ivSpec);
		return new String(cipher.doFinal(textBytes), "UTF-8");
	}


	public static String getEncryptSHA256(String aOrigin){
        String encryptedSHA256 = "";
        MessageDigest md = null;
        
        try {
            md = MessageDigest.getInstance("SHA-256");
            md.update(aOrigin.getBytes(), 0, aOrigin.length());
            encryptedSHA256 = new BigInteger(1, md.digest()).toString(16); 
        } catch (NoSuchAlgorithmException e) {
            log.error(e.getMessage());
        }
        
        return encryptedSHA256;
    }
}
