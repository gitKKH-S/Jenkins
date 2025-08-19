package com.mten.bylaw.mif;

import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;

public class AlertApi extends Thread {
  private String strSnd = "";
  
  private String ip = "";
  
  private int port = 0;
  
  public AlertApi(String paramString, int paramInt) {
    this.ip = paramString;
    this.port = paramInt;
  }
  
  public void MakePacket(String paramString1, String paramString2, int paramInt, String paramString3, String paramString4, String paramString5) {
    byte b = 0;
    String str1 = "";
    String str2 = Integer.toString(paramInt);
    int i = 4 - str2.length();
    for (b = 0; b < i; b++)
      str1 = str1 + "0"; 
    str1 = str1 + str2;
    this.strSnd = "N" + paramString1 + paramString2 + "^" + str1 + paramString3 + "^" + paramString4 + "^" + paramString5 + "\f\f";
    System.out.println(this.strSnd);
  }
  
  public void SetPacket(String paramString) {
    this.strSnd = paramString;
  }
  
  public void SendPacket() {
    start();
  }
  
  public void run() {
    Socket socket = null;
    PrintWriter printWriter = null;
    int timeout = 10000;
    try {
      socket = new Socket(this.ip, this.port);
      socket.setSoTimeout(timeout);
      printWriter = new PrintWriter(new OutputStreamWriter(socket.getOutputStream()));
      System.out.println(this.strSnd);
      printWriter.println(this.strSnd);
      printWriter.flush();
    } catch (Exception exception) {
      System.err.println(exception);
    } finally {
      try {
        printWriter.close();
        printWriter = null;
      } catch (Exception exception) {}
      try {
        socket.close();
        socket = null;
      } catch (Exception exception) {}
    } 
  }
}
