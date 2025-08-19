<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*" %>
<%
	String Writer ="";
	String Writerno="";
	String Dept="";
	String Email="";
	String Grpcd="";
	String USERLEVEL="";
	String Officephone="";
	String Posit = "";
	String Orgname ="";
	String Deptcd ="";
	String Empno ="";
	String Nickname ="";
	String Mileage = "";
	String PASS="";
	String priv_cd = "";
	String grdcd = "";
	String pw = "";
	String DEPTPATH = "";
	System.out.println("SSSSSSSSaa===>"+session.getId());
	boolean Session = false;
	try{
	//세션값 받기
		HashMap h = (HashMap)session.getAttribute("userInfo");
		Writer = h.get("Writer")==null?"":h.get("Writer").toString();						//작성자이름
		Writerno = h.get("Writerno")==null?"":h.get("Writerno").toString();					//PK
		Empno = h.get("Empno")==null?"":h.get("Empno").toString();							//사번
		Dept = h.get("Dept")==null?"":h.get("Dept").toString();							//팀명
		Email = h.get("Email")==null?"":h.get("Email").toString(); 	//메일
		Officephone = h.get("Officephone")==null?"":h.get("Officephone").toString(); 	//전화
		Grpcd = h.get("Grpcd")==null?"":h.get("Grpcd").toString();							//Y:관리자  G:감사실  N:사규담당자
		USERLEVEL = h.get("Grpcd")==null?"":h.get("Grpcd").toString();							//Y:관리자  G:감사실  N:사규담당자
		Posit = h.get("Posit")==null?"":h.get("Posit").toString();								//직위
		Orgname = h.get("Orgname")==null?"":h.get("Orgname").toString();							//부서명
		Deptcd = h.get("deptcd")==null?"":h.get("deptcd").toString();							//부서명CD
		Nickname = h.get("Nickname")==null?"":h.get("Nickname").toString();							//닉네임
		PASS = h.get("PASS")==null?"":h.get("PASS").toString();
		priv_cd = h.get("priv_cd")==null?"":h.get("priv_cd").toString();
		grdcd = h.get("grdcd")==null?"":h.get("grdcd").toString();
		pw = h.get("pw")==null?"":h.get("pw").toString();
		DEPTPATH = h.get("DEPTPATH")==null?"":h.get("DEPTPATH").toString();
		System.out.println("%%%%%%%%%%%%%%%%%%=>"+h);
		if (Grpcd.equals("")){%>
	<script language="javascript">
		alert("보안정책상 장시간 미사용으로 자동로그아웃 되었습니다1.");
		window.open('<%=CONTEXTPATH %>/jsp/lkms3/jsp/login/login.jsp','goLogin',"left=400,top=400,width=510,height=400,scrollbars=yes,resizable=yes,status=no,toolbar=no");
		window.open("about:blank","_self").close();
	</script>
	  <%}
		Session =true;
	}catch(Exception e){
		out.println(e);
%>
	<script language="javascript">
		alert("보안정책상 장시간 미사용으로 자동로그아웃 되었습니다2.");
		window.open('<%=CONTEXTPATH %>/jsp/lkms3/jsp/login/login.jsp','goLogin',"left=400,top=400,width=510,height=400,scrollbars=yes,resizable=yes,status=no,toolbar=no");
		window.open("about:blank","_self").close();
	</script>
<%
	}
%>