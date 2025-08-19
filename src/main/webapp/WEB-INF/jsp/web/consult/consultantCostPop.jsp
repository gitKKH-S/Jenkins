<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.mten.cmn.MtenResultMap"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.StringUtil"%> 
<%@ page import="com.mten.bylaw.consult.DateUtil"%>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%@ page import="java.text.DecimalFormat"%>
<%
	String consultid = request.getParameter("consultid")==null?"":request.getParameter("consultid");
	List consultantList = request.getAttribute("ConsultantList")==null?new ArrayList():(ArrayList)request.getAttribute("ConsultantList");
	int consultantListCnt = consultantList.size();
%>

<style>

</style>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
$(document).ready(function(){
	$("#savebtn").click(function(){
		if(confirm("등록 하시겠습니까?")){
			var costInfo = {};
			var costInfoArr = new Array();
			var chk = true;
			var chkType = "";
			var officeTmp = "";
			
			for ( var i=0; i<consultantListCnt; i++ ) {
				var frmNm = "costInfoFrm" + i;
				var frmTmp = document.getElementById( frmNm );
				
				// 지급액 입력 내역 체크
				var inputCost = removeComma( frmTmp.korailcost.value );
				var chkCost = /^[0-9]*$/;
				if ( ( inputCost == "" || inputCost == 0 ) || ! ( chkCost.test( inputCost ) ) ) {
					chk = false;
					
					if ( inputCost== "" || inputCost == 0 ) {
						chkType = "E";
					}
					else {
						chkType = "N";
					}
					
					officeTmp = frmTmp.office.value;
					tabBtn_onclick( i );
					frmTmp.korailcost.focus();
					frmTmp.korailcost.select();
					break;
				}
				
				// JSON 데이터 구성
				var costInfoTmp = {};
				costInfoTmp.consultid = frmTmp.consultid.value;
				costInfoTmp.consultantid = frmTmp.consultantid.value;
				costInfoTmp.korailcost = removeComma( frmTmp.korailcost.value );
				costInfoTmp.consultantcost = removeComma( frmTmp.consultantcost.value );
				costInfoTmp.bankname = encodeURIComponent( frmTmp.bankname.value );
				costInfoTmp.account = frmTmp.account.value;
				costInfoTmp.accountowner = encodeURIComponent( frmTmp.accountowner.value );
				costInfoTmp.seqGbn = frmTmp.seqGbn.value;
				
				costInfoArr.push( costInfoTmp );
			}
			
			if ( chk ) {
				costInfo.data = costInfoArr;
				
				// 저장
				$.ajax({
						url : "<%= CONTEXTPATH %>/consult/saveCostInfo.do"
					,	data : { "costInfo" : JSON.stringify( costInfo ) }
					,	dataType : "json"
					,	method : "post"
					,	success : function( result ) {
							alert( "정상 처리 되었습니다." );
							opener.refresh();
							window.close();
						}
					,	error : function( jqXHR , textStatus , errorThrown ) {
							console.log( errorThrown );
							alert( "처리 중 오류가 발생하였습니다." );
						}
				});
			}
			else {
				if ( chkType == "E" ) {
					alert( "[ " + officeTmp + " ]에 대한 자문료 지급정보 입력이 완료되지 않았습니다." );
				}
				else if ( chkType == "N" ) {
					alert( "[ " + officeTmp + " ] 지급액은 숫자만 입력할 수 있습니다." );
				}
			}
		}
	});
	tabBtn_onclick( 0 );
});
var consultantListCnt = <%= consultantListCnt %>;

// 법무법인 탭 버튼 클릭
function tabBtn_onclick( tab ) {
	
	$( "ul" ).children( "li" ).removeClass( "active" );
	$( "#tabBtn" + tab ).addClass( "active" );
	
	$( "#costInfoArea" ).children( "div" ).css( "display" , "none" );
	$( "#costInfoItems" + tab ).css( "display" , "block" );
	
	var frmNm = "costInfoFrm" + tab;
	var frmTmp = document.getElementById( frmNm );
	frmTmp.korailcost.focus();
}
//자문료 지급액 입력 시, 3자리마다 콤마 처리
function costComma( korailCost ) {
	
	var costv = korailCost.value;
	
	costv = removeComma( costv );
	costv = insertComma( costv );
	
	korailCost.value = costv;
}
function removeComma( remove ) {
	var rgxNum = /[^0-9]/g;
	remove = remove.replace( rgxNum , '' );
	
	return remove;
}
function insertComma( insert ) {
	var rgxComma = /([0-9]+)([0-9]{3})/;
	while ( rgxComma.test( insert ) ) {
		insert = insert.replace( rgxComma , '$1'+','+'$2' );
	}
	
	return insert;
}
</script>
<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">자문료 지급정보</strong>
		</div>
		<div class="subBtnC right" id="test">
		 	<a href="#none" class="sBtn type1" id="savebtn">저장</a>
		</div>
	</div>	
	<div class="innerB" >
		<div class="subTabW">
			<ul>
				<%
					for ( int i=0; i<consultantList.size(); i++ ) {
						HashMap consultant = (HashMap) consultantList.get( i );
				%>
					<li id="tabBtn<%= i %>">
						<a href="#" onclick="tabBtn_onclick(<%= i %>)"><%= consultant.get("LAWYERNM") %></a>
					</li>
				<%
					}
				%>
			</ul>
		</div>
		<%-- 법무법인 별 지급정보 --%>
		<div id="costInfoArea">
			<%
				for ( int i=0; i<consultantList.size(); i++ ) {
					HashMap consultant = (HashMap) consultantList.get( i );
					
					String consultantCost = consultant.get("CONSULTANTCOST")==null?"":consultant.get("CONSULTANTCOST").toString();
					String korailCost = consultant.get("KORAILCOST")==null?"":consultant.get("KORAILCOST").toString();
					
					// 금액 3자리마다 콤마 처리
					DecimalFormat df = new DecimalFormat( "#,##0" );
					consultantCost = "".equals( consultantCost ) ? "":df.format( Double.parseDouble( consultantCost ) );
					korailCost = "".equals( korailCost ) ? "":df.format( Double.parseDouble( korailCost ) );
			%>
			<div class="tableW" id="costInfoItems<%= i %>">
				
				<form id="costInfoFrm<%= i %>" name="costInfoFrm<%= i %>" method="post">
					<input type="hidden" id="consultid" name="consultid" value="<%= consultid %>" />
					<input type="hidden" id="consultantid" name="consultantid" value="<%= consultant.get("CONSULTANTID") %>" />
					<input type="hidden" id="filegbn" name="filegbn" value="krcost" />
					<input type="hidden" id="seqGbn" name="seqGbn" value="CCostInput" />
					
					<table class="infoTable">
						<colgroup>
							<col style="width: 25%;">
							<col style="width: 75%;">
						</colgroup>
						
						<tr>
							<th>법무법인</th>
							<td>
								<input type="text" id="office" name="office" value="<%= consultant.get("LAWYERNM") %>" readonly="readonly" style="width: 97%;" />
							</td>
						</tr>
						<tr>
							<th>은행</th>
							<td>
								<input type="text" id="bankname" name="bankname" value="<%= consultant.get("BANKNAME") %>" style="width: 97%;" />
							</td>
						</tr>
						<tr>
							<th>계좌번호</th>
							<td>
								<input type="text" id="account" name="account" value="<%= consultant.get("ACCOUNT") %>" style="width: 97%;" />
							</td>
						</tr>
						<tr>
							<th>예금주</th>
							<td>
								<input type="text" id="accountowner" name="accountowner" value="<%= consultant.get("ACCOUNTOWNER") %>" style="width: 97%;" />
							</td>
						</tr>
						<tr>
							<th>청구액</th>
							<td>
								<input type="text" id="consultantcost" name="consultantcost" value="<%= consultantCost %>" readonly="readonly" style="width: 97%;" />
							</td>
						</tr>
						<tr>
							<th>지급액</th>
							<td>
								<input type="text" id="korailcost" name="korailcost" value="<%= korailCost %>" onkeyup="costComma( this )" onchange="costComma( this )" style="width: 97%;" />
							</td>
						</tr>
						
					</table>
				</form>
			</div>
			<%
				}
			%>
		</div>
	</div>
</div>
