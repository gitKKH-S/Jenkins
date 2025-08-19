package com.mten.email;

import javax.mail.MessagingException;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.PasswordAuthentication;

public class MailSend {
    public static void main(String args[]) throws MessagingException{
        String recipient = "kyugwan@naver.com";

        sendMail(recipient,"111","dddd");
    }

    public static void sendMail(String toMail ,String userid , String pwd) throws MessagingException{
        System.out.println("메일발송준비");
        // 메일 관련 정보
        String host = "gwmail.yakult.co.kr";
        final String username = "hydoc@yakult.co.kr";	// kmf567890@gmail.com
        final String password = "yakult510!";		// !2QWEasd
        // 메일 내용
        String recipient = toMail;
        String subject = "한국야쿠르트 문서관리시스템 관리자입니다.";
        String body = "비밀번호를 발송합니다. \n 아이디 : "+userid+" / 비밀번호 : "+pwd;
        //properties 설정
        Properties props = new Properties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", 587);
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.trust", host);
        
        Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
            String un=username;
            String pw=password;
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(un, pw);
            }
        });
        session.setDebug(true); //for debug
        Message mimeMessage = new MimeMessage(session);
        mimeMessage.setFrom(new InternetAddress(username));
        mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
        mimeMessage.setSubject(subject);
        mimeMessage.setText(body);
        Transport.send(mimeMessage);
        System.out.println("메일발송완료");
    }
    
    public static void sendMail2(String toMail ,String userid , String pwd) throws MessagingException{
        System.out.println("메일발송준비");
        // 메일 관련 정보
        String host = "smtp.gmail.com";
        String username = "kmf567890@gmail.com";
        String password = "!2QWEasd";
        // 메일 내용
        String recipient = toMail;
        String subject = "한국야쿠르트 문서관리시스템 관리자입니다.";
        String body = "비밀번호를 발송합니다. \n 아이디 : "+userid+" / 비밀번호 : "+pwd;
        //properties 설정
        Properties props = new Properties();
        props.put("mail.smtps.auth", "true");
        // 메일 세션
        Session session = Session.getDefaultInstance(props);
        MimeMessage msg = new MimeMessage(session);
        // 메일 관련
        msg.setSubject(subject);
        msg.setText(body);
        msg.setFrom(new InternetAddress(username));
        msg.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
        // 발송 처리
        Transport transport = session.getTransport("smtps");
        transport.connect(host, username, password);
        transport.sendMessage(msg, msg.getAllRecipients());
        transport.close();
        System.out.println("메일발송완료");
    }

    public static void naver(String args[]) throws MessagingException {
        // 메일 관련 정보
        String host = "smtp.naver.com";
        final String username = "네이버아이디";
        final String password = "비밀번호";
        int port=465;
        // 메일 내용
        String recipient = "수신자";
        String subject = "네이버를 사용한 발송 테스트입니다.";
        String body = "내용 무";
        Properties props = System.getProperties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.trust", host);
        Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
            String un=username;
            String pw=password;
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(un, pw);
            }
        });
        session.setDebug(true); //for debug
        Message mimeMessage = new MimeMessage(session);
        mimeMessage.setFrom(new InternetAddress("발신자 정보"));
        mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
        mimeMessage.setSubject(subject);
        mimeMessage.setText(body);
        Transport.send(mimeMessage);
    }
}
