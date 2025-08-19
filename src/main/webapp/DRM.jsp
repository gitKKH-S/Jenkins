<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%@page import="com.mten.util.fasooDrm"%>
<%
System.out.println("E start--------------------------");
fasooDrm.fileDoPackaging("10000202.hwp", "A10000202.hwp", "/home/legal/legalb/dataFile/bbs/");
System.out.println("E end--------------------------");
System.out.println("D start--------------------------");
fasooDrm.fileUnPackaging("E10000202.hwp", "D10000202.hwp", "/home/legal/legalb/dataFile/bbs/");
System.out.println("D end--------------------------");
%>
