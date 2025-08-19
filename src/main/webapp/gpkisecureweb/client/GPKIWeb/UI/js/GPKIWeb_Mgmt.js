function initAdminMainEvent(){
	GPKISecureWebLog.log("GPKIWeb_Mgmt.js - initAdminMainEvent() called...");

	//인증서 관리창 스토리지 선택
	$('[id^="stg_admin_"]').click(function () {
		var stg_id = this.id.split("stg_admin_")[1];
		GPKISecureWebLog.log("admin storage selected.... storageId = "+stg_id)

		//UI driver 선택창 위치 조정
		var stg_idx = $(this).attr("stgIdx");
		$('#driver_admin_div').removeClass("pos_01").removeClass("pos_02").removeClass("pos_03").removeClass("pos_04").removeClass("pos_05");
		$('#driver_admin_div').addClass("pos_0"+stg_idx);

		//UI css selection 처리....
		$('[class^="ML_storage_"]').removeClass("on");
		$(this).parent().addClass("on");

		//인증서 목록 무조건 초기화
		makeAdminCertiListDiv(null);

		// 드라이버 선택창 닫기
		closeAdminDriverDialog();

		//UI 관리 기능 셋팅
		setMgmtFuncBtn(stg_id);

//		if(stg_id=="pfx"){
			//파일탐색기 열기...
//			openSearchPfxMgmtDialog();//인증서찾기창
//		}else {
			GPKISecureWebUI.selectStorageInfo(stg_id, function(resultCode, jsonObj){
//			GPKISecureWebApi.selectStorageInfo(stg_id, function(resultCode, jsonObj){
				GPKISecureWebLog.log("[Callback]selectStorage()  .... resultCode === "+resultCode);

				if( resultCode == 0) {
					if(jsonObj == null || $.isEmptyObject(jsonObj)){
						GPKISecureWebLog.log( "[click]옵션없음 인증서 목록 조회해라....");
						var certOpt = {"storageName":stg_id};

						GPKISecureWebUI.getStorageCertList(certOpt, function(resultCode, jsonObj) {
//						GPKISecureWebApi.getStorageCertList(certOpt, function(resultCode, jsonObj) {
							if( resultCode == 0) {//성공
//								GPKISecureWebLog.log("[SUCCESS!!!] Result === " + JSON.stringify(jsonObj));
								makeAdminCertiListDiv(jsonObj.cert_list);
							}else{	//실패
								GPKISecureWebLog.log("[ERROR!!! - "+resultCode+" ] errCode === " + jsonObj.errCode + ", errMsg === " +  jsonObj.errMsg);
								makeAdminCertiListDiv(null);
								//EmptyCertDiv();
							}
						});
					} else {
						GPKISecureWebLog.log("[SUCCESS!!!] Select Drive. Result === " + JSON.stringify(jsonObj));
//						GPKISecureWebLog.log( "[click]옵션있으니 드라이브 선택처리해라... drivers.length === " + jsonObj.drivers.length);
						openAdminDriverDialog(stg_id, jsonObj);
					}
				} else{
					GPKISecureWebLog.log("[ERROR!!! - "+resultCode+" ] errCode === " + jsonObj.errCode + ", errMsg === " +  jsonObj.errMsg);
					EmptyCertDiv();
				}
			});
//		}
	});
}

function setMgmtFuncBtn(stgId){
	//mgmtAll, copy, delete, import, export, changePw
	var dialogName = GPKISecureWebUI.getDialogName();
	GPKISecureWebLog.log("GPKIWeb_Mgmt.js - setMgmtFuncBtn() dialogName ===" + dialogName);

	$(".ad_cert_copy").addClass("off");
	$(".ad_cert_del").addClass("off");
	$(".ad_cert_pass_change").addClass("off");
	$(".ad_cert_import").addClass("off");
	$(".ad_cert_send").addClass("off");

	var classArr = [$(".ad_cert_copy"), $(".ad_cert_view"), $(".ad_cert_del"), $(".ad_cert_pass_change"), $(".ad_cert_import"), $(".ad_cert_send")];

	if(dialogName=="copy"){
		classArr = [$(".ad_cert_view"), $(".ad_cert_copy")];
	}else if(dialogName=="delete"){
		classArr = [$(".ad_cert_view"), $(".ad_cert_del")];
	}else if(dialogName=="import"){
		classArr = [$(".ad_cert_view"), $(".ad_cert_import")];
	}else if(dialogName=="export"){
		classArr = [$(".ad_cert_view"), $(".ad_cert_send")];
	}else if(dialogName=="changePw"){
		classArr = [$(".ad_cert_view"), $(".ad_cert_pass_change")];
	}

	if(stgId=="token"){
		for(var i=0;i<classArr.length;i++){
			classArr[i].addClass("off");
		}
		$(".ad_cert_view").removeClass("off");
	}else{
		for(var i=0;i<classArr.length;i++){
			classArr[i].removeClass("off");
		}
	}
}

function makeAdminCertiListDiv(listObj) {
	//GPKISecureWebLog.log("makeAdminCertiListDiv() called... listObj === " + JSON.stringify(listObj));

	var source = makeSourceData(listObj);	//main.js fn
	var dataAdapter = new $.MLjqui.dataAdapter(source);

	var dt_width = 398;
	var dt_height = 150;

	$("#dataTable_admin").MLjquiDataTable(
	{
		theme:"DSdatatable",
		width: dt_width,
		height: dt_height,
		columnsHeight:25,
		altRows: true, // 행 백그라운드 교차 //
		autoRowHeight: false,
		sortable: true,
		pageable: false,
		source: dataAdapter,
		enableHover: true,
		columnsResize: true,
		columns: [
			{ text: '구분', dataField: 'Policy', width: 80, align: 'center',
				cellsRenderer: function (row, column, value, rowData) {
					var image = "<div style='display:inline-block; padding-right:5px;'>";

					var imgurl = '';
					var isExpired = GPKISecureWebUtil.isDateExpired(rowData.enddatetime);
					if(isExpired){
						imgurl = 'UI/images/icon_cert_expire.png';
					}else{
						imgurl = 'UI/images/icon_cert_default.png';
					}

					var img = '<img width="16" height="16" style="display:block;" src="' + imgurl + '"/>';
					image += img;
					//image += "</div><span style='display:inline-block; vertical-align:top; padding-top:2px;'>" + rowData.Policy + "</span>";
					image += "</div><span style='display:inline-block; vertical-align:top; padding-top:2px;' title='" + rowData.Policy + "'>" + rowData.Policy + "</span>";
					return image;
				}
			},
			{ text: '사용자', dataField: 'Cn', width: 160, align: 'center',
				cellsRenderer: function (row, column, value, rowData) {
					var tooltip = "<span style='display:inline-block; vertical-align:top; padding-top:2px;' title='" + rowData.Cn + "'>" + rowData.Cn + "</span>";
					return tooltip;
				}
			},
			{ text: '만료일', dataField: 'enddate', width: 78, cellsAlign: 'center', align: 'center', cellsFormat: 'd' },
			{ text: '발급자', dataField: 'Issuer', cellsAlign: 'left', align: 'center', cellsFormat: 'c2' }
		],
		ready:function(){
			if(listObj!=null && listObj.length>0){
				$("#dataTable_admin").MLjquiDataTable('selectRow', 0);
			}
		}
	});

	if (listObj!=null && $.isEmptyObject($("#dataTable_admin").MLjquiDataTable('selectRow')) && listObj.length>0){
		$("#dataTable_admin").MLjquiDataTable('selectRow', 0);
	}

	//table row(인증서) 선택 event catch
	$("#dataTable_admin").on('rowSelect', function(e){
		var args = e.args;
		var index = args.index;
		var rowData = args.row;
		var rowKey = args.key;
//		GPKISecureWebLog.log("dataTable.rowSelect.args === " +args);
//		GPKISecureWebLog.log("dataTable.rowSelect.index === " +index);
//		GPKISecureWebLog.log("dataTable.rowSelect.rowData === " + JSON.stringify(rowData));
//		GPKISecureWebLog.log("dataTable.rowSelect.rowKey === " +rowKey);
	});
}

function openAdminDriverDialog(id, obj){
	var str = '';
		str += '<ul class="drive_position_menu">';
		if( id=="pfx" ){

		}else if( id=="hdd" ){
			for(var i=0; i<obj.hddOpt.length ; i++){
				str += '	<li id="'+id+'_driver_'+i+'" ><a href="#" >'+obj.hddOpt[i].diskname+'</a></li>';
			}
		}else if( id=="token" ){
			//{"tokenOpt":[{"tokenname":"A-Token","driver":"C","driverPath":"C:/", "tokenpasswd":""},{"tokenname":"B-Token","driver":"D","driverPath":"D:/", "tokenpasswd":""}]}
			for(var i=0; i<obj.tokenOpt.length ; i++){
				str += '	<li id="'+id+'_driver_'+i+'" ><a href="#" >'+obj.tokenOpt[i].tokenname+'</a></li>';
			}
		}else if( id=="mobile" ){
			//{"phoneOpt":[{"servicename":"ubikey","serviceOpt":{"version":"V2.0.1","popupURL":"http://aaa.co.kr","UbikeyWParam":"aaa1","UbikeylParam":"aaa2"}}]}
			for(var i=0; i<obj.phoneOpt.length ; i++){
				str += '	<li id="'+id+'_driver_'+i+'" ><a href="#" >'+obj.phoneOpt[i].servicename+'</a></li>';
			}
		}else if( id=="smartcert" ){
			//{"smartCertOpt":{"servicename":"dreamCS","serviceOpt":{"USIMServerIP":"","USIMServerPort":"","USIMSiteDomain":"","USIMRaonSiteCode":"","USIMInstallURL":"","USIMTokenInstallURL":""}}}
			for(var i=0; i<obj.smartCertOpt.length ; i++){
				str += '	<li id="'+id+'_driver_'+i+'" ><a href="#" >'+obj.smartCertOpt[i].servicename+'</a></li>';
			}
		}else if( id=="cloud" ){
			//{"cloudOpt":[{"servicename":"Dropbox","id":"dreamuser","passwd":"dreampw"},{"servicename":"google","id":"dreamuser","passwd":"dreampw"}]}
			for(var i=0; i<obj.cloudOpt.length ; i++){
				str += '	<li id="'+id+'_driver_'+i+'" ><a href="#" >'+obj.cloudOpt[i].servicename+'</a></li>';
			}
		}
		str += '</ul>';

	$('#driver_admin_div').empty().html(str);
	$('#driver_admin_div').show();

	//event binding
	GPKISecureWebLog.log("[driver select storage option]event binding prepared... "+id+" === " + JSON.stringify(obj))
	if( id=="pfx" ){

	}else if( id=="hdd" ){
		for(var i=0; i<obj.hddOpt.length ; i++){
			$("#"+id+"_driver_"+i).bind("click", function () {
				//var strVal = '{"diskname":"'+$(this).find("a").html()+'\\"}';
				var strVal = '{"diskname":"'+$(this).find("a").html()+'"}';
				selectAdminDriver(id, strVal);
			});
		}
	}else if( id=="token" ){
		
		for(var i=0; i<obj.tokenOpt.length ; i++){
			var optVal = JSON.stringify(obj.tokenOpt[i]);
			document.getElementById(id+"_driver_"+i).setAttribute("optStr", optVal);

			$("#"+id+"_driver_"+i).bind("click", function () {
				//selectDriver(id, this.getAttribute("optStr"));
				var toeknOptStr = this.getAttribute("optStr");

				if(toeknOptStr!=null && toeknOptStr.length!=0){
					var toeknOpt = JSON.parse(toeknOptStr);

					if(toeknOpt.driverPath==null || toeknOpt.driverPath.length==0){
						var smartCertURL = GPKISecureWebApi.getProperty('cs_smartcert_installurl');
						var smartCertSize = GPKISecureWebApi.getProperty('cs_smartcert_size');

						window.open(smartCertURL,'_blank','scrollbars=no,toolbar=no,resizable=no,'+smartCertSize+',left=0,top=0');
					}else{
						selectAdminDriver(id, toeknOptStr);
					}
				}else{
					// 설치 드라이버가 없는 경우
				}
			});
		}
	}else if( id=="mobile" ){
		for(var i=0; i<obj.phoneOpt.length ; i++){
			var optVal = JSON.stringify(obj.phoneOpt[i]);
			$("#"+id+"_driver_"+i).bind("click", function () {
				selectAdminDriver(id, optVal);
			});
		}
	}else if( id=="smartcert" ){
		for(var i=0; i<obj.smartCertOpt.length ; i++){
			var optVal = JSON.stringify(obj.smartCertOpt[i]);
			$("#"+id+"_driver_"+i).bind("click", function () {
				selectAdminDriver(id, optVal);
			});
		}
	}else if( id=="cloud" ){
		for(var i=0; i<obj.cloudOpt.length ; i++){
			var optVal = JSON.stringify(obj.cloudOpt[i]);
			$("#"+id+"_driver_"+i).bind("click", function () {
				selectAdminDriver(id, optVal);
			});
		}
	}
}

function closeAdminDriverDialog(){
	GPKISecureWebLog.log("closeAdminDriverDialog() called... ");

	$('#driver_admin_div').hide();
}

function selectAdminDriver(key, optVal){
	GPKISecureWebLog.log("selectAdminDriver() called... "+key+" === " + optVal);

	var certOpt = {"storageName":key};

	switch(key){
		case 'pfx' :
			certOpt.pfxOpt = JSON.parse(optVal);
			break
		case 'hdd' :
			certOpt.hddOpt = JSON.parse(optVal);
			break;
		case 'shdd' :
			certOpt.shddOpt = JSON.parse(optVal);
			break;
		case 'token' :
			certOpt.tokenOpt = JSON.parse(optVal);
			break;
		case 'mobile' :
			certOpt.phoneOpt = JSON.parse(optVal);
			break;
		case 'smartcert' :
			certOpt.smartCertOpt = JSON.parse(optVal);
			break;
		case 'cloud' :
			certOpt.cloudOpt = JSON.parse(optVal);
			break;
	}

	GPKISecureWebUI.getStorageCertList(certOpt, function(resultCode, jsonObj) {
//	GPKISecureWebApi.getStorageCertList(certOpt, function(resultCode, jsonObj) {
		GPKISecureWebLog.log("selectDriver.getStorageCertList");
		if( resultCode == 0) {
			//GPKISecureWebLog.log("[SUCCESS!!!] Result === " + JSON.stringify(jsonObj));
			makeAdminCertiListDiv(jsonObj.cert_list);
		}else{	//실패
			GPKISecureWebLog.log("[ERROR!!! - "+resultCode+" ] errCode === " + jsonObj.errCode + ", errMsg === " +  jsonObj.errMsg);
			EmptyAdminCertDiv();
		}
	});

	$('#driver_admin_div').hide();
}

function EmptyAdminCertDiv() {
	$("#dataTable_admin").MLjquiDataTable('clear');
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * 서브 팝업 공통화
 */
 //
//관리기능  - 암호변경, 가져오기, 내보내기
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function selectToStorage(key) {
//	console.log("============================================="+key);
	$("#subStorageDriver").hide();

	var certData = DSDialog.getProperty("certData");

	GPKISecureWebUI.selectStorageInfo(key, function(resultCode, jsonObj){
//	GPKISecureWebApi.selectStorageInfo(key, function(resultCode, jsonObj){
		if( resultCode == 0) {
			if(jsonObj == null || $.isEmptyObject(jsonObj)){
				GPKISecureWebLog.log( "[selectStorageInfo]옵션없음. 끝....");

				certData.certOpt = {"storageName":key};

				DSDialog.setProperty("certData", certData);

			} else {
				GPKISecureWebLog.log( "[selectStorageInfo]옵션있음. 선택해라....ResultObj === " + JSON.stringify(jsonObj));

				openToStorageDriverDialog(key, jsonObj);
			}
		} else{
			GPKISecureWebLog.log("[ERROR!!! - "+resultCode+" ] errCode === " + jsonObj.errCode + ", errMsg === " +  jsonObj.errMsg);
		}
	});
}

function openToStorageDriverDialog(key, obj){
	var certData = DSDialog.getProperty("certData");

	$("#subStorageDriver").hide();
	$("#subStorageDriver").removeClass("iepos_02");
	$("#subStorageDriver").removeClass("iepos_03");

	var str = '';
		str += '<ul class="drive_position_menu">';
	switch(key){
		case 'web' :
			certData.certOpt = {"storageName":"web"};
			certData.certOpt.storageOpt = {};
			break;
		case 'pfx' :
			break;
		case 'hdd' :
			certData.certOpt = {"storageName":"hdd"};
			certData.certOpt.storageOpt = {};

			$("#subStorageDriver").addClass("iepos_02");

			for(var i=0; i<obj.hddOpt.length ; i++){
				str += '	<li id="'+key+'_dv_'+i+'" ><a href="#" >'+obj.hddOpt[i].diskname+'</a></li>';
			}
			break;
		case 'token' :
			certData.certOpt = {"storageName":"token"};
			certData.certOpt.storageOpt = obj;

			$("#subStorageDriver").addClass("iepos_03");

			for(var i=0; i<obj.tokenOpt.length ; i++){
				str += '	<li id="'+key+'_dv_'+i+'" ><a href="#" >'+obj.tokenOpt[i].tokenname+'</a></li>';
			}
			break;
		case 'mobile' :
			break;
		case 'smartcert' :
			break;
		case 'cloud' :
			break;
	}
		str += '</ul>';

	$('#subStorageDriver').empty().html(str);
	$("#subStorageDriver").show();

	//event binding
	if( key=="hdd" ){
		for(var i=0; i<obj.hddOpt.length ; i++){
//console.log("				length === "+key+"_dv_"+i);
			$("#"+key+"_dv_"+i).bind("click", function () {
//console.log("				this.html === " + $(this).find("a").html());
				var strVal = '{"diskname":"'+$(this).find("a").html()+'"}';
				certData.certOpt.storageOpt.hddOpt = JSON.parse(strVal);
			});
		}
	}else if( key=="token" ){
		for(var i=0; i<obj.tokenOpt.length ; i++){
			var optVal = JSON.stringify(obj.tokenOpt[i]);

			document.getElementById(key+"_dv_"+i).setAttribute("optStr", optVal);

			$("#"+key+"_dv_"+i).bind("click", function () {
				var toeknOptStr = this.getAttribute("optStr");
				
				certData.certOpt.storageOpt.tokenOpt = JSON.parse(toeknOptStr);
				
				
				//console.info('toeknOptStr='+toeknOptStr);

//				if(toeknOptStr!=null && toeknOptStr.length!=0){
//					var toeknOpt = JSON.parse(toeknOptStr);

//					if(toeknOpt.driverPath==null || toeknOpt.driverPath.length==0){
//						var smartCertURL = MtoeknOptStrL4WebApi.getProperty('cs_smartcert_installurl');
//						var smartCertSize = GPKISecureWebApi.getProperty('cs_smartcert_size');

//						window.open(smartCertURL,'_blank','scrollbars=no,toolbar=no,resizable=no,'+smartCertSize+',left=0,top=0');
//					}else{
//						selectCopyDriver(key, toeknOptStr);
//					}
//				}else{
					// 설치 드라이버가 없는 경우
//				}
			});
		}
	}

	DSDialog.setProperty("certData", certData);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//인증서 암호변경 다이얼로그 Open
function openCertPassChangeDialog(data){
	GPKISecureWebLog.log("function openCertPassChangeDialog()...");
	var popOption = {
		mode:"mgmt",
		title:"인증서 암호변경",
		showCert:true,
		certData:data,
		onclick:"changeCertPW",
		contentKey:"change_pw",
		dialogHeight:"355px"
	};

	DSDialog.openDialog(popOption, function(code,jsonObj){
		$("#input_pw_prev").focus();
	});
}

//암호변경 비밀번호 변경
function changeCertPW(data) {
	//비밀번호 입력 확인
	if($("#input_pw_prev").val() == '') {
		//openMgmtAlertDialog($.i18n.prop("ES006"));
		//$("#input_pw_prev").focus();
		DSAlert.openAlert("mgmt", $.i18n.prop("ES006"), $("#input_pw_prev"));
		return false;
	} else if($("#input_pw_new1").val() == '') {
		//openMgmtAlertDialog($.i18n.prop("ES006"));
		//$("#input_pw_new1").focus();
		DSAlert.openAlert("mgmt", $.i18n.prop("ES006"), $("#input_pw_new1"));
		return false;
	} else if($("#input_pw_new2").val() == '') {
		//openMgmtAlertDialog($.i18n.prop("ES006"));
		//$("#input_pw_new2").focus();
		DSAlert.openAlert("mgmt", $.i18n.prop("ES006"), $("#input_pw_new2"));
		return false;
	}
	
	var filter = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,16}$/;
	
	// 새 비밀번호 유효성 체크
	/*if(!filter.test($("#input_pw_new1").val())){
		//openMgmtAlertDialog($.i18n.prop("ES007") + "[새 비밀번호]");
		//$("#input_pw_new1").focus();
		//$("#input_pw_new1").val('');
		DSAlert.openAlert("mgmt", $.i18n.prop("ES007") + "[새 비밀번호]", $("#input_pw_new1"));
		return false;
	}
	
	// 새 비밀번호 확인 유효성 체크
	if(!filter.test($("#input_pw_new2").val())){
		//openMgmtAlertDialog($.i18n.prop("ES007") + "[새 비밀번호 확인]");
		//$("#input_pw_new2").focus();
		//$("#input_pw_new2").val('');
		DSAlert.openAlert("mgmt", $.i18n.prop("ES007") + "[새 비밀번호 확인]", $("#input_pw_new2"));
		return false;
	}*/
	
	if(!filter.test($("#input_pw_new1").val()) || !filter.test($("#input_pw_new2").val())){
		$("#input_pw_new1").val('');
		$("#input_pw_new2").val('');
		DSAlert.openAlert("mgmt", $.i18n.prop("ES007"), $("#input_pw_new1"));
		return false;
	}
	
	//새 비밀번호 확인
	if($("#input_pw_new1").val() != $("#input_pw_new2").val()) {
		//openMgmtAlertDialog($.i18n.prop("ES008"));
		//$("#input_pw_new1").focus();
		$("#input_pw_new1").val('');
		$("#input_pw_new2").val('');
		DSAlert.openAlert("mgmt", $.i18n.prop("ES008"), $("#input_pw_new1"));
		return false;
	}

	GPKISecureWebApi.changeStorageCertPasswd( data.storageEncCertIdx, $("#input_pw_prev").val(), $("#input_pw_new1").val(), function( code, obj){
		//GPKISecureWebLog.log("changeStorageCertPasswd() callback   code === "+ code + " / obj === " + JSON.stringify(obj));
		if(code == 0){
			DSDialog.closeDialog(function(code,obj){});
			//openMgmtAlertDialog($.i18n.prop("ES001"));
			DSAlert.openAlert("mgmt", $.i18n.prop("ES001"), null);

			//backup localStorage
			GPKISecureWebUtil.setBackupCertList(null);
		}else{
			if(obj.errCode==30011){
				$("#input_pw_prev").val('');
				DSAlert.openAlert("mgmt", $.i18n.prop("ES002"), $("#input_pw_prev"));
			}else{
				$("#input_pw_prev").val('');
				$("#input_pw_new1").val('');
				$("#input_pw_new2").val('');
				DSAlert.openAlert("mgmt", "비밀번호 변경에 실패 하였습니다.", null);
			}
		}
	});
}

//암호변경 popup Close
function closePwDialog() {
	//document.getElementById('pw_wrap').style.display='none';
	//$('#pw_wrap input[type="password"]').val('');
	//$("#pw_wrap_before").val('');
	//$("#pw_wrap_after").val('');
	//$("#pw_wrap_confirm").val('');

	DSDialog.closeDialog(function(code,obj){});
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PFX 인증서 가져오기 창 Open
function openSearchPfxDialog(){
	var popOption = {
		mode:"mgmt",
		title:"PFX 인증서 가져오기",
		showCert:false,
		certData:{},
		onclick:"importPfxToStorage",
		contentKey:"import_pfx",
		dialogHeight:"225px"
	};

	DSDialog.openDialog(popOption, function(code,jsonObj){
		$('#filefile').change( function(evt){

			var target = $(evt.target);
//console.log(JSON.stringify(target));
console.log("1="+JSON.stringify(target.files));

			var files = evt.target.files;
			var file = files[0];
//console.log(JSON.stringify(file));
			if (files && file) {
//console.log("1111111111111111111111111111111");
				var reader = new FileReader();

				if (FileReader.prototype.readAsBinaryString === undefined) {
					FileReader.prototype.readAsBinaryString = function (fileData) {
						var binary = "";
						var pt = this;
						reader.onload = function (e) {
							var bytes = new Uint8Array(reader.result);
							var length = bytes.byteLength;
							for (var i = 0; i < length; i++) {
								binary += String.fromCharCode(bytes[i]);
							}
							//pt.result  - readonly so assign content to another property
							pt.content = btoa(binary);

							//$("#sel_5132_01").attr("b64Cert",pt.content);
							$('#file_route').attr("b64Cert",pt.content);

							//$(pt).trigger('onload');
						}
						reader.readAsArrayBuffer(fileData);
					}
				}else{
					reader.onload = function(readerEvt) {
						var binaryString = readerEvt.target.result;
						//document.getElementById("base64textarea").value = btoa(binaryString);

						//$("#sel_5132_01").attr("b64Cert",btoa(binaryString));
						$('#file_route').attr("b64Cert",btoa(binaryString));
					};
				}

				reader.readAsBinaryString(file);
			}else{
				console.log("file null...");
			}
		});
	});
}

//PFX 인증서 가져오기 창 Open by local server
function openSearchPfxByCDialog(){
	var popOption = {
		mode:"mgmt",
		title:"PFX 인증서 가져오기",
		showCert:false,
		certData:{},
		onclick:"importPfxToStorage",
		contentKey:"import_pfx_c",
		dialogHeight:"225px"
	};

	DSDialog.openDialog(popOption, function(code,obj){});
}

//local server filePicker 로 pfx 인증서 정보 가져오기
function openCSFilePicker(){
	var funcOpt = {"fileExt":"pfx"};
	GPKISecureWebApi.createCryptoMsg("c", "getFilePicker", funcOpt, function(code, obj){
		GPKISecureWebLog.log("getFilePicker() PFX callback code === " + code);
		GPKISecureWebLog.log("getFilePicker() PFX callback b64FileStr === " + obj.b64FileStr);
		GPKISecureWebLog.log("getFilePicker() PFX callback filePath === " + obj.filePath);
		if( code == 0) {
			var filepath = obj.filePath;
			var filename = filepath.substr(filepath.lastIndexOf("\\")+1, filepath.length);

			$('#file_route').val(filename);
			$('#file_route').attr("b64Cert", obj.b64FileStr);
		}else{
			DSAlert.openAlert("mgmt", "PFX 인증서 정보 조회 오류가 발생하였습니다.", null);
		}
	});

}

//가져오기 확인
function importPfxToStorage(data) {
	var b64Cert = $('#file_route').attr("b64Cert");
	var pfxpasswd = $('#import_pfx_password').val();

	var pfxOpt = {};
	pfxOpt.libType = "javascript";
	pfxOpt.b64CertString = b64Cert;
	pfxOpt.pfxPasswd = pfxpasswd;

	//validation
	if(b64Cert==null || b64Cert==""){
		DSAlert.openAlert("mgmt", "선택된 PFX 인증서가 없습니다.", null);
		return false;
	}else if(pfxpasswd==null || pfxpasswd==""){
		DSAlert.openAlert("mgmt", $.i18n.prop("ES006"), $("#import_pfx_password"));
		return false;
	}

	var certbag = {};
	var passwd = $("#import_pfx_password").val();
	var targetStorage = GPKISecureWebApi.getProperty('selectedStorage').key;
	var targetStorageOpt = GPKISecureWebApi.getProperty('selectedStorage').current_option;

	var funcOpt = {"b64Pfx":b64Cert,"sPassword":passwd}

	GPKISecureWebApi.createCryptoMsg(GPKISecureWebApi.getProperty("libType"), "pfxImport", funcOpt, function(code, obj){
		GPKISecureWebLog.log("createCryptoMsg() callback code === "+code);
		//GPKISecureWebLog.log("createCryptoMsg() callback obj === "+JSON.stringify(obj));
		if(code == 0){
			if(GPKISecureWebApi.getProperty("libType") == 0){
				certbag =obj;
				var crypto_api = GPKISecureWebApi.getCryptoApi();
				crypto_api.prikeyEncrypt(certbag.signpri, passwd, null, function(code3,encSignPri){
					certbag.signpri = encSignPri;
					certbag.libType = 0;
					crypto_api.prikeyEncrypt(certbag.kmpri, passwd, null, function(code5,encKmPri){
						certbag.kmpri = encKmPri;
						GPKISecureWebApi.saveCertToStorage(certbag, passwd, targetStorage, targetStorageOpt, function(code2, obj2){
							GPKISecureWebLog.log("saveCertToStorage() callback code === "+code2);
							GPKISecureWebLog.log("saveCertToStorage() callback obj === "+JSON.stringify(obj2));
							if(code2 == 0){
								DSDialog.closeDialog(function(code3, obj3){});

								//목록 초기화.
								GPKISecureWebUI.getStorageCertList(null, function(resultCode, jsonObj) {
//								GPKISecureWebApi.getStorageCertList(null, function(resultCode, jsonObj) {
									if( resultCode == 0) {//성공
										makeAdminCertiListDiv(jsonObj.cert_list);
										DSAlert.openAlert("mgmt", $.i18n.prop("ES012"), null);
									}else{	//실패
										GPKISecureWebLog.log("[ERROR!!! - "+resultCode+" ] errCode === " + obj.errCode + ", errMsg === " +  obj.errMsg);
										makeAdminCertiListDiv(null);
									}
								});

								//backup localStorage
								GPKISecureWebUtil.setBackupCertList(null);
							}else{
								if(obj2.errCode == 30009){
									//openMgmtAlertDialog("지원하지않는 저장 매체입니다.");
									DSAlert.openAlert("mgmt", $.i18n.prop("ER101"), null);
								}else{
									//openMgmtAlertDialog("PFX 인증서 정보 저장 오류가 발생했습니다.");
									DSAlert.openAlert("mgmt", "PFX 인증서 정보 저장 오류가 발생했습니다.", null);
								}
							}
						});
					});
			
				});
			}else{
				certbag = obj.result;
				GPKISecureWebApi.saveCertToStorage(certbag, passwd, targetStorage, targetStorageOpt, function(code2, obj2){
					GPKISecureWebLog.log("saveCertToStorage() callback code === "+code2);
					GPKISecureWebLog.log("saveCertToStorage() callback obj === "+JSON.stringify(obj2));
					if(code2 == 0){
						DSDialog.closeDialog(function(code3, obj3){});

						//목록 초기화.
						GPKISecureWebUI.getStorageCertList(null, function(resultCode, jsonObj) {
//						GPKISecureWebApi.getStorageCertList(null, function(resultCode, jsonObj) {
							if( resultCode == 0) {//성공
								makeAdminCertiListDiv(jsonObj.cert_list);
								DSAlert.openAlert("mgmt", $.i18n.prop("ES012"), null);
							}else{	//실패
								GPKISecureWebLog.log("[ERROR!!! - "+resultCode+" ] errCode === " + obj.errCode + ", errMsg === " +  obj.errMsg);
								makeAdminCertiListDiv(null);
							}
						});

						//backup localStorage
						GPKISecureWebUtil.setBackupCertList(null);
					}else{
						if(obj2.errCode == 30009){
							//openMgmtAlertDialog("지원하지않는 저장 매체입니다.");
							DSAlert.openAlert("mgmt", $.i18n.prop("ER101"), null);
						}else{
							//openMgmtAlertDialog("PFX 인증서 정보 저장 오류가 발생했습니다.");
							DSAlert.openAlert("mgmt", "PFX 인증서 정보 저장 오류가 발생했습니다.", null);
						}
					}
				});
			}

			
		}else{
			if(code==42101){
				//openMgmtAlertDialog("PFX 인증서 비밀번호가 틀렸습니다.");
				DSAlert.openAlert("mgmt", "PFX 인증서 비밀번호가 틀렸습니다.", $("#import_pfx_password"));
			}else{
				//openMgmtAlertDialog("PFX 인증서 정보 조회 오류가 발생했습니다.");
				DSAlert.openAlert("mgmt", "PFX 인증서 정보 조회 오류가 발생했습니다.", null);
			}
		}
	});
}

//가져오기 취소
function openSearchPfxMgmtDialogCancel() {

}

//인증서 내보내기
function openExportPfxDialog(data){
	//$('#popup_export_admin').MLjquiWindow('open');
	//GPKISecureWebLog.log("openExportPfxDialog() data === "+JSON.stringify(data));
	var popOption = {
		mode:"mgmt",
		title:"PFX 인증서 내보내기",
		showCert:true,
		certData:data,
		onclick:"exportPfxProc",
		contentKey:"confirm_pw",
		dialogHeight:"260px"
	};

	DSDialog.openDialog(popOption, function(code,jsonObj){});
}

function exportPfxProc(data) {
	var certPassword = $("#input_pw_confirm").val();

	//비밀번호 입력 확인
	if(certPassword == '') {
		//openMgmtAlertDialog($.i18n.prop("ES006"));
		//$("#input_pw_confirm").focus();
		DSAlert.openAlert("mgmt", $.i18n.prop("ES006"), $("#input_pw_confirm"));
		return false;
	}

	GPKISecureWebApi.getCertString(data.storageEncCertIdx, function(code, obj){
		//GPKISecureWebLog.log("getCertString() callback obj === " + JSON.stringify(obj));
		if(code == 0 ){
			var certbag = obj.cert;
			var targetStorage = "pfx";
			var targetStorageOpt = {"pfxOpt":{"libType":GPKISecureWebApi.getProperty("libType"),"b64CertString":""}};

			GPKISecureWebApi.saveCertToStorage(certbag, certPassword, targetStorage, targetStorageOpt, function(code2, obj2){
//				GPKISecureWebLog.log("saveCertToStorage() callback code === "+code2);
//				GPKISecureWebLog.log("saveCertToStorage() callback obj === "+JSON.stringify(obj2));
				if(code2 == 0 ){
					DSDialog.closeDialog(function(code3, obj3){});
					//openMgmtAlertDialog("인증서 내보내기에 성공하였습니다.");
					DSAlert.openAlert("mgmt", $.i18n.prop("ES013"), null);

					//backup localStorage
					GPKISecureWebUtil.setBackupCertList(null);
				}else{
					//openMgmtAlertDialog("인증서 내보내기에 실패하였습니다.");
					DSAlert.openAlert("mgmt", $.i18n.prop("ES020"), null);
				}
			});
		} else {
			//openMgmtAlertDialog("인증서 정보 조회 오류.");
			DSAlert.openAlert("mgmt", $.i18n.prop("ER201"), null);
		}
	});
}

//alert 창 열기/닫기
/*function openMgmtAlertDialog(msg){
	$('#mgmt_alert_msg').html(msg);
	$('#popup_mgmt_alert').MLjquiWindow('open');
}
function closeMgmtAlertDialog(){
	$('#popup_mgmt_alert').MLjquiWindow('close');
	$('#ML_window_admin').focus();
}*/