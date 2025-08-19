package com.mten.bylaw.mif.serviceSch;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.util.*;

import com.mten.util.MakeHan;
 


 
 
/**
 * # URL상의 파일을 다운로드, DBMS에 저장
 */
public class FileUrlDownload {
    final static int bufferSize = 1024;
    
    public static void main(String[]srag) throws IOException {
    	String fileUrl = MakeHan.File_url("LAWURL")+"flDownload.do?flSeq=25039254";
    	URLConnection uCon = null;
    	try {
    		URL Url = new URL(fileUrl);
            uCon = Url.openConnection();
            String fileNm = "";
            for (Map.Entry<String, List<String>> header : uCon.getHeaderFields().entrySet()) {
            	String key = header.getKey();
                for (String value : header.getValue()) {
                    System.out.println(key + " : " + value);
                    if(key!=null && key.equals("Content-Disposition")){
                    	String fn[] = value.split("fileName=");
                    	fileNm = fn[1].replaceAll("\"","").replaceAll(";","");
                    	System.out.println(fn[1].replaceAll("\"","").replaceAll(";",""));
                    }
                }
            }
    	}catch(Exception e) {
    		
    	}
    }
    
    /**
     * # URL 경로의 파일 다운로드
     */
    public static HashMap fileUrlReadAndDownload(String fileUrl, String localFileName, String downloadDir) {
    	HashMap result = new HashMap();
        OutputStream outStream = null;
        URLConnection uCon = null;
 
        InputStream is = null;
        int byteWritten = 0;
        try {
 
            URL Url;
            byte[] buf;
            int byteRead;
            Url = new URL(fileUrl);
            uCon = Url.openConnection();
            
            String fileNm = "";
            for (Map.Entry<String, List<String>> header : uCon.getHeaderFields().entrySet()) {
            	String key = header.getKey();
                for (String value : header.getValue()) {
                    System.out.println(key + " : " + value);
                    if(key!=null && key.equals("Content-Disposition")){
                    	String fn[] = value.split("fileName=");
                    	fileNm = fn[1].replaceAll("\"","").replaceAll(";","");
                    	System.out.println(fn[1].replaceAll("\"","").replaceAll(";",""));
                    }
                }
            }
            //localFileName = localFileName+fileNm.substring(fileNm.lastIndexOf("."),fileNm.length());
            
            outStream = new BufferedOutputStream(
            		//new FileOutputStream(downloadDir + File.separator + URLDecoder.decode(localFileName, "UTF-8"))
            		new FileOutputStream(downloadDir + "/" + URLDecoder.decode(localFileName, "UTF-8"))
            		);
 
                    is = uCon.getInputStream();
                    buf = new byte[bufferSize];
                    while ((byteRead = is.read(buf)) != -1) {
                        outStream.write(buf, 0, byteRead);
                        byteWritten += byteRead;
                    }
                    
                    result.put("filenm", localFileName);
        			result.put("byteWritten", byteWritten);
                    System.out.println("Download Successfully.");
                    System.out.println("File name : " + localFileName);
                    System.out.println("of bytes  : " + byteWritten);
                    System.out.println("-------Download End--------");
                    is.close();
                    outStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                is.close();
                outStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return result;
    }
 
    /**
     * # 다운로드된 파일 정보를 Bean 클래스에 저장
     *  - DBMS에 저장및 정보 활용을 위함.
     */
    public static FileBean setUrlFileSave(String fileUrl, String downloadDir,String fileName) {
        FileBean fileBean = new FileBean();
        int fileSize = 0;
         
        int slashIndex = fileUrl.lastIndexOf('/');
        int periodIndex = fileUrl.lastIndexOf('.');
 
        // 파일 경로에서 마지막 파일명을 추출
        //String fileName = fileUrl.substring(slashIndex + 1);
        String filePath = downloadDir;//+File.separator+fileName;
        
        HashMap result = new HashMap();
        if (periodIndex >= 1 && slashIndex >= 0 && slashIndex < fileUrl.length() - 1) {
        	result = fileUrlReadAndDownload(fileUrl, fileName, downloadDir);
        }
        fileName = result.get("filenm").toString();
        fileBean.setFileName(fileName);
        fileBean.setFilePath(filePath);
        fileBean.setFileSize(Integer.parseInt(result.get("byteWritten").toString()));
        
		try {
			System.out.println("EEEEEE===>"+filePath+"/"+fileName);
			RandomAccessFile f = new RandomAccessFile(filePath+"/"+fileName, "r");
			byte[] b = new byte[(int)f.length()];
	        f.readFully(b);
	        fileBean.setFbuf(b);
	        System.out.println("EEEEEE===>"+b);
		} catch (Exception e) {
			System.out.println(e);
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        
//        String mimeType = null;
//        Tika tika = new Tika(); // 파일의 Mime-Type 추출
        
//        try {
//            mimeType = tika.detect(new File(filePath));
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//        fileBean.setFileType(mimeType); // 파일 Mime-Type
         
        return fileBean;
    }
    
    public static FileBean setUrlImgFileSave(String fileUrl, String downloadDir,String fileName) {
        FileBean fileBean = new FileBean();
        int fileSize = 0;
         
        int slashIndex = fileUrl.lastIndexOf('/');
        int periodIndex = fileUrl.lastIndexOf('.');
 
        // 파일 경로에서 마지막 파일명을 추출
        //String fileName = fileUrl.substring(slashIndex + 1);
        String filePath = downloadDir;//+File.separator+fileName;
        HashMap result = new HashMap();
        if (periodIndex >= 1 && slashIndex >= 0  && slashIndex < fileUrl.length() - 1) {
        	result = ImgfileUrlReadAndDownload(fileUrl, fileName, downloadDir);
        }
        fileName = result.get("filenm").toString();
        fileBean.setFilePath(filePath);
        fileBean.setFileName(fileName);
        fileBean.setFileSize(Integer.parseInt(result.get("byteWritten").toString()));
        
		try {
			System.out.println("EEEEEE===>"+filePath+"/"+fileName);
			RandomAccessFile f = new RandomAccessFile(filePath+"/"+fileName, "r");
			byte[] b = new byte[(int)f.length()];
	        f.readFully(b);
	        fileBean.setFbuf(b);
	        System.out.println("EEEEEE===>"+b);
		} catch (Exception e) {
			System.out.println(e);
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        
//        String mimeType = null;
//        Tika tika = new Tika(); // 파일의 Mime-Type 추출
        
//        try {
//            mimeType = tika.detect(new File(filePath));
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//        fileBean.setFileType(mimeType); // 파일 Mime-Type
         
        return fileBean;
    }
    
	public static HashMap ImgfileUrlReadAndDownload(String fileUrl, String localFileName, String downloadDir) {
		HashMap result = new HashMap();
		OutputStream outStream = null;
		URLConnection uCon = null;

		InputStream is = null;
		int byteWritten = 0;
		try {

			URL Url;
			byte[] buf;
			int byteRead;
			Url = new URL(fileUrl);

			uCon = Url.openConnection();
			
			// 응답 헤더의 정보를 모두 출력
            String fileNm = "";
            for (Map.Entry<String, List<String>> header : uCon.getHeaderFields().entrySet()) {
            	String key = header.getKey();
                for (String value : header.getValue()) {
                    System.out.println(key + " : " + value);
                    if(key!=null && key.equals("Content-Disposition")){
                    	String fn[] = value.split("fileName=");
                    	fileNm = fn[1].replaceAll("\"","").replaceAll(";","");
                    	System.out.println(fn[1].replaceAll("\"","").replaceAll(";",""));
                    }
                }
            }
            localFileName = localFileName+fileNm.substring(fileNm.lastIndexOf("."),fileNm.length());
            outStream = new BufferedOutputStream(
					// new FileOutputStream(downloadDir + File.separator +
					// URLDecoder.decode(localFileName, "UTF-8"))
					new FileOutputStream(downloadDir + "/" + URLDecoder.decode(localFileName, "UTF-8")));
            System.out.println(localFileName);
			is = uCon.getInputStream();
			buf = new byte[bufferSize];
			while ((byteRead = is.read(buf)) != -1) {
				outStream.write(buf, 0, byteRead);
				byteWritten += byteRead;
			}
			result.put("filenm", localFileName);
			result.put("byteWritten", byteWritten);
			System.out.println("Download Successfully.");
			System.out.println("File name : " + localFileName);
			System.out.println("of bytes  : " + byteWritten);
			System.out.println("-------Download End--------");
			is.close();
			outStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				is.close();
				outStream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return result;
	}
	
	public static HashMap ImgfileUrlReadAndDownloadIN(String fileUrl, String localFileName, String downloadDir) {
		HashMap result = new HashMap();
		OutputStream outStream = null;
		URLConnection uCon = null;

		InputStream is = null;
		int byteWritten = 0;
		try {

			URL Url;
			byte[] buf;
			int byteRead;
			Url = new URL(fileUrl);

			uCon = Url.openConnection();
			
			// 응답 헤더의 정보를 모두 출력
            outStream = new BufferedOutputStream(
					// new FileOutputStream(downloadDir + File.separator +
					// URLDecoder.decode(localFileName, "UTF-8"))
					new FileOutputStream(downloadDir + "/" + URLDecoder.decode(localFileName, "UTF-8")));
            System.out.println(localFileName);
			is = uCon.getInputStream();
			buf = new byte[bufferSize];
			while ((byteRead = is.read(buf)) != -1) {
				outStream.write(buf, 0, byteRead);
				byteWritten += byteRead;
			}
			result.put("filenm", localFileName);
			result.put("byteWritten", byteWritten);
			System.out.println("Download Successfully.");
			System.out.println("File name : " + localFileName);
			System.out.println("of bytes  : " + byteWritten);
			System.out.println("-------Download End--------");
			is.close();
			outStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				is.close();
				outStream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return result;
	}
	
	public static String getImgName(String URL) {
		URL url = null;
		URLConnection connection = null;
		String strXML = new String(); // xml내용 저장하기 위한 변수
		try {
			url = new URL(URL); // URL 세팅
			connection = url.openConnection(); // 접속
			BufferedReader rd = new BufferedReader(new InputStreamReader(connection.getInputStream(), "utf-8"));
			StringBuffer sb = new StringBuffer();
			int BUFFER_SIZE = 1024;
			char[] buffer = new char[BUFFER_SIZE]; // or some other size,
			int charsRead = 0;
			while ((charsRead = rd.read(buffer, 0, BUFFER_SIZE)) != -1) {
				sb.append(buffer, 0, charsRead);
			}
			strXML = sb.toString().trim();
			rd.close();

		} catch (MalformedURLException mue) {
			System.out.println(mue);
		} catch (IOException ioe) {
			System.out.println(ioe);
			ioe.printStackTrace();
		}
		return strXML;
	}
    /**
     * # main
     * @throws IOException 
     */
    public static void main2(String[] args) throws IOException {
 
        // 파일 URL
        String fileUrl = MakeHan.File_url("LAWURL")+"LSW/flDownload.do?flSeq=19079295";//"http://www.law.go.kr/LSW/flDownload.do?flSeq=18983872";
 
        // 다운로드 디렉토리
        String downDir = "E:/";
 
        /*
         * 파일 다운로드및 파일 정보를 저장하여 서비스 활용
        */
        //setUrlFileSave(fileUrl, downDir,"a.hwp");
        
        
        
        
        FileUrlDownload.ImgfileUrlReadAndDownloadIN("http://211.187.234.227:8081/high1new/dataFile/klaw/220979/13357422.gif","13357422.gif", "E:/hkkdev/high1/src/main/webapp/dataFile/klaw/220979");
        	
        URL url = null;
		URLConnection connection = null;
		String strXML = new String(); // xml내용 저장하기 위한 변수
		try {
			url = new URL("http://211.187.234.227:8081/high1new/mif/getImg.do?id=13357422&lawid=220979"); // URL 세팅
			connection = url.openConnection(); // 접속
			BufferedReader rd = new BufferedReader(new InputStreamReader(connection.getInputStream(), "utf-8"));
			StringBuffer sb = new StringBuffer();
			int BUFFER_SIZE = 1024;
			char[] buffer = new char[BUFFER_SIZE]; // or some other size,
			int charsRead = 0;
			while ((charsRead = rd.read(buffer, 0, BUFFER_SIZE)) != -1) {
				sb.append(buffer, 0, charsRead);
			}
			System.out.println(sb.toString());
			rd.close();

		} catch (MalformedURLException mue) {
			System.out.println(mue);
		} catch (IOException ioe) {
			System.out.println(ioe);
			ioe.printStackTrace();
		}
    }
}
