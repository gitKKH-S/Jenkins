package com.mten.util;


import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;

public class test {
	public static void main(String srta[]) {
		 StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor();
	        pbeEnc.setAlgorithm("PBEWithMD5AndDES");
	        pbeEnc.setPassword("MTENBYLAW");

	        String enc = pbeEnc.encrypt("HIGH1LAW2!");
	        System.out.println("enc : "+enc);

	        String des = pbeEnc.decrypt("MmgP1l5DHkYSIOv4ArhWQL4cGmmky/og");
	        System.out.println("desc : "+des);



	}
}
