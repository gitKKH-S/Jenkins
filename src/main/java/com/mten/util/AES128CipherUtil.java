package com.mten.util;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * @Class : AES256Cipher.java
 * @Package : 
 * @Description :
 * @version
 *
 *------------------------------------------------------------------------
 * Modification Information
 *------------------------------------------------------------------------   
 *     날짜              수정자             변경사유
 */
public class AES128CipherUtil {
	
	static Logger logger = LogManager.getLogger();
	
	final static String KEY = "ATECXQ0765423678"; // 128 bit key
	final static String IV = "1D7F8E0EBD8768C2"; // 16 bytes IV
		
	// 암호화
	public static String encrypt( String value ) {
		
		try {
			IvParameterSpec iv = new IvParameterSpec( IV .getBytes( "UTF-8" ) );
			SecretKeySpec skKeySpec = new SecretKeySpec( KEY.getBytes("UTF-8"), "AES" );
			
			Cipher cipher = Cipher.getInstance( "AES/CBC/PKCS5Padding" );
			cipher.init( Cipher.ENCRYPT_MODE , skKeySpec, iv );

			return byteArrayToHex( cipher.doFinal( value.getBytes() ) );
			
		} catch( Exception ex ) {
			//ex.printStackTrace();
			logger.error( ex.getMessage() );
		}
		
		return null;
	}
	
	// 복호화
	public static String decrypt( String value ) {
		
		try {
			IvParameterSpec iv = new IvParameterSpec( IV.getBytes( "UTF-8" ) );
			SecretKeySpec skKeySpec = new SecretKeySpec( KEY.getBytes("UTF-8"), "AES" );
			
			Cipher cipher = Cipher.getInstance( "AES/CBC/PKCS5Padding" );
			cipher.init( Cipher.DECRYPT_MODE , skKeySpec, iv );

			return new String( cipher.doFinal( hexToByteArray(value) ) );
			
		} catch( Exception ex ) {
			//ex.printStackTrace();
			logger.error( ex.getMessage() );
		}
		
		return null;
	}
	
	private static byte[] hexToByteArray( String str ) {
		byte[] retValue = null;
		if ( str != null && str.length() != 0 ) {
			retValue = new byte[ str.length()/2 ];
			for ( int inx = 0 ; inx < retValue.length ; inx++ ) {
				retValue[inx] = (byte) Integer.parseInt( str.substring( 2*inx, 2*inx+2), 16 );
			}
		}
		return retValue;
	}
	
	private static String byteArrayToHex( byte buf[] ) {
		StringBuffer strbuf = new StringBuffer( buf.length*2 );
		
		for ( int inx = 0 ; inx < buf.length ; inx++ ) {
			if ( ((int)buf[inx] & 0xff ) < 0x10 ) {
				strbuf.append( "0" );
			}
			strbuf.append( Long.toString( (int)buf[inx] & 0xff, 16 ));
		}
		return strbuf.toString();
	}

}
