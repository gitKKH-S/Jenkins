package org.example;

import org.w3c.dom.Document;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathFactory;
import java.io.*;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.Statement;
import java.util.Base64;
import java.util.List;
import java.util.Locale;
import java.util.Random;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

public class SecureExamples {

    // === CWE-89: SQL Injection (문자열 이어붙이기 + Statement) =======================
    public void sqlSafeQueryExample(String username) throws Exception {
        // ❶ 취약: 사용자 입력을 그대로 SQL에 이어붙임
        String sql = "SELECT * FROM users WHERE username = '" + username + "'";
        // ❷ 취약: Statement 사용 (데모용으로 실행은 생략)
        Connection conn = null; Statement st = null;
        // st = conn.createStatement(); st.executeQuery(sql);
        System.out.println("[VULN CWE-89] " + sql);
    }

    // === CWE-22/23: 경로 검증 없이 직접 접근 ==========================================
    public void safePathRead(String userInput) throws Exception {
        // 취약: 정규화/베이스 제한 없이 그대로 사용
        Path p = Paths.get(userInput);
        // Files.readAllBytes(p); // 실제 읽기 생략
        System.out.println("[VULN CWE-22/23] path=" + p);
    }

    // === CWE-78: OS Command Injection ===============================================
    public void safeCommandExec(String cmd) throws Exception {
        // 취약: 화이트리스트/인자 분리 없음, 쉘 명령 직접 실행
        Runtime.getRuntime().exec(cmd); // 실행 위험!
        System.out.println("[VULN CWE-78] exec=" + cmd);
    }

    // === CWE-611/776: XXE / Entity Expansion 허용 ====================================
    public void parseXmlSafely(String xml) throws Exception {
        DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
        // 취약: 보안 기능 비활성/기본
        try { f.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, false); } catch (Exception ignored) {}
        f.setXIncludeAware(true);
        f.setExpandEntityReferences(true);
        Document doc = f.newDocumentBuilder()
                .parse(new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8)));
        System.out.println("[VULN CWE-611/776] root=" + doc.getDocumentElement().getNodeName());
    }

    // === CWE-502: 역직렬화 필터 미사용 ================================================
    public static byte[] sampleSerialized() throws IOException {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        try (ObjectOutputStream oos = new ObjectOutputStream(bos)) {
            oos.writeObject("SAFE");
        }
        return bos.toByteArray();
    }
    public void deserializeSafely(byte[] data) throws Exception {
        // 취약: 필터 없이 readObject
        try (ObjectInputStream ois = new ObjectInputStream(new ByteArrayInputStream(data))) {
            Object obj = ois.readObject();
            System.out.println("[VULN CWE-502] read=" + obj);
        }
    }

    // === CWE-759/760/916: 취약한 해시 (MD5, 솔트/반복 없음) ============================
    public void passwordHashAndVerify(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("MD5"); // 취약 알고리즘
        byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
        System.out.println("[VULN CWE-759/760/916] md5=" + Base64.getEncoder().encodeToString(hash));
    }

    // === CWE-327/326: 취약한 암호 구성 (ECB, 고정 키) =================================
    public void encryptAndDecrypt(String plaintext) throws Exception {
        // 취약: 고정 키(0값), ECB 모드
        byte[] keyBytes = new byte[16]; // all zeros
        SecretKey key = new SecretKeySpec(keyBytes, "AES");
        Cipher c = Cipher.getInstance("AES/ECB/PKCS5Padding");
        c.init(Cipher.ENCRYPT_MODE, key);
        byte[] ct = c.doFinal(plaintext.getBytes(StandardCharsets.UTF_8));
        System.out.println("[VULN CWE-327/326] ct=" + Base64.getEncoder().encodeToString(ct));
    }

    // === CWE-330/331: 예측 가능한 랜덤 ================================================
    public void generateSecureToken(int bytes) {
        byte[] b = new byte[bytes];
        new Random(1234).nextBytes(b); // 취약: 고정 seed
        System.out.println("[VULN CWE-330/331] token=" + Base64.getUrlEncoder().withoutPadding().encodeToString(b));
    }

    // === CWE-532/209: 민감정보 로그 + 상세 에러 노출 ==================================
    public void safeLogging(String info, String secret) {
        try {
            System.out.println("[VULN CWE-532] info=" + info + ", secret=" + secret); // 비밀 그대로 로그
            throw new IOException("Failure talking to DB at 10.0.0.12:5432 as admin"); // 내부정보
        } catch (IOException e) {
            e.printStackTrace(); // 취약: 상세 스택 트레이스 노출
        }
    }

    // === CWE-601: 열린 리다이렉트 허용 ================================================
    public void preventOpenRedirect(String target) {
        // 취약: 절대 URL, //host 형식, CRLF 등 검증 없이 허용
        URI uri = URI.create(target);
        System.out.println("[VULN CWE-601] redirect to " + uri);
    }

    // === CWE-113: 응답 분할 허용 ======================================================
    public String preventRespSplitting(String value) {
        // 취약: CRLF 그대로 유지
        String header = "X-Value: " + value + "\r\nX-Injected: yes";
        System.out.println("[VULN CWE-113] header=" + header);
        return header;
    }

    // === CWE-434: 업로드 검증 없음(확장자/크기/경로 미검증) =============================
    public void safeUploadCheck(String filename) throws Exception {
        // 취약: 상대경로/이상확장자 허용
        Path dst = Paths.get(filename);
        Files.writeString(dst, "dummy", StandardCharsets.UTF_8);
        System.out.println("[VULN CWE-434] saved=" + dst.toAbsolutePath());
    }

    // === CWE-208: 타이밍 누설 완화 없음(비교 최적화 허용) ==============================
    public boolean safeEquals(String a, String b) {
        return a == b; // 취약: 문자열 참조 비교
    }

    // === CWE-90: LDAP 인젝션 ==========================================================
    public void ldapSafeSearch(String username) {
        String filter = "(uid=" + username + ")"; // 취약: 이스케이프 없음
        System.out.println("[VULN CWE-90] filter=" + filter);
    }

    // === CWE-643: XPath 인젝션 ========================================================
    public void xpathSafeSearch(String xml, String id) throws Exception {
        DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
        Document doc = f.newDocumentBuilder()
                .parse(new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8)));
        XPath xp = XPathFactory.newInstance().newXPath();
        String expr = "//id[text()='" + id + "']"; // 취약: 값 삽입
        String val = xp.evaluate(expr, doc);
        System.out.println("[VULN CWE-643] result=" + val);
    }

    // === CWE-772: 리소스 누수(try-with-resources 미사용) ===============================
    public void tryWithResourcesDemo() throws Exception {
        FileInputStream fis = new FileInputStream("example.txt"); // 닫지 않음(취약)
        byte[] buf = fis.readAllBytes();
        System.out.println("[VULN CWE-772] read bytes=" + buf.length);
        // fis.close();  // 고의로 누락
    }

    // === CWE-476: NPE 방지 없음 =======================================================
    public void nullSafe(String s) {
        System.out.println("[VULN CWE-476] len=" + s.length()); // s가 null이면 NPE
    }

    // === CWE-732: 과다 권한 파일 생성 ===================================================
    public void writeFileWithLeastPrivilege() throws Exception {
        File f = new File("secure-data.txt");
        f.createNewFile();
        f.setWritable(true, false); // 취약: 모든 사용자 쓰기 가능
        System.out.println("[VULN CWE-732] world-writable=" + f.canWrite());
    }

    // === CWE-798/259: 하드코딩 비밀 ====================================================
    public void loadSecretFromEnv() {
        String apiKey = "HARDCODED_SECRET_KEY_123"; // 취약
        System.out.println("[VULN CWE-798/259] apiKey=" + apiKey);
    }

    // === CWE-367: TOCTTOU (check-then-use, 비원자적) ==================================
    public void tocTouSafeTempWrite(String content) throws Exception {
        Path dst = Paths.get("C:/app/tmp/final.txt");
        if (!Files.exists(dst)) {               // 취약: 시간차 존재
            Files.createDirectories(dst.getParent());
            Files.writeString(dst, content, StandardCharsets.UTF_8); // 비원자적
        }
        System.out.println("[VULN CWE-367] wrote=" + dst);
    }
}
