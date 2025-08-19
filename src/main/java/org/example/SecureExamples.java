package org.example;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.naming.Context;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.*;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.nio.file.attribute.PosixFilePermissions;
import java.security.*;
import java.security.spec.KeySpec;
import java.time.Instant;
import java.util.*;

import org.w3c.dom.Document;
import javax.xml.xpath.*;

public class SecureExamples {

    // === CWE-89: SQL Injection (준비된 문 사용) ======================================
    public void sqlSafeQueryExample(String username) throws Exception {
        // 예시: JDBC가 있다고 가정만 하고, 실 DB연결은 생략
        // String sql = "SELECT * FROM users WHERE username = ?";  // 안전
        // try (Connection c = ds.getConnection();
        //      PreparedStatement ps = c.prepareStatement(sql)) {
        //     ps.setString(1, username);
        //     try (ResultSet rs = ps.executeQuery()) { ... }
        // }
        if (username == null) throw new IllegalArgumentException("username");
        System.out.println("[CWE-89] PreparedStatement로 파라미터 바인딩");
    }

    // === CWE-22/23: 경로 조작 방지 (정규화 + 베이스 제한) ============================
    public void safePathRead(String userInput) throws Exception {
        Path base = Paths.get("C:/app/data").toAbsolutePath().normalize();
        Path target = base.resolve(userInput).normalize();
        if (!target.startsWith(base)) {
            throw new SecurityException("Path Traversal detected");
        }
        // Files.readAllBytes(target);
        System.out.println("[CWE-22/23] Path normalized OK: " + target);
    }

    // === CWE-78: OS Command Injection (화이트리스트 + 인자 분리) =====================
    public void safeCommandExec(String cmd) throws Exception {
        Set<String> allow = Set.of("ipconfig", "whoami", "dir");
        if (!allow.contains(cmd)) throw new SecurityException("Command not allowed");
        ProcessBuilder pb = new ProcessBuilder(cmd); // 인자 분리, 쉘 미사용
        pb.redirectErrorStream(true);
        // Process p = pb.start(); try (BufferedReader br = ...) { ... }
        System.out.println("[CWE-78] Allowed command exec: " + cmd);
    }

    // === CWE-611/776: XXE/Entity Expansion 방지 =====================================
    public void parseXmlSafely(String xml) throws Exception {
        DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
        f.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
        f.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        f.setXIncludeAware(false);
        f.setExpandEntityReferences(false);
        Document doc = f.newDocumentBuilder()
                .parse(new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8)));
        System.out.println("[CWE-611/776] XML parsed safely: " + doc.getDocumentElement().getNodeName());
    }

    // === CWE-502: 역직렬화 안전 (필터/화이트리스트 & 자바 직렬화 지양) ================
    public static byte[] sampleSerialized() throws IOException {
        // 데모용 직렬화 바이트
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        try (ObjectOutputStream oos = new ObjectOutputStream(bos)) {
            oos.writeObject("SAFE");
        }
        return bos.toByteArray();
    }
    public void deserializeSafely(byte[] data) throws Exception {
        try (ObjectInputStream ois = new ObjectInputStream(new ByteArrayInputStream(data))) {
            // Java 9+ 필터: 허용 타입만
            ObjectInputFilter filter = ObjectInputFilter.Config.createFilter("java.lang.String;!*");
            ObjectInputFilter.Config.setObjectInputFilter(ois, filter);
            Object obj = ois.readObject();
            if (!(obj instanceof String)) throw new SecurityException("Unexpected type");
            System.out.println("[CWE-502] Deserialized allowed type: " + obj);
        }
    }

    // === CWE-759/760/916: 안전한 패스워드 해싱 (PBKDF2 + SALT + 충분한 반복) ===========
    public void passwordHashAndVerify(String password) throws Exception {
        byte[] salt = new byte[16];
        SecureRandom.getInstanceStrong().nextBytes(salt);
        int iter = 120_000; // 정책에 맞게 상향 가능
        KeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iter, 256);
        SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] hash = skf.generateSecret(spec).getEncoded();

        // 검증 샘플
        boolean ok = verifyPassword(password, salt, iter, hash);
        System.out.println("[CWE-759/760/916] Password verified=" + ok);
    }
    private boolean verifyPassword(String password, byte[] salt, int iter, byte[] expected) throws Exception {
        KeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iter, expected.length * 8);
        SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] got = skf.generateSecret(spec).getEncoded();
        return constantTimeEquals(expected, got); // 타이밍 완화
    }

    // === CWE-327/326: 안전한 대칭키 암호 (AES/GCM, ECB 금지) =========================
    public void encryptAndDecrypt(String plaintext) throws Exception {
        KeyGenerator kg = KeyGenerator.getInstance("AES");
        kg.init(256);
        SecretKey key = kg.generateKey();

        byte[] iv = new byte[12];
        SecureRandom.getInstanceStrong().nextBytes(iv);
        GCMParameterSpec gcm = new GCMParameterSpec(128, iv);

        Cipher enc = Cipher.getInstance("AES/GCM/NoPadding");
        enc.init(Cipher.ENCRYPT_MODE, key, gcm);
        byte[] ct = enc.doFinal(plaintext.getBytes(StandardCharsets.UTF_8));

        Cipher dec = Cipher.getInstance("AES/GCM/NoPadding");
        dec.init(Cipher.DECRYPT_MODE, key, gcm);
        byte[] pt = dec.doFinal(ct);

        System.out.println("[CWE-327/326] Decrypted=" + new String(pt, StandardCharsets.UTF_8));
    }

    // === CWE-330/331: 충분히 예측 불가능한 랜덤 =====================================
    public void generateSecureToken(int bytes) throws Exception {
        byte[] b = new byte[bytes];
        SecureRandom.getInstanceStrong().nextBytes(b);
        System.out.println("[CWE-330/331] Token=" + Base64.getUrlEncoder().withoutPadding().encodeToString(b));
    }

    // === CWE-532/209: 민감정보 로그 노출 방지 & 오류 메시지 최소화 ===================
    public void safeLogging(String info, String secret) {
        String masked = secret.replaceAll(".", "*");
        System.out.println("[CWE-532] log info=" + info + ", secret=" + masked);
        try {
            throw new IOException("Internal I/O"); // 내부적으로만 상세
        } catch (IOException e) {
            System.out.println("[CWE-209] Error occurred. Please contact support with code=" + Instant.now().toEpochMilli());
            // 내부 로거엔 e를 남기되, 외부 출력은 최소화
        }
    }

    // === CWE-601: 열린 리다이렉트 방지 (상대경로/허용 호스트만 허용) ==================
    public void preventOpenRedirect(String target) throws Exception {
        URI uri = URI.create(target);
        if (uri.isAbsolute()) throw new SecurityException("Absolute URL not allowed");
        // 또는 화이트리스트 도메인만 허용
        System.out.println("[CWE-601] Redirect to relative path: " + uri);
    }

    // === CWE-113: HTTP 응답 분할 방지 (CRLF 제거) ====================================
    public String preventRespSplitting(String value) {
        String cleaned = value.replaceAll("[\\r\\n]", "");
        System.out.println("[CWE-113] header-safe value=" + cleaned);
        return cleaned;
    }

    // === CWE-434: 업로드 제한 (확장자/크기/경로 검증) =================================
    public void safeUploadCheck(String filename) {
        Set<String> allowExt = Set.of(".png", ".jpg", ".pdf");
        String lower = filename.toLowerCase(Locale.ROOT);
        boolean ok = allowExt.stream().anyMatch(lower::endsWith);
        if (!ok) throw new SecurityException("File type not allowed");
        System.out.println("[CWE-434] Allowed upload: " + filename);
    }

    // === CWE-208: 타이밍 차이 완화(상수시간 비교) =====================================
    public boolean safeEquals(String a, String b) {
        return constantTimeEquals(a.getBytes(StandardCharsets.UTF_8), b.getBytes(StandardCharsets.UTF_8));
    }
    private boolean constantTimeEquals(byte[] x, byte[] y) {
        if (x.length != y.length) return false;
        int r = 0;
        for (int i = 0; i < x.length; i++) r |= x[i] ^ y[i];
        return r == 0;
    }

    // === CWE-90: LDAP Injection 방지 (필터 이스케이프) ================================
    public void ldapSafeSearch(String username) throws Exception {
        String escaped = ldapEscape(username);
        String filter = "(uid=" + escaped + ")";  // 안전 필터
        // DirContext ctx = new InitialDirContext(env); ctx.search("ou=people", filter, controls);
        System.out.println("[CWE-90] LDAP filter=" + filter);
    }
    private String ldapEscape(String v) {
        return v.replace("\\", "\\5c")
                .replace("*", "\\2a")
                .replace("(", "\\28")
                .replace(")", "\\29")
                .replace("\u0000", "\\00");
    }

    // === CWE-643: XPath Injection 방지 (값 이스케이프/검증) ==========================
    public void xpathSafeSearch(String xml, String id) throws Exception {
        DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
        f.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
        f.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        Document doc = f.newDocumentBuilder()
                .parse(new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8)));

        String safe = id.replace("'", "&apos;"); // 가장 간단 이스케이프(전처리 검증 병행 권장)
        XPath xp = XPathFactory.newInstance().newXPath();
        String expr = String.format("//id[text()='%s']", safe);
        String val = xp.evaluate(expr, doc);
        System.out.println("[CWE-643] XPath result=" + val);
    }

    // === CWE-772: 리소스 해제 누락 방지 (try-with-resources) =========================
    public void tryWithResourcesDemo() throws Exception {
        Path p = Paths.get("example.txt");
        try (BufferedWriter w = Files.newBufferedWriter(p, StandardCharsets.UTF_8, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING)) {
            w.write("hello");
        }
        System.out.println("[CWE-772] File written safely");
    }

    // === CWE-476: NPE 방지 (사전 검증) ================================================
    public void nullSafe(String s) {
        Objects.requireNonNull(s, "s");
        System.out.println("[CWE-476] len=" + s.length());
    }

    // === CWE-732: 중요 리소스 권한 과다 배정 방지 ====================================
    public void writeFileWithLeastPrivilege() throws Exception {
        Path p = Paths.get("secure-data.txt");
        // Windows에서도 동작하지만 POSIX 권한은 *nix에서만 적용
        Set<PosixFilePermission> perms = PosixFilePermissions.fromString("rw-------"); // 600
        FileAttribute<Set<PosixFilePermission>> attr = PosixFilePermissions.asFileAttribute(perms);
        try {
            Files.createFile(p, attr);
        } catch (UnsupportedOperationException e) {
            // Windows 등 POSIX 미지원 시 대체 처리
            Files.createFile(p);
        }
        System.out.println("[CWE-732] Created with least privilege (where supported)");
    }

    // === CWE-798/259: 하드코딩 비밀번호 금지 (환경/비밀관리) ==========================
    public void loadSecretFromEnv() {
        String apiKey = System.getenv("APP_API_KEY"); // 하드코딩 금지
        if (apiKey == null || apiKey.isBlank()) {
            System.out.println("[CWE-798/259] Missing secret in env");
        } else {
            System.out.println("[CWE-798/259] Loaded secret from env");
        }
    }

    // === CWE-367: TOCTTOU 완화 (원자적 파일 작업 사용) ================================
    public void tocTouSafeTempWrite(String content) throws Exception {
        Path dir = Paths.get("C:/app/tmp").toAbsolutePath().normalize();
        Files.createDirectories(dir);
        Path tmp = Files.createTempFile(dir, "w-", ".part");
        Files.writeString(tmp, content, StandardCharsets.UTF_8);
        Path dst = dir.resolve("final.txt");
        Files.move(tmp, dst, StandardCopyOption.ATOMIC_MOVE, StandardCopyOption.REPLACE_EXISTING);
        System.out.println("[CWE-367] Atomic move completed");
    }
}
