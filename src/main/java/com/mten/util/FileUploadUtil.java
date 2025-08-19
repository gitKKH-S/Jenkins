package com.mten.util;

import java.io.File;
import java.io.IOException;

import org.springframework.web.multipart.MultipartFile;

public class FileUploadUtil {

	/**
	 * 파일 저장 메서드
	 * 
	 * @param multipartFile 업로드된 파일
	 * @param uploadPath 저장할 경로 (디렉토리 + 파일명)
	 * @throws IOException 파일 저장 중 예외 발생 시
	 */
	public static boolean saveFile(MultipartFile multipartFile, String uploadPath) throws IOException {
		if (multipartFile == null || multipartFile.isEmpty()) {
			throw new IllegalArgumentException("파일이 비어있습니다.");
		}
		
		File destFile = new File(uploadPath);
		
		// 부모 디렉토리 생성 (없을 경우)
		File parentDir = destFile.getParentFile();
		if (!parentDir.exists()) {
			boolean created = parentDir.mkdirs();
			if (!created) {
				throw new IOException("업로드 디렉토리를 생성할 수 없습니다: " + parentDir.getAbsolutePath());
			}
		}
		
		String localyn = MakeHan.File_url("localyn");
		boolean chk = true;
		if(localyn.equals("Y")) {
			// 파일 저장
			multipartFile.transferTo(destFile);
		} else {
			multipartFile.transferTo(destFile);
			
			String fnm = uploadPath.substring(uploadPath.lastIndexOf("/")+1,uploadPath.length());
			chk = fasooDrm.fileUnPackaging(fnm, fnm, uploadPath.substring(0,uploadPath.lastIndexOf("/")+1));
		}
		
		return chk;
	}
}