<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	HashMap bonInfo = request.getAttribute("bonInfo")==null?new HashMap() : (HashMap)request.getAttribute("bonInfo");
	HashMap meta = bonInfo.get("bookInfo")==null?new HashMap():(HashMap)bonInfo.get("bookInfo");
	HashMap param = bonInfo.get("param")==null?new HashMap() : (HashMap)bonInfo.get("param");
	List history = bonInfo.get("history")==null?new ArrayList(): (List)bonInfo.get("history");
	String fav = bonInfo.get("fav")==null?"0":bonInfo.get("fav").toString();
	String DAN = bonInfo.get("DAN")==null?"":bonInfo.get("DAN").toString();
	HashMap treecnt = bonInfo.get("treecnt")==null?new HashMap():(HashMap)bonInfo.get("treecnt");
	String vtype = param.get("vtype")==null?"":param.get("vtype").toString();
	
	String nowbookid = "";
	String nownoformyn = "";
	for(int i=0; i<history.size(); i++){
		HashMap hmap = (HashMap)history.get(i);
		if(i==0){
			nowbookid = hmap.get("BOOKID")==null?"":hmap.get("BOOKID").toString();
			nownoformyn = hmap.get("NOFORMYN")==null?"":hmap.get("NOFORMYN").toString();
		}
	}
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.findword.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/mnview/js/fontsize.js"></script>
<link rel="stylesheet" href="${resourceUrl}/mnview/css/font-awesome-4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="${resourceUrl}/mnview/css/view13pt.css">
<link rel="stylesheet" href="${resourceUrl}/mnview/css/viewEtc.css">
<link rel="stylesheet" href="${resourceUrl}/css/bonTop.css">

<script>
$(document).ready(function(){
	var height = window.innerHeight;
	var width =  window.innerWidth-20;
	var box = $('.lawbon');
	<%
	if(!vtype.equals("TOTAL")){
	%>
	box.css('width',width-348);
	box.css('height',height-70);
	<%
	}
	%>
	$('#innerbody').css('height',height-152);
	
	var box2 = $('.slawbon');
	box2.css('height',(height-134)*0.7);

	var box3 = $('.blawbon');
	box3.css('height',(height-134)*0.3);



	$(window).resize(function() {
		var height = window.innerHeight;
		var width =  window.innerWidth-20;
		var box = $('.lawbon');
		<%
		if(!vtype.equals("TOTAL")){
		%>
		box.css('width',width-348);
		box.css('height',height-70);
		<%
		}
		%>

		$('#innerbody').css('height',height-152);
		
		var box2 = $('.slawbon');
		box2.css('height',(height-134)*0.7);

		var box3 = $('.blawbon');
		box3.css('height',(height-134)*0.3);

	})
	$(".layerViewW").mouseleave(function(){
		$(".layerViewW").css("display","none");
	});
	
	$("#innerbody").append("<a name='moveFooter'></a>");
	$("#innerbody").prepend("<a name='moveTop'></a>");
	
	$("#favmn").click(function(){
		var favcnt = $("#favmn").attr("vo");
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/web/regulation/setFav.do",
			data : {
					obookid : "<%=meta.get("OBOOKID")%>",
					docgbn : 'RULE',
					favcnt : favcnt
				},
			dataType: "json",
			error: function(){},
			success:function(data){
				alert(data.msg);
				if(data.gbn=='I'){
					$("#favmn").html('<i class="fa fa-star" aria-hidden="true"></i> 즐겨찾기삭제');
					$("#favmn").attr("vo","1");
				}else if(data.gbn=='D'){
					$("#favmn").html('<i class="fa fa-star" aria-hidden="true"></i> 즐겨찾기등록');
					$("#favmn").attr("vo","0");
				}
			}
		});
	});
	
	$("#newWin").click(function(){
		var cw=1400;
		var ch=900;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("regulationViewPop.do?bookid=<%=meta.get("BOOKID")%>&noformyn=<%=meta.get("NOFORMYN")%>","",property);
	});
	
	$("#totalview").click(function(){
		location.href = "regulationViewPop.do?bookid=<%=meta.get("BOOKID")%>&noformyn=<%=meta.get("NOFORMYN")%>&vtype=TOTAL";
	});
	
	$("#totalprint").click(function(){
		var property="left=300,top=300,width=500,height=600,scrollbars=yes,resizable=no,status=no,toolbar=no";
		var newWindow = window.open("about:blank","",property);
		newWindow.location.href = "popPrint.do?bookid=<%=meta.get("BOOKID")%>&noformyn=<%=meta.get("NOFORMYN")%>&vtype=TOTAL&printyn=Y"
	});
	
	$("#multipleView").click(function(){
		var property="left=300,top=300,width=1300,height=800,scrollbars=no,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("about:blank","",property);
		newWindow.location.href = "multipleView.do"
	});
	
	$("#nowbook").click(function(){
		location.href = "regulationViewPop.do?bookid=<%=nowbookid%>&noformyn=<%=nownoformyn%>";
	});
	
	$("#rprint").click(function(){
		var obj = new HashMap();
     	obj.put("exeform","prtlaw");
     	obj.put("revmode","3");
     	obj.put("grade","");
     	obj.put("sabun","<%=meta.get("writerid")%>");
     	obj.put("statehistoryid","<%=meta.get("STATEHISTORYID")%>");
     	obj.put("bookid","<%=meta.get("BOOKID")%>");
     	obj.put("before_statehistoryid","0");
		chkSetUp(makeXML(obj));
	});
	
	$(".goRdoc").click(function(){
		var obj = new HashMap();
     	obj.put("exeform","fileview");
     	obj.put("revmode","3");
     	obj.put("grade","");
     	obj.put("filecd",this.name);
     	obj.put("sabun","<%=meta.get("writerid")%>");
     	obj.put("statehistoryid","<%=meta.get("STATEHISTORYID")%>");
     	obj.put("bookid","<%=meta.get("BOOKID")%>");
     	obj.put("before_statehistoryid","0");
		chkSetUp(makeXML(obj));
	});
	
	$('#innerbody').FontSize({
	    increaseTimes: 5, // 放大次数
	    reduceTimes: 5,
	});
	
	$("#jochk").on('click', function(event) {
		var chkcnt = $(".slawbon").find('input[type="checkbox"]');
		if(this.checked){
			$(".slawbon").find('input[type="checkbox"]').each(function(obj){
				$(this).prop('checked', true);
				joHidden(this);
			})
		}else{
			$(".slawbon").find('input[type="checkbox"]').each(function(obj){
				$(this).prop('checked', false);
				joHidden(this);
			})
		}
	});
	
	$("#allDown").click(function(){
		location.href="<%=CONTEXTPATH %>/web/regulation/allDownload.do?STATEHISTORYID=<%=meta.get("STATEHISTORYID")%>";
	});
	
	$("#goToRuleTree").click(function(){
		var url = "<%= CONTEXTPATH %>/bylaw/adm/ruleTreeView.do?obookid=<%=meta.get("OBOOKID")%>" ;
		var cw = 600; //1000
		var ch = 300;  //668
		var sw = screen.availWidth;
		var sh = screen.availHeight;
		var px = (sw-cw)/2;
		var py = (sh-ch)/2;
		var property = "left=" + px + ", top=" + py + ", width=" + cw + ", height=" + ch + ", scrollbar=no, resizable=no, status=no, toolbar=no";
		
		window.open(url, "Bookid", property);
	});
});

function joHidden(key){
	var checkId = $("#"+key.value);
	if(key.checked) {
		checkId.css("display", "");
	} else {
		checkId.css("display", "none");
	}

}
function viewHistory(){
	$(".layerViewW").css("display","block");
}
function printJo(Bookid,Contid,cont,bcontid){
	var Contno;
	var Contsubno;
	
	cw=502;
	 ch=320;
	  //스크린의 크기
	 sw=screen.availWidth;
	 sh=screen.availHeight;
	 //열 창의 포지션
	 px=(sw-cw)/2;
	 py=(sh-ch)/2;
	 //창을 여는부분	
	 if(cont.indexOf('bu')>0){
		 var contarr = cont.split('bu');
		 Contno = contarr[0].substring(3,contarr[0].length);
		 //alert(contarr[1]);
		 Contsubno = contarr[1];
	 }else{
		 Contno = cont.substring(3,cont.length);
	 }
	//var Contno = contno.substring(3,contno.length);
	//alert(Contno);
	property="left="+px+",top="+py+",width=502,height=320,scrollbars=yes,resizable=no,status=no,toolbar=no";
	//form=document.revi;
	window.open("${pageContext.request.contextPath}/web/regulation/printJoPop.do?bookid="+Bookid+"&Contid="+Contid+"&Contno="+Contno+"&Contsubno="+Contsubno+"&print=P"+"&bcontid="+bcontid, Bookid, property);
}
function goDanView(){
	var url='${pageContext.request.contextPath}/web/regulation/<%=DAN %>_popup.do';
	var property="width=1350,height=630,scrollbars=no,resizable=yes,status=no,toolbar=no";
	window.open(url+"?obookid=<%=meta.get("OBOOKID")%>",'<%=meta.get("OBOOKID")%>',property);
}
function downpage(Pcfilename,Serverfile,folder){
	form=document.ViewForm;
	form.Pcfilename.value=Pcfilename;
	form.Serverfile.value=Serverfile;
	form.folder.value=folder;
	form.action="${pageContext.request.contextPath}/Download.do";
	form.submit();
}
</script>
<form name="ViewForm" method="post">
  	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
</form>
<form>
    <input type="hidden" name="BOOKID" id="BOOKID" value="<%=meta.get("BOOKID")%>">
    <input type="hidden" name="NOFORMYN" id="NOFORMYN" value="<%=meta.get("NOFORMYN")%>">
    <input type="hidden" name="TITLE" id="TITLE" value="<%=meta.get("TITLE")%>">
</form>
		<div class="funGroup">
			<div class="funLeft">
				<div class="funBtnL" >
					<select id="fontSizeSelect">
						<option value="8">8pt</option>
						<option value="9">9pt</option>
						<option value="10" selected>10pt</option>
						<option value="11">11pt</option>
						<option value="12">12pt</option>
						<option value="13">13pt</option>
						<option value="14">14pt</option>
						<option value="15">15pt</option>
					</select>
				</div>
				<!-- 
				setFontPlMi('p')
				setFontPlMi('m')
				 -->
				<a href="#" class="funBtn funBtnL view zoomin" onclick=""><i class="fa fa-search-plus" aria-hidden="true" style="padding-top: 4px;"></i></a>
				<a href="#" class="funBtn funBtnL view zoomout" onclick=""><i class="fa fa-search-minus" aria-hidden="true" style="padding-top: 4px;"></i></a>
				<a href="#" class="funBtn funBtnL view" onclick="viewHistory()"><i class="fa fa-history" aria-hidden="true"></i> 연혁</a>
			</div>
			<div class="funRight">

				<input type="text" id="findWord" placeholder="검색어를 입력하세요." onkeypress="if(event.keyCode == 13) findWordInPage()">
				<a href="#" class="funBtn srch" onclick="findWordInPage()"><i class="fa fa-search" aria-hidden="true" style="padding-top: 4px;"></i></a>
				<a href="#" class="funBtn" id="favmn" vo = '<%=fav%>'><i class="fa fa-star" aria-hidden="true"></i> 즐겨찾기<%=fav.equals("0")?"등록":"삭제" %></a>
				<a href="#" class="funBtn" id="rprint"><i class="fa fa-print" aria-hidden="true"></i> 출력/저장</a>
				<%if(treecnt.get("MDOCID") != null){ %>
				<a href="#" class="funBtn" id="goToRuleTree"><i class="fa fa-sitemap" aria-hidden="true"></i> 규정체계도</a>
				<%} %>
				<a href="#" class="funBtn" id="multipleView"><i class="fa fa-columns" aria-hidden="true"></i> 동시보기</a>
				<%if(!DAN.equals("")){ %>
				<a href="#" class="funBtn" onclick="goDanView()"><i class="fa fa-columns" aria-hidden="true"></i> <%=DAN %>단보기</a>
				<%} %>
				<a href="#" class="funBtn goRdoc" name="SIN"><i class="fa fa-file-text-o" aria-hidden="true"></i> 신구조문</a>
				<!-- 
				<a href="#" class="funBtn goRdoc" name="GAE"><i class="fa fa-file-text-o" aria-hidden="true"></i> 개정문</a>
				 -->
				<a href="#" class="funBtn goRdoc" name="REA"><i class="fa fa-file-text-o" aria-hidden="true"></i> 개정이유</a>
				<a href="#" class="funBtn" id="totalview">과거조문동시보기</a>
				<a href="#" class="funBtn" id="totalprint"><i class="fa fa-print" aria-hidden="true"></i> 과거조문동시보기출력</a>
				<a href="#" class="funBtn" id="nowbook">현행보기</a>
				<div class="layerViewW">
					<div class="lv_top">
						<ul class="miniTab">
							<li><a href="#" class="active">연혁</a></li>
						</ul>
					</div>
					<div class="lv_contents">
					<%
						for(int i=0; i<history.size(); i++){
							HashMap hmap = (HashMap)history.get(i);
							String bc = "";
							if(meta.get("BOOKID").equals(hmap.get("BOOKID"))){
								bc = "background-color:#efefef;";
							}
					%>
						<div style="border:1px dotted #CCC;padding:3px;cursor:pointer;<%=bc %>" onclick="goRegulationView('<%=hmap.get("BOOKID") %>','<%=hmap.get("NOFORMYN") %>')">
							<div style="color:black;"><b style="font-size:14px;"><%=hmap.get("TITLE") %></b></div>
							<div  style="color:rgba(139, 184, 243, 1);font-size:13px;">제<%=hmap.get("REVCHA") %>차 <%=hmap.get("REVCD") %> / (공포일)<%=hmap.get("PROMULDT") %> / (시행일)<%=hmap.get("PROMULDT") %></div>
						</div>
					<%
						}
					%>
					</div>
				</div>

			</div>
		</div>

		<div class="funText">
			<div class="funTextL">
				▶<%=bonInfo.get("docPath") %>
			</div>

			<div class="funTextR">
				<%=meta.get("DEPTNAME")==null?"":"담당부서 : "+meta.get("DEPTNAME") %>
			</div>
		</div>
		<div style="position:absolute;z-index: 500; padding:7px;">
			<a href="#moveTop">
				<img src="${resourceUrl}/images/btn_page_up.png">
			</a>
			<a href="#moveFooter">
				<img src="${resourceUrl}/images/btn_page_down.png">
			</a>
		</div>
		<div class="lawbon" id="regulCont">
			<%=bonInfo.get("bon") %>
		</div>
		<%
		if(!vtype.equals("TOTAL")){
		%>
		<div class="lawV_listW">
			<p class="title_index">
				<span style="float:left;font-size:10pt;">조별목록</span>
				<span style="float:right;font-size:10pt;"><input id="jochk" type="checkbox" checked>전체선택</span>
			</p>
			<div class="slawbon"><%=bonInfo.get("rbon") %></div>
		</div>
		<div class="lawV_listW">
			<p class="title_attach">
				<span style="float:left;">별표 및 서식</span>
				<span style="float:right;padding-top:3px;"><a href="#" class="funBtn" id="allDown"><i class="fa fa-download" aria-hidden="true"></i> 전체다운로드</a></span>
			</p>
			<div class="blawbon"><%=bonInfo.get("rbbon") %></div>
		</div>
		<%
		}
		%>
		