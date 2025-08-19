package org.example;

public class Main {
    public static void main(String[] args) throws Exception {
        SecureExamples ex = new SecureExamples();

        // 필요한 것만 주석 해제해서 테스트하세요.
        ex.sqlSafeQueryExample("alice");                            // CWE-89
        ex.safePathRead("docs/report.pdf");                         // CWE-22/23
        ex.safeCommandExec("ipconfig");                             // CWE-78
        ex.parseXmlSafely("<root>ok</root>");                       // CWE-611/776
        ex.deserializeSafely(SecureExamples.sampleSerialized());    // CWE-502
        ex.passwordHashAndVerify("P@ssw0rd!");                      // CWE-759/760/916
        ex.encryptAndDecrypt("top-secret");                         // CWE-327/326
        ex.generateSecureToken(32);                                 // CWE-330/331
        ex.safeLogging("user=alice", "pwd=VerySecret!");            // CWE-532/209
        ex.preventOpenRedirect("/home");                            // CWE-601
        ex.preventRespSplitting("value");                           // CWE-113
        ex.safeUploadCheck("profile.png");                          // CWE-434
        ex.safeEquals("abc", "abc");                                // CWE-208 (타이밍 완화)
        ex.ldapSafeSearch("alice");                                 // CWE-90
        ex.xpathSafeSearch("<u><id>alice</id></u>", "alice");       // CWE-643
        ex.tryWithResourcesDemo();                                  // CWE-772
        ex.nullSafe("text");                                        // CWE-476
        ex.writeFileWithLeastPrivilege();                           // CWE-732
        ex.loadSecretFromEnv();                                     // CWE-798/259
        ex.tocTouSafeTempWrite("hello");                            // CWE-367
    }
}
