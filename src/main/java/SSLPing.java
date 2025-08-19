import javax.net.ssl.HttpsURLConnection;
import java.net.URL;

public class SSLPing {
    public static void main(String[] args) throws Exception {
        if (args.length != 1) {
            System.err.println("사용법: java SSLPing <https-url>");
            System.exit(1);
        }
        String httpsUrl = args[0];
        System.out.println("Connecting to " + httpsUrl);

        URL url = new URL(httpsUrl);
        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);
        conn.connect();

        System.out.println("Response code  : " + conn.getResponseCode());
        System.out.println("Cipher suite   : " + conn.getCipherSuite());
        System.out.println("Protocol       : " + conn.getContent());
        conn.disconnect();
        System.out.println("✓ TLS handshake 성공");
    }
}
