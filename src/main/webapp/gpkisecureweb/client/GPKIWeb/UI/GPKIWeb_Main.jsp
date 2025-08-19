<!doctype html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" import="java.util.*" %>
<html lang="ko">
<head>
<title> 인증서 선택 </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="format-detection" content="telephone=no">
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" />

<%-- Draw --%>
<script type="text/javascript" src="UI/js/GPKIWeb_Draw.js"></script>
<script type="text/javascript" src="UI/js/Issuer.js"></script>
<script type="text/javascript" src="UI/js/GPKIWeb_Main.js"></script>
<script type="text/javascript" src="UI/js/GPKIWeb_Popup.js"></script>
<script type="text/javascript" src="UI/js/encoding-indexes.js"></script>
<script type="text/javascript" src="UI/js/encoding.js"></script>
<script type="text/javascript">

//child iframe을 위한 이벤트 리스너 추가
window.addEventListener('message', function(e){
	var getDataCheck = typeof (e.data.result);
	var getGPKICert = e.data.protocol;
	
	if(getGPKICert != "GetCertList"){
		if(getDataCheck == null || getDataCheck != 'undefined' || getDataCheck != "undefined"){
			Storage_API_web.SaveServerCert(e, function(resultCode, resultValue){
				if(resultCode == 0){
					//성공시 닫기 처리
					DSAlert.closeAlert();
				}else{
					//실패시 닫기 처리
					DSAlert.closeAlert();
				}
			});	
		}
		if(e.data.success){
			DSAlert.closeAlert();
		}
	}

});

//IE Caps Lock 체크 해제
document.msCapsLockWarningOff = true;

var contextPath = '<%=request.getContextPath()%>';
// moved to ML_Draw.js all of func
$(document).ready(function(){
	//초기화 함수 호출
	GPKISecureWebDraw.loadCSS();
	GPKISecureWebDraw.initDraw();
	
});

</script>


</head>
<body>
<div id="ML_window" style="display:none;">
	<div style="width:418px; float:left;"></div>
	<div id="ML_container" style="width:418px; float:left;"><%-- ML_container : S --%>
		<div class="ML_content" style="width:418px;float:left;"><%-- ML_content : S --%>
			<div class="ML_content-area" id="GPKISecureWeb" style="padding-top:5px;"><%-- ML_content-area : S --%>
			<div id='ESignWindow'></div>
				<div class="ML_cp_AD" style="display:;"><img src="UI/images/banner_gpki.png" alt="배너"></div>
				<div id="ML_dp_01" class="ML_sub_tit">인증서 저장 위치 선택
					<span class="ML_sub_tit_link">
						<span class="btn_cell_right">
						<p class="hp_btn"><button type="button" id='btn_browser_manual' style="width:160px;" title="새창열림"><span><img src="UI/images/icon_help.png" alt="">브라우저 인증서 사용방법</span></button></p>	
						</span>
					</span>
				</div>
				<div class="ML_storage_box">
					<div class="ML_storage_box_sub">
						<%-- <form> --%>
						<div class="MLstrSlide" id="MLstrSlide">
							<%-- // --%>
						</div>
						<%-- </form> --%>
					</div>
					<div class="customNavigation" id="0"><div class="str_add_li ne"><a class="next"><span class="btn_str_add"></span></a></div></div>
					<%-- Drive list : S --%>
					<div id="driver_div" class="drive_position pos_05"  style="display:none;">
						<%-- // --%>
					</div>
					<%-- Drive list : E --%>
				</div>
				<%-- TRACE #1 --%>
				<%-- Certificate list : S --%>
				<div id="ML_dp_02"  class="ML_sub_tit">사용할 인증서 선택</div>
				<div id="ML_certlist_area" class="ML_cert_list_area">
					<div id="dataTable"></div>
				</div>
				<%-- BTN : S --%>
				<span id="ML_dp_03" class="btn_row_s_c">
					<span class="btn_cell_center">
						<p id="btn_browser" class="whtgrey_ws_btn2"><button type="button" id="in_browser"><span id="get_cert"></span></button></p>
						<p id="btn_browser" class="whtgrey_ws_btn2"><button type="button" id="out_browser"><span id="out_cert"></span></button></p>
						<p id="btn_browser" class="whtgrey_ws_btn2"><button type="button" id="con_browser"><span id="con_cert"></span></button></p>
					<%--	<p id="btn_browser" class="whtgrey_ws_btn2"><button type="button" id="btn_viewCert2"><span id="MSG_TS017">인증서 보기</span></button></p>--%>
					</span>
				</span>
				<%-- BTN : E --%>
				<%-- Certificate list : E --%>

				<div id="ML_dp_04" class="ML_sub_tit">인증서 비밀번호 입력</div>
				<div id="ML_status_area" class="ML_status_area">
					<div class="ML_pw_area">
						<div class="ML_cert_pw_area">
							<span class="ML_cert_pw_field">
								<%-- <input type="password" id="input_cert_pw" class="passwd_input" style="ime-mode:active;" placeholder="비밀번호를 입력하시오." autocomplete="off" value="" onKeypress="signEnterKeyEvent(event)"/> --%>
								<input type="password" id="input_cert_pw" class="passwd_input" data-tk-kbdType="qwerty" placeholder="비밀번호를 입력하시오." title="인증서 비밀번호" autocomplete="off" value="" onKeypress="signEnterKeyEvent(event)" npkencrypt="on" data-keypad-type="alpha" data-keypad-theme="default" data-keypad-useyn-type="toggle" data-keypad-useyn-input="keyboardOn" />
								<span id="capslock" class="capslock_box">＜Caps Lock＞이 켜져 있습니다.</span>
								<%-- <span id="input_cert_pw_tk_btn">마우스입력</span> --%>
								<span class="ML_cert_pw_key_box"><a href="#" id="keyboardOn" title="보안키보드"><div class="ML_cert_pw_keypad"></div></a></span>
							</span>
						</div>
						<%-- BTN --%>
						<span class="btn_row">
							<p class="b_blue_btn"><button type="button" id="btn_confirm_iframe"><span>확인</span></button></p>
							<span class="w_space10"></span>
							<p class="b_grey_btn"><button type="button" id="btn_cancel"><span>취소</span></button></p>
							<span class="w_space10"></span>
							<p class="b_grey_btn"><button type="button" id="btn_viewCert"><span class="MSG_cls" id="MSG_TS017">인증서 보기</span></button></p>
						</span>
						<%-- BTN --%>
					</div>
				</div>
			</div><%-- ML_content-area : E --%>
		</div><%-- ML_content : E --%>
		<%-- 브라우저 매뉴얼 --%>
		<div id="browser_manual1" style="width:250px; top:0px;left:418px;  position:absolute;z-index:10002;">
			<div class="br-modal-dialog02" style="width:250px;">
                <div class="br-modal-header">
            <img id="manual_close" src="UI/images/btn_hd_close.png" style="width:20px; heigth:20px;position:absolute; left:220px; " alt="브라우저 인증서 사용방법 닫기버튼" title="닫기버튼" tabindex="0" onKeyPress="manualClose(event);">
            <div class="br_hd_tit"><i class="la la-certificate"></i>브라우저 인증서 사용 방법</div>
			<div class="br_hd_con">
				브라우저 인증서는 하드디스크 등에 있는 인증서를 브라우저에 저장하는 것입니다. 
			</div>
        		</div>
	        <div class="br-modal-body">
	        	<div class="br_con_box">
	            	<div class="con_list">브라우저 인증서가 저장되어 있지 않을 경우, 아래의 절차대로 인증서를 선택하여 주세요.</div>
					<div class="con_step_box">
	                    <ul>
	                        <li><span class="step_cir">1</span>[인증서 가져오기] 버튼클릭</li>
	                        <li><span class="step_cir">2</span>하드디스크에 있는 인증서 파일 선택
	                            <ul>
	                                <li>파일경로 : C:\GPKI\certificate\class2</li>
	                                <li>파일종류 : *sig.cert, *sig.key 파일 2개</li>
	                            </ul>
	                        </li>
	                        <!-- <li><span class="step_cir">3</span>브라우저에 인증서 저장 체크 또는 체크해제
	                            <ul>
	                                <li>체&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;크 : 브라우저에 인증서를 저장 최초 1회만 저장하면 계속 이용가능</li>
	                                <li>체크해제 : 브라우저에 인증서를 저장하지 않음</li>
	                            </ul>
	                        </li>  -->
	                    </ul>
	                    <div class="con_list">인증서 비밀번호 입력</div>   
	                    <div class="con_list">브라우저 인증서는 브라우저 캐시를 삭제하면 지워짐</div>
					<!--<div class="con_last"><i class="la la-check-circle"></i>자세한 사항은 <span class="br_txt_bold">[브라우저 인증서 사용방법]</span> 선택</div>-->
					</div>
				</div>
			</div>
			</div>
		</div>
	</div><%-- ML_container : E --%>
</div>
<%-- 브라우저 메뉴얼에 타이틀바 없을 때 browser_menual3.png(250x558) 
            타이틀바 있을 때 browser_menual.png(250x523) 사용 --%>
<%-- <div id="browser_manual" style="display:none;">
	<div class="ML_container">
		<div class="ML_content">
			<div class="ML_content-area">
				<img src="UI/images/browser_menual3.png" alt="브라우저 인증서 사용방법" class="MLjqui-window-close-button MLjqui-icon-close">
			</div>
		</div>
	</div>
</div> --%>

<%-- 00. 인증서 Action Type 설정(MakeSignData, envelope, sign&envelope) --%>
<input type="hidden" id="certaction" value="" />

<%-- 수정 : 디폴트 스토리지 hdd일때 제일 앞의 디스크 선택 판단하기 위한 변수 저장 --%>
<input type="hidden" id="flagInit" value="0" />
<input type="hidden" id="temp" value="" />

<%-- 01. Alert dialog --%>
<div id="popup_alert" class="ML_container_dialog" style="display:none;">
	<div class="ML_content">
		<div class="ML_content-area" style="padding-top:5px;">
			<div class="ML_pw_dialog_status_area">
				<div class="ML_pw_dialog_area">
					<div id="alert_msg" class="ML_pw_dialog_txt">비밀번호를 다시 입력하세요.</div>
					<%-- BTN --%>
					<span class="btn_row">
						<p class="b_blue_btn"><button type="button" id="btn_alert_confirm" onClick="DSAlert.closeAlert();"><span>확인</span></button></p>
						<%--<span class="w_space40"></span>
						<p class="b_grey_btn"><button type="button" onClick="selfClose();"><span>취소</span></button></p>--%>
					</span>
					<%-- BTN --%>
				</div>
			</div>
		</div>
	</div>
</div>

<%-- 02. Common --%>
	<div id="ML_Dialog_common" style="display:none;">
		<div class="ML_content">
			<div id="ML_content_area" class="ML_content-area" style="padding-top: 5px; padding-bottom: 0px">
				<%-- Content : S --%>

				<%-- Content : E --%>
			</div>
			<div class="ML_content-area ML_pw_popup_area" style="padding-top: 5px;" id="btnArea">
				<%-- BTN --%>
				<span class="btn_row"  id="btn_row_area">
					<p class="b_blue_btn">
						<button type="button" id="btn_common_confirm" onClick="DSDialog.releaseDialog(null, true);">
							<span>확인</span>
						</button>
					</p>
					<span class="w_space40"></span>
					<p class="b_grey_btn">
						<button type="button" id="btn_common_cancle" onClick="DSDialog.closeDialog(function(code,obj){});" >
							<span>취소</span>
						</button>
					</p>
				</span>
				<%-- BTN --%>
			</div>
		</div>
	</div>
	
<%-- 02. Common (sub) --%>
	<div id="ML_Dialog_common_sub" style="display:none;">
		<div class="ML_content">
			<div id="ML_content_area_sub" class="ML_content-area" style="padding-top: 5px; padding-bottom: 0px">
			</div>
			<div class="ML_content-area ML_pw_popup_area" style="padding-top: 5px;">
				<span class="btn_row"  id="btn_row_area_sub">
					<p class="b_blue_btn">
						<button type="button" id="btn_common_sub_confirm" onClick="DSDialog.releaseDialog(null, true);">
							<span>확인</span>
						</button>
					</p>
				<span class="w_space40"></span>
					<p class="b_grey_btn">
						<button type="button" id="btn_common_sub_cancle" onClick="DSDialog.closeDialog(function(code,obj){});" >
							<span>취소</span>
						</button>
					</p>
				</span>
			</div>
		</div>
	</div>
	
<%-- 03. Cs install dialog --%>
	<div id="ML_dialog_cs_install" style="display:none;">
		<div class="ML_content">
			<div id="ML_content_area_cs" class="ML_content-area" style="padding-top: 5px; padding-bottom: 0px">
			</div>
			<div class="ML_content-area ML_pw_popup_area" style="padding-top: 5px;" id="btnArea">
				<span class="btn_row">
					<p class="b_blue_btn2">
						<button type="button" id="btn_common_confirm" onClick="DSDialog.releaseDialog();">
							<span>설치</span>
						</button>
					</p>
					<span class="w_space20"></span>
					<p class="b_blue_btn2">
						<button type="button" id="btn_common_run" onClick="DSDialog.runDialog();">
							<span>실행</span>
						</button>
					</p>
					<span class="w_space20"></span>
					<p class="b_grey_btn2">
						<button type="button" id="btn_common_cancle" onClick="DSDialog.closeDialog(function(code,obj){});" >
							<span>취소</span>
						</button>
					</p>
				</span>
			</div>
		</div>
	</div>
		
	<%-- 04. Server dialog --%>
	<div id="popup_server_info" class="ML_container_dialog_server" style="display:none; ">
		<div class="ML_content">
			<div class="ML_content-area">
				<div class="ML_pw_dialog_status_area">
					<div class="ML_pw_dialog_area" style="margin: 0; padding: 0;">
						<div id="server_info_area">
					    </div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
	<%-- 05. Statistics Log dialog --%>
	<div id="logsave_info" class="ML_container_dialog" style="display:none; ">
		<div class="ML_content">
			<div class="ML_content-area">
				<div class="ML_pw_dialog_status_area">
					<div class="ML_pw_dialog_area" style="margin: 0; padding: 0;">
						<div id="server_info_area_log">
					    </div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
</body>
</html>
