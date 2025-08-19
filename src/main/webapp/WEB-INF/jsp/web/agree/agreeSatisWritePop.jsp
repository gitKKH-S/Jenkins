<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String DGSTFN_ANS_MNG_NO = request.getAttribute("DGSTFN_ANS_MNG_NO")==null?"":request.getAttribute("DGSTFN_ANS_MNG_NO").toString();
	String CVTN_MNG_NO = request.getAttribute("CVTN_MNG_NO")==null?"":request.getAttribute("CVTN_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	HashMap items = request.getAttribute("items")==null?new HashMap():(HashMap)request.getAttribute("items");
	List satisList = request.getAttribute( "satisList" )==null?new ArrayList():(List) request.getAttribute( "satisList" );
	List lawyerList = request.getAttribute( "lawyerList" )==null?new ArrayList():(List) request.getAttribute( "lawyerList" );
	List procSatisList = request.getAttribute( "procSatisList" )==null?new ArrayList():(List) request.getAttribute( "procSatisList" );
	List satisItemList = request.getAttribute( "satisItemList" )==null?new ArrayList():(List) request.getAttribute( "satisItemList" );
	
	int satisListCnt = satisList.size();
	int lawyerListCnt = lawyerList.size();
	int procSatisListCnt = procSatisList.size();
	int satisItemListCnt = satisItemList.size();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
%>
<script type="text/javascript">
	var satisListCnt = <%=satisListCnt%>;
	var lawyerListCnt = <%=lawyerListCnt%>;
	var procSatisListCnt = <%=procSatisListCnt%>;
	var satisItemListCnt = <%=satisItemListCnt%>;
	
	$( document ).ready( function() {
		console.log(lawyerListCnt);
		tabBtn_onclick(0);
	});
	
	function tabBtn_onclick( tab ) {
		$( "ul" ).children( "li" ).removeClass( "active" );
		$( "#tabBtn" + tab ).addClass( "active" );
		
		$( "#satisArea" ).children( "div" ).css( "display" , "none" );
		$( "#satisItems" + tab ).css( "display" , "block" );
	}
	
	function satisSave(){
		
		if(lawyerListCnt == 0){
			return alert("외부 답변 변호사를 등록 하세요");
		}
		
		var satisData = {};
		var satisDataArr = new Array();
		var chked = true;
		var JDAF_CORP_NMTmp = "";
		
		for(var i=0; i<lawyerListCnt; i++){
			var frmNm = "satisFrm" + i;
			var frmTmp = document.getElementById(frmNm);
			
<%
		if(procSatisListCnt > satisItemListCnt){
%>
			for(var j=(i*satisItemListCnt); j<((i+j)*satisItemListCnt); j++){
<%
		}else{
%>
			for(var j=0; j<satisItemListCnt+1; j++){
			
<%
		}
%>
				var satisDataTmp = {};
				if(satisItemListCnt > j){
					var checkedDGSTFN_ANS_SCR = $("input[name=DGSTFN_ANS_SCR"+i+j+"]:checked").val();
					
					console.log("checkedDGSTFN_ANS_SCR : " + checkedDGSTFN_ANS_SCR);
					
					if(checkedDGSTFN_ANS_SCR == undefined || checkedDGSTFN_ANS_SCR == null || checkedDGSTFN_ANS_SCR == ""){
						chked = false;
						JDAF_CORP_NMTmp = frmTmp.JDAF_CORP_NM.value;
						break;
					}
					
					if(checkedDGSTFN_ANS_SCR.split("@@")[3] != "null" && checkedDGSTFN_ANS_SCR.split("@@")[3] != frmTmp.DGSTFN_SRVY_TRGT_MNG_NO.value){
						continue;
					}
					
					satisDataTmp.TRGT_PST_MNG_NO = frmTmp.CVTN_MNG_NO.value;
					satisDataTmp.DGSTFN_ANS_MNG_NO = checkedDGSTFN_ANS_SCR.split("@@")[0]=="null"?"":checkedDGSTFN_ANS_SCR.split("@@")[0];
					satisDataTmp.DGSTFN_SRVY_MNG_NO = checkedDGSTFN_ANS_SCR.split("@@")[2];
					satisDataTmp.DGSTFN_ANS_SCR = checkedDGSTFN_ANS_SCR.split("@@")[1];
					satisDataTmp.DGSTFN_SRVY_TRGT_MNG_NO = frmTmp.DGSTFN_SRVY_TRGT_MNG_NO.value;
					
					
					console.log("==> ");
					console.log(satisDataTmp);
				} else {
					// 기타 의견 저장
					satisDataTmp.TRGT_PST_MNG_NO = frmTmp.CVTN_MNG_NO.value;
					satisDataTmp.DGSTFN_ANS_MNG_NO = "";
					satisDataTmp.DGSTFN_SRVY_MNG_NO = "0";
					satisDataTmp.DGSTFN_SRVY_TRGT_MNG_NO = frmTmp.DGSTFN_SRVY_TRGT_MNG_NO.value;
					satisDataTmp.DGSTFN_ETC_ANS_CN = frmTmp.DGSTFN_ETC_ANS_CN.value;
				}
				satisDataArr.push(satisDataTmp);
			}
			
			if(!chked){
				break;
			}
		}
		
		if(chked){
			satisData.data = satisDataArr;
			$.ajax({
<%-- 				url:"<%=CONTEXTPATH%>/web/suit/insertSatisfaction.do", --%>
// 				data:{"satisData":JSON.stringify(satisData)},
// 				dataType:"json",
				url:"<%=CONTEXTPATH%>/web/agree/insertSatisfaction.do",
			    data: JSON.stringify(satisData), // ← satisData 객체 전체를 JSON 문자열로 보냄
			    contentType: "application/json; charset=UTF-8", // ← 꼭 필요
			    dataType: "json", // ← 응답이 JSON일 경우
				method:"post",
				success:function( result ) {
					alert("저장되었습니다.");
					opener.agreeStateChange('완료');
					window.close();
				},
				error:function( jqXHR , textStatus , errorThrown ) {
					console.log( errorThrown );
					alert( "처리 중 오류가 발생하였습니다." );
				}
			});
		} else {
			alert("["+JDAF_CORP_NMTmp+"]에 대한 만족도 평가가 완료되지 않았습니다.");
		}
	}
		
	function popClose(){
		if(lawyerListCnt > 0){
			if(confirm("만족도 평가를 저장하지 않고 창을 닫으시겠습니까?")){
				window.close();
			}
		}else{
			window.close();
		}
	}
</script>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="DGSTFN_ANS_MNG_NO" id="DGSTFN_ANS_MNG_NO" value="<%=DGSTFN_ANS_MNG_NO%>"/>
	<input type="hidden" name="CVTN_MNG_NO"      id="CVTN_MNG_NO"      value="<%=CVTN_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NO"       id="WRTR_EMP_NO"       value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"       id="WRTR_EMP_NM"       value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM"       id="WRT_DEPT_NM"       value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"       id="WRT_DEPT_NO"       value="<%=WRT_DEPT_NO%>" />
</form>
	<strong class="popTT"> 자문 만족도 평가 <a href="#none"
		class="popClose" onclick="popClose();">닫기</a>
	</strong>
	<div class="popC">
		<div class="popA">
<%
			if(lawyerListCnt > 0){
%>
			<div class="subTabW">
				<ul>
<%
				HashMap lawinfo = new HashMap();
				for (int i=0; i<lawyerListCnt; i++) {
					lawinfo = (HashMap)lawyerList.get(i);
%>
					<li id="tabBtn<%=i%>">
						<a href="#" onclick="tabBtn_onclick(<%=i%>)" style="padding:15px 15px;"><%=lawinfo.get("RVW_TKCG_EMP_NM")%></a>
					</li>
<%
				}
%>
				</ul>
			</div>
			<div id="satisArea">
<%
				for(int i=0; i<lawyerListCnt; i++){
					lawinfo = (HashMap)lawyerList.get(i);
%>
				<div class="tableW" id="satisItems<%=i%>">
					<form id="satisFrm<%=i%>" name="satisFrm<%=i%>" method="post">
						<input type="hidden" id="CVTN_MNG_NO"              name="CVTN_MNG_NO"            value="<%=CVTN_MNG_NO%>" />
						<input type="hidden" id="WRTR_EMP_NM"               name="WRTR_EMP_NM"             value="<%=USERNO%>" />
						<input type="hidden" id="DGSTFN_SRVY_TRGT_MNG_NO"   name="DGSTFN_SRVY_TRGT_MNG_NO" value="<%=lawinfo.get("RVW_TKCG_MNG_NO")%>" />
						<input type="hidden" id="JDAF_CORP_NM"              name="JDAF_CORP_NM"            value="<%=lawinfo.get("RVW_TKCG_EMP_NM")%>" />
						<input type="hidden" id="TRGT_PST_MNG_NO"           name="TRGT_PST_MNG_NO"         value="<%=CVTN_MNG_NO%>" />
						<input type="hidden" id="WRTR_EMP_NO"               name="WRTR_EMP_NO"             value="<%=WRTR_EMP_NO%>" />
						<input type="hidden" id="WRTR_EMP_NM"               name="WRTR_EMP_NM"             value="<%=WRTR_EMP_NM%>" />
						<input type="hidden" id="WRT_DEPT_NM"               name="WRT_DEPT_NM"             value="<%=WRT_DEPT_NM%>" />
						<input type="hidden" id="WRT_DEPT_NO"               name="WRT_DEPT_NO"             value="<%=WRT_DEPT_NO%>" />
						
						<table class="pop_infoTable write">
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 20%;">
								<col style="width: 20%;">
								<col style="width: 20%;">
								<col style="width: 20%;">
							</colgroup>
<%
					HashMap satisItemMap = new HashMap();
					HashMap tmpMap = new HashMap();
					for(int j=0; j<satisListCnt; j++) {
						satisItemMap = (HashMap)satisList.get(j);
						System.out.println("=============================");
						System.out.println(satisItemMap);
						System.out.println("=============================");
						
						if(satisItemMap.get("DGSTFN_SRVY_TRGT_MNG_NO") != null && !lawinfo.get("DGSTFN_SRVY_TRGT_MNG_NO").equals(String.valueOf(satisItemMap.get("DGSTFN_SRVY_TRGT_MNG_NO")))){
							continue;
						}
						
						String DGSTFN_ANS_SCR = satisItemMap.get("DGSTFN_ANS_SCR")==null?"":String.valueOf(satisItemMap.get("DGSTFN_ANS_SCR"));
						String idStr = String.valueOf(i) + String.valueOf(j);
						System.out.println("=============================");
						System.out.println(idStr);
						System.out.println("=============================");
						
						
						if(i>0 && !"null".equals(String.valueOf(satisItemMap.get("DGSTFN_ANS_MNG_NO"))) && "null".equals(String.valueOf(satisItemMap.get("DGSTFN_SRVY_TRGT_MNG_NO")))){
							satisItemMap.put("DGSTFN_ANS_MNG_NO", "null");
						}
%>
								<tr>
									<th colspan="5" style="text-align:left;"><%=satisItemMap.get("DGSTFN_EVL_TYPE_NM")%> : <%=satisItemMap.get("DGSTFN_SRVY_CN")%></th>
								</tr>
								<tr>
									<td>
										<label for="DGSTFN_ANS_SCR0<%=idStr%>">
											<input type="radio" id="DGSTFN_ANS_SCR0<%=idStr%>" name="DGSTFN_ANS_SCR<%=idStr%>" 
												value="<%=satisItemMap.get("DGSTFN_ANS_MNG_NO")%>@@5@@<%=satisItemMap.get("DGSTFN_SRVY_MNG_NO")%>@@<%=satisItemMap.get("DGSTFN_SRVY_TRGT_MNG_NO")%>" 
												<%if("5".equals(DGSTFN_ANS_SCR)) out.print("checked");%>> <%=satisItemMap.get("FST_ANS_ARTCL_NM")%> (5)
										</label>
									</td>
									<td>
										<label for="DGSTFN_ANS_SCR1<%=idStr%>">
											<input type="radio" id="DGSTFN_ANS_SCR1<%=idStr%>" name="DGSTFN_ANS_SCR<%=idStr%>" 
												value="<%=satisItemMap.get("DGSTFN_ANS_MNG_NO")%>@@4@@<%=satisItemMap.get("DGSTFN_SRVY_MNG_NO")%>@@<%=satisItemMap.get("DGSTFN_SRVY_TRGT_MNG_NO")%>" 
												<%if("4".equals(DGSTFN_ANS_SCR)) out.print("checked");%>> <%=satisItemMap.get("SEC_ANS_ARTCL_NM")%> (4)
										</label>
									</td>
									<td>
										<label for="DGSTFN_ANS_SCR2<%=idStr%>">
											<input type="radio" id="DGSTFN_ANS_SCR2<%=idStr%>" name="DGSTFN_ANS_SCR<%=idStr%>" 
												value="<%=satisItemMap.get("DGSTFN_ANS_MNG_NO")%>@@3@@<%=satisItemMap.get("DGSTFN_SRVY_MNG_NO")%>@@<%=satisItemMap.get("DGSTFN_SRVY_TRGT_MNG_NO")%>" 
												<%if("3".equals(DGSTFN_ANS_SCR)) out.print("checked");%>> <%=satisItemMap.get("THR_ANS_ARTCL_NM")%> (3)
										</label>
									</td>
									<td>
										<label for="DGSTFN_ANS_SCR3<%=idStr%>">
											<input type="radio" id="DGSTFN_ANS_SCR3<%=idStr%>" name="DGSTFN_ANS_SCR<%=idStr%>" 
												value="<%=satisItemMap.get("DGSTFN_ANS_MNG_NO")%>@@2@@<%=satisItemMap.get("DGSTFN_SRVY_MNG_NO")%>@@<%=satisItemMap.get("DGSTFN_SRVY_TRGT_MNG_NO")%>" 
												<%if("2".equals(DGSTFN_ANS_SCR)) out.print("checked");%>> <%=satisItemMap.get("FOUR_ANS_ARTCL_NM")%> (2)
										</label>
									</td>
									<td>
										<label for="DGSTFN_ANS_SCR4<%=idStr%>">
											<input type="radio" id="DGSTFN_ANS_SCR4<%=idStr%>" name="DGSTFN_ANS_SCR<%=idStr%>" 
												value="<%=satisItemMap.get("DGSTFN_ANS_MNG_NO")%>@@1@@<%=satisItemMap.get("DGSTFN_SRVY_MNG_NO")%>@@<%=satisItemMap.get("DGSTFN_SRVY_TRGT_MNG_NO")%>" 
												<%if("1".equals(DGSTFN_ANS_SCR)) out.print("checked");%>> <%=satisItemMap.get("FIFTH_ANS_ARTCL_NM")%> (1)
										</label>
									</td>
								</tr>
<%
					}
%>
								<tr>
									<th>기타 의견</th>
									<td colspan="4">
										<textarea rows="1" cols="8" id="DGSTFN_ETC_ANS_CN" name="DGSTFN_ETC_ANS_CN"></textarea>
									</td>
								</tr>
						</table>
					</form>
				</div>
<%
				}
%>
			</div>
<%
			}else{
%>

				<div id="nonDiv">
					<br/>
					등록 된 답변 법무법인이 없습니다.
					<br/>
					접수 단계로 돌아가 답변인을 정상적으로 지정 해 주세요
				</div>
<%
			}
%>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" onclick="satisSave();">저장</a>
		</div>
	</div>
