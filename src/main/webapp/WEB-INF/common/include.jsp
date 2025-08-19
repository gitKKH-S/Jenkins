<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"  %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"  %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld"  %>
<%@ taglib prefix="sql" uri="/WEB-INF/tld/sql.tld"  %>
<%@ taglib prefix="x" uri="/WEB-INF/tld/x.tld"  %>
<%@ taglib prefix="spring" uri="/WEB-INF/tld/spring.tld" %>
<%@ taglib prefix="spform" uri="/WEB-INF/tld/spring-form.tld" %>
<%@ taglib prefix="ktag" uri="/WEB-INF/tld/ktag.tld" %>
<spring:url value="/resources" var="resourceUrl" />
<% pageContext.setAttribute("newLine", "\n"); %> 
<%
	String SYSTITLE = "::::::::::::: 서울특별시 법률지원통합시스템 :::::::::::::";
	String CONTEXTPATH = request.getContextPath();
%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />
<c:set var="DMI" value="seoul" />
<c:set var="browser" value="${header['user-agent'] }" scope="session" />
<c:set var="servletPath" value="${requestScope['javax.servlet.forward.servlet_path']}" />

<jsp:useBean id="DATE" class="java.util.Date"/>
<fmt:formatDate value="${DATE }" var="TODAY" pattern="yyyy/MM/dd" />
<fmt:formatDate value="${DATE }" var="TODAY_YEAR" pattern="yyyy" />
<fmt:formatDate value="${DATE }" var="TODAY_MONTH" pattern="MM" />
<fmt:formatDate value="${DATE }" var="TODAY_DAY" pattern="dd" />
