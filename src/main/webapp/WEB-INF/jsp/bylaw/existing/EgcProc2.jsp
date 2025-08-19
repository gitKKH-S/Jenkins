<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="com.mten.common.MakeHan"%>
<%@ page import="com.mten.bylaw.model.Bylaw"%>
<%@ page import="com.mten.bylaw.service.*"%>
<%@ page import="com.mten.common.MakeHan"%>
<%@include file="/jsp/common/session.jsp" %>
<%
	String Bookcode = ServletRequestUtils.getStringParameter(request, "Bookcode", "");				//�����ڵ�
	String Title = ServletRequestUtils.getStringParameter(request,"Title", "");						//���Ը�
	String Mainpith = ServletRequestUtils.getStringParameter(request,"Mainpith", "");				//���Թ�ȣ
	String Bookcd = ServletRequestUtils.getStringParameter(request,"Bookcd", "");					//���Ա���
	String Booksubcd = ServletRequestUtils.getStringParameter(request,"Booksubcd", "");
	String Revcd = ServletRequestUtils.getStringParameter(request,"Revcd", "");						//����������
	String Revcha = ServletRequestUtils.getStringParameter(request,"Revcha", "");					//��������
	String Promulno = ServletRequestUtils.getStringParameter(request,"Promulno", "");				//������ȣ
	String Promuldt = ServletRequestUtils.getStringParameter(request,"Promuldt", "7777-12-31");				//������
	String Startdt = ServletRequestUtils.getStringParameter(request,"Startdt", "6666-12-31");					//������
	String Enddt = ServletRequestUtils.getStringParameter(request,"Enddt", "5555-12-31");						//������
	if(Promuldt.equals(""))Promuldt="7777-12-31";
	if(Startdt.equals(""))Startdt="6666-12-31";
	if(Enddt.equals(""))Enddt="5555-12-31";
	String Ord = ServletRequestUtils.getStringParameter(request,"Ord", "0");						//���ļ���
	String Otherlaw = ServletRequestUtils.getStringParameter(request,"Otherlaw", "");				//Ÿ��
	String Deptname = ServletRequestUtils.getStringParameter(request,"Deptname", "");				//�μ���
	String Legislator = ServletRequestUtils.getStringParameter(request,"Legislator", "");			//��������
	String bylawFileUrl = ServletRequestUtils.getStringParameter(request,"bylawFileUrl", "");		//���ϰ��
	String bylawFilename = ServletRequestUtils.getStringParameter(request,"bylawFilename", "");		//���ϸ�
	String fileName = ServletRequestUtils.getStringParameter(request,"fileName", "");				//���ϸ�
	String Stateid = ServletRequestUtils.getStringParameter(request,"Statecd", "1000");				//���Ի���
	String sDept = ServletRequestUtils.getStringParameter(request,"dept", Dept);	//
	String Pcatid = ServletRequestUtils.getStringParameter(request,"Pcatid", "");					//Ʈ���κ��� �Ѿ�� ��
	String Noformyn = ServletRequestUtils.getStringParameter(request,"Noformyn", "N");	
	String noFormYn_Tree = ServletRequestUtils.getStringParameter(request,"noFormYn", "N");		    //Ʈ���κ��� �Ѿ�� ��
	String state = ServletRequestUtils.getStringParameter(request,"state", "");						//����������
	String pstate = ServletRequestUtils.getStringParameter(request,"pstate", "");					//���,����,��������
	String Obookid = ServletRequestUtils.getStringParameter(request,"Obookid", "");					//
	String bontxt = ServletRequestUtils.getStringParameter(request,"bontxt", "");					//����
	String bonhtml = ServletRequestUtils.getStringParameter(request,"bonhtml", "");					//����html
	String Xmlid = ServletRequestUtils.getStringParameter(request,"Xmlid", "");					
	String gbn = ServletRequestUtils.getStringParameter(request, "gbn", "");						//��ũ���� ����
	String subTitle = ServletRequestUtils.getStringParameter(request,"subTitle", "");	//�����ڵ�
	String username = ServletRequestUtils.getStringParameter(request,"username", "");					//
	String userid = ServletRequestUtils.getStringParameter(request,"userid", "");					//
	String phone = ServletRequestUtils.getStringParameter(request,"phone", "");
	String CHG = ServletRequestUtils.getStringParameter(request,"CHG", ""); 						//������ ���ΰ���ó�� �ϴ��� üũ
	String buyn = ServletRequestUtils.getStringParameter(request,"buyn", "N");
	String actionyn = ServletRequestUtils.getStringParameter(request,"actionyn", "N");
	String grade = ServletRequestUtils.getStringParameter(request,"grade", "");
	String before_statehistoryid = ServletRequestUtils.getStringParameter(request,"bstatehistoryid", "0");
	String approverid = ServletRequestUtils.getStringParameter(request,"approverid", "");
	String buchkyn = ServletRequestUtils.getStringParameter(request,"buchkyn", "");
	String prelawyn = ServletRequestUtils.getStringParameter(request,"prelawyn", "");
	String homeyn = ServletRequestUtils.getStringParameter(request,"homeyn", "");
	String openyn = ServletRequestUtils.getStringParameter(request,"openyn", "");
	
	if(pstate.equals("P")){
		pstate = "RE";
	}
	
	if (Stateid.equals("")){
		Stateid = "1000";
	}
	
	bontxt = bontxt.replaceAll("��", "\"").replaceAll("��", "\"");
	
	BylawService service = BylawServiceHelper.getBylawService(application);
	String Statecd = service.getStateCd(Stateid);
	Bylaw bylaw = new Bylaw();
	bylaw.setBookcode(Bookcode);
	bylaw.setPcatid(Pcatid);
	bylaw.setTitle(Title);
	bylaw.setMainpith(Mainpith);
	bylaw.setBookcd(Bookcd);
	bylaw.setBooksubcd(Booksubcd);
	bylaw.setRevcd(Revcd);
	bylaw.setRevcha(Revcha);
	bylaw.setPromulno(Promulno);
	bylaw.setPromuldt(Promuldt);
	bylaw.setStartdt(Startdt);
	bylaw.setStatecd(Stateid);
	bylaw.setDept(sDept);
	bylaw.setAbolishdt("");
	bylaw.setUseyn("Y");
	bylaw.setDelyn("N");
	bylaw.setRevreason("");
	bylaw.setXmldata("");
	bylaw.setOpenyn(openyn);
	bylaw.setWorkstatecd("");
	bylaw.setNoformyn(Noformyn);
	bylaw.setLinkurl("");
	bylaw.setEnddt(Enddt);
	bylaw.setOrd(Ord);
	bylaw.setBontxt(bontxt);
	bonhtml = bonhtml.replaceAll("&#8228;","��");
	bylaw.setBonhtml(bonhtml);
	bylaw.setOtherlaw(Otherlaw);
	bylaw.setDeptname(Deptname);
	bylaw.setLegislator(Legislator);
	bylaw.setUpdt(MakeHan.get_data());
	bylaw.setObookid(Obookid);
	bylaw.setSubtitle(subTitle);
	bylaw.setUsername(username);
	bylaw.setUserid(userid);
	bylaw.setPhone(phone);
	bylaw.setChg(CHG);
	bylaw.setBuyn(buyn);
	bylaw.setActionyn(actionyn);
	bylaw.setGrade(grade);
	bylaw.setApproverid(approverid);
	bylaw.setBuchkyn(buchkyn);
	bylaw.setHomeyn(homeyn);
	bylaw.setPrelawyn(prelawyn);
	bylaw.setWriterid(Writerno);
	if(Revcd.equals("���ΰ���")||CHG.equals("Y")){
		bylaw.setAllrevyn("Y");
	}else{
		bylaw.setAllrevyn("N");
	}
	
	if(pstate.equals("I")){	//���������� ����ū�� ����
		bylaw.setOrd(service.getMaxOrd(Pcatid));
	}
	
	String Bookid = "";
	String statehistoryid = "";
	String result = "";
	boolean result2 = false;
	if(pstate.equals("I")){	//�������� ����
		Bylaw re = service.setEnactment_new(bylaw);
		Bookid = re.getBookid();
		statehistoryid = re.getStatehistoryid();
		//result = "{success:true,key:{Bookid:'"+Bookid+"'}}";
	}else if(pstate.equals("U")){	//�������� ������������
		Bookid = ServletRequestUtils.getStringParameter(request,"Bookid", "");
		statehistoryid = ServletRequestUtils.getStringParameter(request,"statehistoryid", "");
		bylaw.setStatehistoryid(statehistoryid);
		bylaw.setBookid(Bookid);
		System.out.println("===>"+bylaw.getStatehistoryid());
		int re = service.noFormUp(bylaw).intValue();		
		if(re>0){
			result = "{success:true,key:{Bookid:'"+Bookid+"'}}";
		}else{
			result = "{failure:true,key:{Bookid:'"+Bookid+"'}}";
		}
	}else if(pstate.equals("RE")){	
		if(noFormYn_Tree.equals("Y")){	//������������ ���������� ���ΰ���
			bylaw.setBookid(ServletRequestUtils.getStringParameter(request,"Bookid", ""));
			Bylaw re = service.allDocRevision(bylaw);
			Bookid = re.getBookid();
			statehistoryid = re.getStatehistoryid();
			result = "{success:true,key:{Bookid:'"+Bookid+"'}}";
		}else{
			if(Revcd.equals("���ΰ���")||CHG.equals("Y")){						//�������� ���ΰ���
				bylaw.setBookid(ServletRequestUtils.getStringParameter(request,"Bookid", ""));
				Bylaw re = service.allDocRevision(bylaw);
				Bookid = re.getBookid();
				statehistoryid = re.getStatehistoryid();
				result = "{success:true,key:{Bookid:'"+Bookid+"'}}";
			}else{												//������������
				bylaw.setBookid(ServletRequestUtils.getStringParameter(request,"Bookid", ""));
				bylaw.setStatehistoryid(ServletRequestUtils.getStringParameter(request,"statehistoryid", ""));
				Bookid = ServletRequestUtils.getStringParameter(request,"Bookid", "");
				statehistoryid = ServletRequestUtils.getStringParameter(request,"statehistoryid", "");
				bylaw.setStatehistoryid(statehistoryid);
				bylaw.setBookid(Bookid);
				
				statehistoryid = service.DocRevision_V2(bylaw);
				//Bookid = service.getSeqid("BOOKID");
				//statehistoryid = service.getSeqid("STATEHISTORYID");
			}
		}
	}else if(pstate.equals("CRE")){	//���Ӱ���	
		Title = MakeHan.toKorean(Title);
		out.println("<div id=\"bb\" style=\"margin: 5px 5px 5px 25px; text-align: left; display:''\">");
		out.println(Title+" "+Revcha+ "�� �� ���� ���� ���Դϴ�.");
		out.println("</div>");
	}else if(pstate.equals("FILE")){ //�������� �� �ֿ䳻��	
		Title = MakeHan.toKorean(Title);
		out.println("<div id=\"bb\" style=\"margin: 5px 5px 5px 25px; text-align: left; display:''\">");
		out.println(Title+" "+Revcha+ " �������� �� �ֿ䳻�� ������Դϴ�.");
		out.println("</div>");		
	}else if(pstate.equals("URE")||pstate.equals("YURE")||pstate.equals("YURE2")){	//�������
		if ( MakeHan.setBrowser(request).equals("ie8")){
		Title = MakeHan.toKorean(Title);
		}
		Bookid = ServletRequestUtils.getStringParameter(request,"Bookid", "");
		statehistoryid = ServletRequestUtils.getStringParameter(request,"statehistoryid", "");
		System.out.println("Bookid===>"+Bookid);
		System.out.println("statehistoryid===>"+statehistoryid);
		
		Bylaw as = service.selectBon(Bookid);
		Startdt = as.getStartdt();
		Enddt = as.getEnddt();
		Promuldt = as.getPromuldt();
		Revcd = as.getRevcd();
		Title = as.getTitle();
		out.println("<div id=\"bb\" style=\"margin: 5px 5px 5px 25px; text-align: left; display:''\">");
		out.println(Title+" "+Revcha+ "���� ������ ���� ���Դϴ�.");
		out.println("</div>");
	}else if(state.equals("link1")){			//��ũ����
		if(gbn.equals("DOC")){					//���๮�� ��ũ����
			result = service.makeLink(ServletRequestUtils.getStringParameter(request,"Bookid", ""));	
		}else if(gbn.equals("ALLDOC")){			//���๮�� �������� ��ũ����
			result2 = service.makeAllLink(ServletRequestUtils.getStringParameter(request,"Bookid", ""));
		}else if(gbn.equals("TOTALDOC")){		//��ü���� ��ũ����
			result2 = service.makeAllLink("");	
		}
		if(!result.equals("")){
			result2 = true;
		}
	}
	String userAgent = request.getHeader("User-Agent");
	String Browser = "";
	if (userAgent.indexOf("Trident") > 0 || userAgent.indexOf("MSIE") > 0) {
		Browser = "IE";
	} else if(userAgent.indexOf("Chrome") > 0){
		Browser = "Chrome";
	}else{
		Browser = "Other";
	}
%>
<script type="text/javascript" src="<%=CONTEXTPATH %>/js/setup.js"></script>
<script>
var Browser = "<%=Browser%>";
function makeXml(revmode){
	var strXML = "<data>";
	//sample="lawxml=����,prtlaw=���������,downlaw=cd����"
	strXML = strXML + "<exeform>lawxml</exeform>";
	strXML = strXML + "<statehistoryid><%=statehistoryid%></statehistoryid>";
	//^explanation=\"�ش�ȵɰ��^0\"
	strXML = strXML + "<before_statehistoryid><%=before_statehistoryid%></before_statehistoryid>";
	
	//^explanation=\"����0,����1,����2,���Ӱ���3,���ż���4\"
	strXML = strXML + "<revmode>3</revmode>";
	strXML = strXML + "<LKRMS5configurl><%=MakeHan.File_url("ROOTURL")%><%=CONTEXTPATH%>/jsp/bylaw/dllapp/LKRMS5.config</LKRMS5configurl>";
	strXML = strXML + "<LawXmlconfigurl><%=MakeHan.File_url("ROOTURL")%><%=CONTEXTPATH%>/jsp/bylaw/dllapp/LawXml.exe.config</LawXmlconfigurl>";
	strXML = strXML + "</data>";
	return strXML;
}
<% 
	if(pstate.equals("I")||pstate.equals("U")){	//����,�������� ����
		if(pstate.equals("I")){
%>
			function goDll(){
				var xml = makeXml('1');
				chkSetUp(xml);
				
				parent.msghidden();
				parent.msgbox2('<%=Bookid%>','<%=Noformyn%>','<%=statehistoryid%>');
				parent.treload();
				parent.close();
			}
<%
		}else{
%>
			parent.msghidden();
			parent.getDocInfo('<%=Bookid%>','<%=Noformyn%>','<%=statehistoryid%>');
			parent.treload();
			parent.close();
<%	
		}
	}
	if(pstate.equals("CRE")){	//���Ӱ���
%>
		function goDll(){
			parent.msghidden();
			Main.metaXml = makeXml('3');
			Main.Start();
			Main.End();
			//������ �ٽ� ����
			//parent.getDocInfo('<%=ServletRequestUtils.getStringParameter(request,"Bookid", "") %>','<%=Noformyn%>');
			//parent.treload();
			document.all.bb.style.display='none';
			document.all.aa.style.display='';
			//parent.close();
		}
<%	
	}
	if(pstate.equals("FILE")){	//���������� �ֿ����
	%>
		function goDll(){
			parent.msghidden(); 
			Main.sBookId = "<%=ServletRequestUtils.getStringParameter(request,"Bookid", "") %>";
			Main.sRevCha = "<%=Revcha%>";
			Main.sStatecd = "<%=Statecd%>";
			Main.sWork = "<%=Statecd%>";
			Main.sFileId = "<%=Statecd%>";
			Main.sOpen = "Y";
			Main.sWork = "FILE";
			Main.Start();
			Main.End();
			//������ �ٽ� ����
			parent.getDocInfo('<%=ServletRequestUtils.getStringParameter(request,"Bookid", "") %>','<%=Noformyn%>');
			parent.treload();
			document.all.bb.style.display='none';
			document.all.aa.style.display='';
			//parent.close();
		}
	<%	
	}
	if(pstate.equals("URE")){	//�������
%>
		function goDll(){
			var xml = makeXml('1');
			chkSetUp(xml);
		}
<%
	}
	if(pstate.equals("YURE")||pstate.equals("YURE2")){	//�������
		int rev = 1;
		rev = pstate.equals("YURE")? 1 : 4 ;
%>
		function goDll(){
			var xml = makeXml('1');
			console.log("������� >> " + xml);
			chkSetUp(xml);
			
			//parent.msghidden();
			//parent.msgbox2('<%=ServletRequestUtils.getStringParameter(request,"Bookid", "") %>','<%=Noformyn%>','<%=statehistoryid%>');
			//parent.treload();
			//parent.close();
		}
<%
	}
	if(pstate.equals("RE")){
		if(!Revcd.equals("���ΰ���") && !Revcd.equals("����")){	//����
%>
//RevMode (1--����,2--����,3--���Ӱ���,4--���Ź�����)
			function goDll(){
				var xml = makeXml('1');
				chkSetUp(xml);
				
				parent.msghidden();
				parent.msgbox2('<%=Bookid%>','<%=Noformyn%>','<%=statehistoryid%>');
				parent.treload();
				parent.close();
			}
<%
		}else{	//���� ����
%>
			function goDll(){
				
				var xml = makeXml('1');
				chkSetUp(xml);
				
			    parent.msghidden();
			    parent.msgbox2('<%=Bookid%>','<%=Noformyn%>','<%=statehistoryid%>');
				parent.treload();
				parent.close();
			}
			//parent.msghidden();
			//parent.getDocInfo('<%=Bookid%>','<%=Noformyn%>');
			//parent.treload();
			//parent.close();
<%
		}
	}

%>
</script>
<%
	if(pstate.equals("RE")){
		if(!Revcd.equals("���ΰ���")){	//����
%>
			<body onload = "goDll();" id="body">
			</body>
<%
		}else{	//���� ����
%>
			<body onload = "goDll();" id="body">
			</body>
<%			
		}
	}else if(pstate.equals("I")||pstate.equals("CRE")||pstate.equals("URE")||pstate.equals("YURE")||pstate.equals("YURE2")||pstate.equals("FILE")){	//���Ӱ���,�������
%>
			<%-- <link href="<%=CONTEXTPATH%>/jsp/bylaw/dllapp/LawXml.dll.config" rel="Configuration"> --%>
			<body onload = "goDll();" id="body">
			</body>
<%
	}
%>

<%
	if(state.equals("link1")){			//��ũ����
%>
		<%=result2%>
<%
	}else{
%>
		<%=result%>
<%		
	}
%>
