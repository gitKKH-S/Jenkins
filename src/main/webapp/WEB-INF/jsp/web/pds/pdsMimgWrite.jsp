<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
%>
<script type="text/javascript">
	$(document).ready(function(){
		var oEditors = [];
		// 추가 글꼴 목록
		//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];
		nhn.husky.EZCreator.createInIFrame({
			oAppRef: oEditors,
			elPlaceHolder: "ir1",
			sSkinURI: "${resourceUrl}/smarteditor/SmartEditor2Skin.html",	
			htParams : {
				bUseToolbar : false,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				//bSkipXssFilter : true,		// client-side xss filter 무시 여부 (true:사용하지 않음 / 그외:사용)
				//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
				fOnBeforeUnload : function(){
					//alert("완료!");
				}
			}, //boolean
			fOnAppLoad : function(){
				//var sHTML = result.content;
				//oEditors.getById["ir1"].exec("PASTE_HTML", [sHTML]);
			},
			fCreator: "createSEditor2"
		});
		
		$(".sBtn").click(function(){
			var frm = document.wform;
			frm.PST_CN.value = oEditors.getById["ir1"].getIR();
			frm.submit();
		});
	});
</script>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong><font style="color:red;font-size:10pt;">&nbsp;&nbsp;&nbsp;(※ 이미지 사이즈는 1565×400 기준입니다.)</font>
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="countT"></strong>
		</div>
		<div class="subBtnC right">
			<a href="#" id="sBtn" class="sBtn type1">저장</a>
		</div>
	</div>
	<div class="innerB">
		<div id="gridList">
			<div class="tableW">
				<form name="wform" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/web/pds/pdsMimgSave.do">
					<input type="hidden" id="PST_TTL" name="PST_TTL" value="메인이미지등록">
					<input type="hidden" name="PST_CN" id="PST_CN"/>
					<input type="hidden" name="BBS_SE" id="BBS_SE" value="MAIN"/>
					<input type="hidden" name="MENU_MNG_NO"  value="<%=MENU_MNG_NO%>">
					<table class="infoTable write">
						<colgroup>
							<col style="width:20%;">
							<col style="width:*;">
						</colgroup>
						<tr>
							<th>메인 이미지 내용</th>
							<td>
								<script type="text/javascript" src="${resourceUrl}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>
								<textarea name="ir1" id="ir1" rows="5" cols="100" style="width:100%; height:212px; display:none;"></textarea>
							</td>
						</tr>
						<tr>
							<th>메인 이미지 파일</th>
							<td>
								<div class="filebox preview-image"> 
									<input class="upload-name" value="파일선택" disabled="disabled" > 
									<label for="mimg">업로드</label> 
									<input type="file" id="mimg" name="mimg" class="upload-hidden"> 
								</div>
							</td>
						</tr>
					</table>
				</form>
			</div>				
		</div>
	</div>
</div>
<style>
	/* imaged preview */
	.filebox .upload-display { /* 이미지가 표시될 지역 */
		margin-bottom: 5px;
	}
	
	@media ( min-width : 768px) {
		.filebox .upload-display {
			display: inline-block;
			margin-right: 5px;
			margin-bottom: 0;
		}
	}
	
	.filebox .upload-thumb-wrap { /* 추가될 이미지를 감싸는 요소 */
		display: inline-block;
		width: 54px;
		padding: 2px;
		vertical-align: middle;
		border: 1px solid #ddd;
		border-radius: 5px;
		background-color: #fff;
	}
	
	.filebox .upload-display img { /* 추가될 이미지 */
		display: block;
		max-width: 100%;
		width: 100% \9;
		height: auto;
	}
	
	.filebox input[type="file"] {
		position: absolute;
		width: 1px;
		height: 1px;
		padding: 0;
		margin: -1px;
		overflow: hidden;
		clip: rect(0, 0, 0, 0);
		border: 0;
	}
	
	.filebox label {
		display: inline-block;
		padding: .5em .75em;
		color: #999;
		font-size: inherit;
		line-height: normal;
		vertical-align: middle;
		background-color: #fdfdfd;
		cursor: pointer;
		border: 1px solid #ebebeb;
		border-bottom-color: #e2e2e2;
		border-radius: .25em;
	} 
	/* named upload */
	.filebox .upload-name {
		width : 25%;
		display: inline-block;
		padding: .5em .75em; /* label의 패딩값과 일치 */
		font-size: inherit;
		font-family: inherit;
		line-height: normal;
		vertical-align: middle;
		background-color: #f5f5f5;
		border: 1px solid #ebebeb;
		border-bottom-color: #e2e2e2;
		border-radius: .25em;
		-webkit-appearance: none; /* 네이티브 외형 감추기 */
		-moz-appearance: none;
		appearance: none;
	}
</style>
<script>
	//preview image  
	var imgTarget = $('.preview-image .upload-hidden');
	
	imgTarget.on('change', function(){ 
		var parent = $(this).parent();
		parent.children('.upload-display').remove(); 
		if(window.FileReader){ 
			//image 파일만 
			if (!$(this)[0].files[0].type.match(/image\//)) return; 
			
			var reader = new FileReader();
			reader.onload = function(e){ 
				var src = e.target.result;
				parent.prepend('<div class="upload-display"><div class="upload-thumb-wrap"><img src="'+src+'" class="upload-thumb"></div></div>'); 
			}
			reader.readAsDataURL($(this)[0].files[0]); 
		} else { 
			$(this)[0].select(); 
			$(this)[0].blur(); 
			var imgSrc = document.selection.createRange().text;
			parent.prepend('<div class="upload-display"><div class="upload-thumb-wrap"><img class="upload-thumb"></div></div>'); 
			var img = $(this).siblings('.upload-display').find('img');
			img[0].style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enable='true',sizingMethod='scale',src=\""+imgSrc+"\")"; 
		} 
	});
</script>