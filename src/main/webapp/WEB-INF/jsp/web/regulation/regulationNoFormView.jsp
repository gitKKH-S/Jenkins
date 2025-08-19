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
	List flist = bonInfo.get("flist")==null?new ArrayList(): (List)bonInfo.get("flist");
	String junFname = "";
	for(int i=0; i<flist.size(); i++){
		HashMap fre = (HashMap)flist.get(i);
		String fcd = fre.get("FILECD")==null?"":fre.get("FILECD").toString();
		if(fcd.equals("전문")){
			junFname = fre.get("SERVERFILE")==null?"":fre.get("SERVERFILE").toString();
		}
	}
	if(junFname.equals("")){
		for(int i=0; i<flist.size(); i++){
			HashMap fre = (HashMap)flist.get(i);
			junFname = fre.get("SERVERFILE")==null?"":fre.get("SERVERFILE").toString();
		}	
	}
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.findword.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/PDFObject-master/pdfobject.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/mnview/css/font-awesome-4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="${resourceUrl}/mnview/css/view13pt.css">
<link rel="stylesheet" href="${resourceUrl}/mnview/css/viewEtc.css">
<link rel="stylesheet" href="${resourceUrl}/css/bonTop.css">
<script>
var docView;
$(document).ready(function(){
	var height = window.innerHeight;
	var width =  window.innerWidth;
	var box = $('.lawbon');
	box.css('width',width-348);
	box.css('height',height-70);
	
	var box2 = $('.slawbon');
	box2.css('height',(height-134)*0.7);
	
	var junFname = "<%=junFname%>";
	docView = function(junFname){
		if(junFname.toUpperCase().indexOf("HWP")>-1 || junFname.toUpperCase().indexOf("DOC")>-1){
			$.ajax({
	            url : '${pageContext.request.contextPath}/bylaw/adm/goHwp.do',
	            dataType : "html",
	            type : "post",  // post 또는 get
	            data : { fileName : junFname},   // 호출할 url 에 있는 페이지로 넘길 파라메터
	            success : function(result){
					$("#regulCont").html(result);
					$("#HwpCtrl").css("height",$("#regulCont").css("height"));
	            }
	        });
		}else if(junFname.toUpperCase().indexOf("PDF")>-1){
			$("#regulCont").html("<div id='innerbody'></div>");
			var options = {
				    height : $("#regulCont").css("height"),
					page : '2',
					pdfOpenParams : {
						view : 'FitV',
						pagemode : 'thumbs'
					}
				};
			PDFObject.embed("${pageContext.request.contextPath}/dataFile/law/attach/"+junFname, "#innerbody");
		}else{
			$("#regulCont").html("<div id='innerbody' style='padding:50px;'>미리보기를 지원하지 않는 파일 형식 입니다.</div>");
		}
	}
	docView(junFname);
	$(window).resize(function() {
		var height = window.innerHeight;
		var width =  window.innerWidth;
		var box = $('.lawbon');
		box.css('width',width-348);
		box.css('height',height-70);

		var box2 = $('.slawbon');
		box2.css('height',(height-134)*0.7);
		
		$("#HwpCtrl").css("height",$("#regulCont").css("height"))
	})
	
	$(".layerViewW").mouseleave(function(){
		$(".layerViewW").css("display","none");
		$("#HwpCtrl").css("display","block");
		$("#innerbody").css("display","block");
	});
	
	$("#multipleView").click(function(){
		var property="left=300,top=300,width=1300,height=800,scrollbars=no,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("about:blank","",property);
		newWindow.location.href = "multipleView.do"
	});
	
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
function viewHistory(){
	$(".layerViewW").css("display","block");
	$("#HwpCtrl").css("display","none");
	$("#innerbody").css("display","none");
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
				<a href="#" class="funBtn funBtnL view" onclick="viewHistory()"><i class="fa fa-history" aria-hidden="true"></i> 연혁</a>
			</div>
			<div class="funRight">

				<a href="#" class="funBtn" id="favmn" vo = '<%=fav%>'><i class="fa fa-star" aria-hidden="true"></i> 즐겨찾기<%=fav.equals("0")?"등록":"삭제" %></a>
				<a href="#" class="funBtn" id="multipleView"><i class="fa fa-columns" aria-hidden="true"></i> 동시보기</a>
				<%if(treecnt.get("MDOCID") != null){ %>
				<a href="#" class="funBtn" id="goToRuleTree"><i class="fa fa-sitemap" aria-hidden="true"></i> 규정체계도</a>
				<%} %>
				<%if(!DAN.equals("")){ %>
				<a href="#" class="funBtn" onclick="goDanView()"><i class="fa fa-columns" aria-hidden="true"></i> <%=DAN %>단보기</a>
				<%} %>
				<a href="#" class="funBtn" onclick="goView('NOW')">현행보기</a>
				<a href="#" class="funBtn" onclick="newWinView()"><i class="fa fa-window-maximize" aria-hidden="true"></i> 새창</a>
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
		<div class="lawbon" id="regulCont">
		</div>
		<div class="lawV_listW">
			<p class="title_attach">첨부파일</p>
			<div class="slawbon">
				<%
				for(int i=0; i<flist.size(); i++){
					HashMap fre = (HashMap)flist.get(i);
					String sfnm = fre.get("SERVERFILE")==null?"":fre.get("SERVERFILE").toString();
					String pcfnm = fre.get("PCFILENAME")==null?"":fre.get("PCFILENAME").toString();
				%>
					<p title="<%=pcfnm %>" class="attachText" style="line-height: 23px; cursor: pointer; font-size : 12pt;" onclick="docView('<%=sfnm %>')">
						[<%=fre.get("FILECD") %>] <%=pcfnm %>
						<img style="cursor: pointer;" onclick="downpage('<%=pcfnm %>', '<%=sfnm %>', 'ATTACH')" alt="<%=pcfnm %>" src="${resourceUrl}/images/down2.gif">
					</p>
				<%
				}	
				%>
				
			</div>
		</div>
