<%@ page import="com.gpki.io.GPKIJspWriter" %>
<%@ page import="com.gpki.servlet.GPKIHttpServletRequest" %>
<%@ page import="com.gpki.servlet.GPKIHttpServletResponse" %>
<%@ page import="com.gpki.secureweb.GPKIKeyInfo" %>
<%@ page import="com.dsjdf.jdf.*" %>
<%@ page import="java.net.*"%>
<%
	GPKIHttpServletResponse gpkiresponse = null;
	GPKIHttpServletRequest gpkirequest   = null;

	try {
		Logger.debug.println(this, "222222222222222");
		gpkiresponse = new GPKIHttpServletResponse(response); 
		Logger.debug.println(this, "2222222222222223333"+gpkiresponse);
		gpkirequest  = new GPKIHttpServletRequest(request);
		Logger.debug.println(this, "2222222222222224444");
		gpkiresponse.setRequest(gpkirequest);

		out = new GPKIJspWriter(out,(GPKIKeyInfo)session.getAttribute("GPKISession"));
		Logger.debug.println(this, "[current_thread]["+Thread.currentThread()+"] gpkisecureweb ref= " + out.toString());
	} catch (NullPointerException e) {
		Logger.debug.println(this, "2222222222222224444e1"+e);
		com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
		StringBuffer sb = new StringBuffer(1500);
		sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
		sb.append("?errmsg=");
		sb.append(URLEncoder.encode(e.getMessage(), "euc-kr"));
		response.sendRedirect(sb.toString());
		return;
	}catch (Exception e) {
		Logger.debug.println(this, "2222222222222224444e2"+e);
		com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
		StringBuffer sb = new StringBuffer(1500);
		sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
		sb.append("?errmsg=");
		sb.append(URLEncoder.encode(e.getMessage(), "euc-kr"));
		response.sendRedirect(sb.toString());
		return;
	}
%>
