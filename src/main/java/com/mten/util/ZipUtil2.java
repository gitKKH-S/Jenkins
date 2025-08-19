package com.mten.util;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;

public class ZipUtil2 {

	public static void main(String[] args) throws IOException {
		String path = "C:\\Users\\Administrator\\Desktop\\test";
		File file = new File(path);
		String files[] = null;
		// 파일이 디렉토리 일경우 리스트를 읽어오고
		// 파일이 디렉토리가 아니면 첫번째 배열에 파일이름을 넣는다.
		if (file.isDirectory()) {
			files = file.list();
		} else {
			files = new String[1];
			files[0] = file.getName();
			System.out.println(file.getName().getBytes());
		}

		// buffer size
		int size = 1024;
		byte[] buf = new byte[size];
		String outZipNm = path + "\\테스트.zip";
		FileInputStream fis = null;
		ZipArchiveOutputStream zos = null;
		BufferedInputStream bis = null;
		try {
			// Zip 파일생성
			zos = new ZipArchiveOutputStream(new BufferedOutputStream(new FileOutputStream(outZipNm)));
			for (int i = 0; i < files.length; i++) {
				// 해당 폴더안에 다른 폴더가 있다면 지나간다.
				if (new File(path + "/" + files[i]).isDirectory()) {
					continue;
				}
				// encoding 설정
				zos.setEncoding("UTF-8");
				// buffer에 해당파일의 stream을 입력한다.
				fis = new FileInputStream(path + "/" + files[i]);
				bis = new BufferedInputStream(fis, size);
				// zip에 넣을 다음 entry 를 가져온다.
				zos.putArchiveEntry(new ZipArchiveEntry(files[i]));
				// 준비된 버퍼에서 집출력스트림으로 write 한다.
				int len;
				while ((len = bis.read(buf, 0, size)) != -1) {
					zos.write(buf, 0, len);
				}
				bis.close();
				fis.close();
				zos.closeArchiveEntry();
			}
			zos.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} finally {
			if (zos != null) {
				zos.close();
			}
			if (fis != null) {
				fis.close();
			}
			if (bis != null) {
				bis.close();
			}
		}
	}
	
	
	public static void setZip(String path,String outZipNm) throws IOException {
		File file = new File(path);
		String files[] = null;
		// 파일이 디렉토리 일경우 리스트를 읽어오고
		// 파일이 디렉토리가 아니면 첫번째 배열에 파일이름을 넣는다.
		if (file.isDirectory()) {
			files = file.list();
		} else {
			files = new String[1];
			files[0] = file.getName();
			System.out.println(file.getName().getBytes());
		}

		// buffer size
		int size = 1024;
		byte[] buf = new byte[size];
		FileInputStream fis = null;
		ZipArchiveOutputStream zos = null;
		BufferedInputStream bis = null;
		try {
			// Zip 파일생성
			zos = new ZipArchiveOutputStream(new BufferedOutputStream(new FileOutputStream(outZipNm)));
			for (int i = 0; i < files.length; i++) {
				// 해당 폴더안에 다른 폴더가 있다면 지나간다.
				if (new File(path + "/" + files[i]).isDirectory()) {
					continue;
				}
				// encoding 설정
				zos.setEncoding("UTF-8");
				// buffer에 해당파일의 stream을 입력한다.
				fis = new FileInputStream(path + "/" + files[i]);
				bis = new BufferedInputStream(fis, size);
				// zip에 넣을 다음 entry 를 가져온다.
				zos.putArchiveEntry(new ZipArchiveEntry(files[i]));
				// 준비된 버퍼에서 집출력스트림으로 write 한다.
				int len;
				while ((len = bis.read(buf, 0, size)) != -1) {
					zos.write(buf, 0, len);
				}
				bis.close();
				fis.close();
				zos.closeArchiveEntry();
			}
			zos.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} finally {
			if (zos != null) {
				zos.close();
			}
			if (fis != null) {
				fis.close();
			}
			if (bis != null) {
				bis.close();
			}
		}
	}
}
