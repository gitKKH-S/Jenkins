<%@ page import="com.gpki.gpkiapi.storage.Disk" %>
<%@ page import="com.gpki.gpkiapi.util.Base64" %>
<%@ page import="com.gpki.gpkiapi.cert.X509Certificate" %>
<%
String SERVER_KM_CERT_PATH = "/home/legal/legalb/gpkisecureweb/WEB-INF/certs/SVR6113516002_env.cer";
Base64 base64 = new Base64();
byte[] bBase64 = null;
String strBase64 = "";
X509Certificate srvCert = Disk.readCert(SERVER_KM_CERT_PATH);
bBase64 = srvCert.getCert();
strBase64 = new String(base64.encode(bBase64));
%>
