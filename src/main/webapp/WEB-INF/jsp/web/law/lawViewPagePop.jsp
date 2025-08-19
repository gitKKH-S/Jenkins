<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	HashMap bonInfo = request.getAttribute("bonInfo")==null?new HashMap() : (HashMap)request.getAttribute("bonInfo");
	HashMap param = bonInfo.get("param")==null?new HashMap() : (HashMap)bonInfo.get("param");
	String fav = bonInfo.get("fav")==null?"0":bonInfo.get("fav").toString();
	
	HashMap info = bonInfo.get("param")==null?new HashMap():(HashMap)bonInfo.get("param");
	String lawurl = info.get("lawurl")==null?"":info.get("lawurl").toString();
	
	String JO = request.getParameter("JO")==null?"":request.getParameter("JO");
	if(!JO.equals("")){
		lawurl = lawurl+"&JO="+JO;
	}
	System.out.println(lawurl);
%>
<script src="${pageContext.request.contextPath}/webjars/jquery/1.12.4/jquery.min.js"></script>
<script>
	$(document).ready(function() {
		var url = opener.urlInfo;
		//location.href = "https://www.law.go.kr<%=lawurl%>";
		document.getElementById("popIf").src = "https://www.law.go.kr<%=lawurl%>";
	})
</script>
<iframe id="popIf" src="" width="100%" height="100%" frameborder="0" scrolling="yes"></iframe>
<%-- 
<script src="${resourceUrl}/js/mten.findword.js"></script>
<script src="${resourceUrl}/mnview/js/fontsize.js"></script>
<link rel="stylesheet" href="${resourceUrl}/mnview/css/font-awesome-4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="${resourceUrl}/css/bonTop.css">
<script>
$(document).ready(function(){
	var height = window.innerHeight;
	var width =  window.innerWidth-20;
	var box = $('.lawbon');
	box.css('width',width-331);
	box.css('height',height-70);

	var box2 = $('.slawbon');
	box2.css('height',(height-134)*0.7);

	var box3 = $('.blawbon');
	box3.css('height',(height-134)*0.3);

	$("#regulCont img").each(function() {
		$(this).attr("src","${pageContext.request.contextPath}/dataFile/klaw/<%=param.get("LAWSID")%>/"+this.id+".gif");
	});

	$("#favmn").click(function(){
		var favcnt = $("#favmn").attr("vo");
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/web/regulation/setFav.do",
			data : {
					obookid : "<%=param.get("LAWID")%>",
					docgbn : 'LAW',
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


	$(window).resize(function() {
		var height = window.innerHeight;
		var width =  window.innerWidth-20;
		var box = $('.lawbon');
		box.css('width',width-331);
		box.css('height',height-70);

		var box2 = $('.slawbon');
		box2.css('height',(height-134)*0.7);

		var box3 = $('.blawbon');
		box3.css('height',(height-134)*0.3);

	})
	
	$('#regulCont').FontSize({
	    increaseTimes: 5, // 放大次数
	    reduceTimes: 5,
	});
	
	$("#createHwp").click(function(){
		var property="left=300,top=300,width=700,height=620,scrollbars=no,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("about:blank","",property);
		newWindow.location.href = "createHwp.do?TYPE=LAW&LAWID=<%=param.get("LAWID")%>"
	});

	$("#multipleView").click(function(){
		var property="left=300,top=300,width=1300,height=800,scrollbars=no,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("about:blank","",property);
		newWindow.location.href = "multipleView.do"
	});
	
	$("#goDanView").click(function(){
		var property="left=300,top=300,width=1300,height=800,scrollbars=no,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("3_popup.do?title=<%=param.get("LAWNAME")%>","1234",property);
	});
});
</script>
<form>
    <input type="hidden" name="LAWID" id="LAWID" value="<%=param.get("LAWID")%>">
    <input type="hidden" name="GBN" id="GBN" value="LAW">
    <input type="hidden" name="TITLE" id="TITLE" value="<%=param.get("LAWNAME")%>">
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
				<a href="#" class="funBtn funBtnL view zoomin" onclick=""><i class="fa fa-search-plus" aria-hidden="true" style="padding-top: 4px;"></i></a>
				<a href="#" class="funBtn funBtnL view zoomout" onclick=""><i class="fa fa-search-minus" aria-hidden="true" style="padding-top: 4px;"></i></a>
			</div>
			<div class="funRight">

				<input type="text" id="findWord" placeholder="검색어를 입력하세요." onkeypress="if(event.keyCode == 13) findWordInPage()">
				<a href="#" class="funBtn srch" onclick="findWordInPage()"><i class="fa fa-search" aria-hidden="true" style="padding-top: 4px;"></i></a>
				<a href="#" class="funBtn" id="favmn" vo = '<%=fav%>'><i class="fa fa-star" aria-hidden="true"></i> 즐겨찾기<%=fav.equals("0")?"등록":"삭제" %></a>
				<a href="#" class="funBtn" id="createHwp"><i class="fa fa-print" aria-hidden="true"></i> 출력/저장</a>
				<a href="#" class="funBtn" id="multipleView"><i class="fa fa-columns" aria-hidden="true"></i> 동시보기</a>
				<a href="#" class="funBtn" id="goDanView"><i class="fa fa-columns" aria-hidden="true"></i> 삼단보기</a>

<!-- 			<a href="#" class="funBtn"><i class="fa fa-list-ul" aria-hidden="true"></i> 목록</a> -->

			</div>
		</div>

		<div class="funText">
			<div class="funTextL">
				▶  <%=info.get("LAWNAME") %>
			</div>

			<div class="funTextR">
				담당부서 : <%=info.get("DEPT") %>
			</div>
		</div>

		<div class="lawbon" id="regulCont">
			<iframe id="popIf" src="" width="100%" height="100%" frameborder="0" scrolling="yes"></iframe>
			
		</div>
		<div class="lawV_listW">
			<p class="title_index">조별목록</p>
			<div class="slawbon"><%=bonInfo.get("rbon") %></div>
		</div>
		<div class="lawV_listW">
			<p class="title_attach">별표 및 서식</p>
			<div class="blawbon"><%=bonInfo.get("rbbon") %></div>
		</div>
 --%>