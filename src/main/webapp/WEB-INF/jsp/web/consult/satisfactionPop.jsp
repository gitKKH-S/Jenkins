<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String isprevsatis = request.getAttribute("isprevsatis")==null?"":request.getAttribute("isprevsatis").toString();
	String consultid = request.getParameter("consultid")==null?"":request.getParameter("consultid");
	String inoutcon = request.getParameter("inoutcon")==null?"":request.getParameter("inoutcon").toString();

	HashMap items = request.getAttribute("items")==null?new HashMap():(HashMap)request.getAttribute("items");
	List satisList = items.get( "satisList" )==null?new ArrayList():(List) items.get( "satisList" );
	List lawyerList = items.get( "lawyerList" )==null?new ArrayList():(List) items.get( "lawyerList" );
	List procSatisList = items.get( "procSatisList" )==null?new ArrayList():(List) items.get( "procSatisList" );
	List satisItemList = items.get( "satisItemList" )==null?new ArrayList():(List) items.get( "satisItemList" );
	
	int satisListCnt = satisList.size();
	int lawyerListCnt = lawyerList.size();
	int procSatisListCnt = procSatisList.size();
	int satisItemListCnt = satisItemList.size();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();	
%>
	<script type="text/javascript">
		var inoutcon = "<%= inoutcon %>";
		var satisListCnt = <%= satisListCnt %>;
		var lawyerListCnt = <%= lawyerListCnt %>;
		var procSatisListCnt = <%= procSatisListCnt %>;
		var satisItemListCnt = <%= satisItemListCnt %>;
		
		function tabBtn_onclick( tab ) {
			$( "ul" ).children( "li" ).removeClass( "active" );
			$( "#tabBtn" + tab ).addClass( "active" );
			
			$( "#satisArea" ).children( "div" ).css( "display" , "none" );
			$( "#satisItems" + tab ).css( "display" , "block" );
		}
		
		// 저장 버튼 클릭
		function btnSave_onclick() {
			
			$( "#btnConfirm" ).css( "display" , "none" );
			
			var satisData = {};
			var satisDataArr = new Array();
			var chked = true;
			var officeTmp = "";
			
			for ( var i=0; i<lawyerListCnt; i++ ) {
				var frmNm = "satisFrm" + i;
				var frmTmp = document.getElementById( frmNm );
				
				<% if ( procSatisListCnt > satisItemListCnt ) { %>
				for ( var j=( i * satisItemListCnt ); j<( ( i + 1 ) * satisItemListCnt ); j++ ) {
				<% } else { %>
				for ( var j=0; j<satisItemListCnt; j++ ) {
				<% } %>
					var satisDataTmp = {};
					var checkedSatisLevel = $( "input[name=satislevel" + i + j + "]:checked" ).val();
					
					if ( checkedSatisLevel == undefined || checkedSatisLevel == null || checkedSatisLevel == "" ) {
						chked = false;
						officeTmp = frmTmp.office.value;
						break;
					}
					
					if ( checkedSatisLevel.split( "@@" )[ 3 ] != "null" && checkedSatisLevel.split( "@@" )[ 3 ] != frmTmp.lawfirmid.value ) {
						continue;
					}
					
					satisDataTmp.consultid = frmTmp.consultid.value;
					satisDataTmp.satisfactionid = checkedSatisLevel.split( "@@" )[ 0 ] == "null" ? "":checkedSatisLevel.split( "@@" )[ 0 ];
					satisDataTmp.satisitemid = checkedSatisLevel.split( "@@" )[ 2 ];
					satisDataTmp.satislevel = checkedSatisLevel.split( "@@" )[ 1 ];
					satisDataTmp.writer = frmTmp.writer.value;
					satisDataTmp.lawfirmid = frmTmp.lawfirmid.value;
					satisDataTmp.inoutcon = inoutcon;
					
					satisDataArr.push( satisDataTmp );
				}
				
				if ( ! chked ) {
					break;
				}
			}
			
			if ( chked ) {
				satisData.data = satisDataArr;
				console.log(JSON.stringify( satisData ));
				// 저장
				$.ajax({
						url : "saveSatisfaction.do"
					,	data : { "satisData" : JSON.stringify( satisData ) }
					,	dataType : "json"
					,	method : "post"
					,	success : function( result ) {
							alert( "정상 처리 되었습니다." );
							
							if ( <%= ! "YYY".equals( isprevsatis ) %> ) {
								opener.gotoview();
							}
							
							window.close();
						}
					,	error : function( jqXHR , textStatus , errorThrown ) {
							console.log( errorThrown );
							alert( "처리 중 오류가 발생하였습니다." );
						}
				});
			}
			else {
				alert( "[ " + officeTmp + " ]에 대한 만족도 평가가 완료되지 않았습니다." );
				$( "#btnConfirm" ).css( "display" , "" );
			}
		}
		
		// 취소 버튼 클릭
		function btnCancel_onclick() {
			
			if ( confirm( "만족도 평가를 저장하지 않고 창을 닫으시겠습니까?" ) ) {
				window.close();
			}
		}
		
		// 페이지 로드 시 수행
		$( document ).ready( function() {
			tabBtn_onclick( 0 );
		});
	</script>
<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">만족도 평가</strong>
		</div>
		<div class="subBtnC right" id="test">
		 	<a href="#none" class="sBtn type1" onclick="javascript:btnSave_onclick();">저장</a>
		</div>
	</div>	
	<div class="innerB" >
		<%-- 법무법인 탭 버튼 --%>
		<div class="subTabW">
			<ul>
				<%
					HashMap consult = new HashMap();
					for ( int i=0; i<lawyerListCnt; i++ ) {
						consult = (HashMap) lawyerList.get( i );
				%>
					<li id="tabBtn<%= i %>">
						<a href="#" onclick="tabBtn_onclick(<%= i %>)" style="padding:15px 15px;"><%= consult.get("OFFICE") %></a>
					</li>
				<%
					}
				%>
			</ul>
		</div>
		
		<%-- 법무법인 별 평가지 --%>
		<div id="satisArea">
			<%
				for ( int i=0; i<lawyerListCnt; i++ ) {
					consult = (HashMap) lawyerList.get( i );
			%>
			<div class="tableW" id="satisItems<%= i %>">
				
				<form id="satisFrm<%= i %>" name="satisFrm<%= i %>" method="post">
					<input type="hidden" id="consultid" name="consultid" value="<%= consultid %>" />					<%-- 자문ID --%>
					<input type="hidden" id="writer" name="writer" value="<%= USERNO %>" />									<%-- 만족도 평가자ID --%>
					<input type="hidden" id="lawfirmid" name="lawfirmid" value="<%= consult.get("LAWFIRMID") %>" />	<%-- 법무법인ID --%>
					<input type="hidden" id="office" name="office" value="<%= consult.get("OFFICE") %>" />					<%-- 법무법인명 --%>
					
					<table class="infoTable">
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
							for ( int j=0; j<satisListCnt; j++ ) {
								satisItemMap = (HashMap) satisList.get( j );
								
								if ( satisItemMap.get( "lawfirmid" ) != null && ! consult.get("LAWFIRMID").equals( String.valueOf( satisItemMap.get( "lawfirmid" ) ) ) ) {
									continue;
								}
								
								String satisLevel = satisItemMap.get( "satislevel" ) == null ? "":String.valueOf( satisItemMap.get( "satislevel" ) );
								String idStr = String.valueOf( i ) + String.valueOf( j );
								
								if ( i > 0 && ! "null".equals( String.valueOf( satisItemMap.get( "satisfactionid" ) ) ) && "null".equals( String.valueOf( satisItemMap.get( "lawfirmid" ) ) ) ) {
									satisItemMap.put( "satisfactionid" , "null" );
								}
						%>
						<tr>
							<th colspan="5" style="text-align: left;"><%= satisItemMap.get( "itemtype" ) %> : <%= satisItemMap.get( "item" ) %></th>
						</tr>
						<tr>
							<td>
								<label for="satislevel0<%= idStr %>"><input type="radio" id="satislevel0<%= idStr %>" name="satislevel<%= idStr %>" value="<%= satisItemMap.get( "satisfactionid" ) %>@@25@@<%= satisItemMap.get( "satisitemid" ) %>@@<%= satisItemMap.get( "lawfirmid" ) %>" <% if ( "25".equals( satisLevel ) ) out.print( "checked" ); %>> <%= satisItemMap.get( "ans1" ) %> ( 25 )</label>
							</td>
							<td>
								<label for="satislevel1<%= idStr %>"><input type="radio" id="satislevel1<%= idStr %>" name="satislevel<%= idStr %>" value="<%= satisItemMap.get( "satisfactionid" ) %>@@20@@<%= satisItemMap.get( "satisitemid" ) %>@@<%= satisItemMap.get( "lawfirmid" ) %>" <% if ( "20".equals( satisLevel ) ) out.print( "checked" ); %>> <%= satisItemMap.get( "ans2" ) %> ( 20 )</label>
							</td>
							<td>
								<label for="satislevel2<%=idStr %>"><input type="radio" id="satislevel2<%= idStr %>" name="satislevel<%= idStr %>" value="<%= satisItemMap.get( "satisfactionid" ) %>@@15@@<%= satisItemMap.get( "satisitemid" ) %>@@<%= satisItemMap.get( "lawfirmid" ) %>" <% if ( "15".equals( satisLevel ) ) out.print( "checked" ); %>> <%= satisItemMap.get( "ans3" ) %> ( 15 )</label>
							</td>
							<td>
								<label for="satislevel3<%= idStr %>"><input type="radio" id="satislevel3<%= idStr %>" name="satislevel<%= idStr %>" value="<%= satisItemMap.get( "satisfactionid" ) %>@@10@@<%= satisItemMap.get( "satisitemid" ) %>@@<%= satisItemMap.get( "lawfirmid" ) %>" <% if ( "10".equals( satisLevel ) ) out.print( "checked" ); %>> <%= satisItemMap.get( "ans4" ) %> ( 10 )</label>
							</td>
							<td>
								<label for="satislevel4<%= idStr %>"><input type="radio" id="satislevel4<%= idStr %>" name="satislevel<%= idStr %>" value="<%= satisItemMap.get( "satisfactionid" ) %>@@5@@<%= satisItemMap.get( "satisitemid" ) %>@@<%= satisItemMap.get( "lawfirmid" ) %>" <% if ( "5".equals( satisLevel ) ) out.print( "checked" ); %>> <%= satisItemMap.get( "ans5" ) %> ( 5 )</label>
							</td>
						</tr>
						<%
							}
						%>
					</table>
				</form>
			</div>
			<%
				}
			%>
		</div>
	</div>
</div>