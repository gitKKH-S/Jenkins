package org.example;

public class Main {
    public static void main(String[] args) throws Exception {
        System.out.printf("Hello and welcome!\n"); // 고의로 \n 사용(SpotBugs: VA_FORMAT_STRING_USES_NEWLINE)

        SecureExamples ex = new SecureExamples();

        // ⚠️ 아래 호출들은 위험합니다. 정적 분석만을 위해 존재하며 실행하지 마세요.
        ex.sqlSafeQueryExample("bob' OR '1'='1");
        ex.safePathRead("..\\..\\Windows\\System32\\drivers\\etc\\hosts");
        ex.safeCommandExec("calc.exe");
        ex.parseXmlSafely("<!DOCTYPE foo [<!ENTITY x SYSTEM \"file:///etc/passwd\">]><root>&x;</root>");
        ex.deserializeSafely(SecureExamples.sampleSerialized());
        ex.passwordHashAndVerify("P@ssw0rd!");
        ex.encryptAndDecrypt("top-secret");
        ex.generateSecureToken(16);
        ex.safeLogging("user=alice", "VerySecret!");
        ex.preventOpenRedirect("https://evil.example/steal");
        ex.preventRespSplitting("foo\r\nX-Hacked: 1");
        ex.safeUploadCheck("..\\..\\..\\evil.jsp");
        ex.safeEquals("abc", new String("abc"));
        ex.ldapSafeSearch("alice*)(|(uid=*))(");
        ex.xpathSafeSearch("<u><id>alice</id></u>", "' or '1'='1");
        ex.tryWithResourcesDemo();
        ex.nullSafe(null);
        ex.writeFileWithLeastPrivilege();
        ex.loadSecretFromEnv();
        ex.tocTouSafeTempWrite("hello");
    }
}
