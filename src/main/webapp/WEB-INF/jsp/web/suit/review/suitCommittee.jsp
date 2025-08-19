<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script>
	
	var delList = new Array();
	var delIdx = 0;
	
	var useridList = new Array();
	var usernmList = new Array();
	var sosoknmList = new Array();
	var sosokcdList = new Array();
	
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	Ext.onReady(function(){
		gheight = $('body').height();
		$("#empDiv").css("height", gheight-150);
		$("#empListDiv").css("height", gheight-222);
		
		$("#comDiv").css("height", gheight-150);
		$("#comListDiv").css("height", gheight-222);
		
		var Tree = Ext.tree;
		var dLoder = new Ext.tree.TreeLoader({
			dataUrl: '${pageContext.request.contextPath}/web/suit/getDeptList.do'
		});
		var treeDD = new Tree.TreePanel({
			id:'treeDD', renderTo:'deptList', useArrows: false, autoScroll: true,
			animate : true, enableDD: false, containerScroll: true, border: true,
			loader : dLoder, height:($('body').height()-150),
			root: {
				nodeType: 'async', text:'서울시청', draggable:false, id: '6110000', cls:'dept'
			},
			listeners: {
				click: function(node, e){
					// node.id로 해당 부서 직원 select
					if (node.id != "6110000") {
						var getId = node.id;
						getUserList(getId);
					}
				}
			}
		});
		treeDD.getRootNode().expand();
		getComiUserList();
		
		$(window).resize(function() {
			gheight = $('body').height();
			$(".subCA").css("height",gheight);
			$(".innerB").css("height","100%");
			treeDD.setHeight(gheight-150);
			
			$("#empDiv").css("height", gheight-150);
			$("#empListDiv").css("height", gheight-222);
			
			$("#comDiv").css("height", gheight-150);
			$("#comListDiv").css("height", gheight-222);
		});
	});
	
	function getComiUserList(){
		$("#cInfoTr").remove();
		$(".comInfo").remove();
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectComiUserList.do",
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				if(result.result.length > 0){
					$.each(result.result, function(index, val){
						html += "<tr class=\"comInfo\" id=\"comiInfo"+val.ROWN+"\">";
						html += "<td>"+val.USER_NM+"</td>"; // user nm
						if(val.JBGD_NM == undefined){
							html += "<td></td>";
						}else{
							html += "<td>"+val.JIKNM+"</td>";
						}
						html += "<td>"+val.DEPT_NAME+"</td>";
						html += "<td class=\"btnTd\">";
						html += "<img alt=\"delBtn\" src=\"${resourceUrl}/images/common/icon_del.gif\" onclick=\"delCommi('"+val.ROWN+"','"+val.COMMITTEEID+"', '')\">";
						html += "<input type=\"hidden\" name=\"DLBR_MBCMT_EMP_NM\" id=\"DLBR_MBCMT_EMP_NM\" value=\""+val.USER_NM+"\" />";
						html += "<input type=\"hidden\" name=\"DLBR_MBCMT_EMP_NO\" id=\"DLBR_MBCMT_EMP_NO\" value=\""+val.USER_ID+"\" />";
						html += "<input type=\"hidden\" name=\"DLBR_MBCMT_DEPT_NM\" id=\"DLBR_MBCMT_DEPT_NM\" value=\""+val.DEPT_NAME+"\" />";
						html += "<input type=\"hidden\" name=\"DLBR_MBCMT_DEPT_NO\" id=\"DLBR_MBCMT_DEPT_NO\" value=\""+val.DEPT_CODE+"\" />";
						html += "</td>";
						html += "</tr>";
					});
				}else{
					html += "<tr class=\"cInfoTr\" id=\"cInfoTr\"><td colspan=\"4\">지정 된 위원회 목록이 없습니다.</td></tr>";
				}
				$("#comCnt").val(result.result.length+1);
				$("#comList").append(html);
			}
		});
	}
	
	function getUserList(id){
		$("#infoTr").remove();
		$(".userinfo").remove();
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectUserList.do",
			data: {"DEPT_NO":id},
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				if(result.result.length > 0){
					$.each(result.result, function(index, val){
						html += "<tr class=\"userinfo\" onclick=\"selectUser('"+val.EMP_NO+"', '"+val.EMP_NM+"', '"+val.DEPT_NO+"', '"+val.DEPT_NM+"', '"+val.JBGD_CD+"')\">";
						html += "<td class=\"selTd\" id=\"usernm\">"+val.EMP_NM+"</td>"; // user nm
						html += "<td>"+val.JBGD_CD+"</td>";
						html += "<td>"+val.DEPT_NM+"</td>";
						html += "</tr>";
					});
				}else{
					html += "<tr class=\"userinfo\"><td colspan=\"3\">검색 결과가 없습니다.</td></tr>";
				}
				$("#emplist").append(html);
			}
		});
	}
	
	function selectUser(EMP_NO, EMP_NM, DEPT_NO, DEPT_NM, JBGD_CD){
		var cnt = $("#comCnt").val()*1;
		var selCnt = $("#selCnt").val()*1;
		if($(".comInfo").length < 12){
			$("#cInfoTr").remove();
			var html = "";
			html += "<tr class=\"comInfo\" id=\"comiInfo"+cnt+"\">";
			html += "<td>"+EMP_NM+"</td>";
			html += "<td>"+JBGD_CD+"</td>";
			html += "<td>"+DEPT_NO+"</td>";
			html += "<td class=\"btnTd\">";
			html += "<img alt=\"delBtn\" src=\"${resourceUrl}/images/common/delete.gif\" onclick=\"delCommi('"+cnt+"','0', '"+selCnt+"')\">";
			html += "<input type=\"hidden\" name=\"EMP_NM\" id=\"EMP_NM\" value=\""+EMP_NM+"\" />";
			html += "<input type=\"hidden\" name=\"EMP_NO\" id=\"EMP_NO\" value=\""+EMP_NO+"\" />";
			html += "<input type=\"hidden\" name=\"DEPT_NM\" id=\"DEPT_NM\" value=\""+DEPT_NM+"\" />";
			html += "<input type=\"hidden\" name=\"DEPT_NO\" id=\"DEPT_NO\" value=\""+DEPT_NO+"\" />";
			html += "</td>";
			html += "</tr>";
			useridList[selCnt] = EMP_NO;
			usernmList[selCnt] = EMP_NM;
			sosokcdList[selCnt] = DEPT_NO;
			sosoknmList[selCnt] = DEPT_NM;
			$("#comCnt").val(cnt+1);
			$("#selCnt").val(selCnt+1);
			$("#comList").append(html);
		}else{
			alert("위원회 인원은 12명까지만 지정할 수 있습니다.");
		}
	}
	
	function addOutComi(){
		var cnt = $("#comCnt").val()*1;
		if($(".comInfo").length < 12){
			$("#cInfoTr").remove();
			var html = "";
			html += "<tr class=\"comInfo\" id=\"comiInfo"+cnt+"\">";
			html += "<td>";
			html += "<input type=\"text\"   name=\"outEMP_NM\" id=\"EMP_NM\" value=\"\" />";
			html += "<input type=\"hidden\" name=\"outEMP_NO\" id=\"EMP_NO\" value=\"0\" />";
			html += "</td>";
			html += "<td></td>";
			html += "<td>";
			html += "<input type=\"text\" name=\"outDEPT_NM\" id=\"DEPT_NM\" value=\"\" />";
			html += "<input type=\"hidden\" name=\"outDEPT_NO\" id=\"DEPT_NO\" value=\"0\" />";
			html += "</td>";
			html += "<td class=\"btnTd\">";
			html += "<img alt=\"delBtn\" src=\"${resourceUrl}/images/common/delete.gif\" onclick=\"delCommi('"+cnt+"','0','')\">";
			html += "</td>";
			html += "</tr>";
			$("#comCnt").val(cnt+1);
			$("#comList").append(html);
		}else{
			alert("위원회 인원은 12명까지만 지정할 수 있습니다.");
		}
	}
	
	function delCommi(cnt, id, selcnt){
		if(id == "0"){
			$("#comiInfo"+cnt).remove();
			//$("#comCnt").val(($("#comCnt").val()*1)-1);
			if(selcnt != ""){
				delete useridList[selcnt];
				delete usernmList[selcnt];
				delete sosokcdList[selcnt];
				delete sosoknmList[selcnt];
			}
		}else{
			if(confirm("이 위원을 해제하시겠습니까?")){
				$.ajax({
					type:"POST",
					url:"${pageContext.request.contextPath}/web/suit/delComiUser.do",
					data:{DLBR_CMT_MNG_NO:id},
					dataType:"json",
					async:false,
					success:function(result){
						alert(result.msg);
						reLoadCommittee();
					}
				});
			}
		}
	}
	
	function reLoadCommittee(){
		//location.href = "${pageContext.request.contextPath}/web/suit/goSuitCommittee.do";
		
		document.frm.action = "<%=CONTEXTPATH%>/web/suit/goSuitCommittee.do";
		document.frm.submit();
	}
	
	function endComiPop(){
		var cw=900;
		var ch=585;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","hisPop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "hisPop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/suitComHisPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goSaveComiInfo(){
		var selCnt = $("#selCnt").val()*1;
		for(var i=0; i<$("input[name=outEMP_NM]").length; i++){
			useridList[selCnt+i] = $("input[name=outEMP_NO]").eq(i).val();
			usernmList[selCnt+i] = $("input[name=outEMP_NM]").eq(i).val();
			sosokcdList[selCnt+i] = $("input[name=outDEPT_NO]").eq(i).val();
			sosoknmList[selCnt+i] = $("input[name=outDEPT_NM]").eq(i).val();
		}
		
		$("#comUserid").val(useridList);
		console.log("userid" + $("#comUserid").val());
		$("#comUsernm").val(usernmList);
		console.log("usernm" + $("#comUsernm").val());
		$("#comSosokcd").val(sosokcdList);
		console.log("sosokcd" + $("#comSosokcd").val());
		$("#comSosoknm").val(sosoknmList);
		console.log("sosoknm" + $("#comSosoknm").val());
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/comInfoSave.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				reLoadCommittee();
			}
		});
	}
</script>
<style>
	input{width:80%}
	#subTT{display:block;}
	/* .selTd{cursor:pointer;} */
	.countT{display:block; font-size:15px}
	.infoTable{border-collapse:inherit;}
	
	.infoTable th{border-right:0px; text-align:center;}
	.infoTable td{border-right:0px; text-align:center;}
	
	.side{margin-bottom: 0px}
	#deptList{width:20%; margin-right:4%; float:left;}
	#empDiv{width:35%; margin-right:5%; float:left;}
	#empListDiv{overflow-y:scroll; border:1px solid #99bbe8; background-color:white;}
	#comDiv{width:35%; float:left;}
	#comListDiv{overflow-y:scroll; border:1px solid #99bbe8; background-color:white;}
	.btnTd{text-align:center;}
	.innerB{margin-bottom:0px}
	#subTitle{font-size:13px; font-weight:bold;}
	
	.userinfo:hover{background-color:#ececf1; cursor:pointer;}
</style>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	
	<input type="hidden" name="comCnt" id="comCnt" value="0" />
	<input type="hidden" name="selCnt" id="selCnt" value="0" />
	
	<input type="hidden" name="comUserid" id="comUserid" value="" />
	<input type="hidden" name="comUsernm" id="comUsernm" value="" />
	<input type="hidden" name="comSosokcd" id="comSosokcd" value="" />
	<input type="hidden" name="comSosoknm" id="comSosoknm" value="" />
	
	<div class="subCA">
		<strong id="subTT" class="subTT"></strong>
		<div class="innerB">
			<div id="deptList"></div>
			<div id="empDiv">
				<div id="subTitle"><strong class="countT">직원목록</strong></div>
				<table class="infoTable" style="border:1px solid #99bbe8; width:100%">
					<colgroup>
						<col style="width:35%;">
						<col style="width:30%;">
						<col style="width:35%;">
					</colgroup>
					<tr>
						<th>이름</th>
						<th>직책</th>
						<th>부서</th>
					</tr>
				</table>
				<div id="empListDiv">
					<table class="infoTable" id="emplist" style="width:100%">
						<colgroup>
							<col style="width:35%;">
							<col style="width:30%;">
							<col style="width:35%;">
						</colgroup>
						<tr id="infoTr">
							<td colspan="3">조직도에서 부서명을 선택 해 주세요</td>
						</tr>
					</table>
				</div>
			</div>
			<div id="comDiv">
				<div id="subTitle"><strong class="countT">위원목록 (※ 변경사항은 저장버튼을 눌러야 저장됩니다.)</strong></div>
				<table class="infoTable" style="border:1px solid #99bbe8; width:100%">
					<colgroup>
						<col style="width:25%;">
						<col style="width:25%;">
						<col style="width:35%;">
						<col style="width:15%;">
					</colgroup>
					<tr>
						<th>이름</th>
						<th>직책</th>
						<th>부서</th>
						<th></th>
					</tr>
				</table>
				<div id="comListDiv">
					<table class="infoTable" id="comList" style="width:100%">
						<colgroup>
							<col style="width:25%;">
							<col style="width:25%;">
							<col style="width:35%;">
							<col style="width:15%;">
						</colgroup>
					</table>
				</div>
			</div>
			<div class="subBtnW side" style="float:right; margin-top:10px">
				<div class="subBtnC right">
					<a href="#none" class="sBtn type2" onclick="endComiPop();">종료위원보기</a>
					<a href="#none" class="sBtn type3" onclick="addOutComi();">외부위원추가</a>
					<a href="#none" class="sBtn type4" onclick="goSaveComiInfo();">저장</a>
				</div>
			</div>
		</div>
	</div>
</form>