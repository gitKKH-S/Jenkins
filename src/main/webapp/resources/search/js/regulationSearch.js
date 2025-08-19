const INDEX_DOC="rulem";
const INDEX_FILE="rulef";

$(document).ready(function() {
	$("input[name='docgbn']").prop('checked', true);
	mkSortSelectBox(); // 정렬
	$("#hidden_schGbn").val('');
	$("#hidden_consultGbn").val('');
	$("#hidden_docGbn").val('');
	$("#hidden_datepickStart").val('');
	$("#hidden_datepickEnd").val('');
	$("#hidden_fileGbn").val('');
	$("#hidden_searchQuery").val('');
	$("#hidden_indexKey").val(INDEX_DOC);
//	$("#hidden_sortGbn").val('');
	
	$("input[name='schGbn']").click(function(){
		if(this.value=='META'){
			init('doc');
		}else{
			init('file');
		}
	});
	
	if($("#hidden_paramYN").val()=="true"){
		$("#txtSearchBar").val($("#hidden_pQuery_tmp").val());
		param['param_yn']= true;
		param['param_index']= $("#hidden_indexKey").val();
		param['param_query']= $("#hidden_pastQuery").val();
		param['param_pQuery_tmp']= $("#hidden_pQuery_tmp").val();
		param['param_pageNo']=$("#hidden_pageNum").val();
		param['param_listSize']=$("#hidden_listNum").val();
		param['param_sort']= $("#hidden_sortGbn").val();
		
		search($("#hidden_indexKey").val(),
				$("#hidden_pastQuery").val(),
				$("#hidden_pageNum").val(),
				$("#hidden_listNum").val(),
				$("#hidden_sortGbn").val()
				);
	}
	
});

var init = function(type){
	if (type == "" || type ===null || type == undefined){
		$("input[name='schGbn']")[0].checked=true;
		$(".msch input,selectbox").prop("checked",false);
		$(".fsch input").prop("checked",false);
		$('.datepick').val('');
		$("#txtSearchBar").val('');
	}else if(type == "doc"){
		$(".fsch input").prop("checked",false);
	}else if(type == "file"){
		$(".msch input,selectbox").prop("checked",false);
		$('.datepick').val('');
	}
}

var searchSubmit = function() {
	param['param_yn']= false;
	param['param_index']= "";
	param['param_query']= "";
	param['param_pQuery_tmp']= "";
	param['param_pageNo']="";
	param['param_listSize']="";
	param['param_sort']= "";
	
	$("#hidden_pageNum").val(1);
	var index = $("input[name='schGbn']:checked").val() == "META" ? INDEX_DOC
			:INDEX_FILE;
	$("#hidden_indexKey").val(index);
	var listSize = "10";
	$("#hidden_sortGbn").val($("#sortSelect").val());
	var sort = $("#hidden_sortGbn").val();
	var pageNo = "1";

	var pQuery = search_form_check();

	if (pQuery != "") {
		console.log("pQuery : " + pQuery);
		console.log(index +" / "+ pQuery+" / "+ pageNo+" / "+ listSize+" / "+ sort);
		search(index, pQuery, pageNo, listSize, sort);
		

		//키워드
		$.ajax({
			type : "POST",
			url : CONTEXTPATH+"/web/statistics/setWordLog.do",
			data : {"word":$("#txtSearchBar").val()},
			datatype: "json",
			error: function(){},
			success:function(data){}
		});
		
	} else {
		alert("검색어를 입력하세요.");
	}
}

var search_form_check = function() {
	var schGbn = $("input[name='schGbn']:checked").val();
	var index = $("#hidden_indexKey").val();
	var pQuery_tmp = $("#txtSearchBar").val();

	// 측수문자 공백 치환
	pQuery_tmp = searchTrim(searchRemoveSpecial(searchTrim(pQuery_tmp)));
	var operator = " AND ";

	var pQuery = ReplaceStr(pQuery_tmp, " ", operator);

	if (pQuery != '') {
		var schGbn_id = $("input[name='schGbn']:checked").attr('id');
		schGbn_id = schGbn_id.substring(schGbn_id.length - 1, schGbn_id.length);

		var docgbn_query = "";

		// 문서 검색
		if (index == INDEX_DOC) {
			// 검색구분
			if (schGbn_id == '0') {
				pQuery = "(unstored_FIELD_TITLE:("
						+ ReplaceStr(searchTrim(pQuery_tmp), " ", operator)
						+ ")";
				pQuery += " OR unstored_FIELD_CONTENTS:("
						+ ReplaceStr(searchTrim(pQuery_tmp), " ", operator)
						+ "))";
			} else if (schGbn_id == '1') {
				pQuery = "unstored_FIELD_TITLE:("
						+ ReplaceStr(searchTrim(pQuery_tmp), " ", operator)
						+ ")";
			} else if (schGbn_id == '2') {
				pQuery = "unstored_FIELD_CONTENTS:("
						+ ReplaceStr(searchTrim(pQuery_tmp), " ", operator)
						+ ")";
			}
			
			
			// 자치법규
			var rule_arr = []
			if ($("#ruleGbn_1").prop('checked')) {
				rule_arr.push("조례");
			}
			if ($("#ruleGbn_2").prop('checked')) {
				rule_arr.push("훈령");
			}
			if ($("#ruleGbn_3").prop('checked')) {
				rule_arr.push("규정");
			}
			if ($("#ruleGbn_4").prop('checked')) {
				rule_arr.push("규칙");
			}
			if ($("#ruleGbn_5").prop('checked')) {
				rule_arr.push("예규");
			}
			if ($("#ruleGbn_6").prop('checked')) {
				rule_arr.push("의회규칙");
			}
			if ($("#ruleGbn_7").prop('checked')) {
				rule_arr.push("의회훈령");
			} 
			var ruleGbnStr = rule_arr.join(" OR ");
			if(ruleGbnStr != ""){
				pQuery += " AND unstored_FIELD_BOOKCD:(" + ruleGbnStr + ")";
			}
			
			//소관 부서
			var dept = $("#ehkk").val();
			if (dept!=""){
				pQuery += " AND unstored_FIELD_DEPTNAME:(" + dept + ")";
			}

			// 연혁구분
			var state_arr=[]
			if ($("#stateGbn_1").prop('checked')) {
				state_arr.push("현행");
			}
			if ($("#stateGbn_2").prop('checked')) {
				state_arr.push("폐지");
			}
			if ($("#stateGbn_3").prop('checked')) {
				state_arr.push("연혁");
			}
			var stateGbnStr =state_arr.join(" OR "); 
			if(stateGbnStr != ""){
				pQuery += " AND unstored_FIELD_STATECD:(" + stateGbnStr + ")";
			}

			// 요청일
			var startDate = $("#datepickStart").val();
			var endDate = $("#datepickEnd").val();
			if (startDate != "" && startDate !== undefined
					&& startDate !== null && endDate != ""
					&& endDate !== undefined && endDate !== null) {
				pQuery += " AND keyword_FIELD_CREATEDT:[" + startDate + " TO "
						+ endDate + "]";
			}

			// 파일 검색
		} else if (index == INDEX_FILE) {
			pQuery ="(";
			pQuery += "unstored_FIELD_TITLE:("
					+ ReplaceStr(searchTrim(pQuery_tmp), " ", operator) + ")";
			pQuery += " OR unstored_FILE_DESC:("
					+ ReplaceStr(searchTrim(pQuery_tmp), " ", operator) + ")";
			pQuery += " OR unstored_FILE_NM:("
					+ ReplaceStr(searchTrim(pQuery_tmp), " ", operator) + ")";
			pQuery +=")";
			
			// 파일 구분
			var filegbn_arr=[]
			if ($("#file_gbn_1").prop('checked')) {
				filegbn_arr.push("별표");
			} 
			if ($("#file_gbn_2").prop('checked')) {
				filegbn_arr.push("별지서식");
			} 
			if ($("#file_gbn_3").prop('checked')) {
				filegbn_arr.push("별첨");
			}
			var filegbnStr = filegbn_arr.join(" OR "); 
			if (filegbnStr !== ""){
				pQuery += " AND unstored_FIELD_FILECD:(" + filegbnStr + ")";	
			}
		}

		// if(docgbn_query != undefined && docgbn_query != "") {
		// pQuery = pQuery + " AND (" + docgbn_query + ")";
		// }
		
		var pastQuery = $("#hidden_pastQuery").val();
		
		if($("#reSearch").prop("checked") &&
				pastQuery !==undefined && pastQuery !==null && pastQuery != "" ){
			pQuery += " AND (" + pastQuery + ")"; 
		}
		$("#hidden_pastQuery").val(pQuery);
		$("#hidden_pQuery_tmp").val(pQuery_tmp);
		

	}

	return pQuery;
}

var search = function(index, pQuery, pageNo, listSize, sort) {
	// var tab_name = index.substring(0,index.length-1);
	//	
	// $(".liTab").removeClass("active");
	// $("#tab_"+tab_name).addClass("active");
	console.log(index, pQuery, pageNo, listSize, sort);

	param['param_yn']= true;
	param['param_query']= pQuery;
	param['param_pQuery_tmp']= $("#hidden_pQuery_tmp").val();
	param['param_sort']=sort;
	
	search_ajax(index, pQuery, pageNo, listSize, sort);
}

var search_ajax = function(index, query, pageNo, listSize, sort) {
	var pQuery_tmp = $("#hidden_pQuery_tmp").val();

	$.ajax({
		contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		type : "POST",
		url : "../SearchRestApi.jsp",
		data : {
			index : index,
			query : query,
			pQuery_tmp : pQuery_tmp,
			pageNo : pageNo,
			listSize : listSize,
			sort : sort
		},
		dataType : "json",
		cache : false,
		timeout : 5000,
		success : function(data) {

			writeContent(data);

		},
		complete : function(data) {

		},
		error : function(jqxhr, status, error) {
			console.log(jqxhr.statusText + ",  " + status + ",   " + error);
			console.log(jqxhr.status);
			console.log(jqxhr.responseText);
		}

	});

}

var writeContent = function(data) {
	console.log(data);
	var count = data.count;
	var pageList_area = data.pageList;
	var result_list = "";
	var index = $("#hidden_indexKey").val();
	$(".subTT").append("("+count+")");
	// $("#mailCount").val(count);
	result_list += "<div class=\"innerB\">";
	if (count > 0) {
		result_list += "<div class=\"srchResultW\">";
		for (i = 0; i < data.list.length; i++) {
			result_list += "<a href=\"javascript:pageOpen(\'"+data.list[i].stored_FIELD_URLINFO+"\')\" >";
			result_list += "<h3 class=\"subSSTitle\">";
			result_list += data.list[i].stored_FIELD_TITLE + " "
					+ data.list[i].stored_FIELD_CREATEDT; // [법령]전기공사일반
															// 2013-08-05
			result_list += "</h3>";
			result_list += "</a>";
			result_list += "<div class=\"textBox\">";
			result_list += "<p>";
			result_list += data.list[i].stored_FIELD_CONTENTS;
			result_list += "</p>";
			if (index== INDEX_DOC){
				if (data.list[i].stored_ATTACH_LIST !== null
						&& data.list[i].stored_ATTACH_LIST !== undefined 
						&& data.list[i].stored_ATTACH_LIST != "" ) {
					var attach_list = data.list[i].stored_ATTACH_LIST.split("###");
					var file_desc_list = data.list[i].stored_FILE_DESC.split("###");

					result_list += "<ul class=\"preViewList\">";
					for (j = 0; j < attach_list.length - 1; j++) {
						var sfileNm = attach_list[j].split("@@@")[0];
						var fileId = attach_list[j].split("@@@")[1];
						var fileNm = attach_list[j].split("@@@")[2];
						var FIELD_FILEID = attach_list[j].split("@@@")[3];
						var exe = sfileNm.substring(sfileNm.lastIndexOf(".")+1 , sfileNm.length);

						// 파일명, 서버파일명, 구분(협약 : AGREE, 자문 : CONSULT, 소송 : SUIT, 자치법규 : LAW, 게시판(자료실) : BBS)
//						downFile('표준협약서.hwp', 'agree.hwp','AGREE')
						if(j==0){
							result_list += "<li>";
							result_list += "<a href=\"javascript:downFile('"+fileNm+"', '"+sfileNm+"','LAW')\">";
//							result_list += "<span class=\"iconStyle "+exe+"\">한글아이콘</span> "+
							result_list += fileNm;
							result_list += "</a>";
							result_list += "<a href=\"javascript:fileOpen("+FIELD_FILEID+")\" class=\"btnInTable\" id=\"btnInTable_"+
								FIELD_FILEID + "\">첨부문서 닫기</a>"; 	// key = file_name
							result_list += "<div class=\"preViewOpen\" id=\"preViewOpen_"+
								FIELD_FILEID + "\" style=\"display: block;\">";
//							result_list += file_desc_list[j];
							result_list += "</div>";
							result_list += "</li>";
							fileContentOpen(FIELD_FILEID);
						}else{
							result_list += "<li>";
							result_list += "<a href=\"javascript:downFile('"+fileNm+"', '"+sfileNm+"','LAW')\">";
//							result_list += "<span class=\"iconStyle "+exe+"\">한글아이콘</span> "+
							result_list += fileNm;
							result_list += "</a>";
							result_list += "<a href=\"javascript:fileOpen("+FIELD_FILEID+")\" class=\"btnInTable\" id=\"btnInTable_"+
								FIELD_FILEID + "\">첨부문서 확인</a>"; 	// key = file_name
							result_list += "<div class=\"preViewOpen\" id=\"preViewOpen_"+
								FIELD_FILEID + "\" style=\"display: none;\">";
//							result_list += file_desc_list[j];
							result_list += "</div>";
							result_list += "</li>";
							fileContentOpen(FIELD_FILEID);
						}
					}
					
					result_list += "</ul>";

				}
			}else if(index == INDEX_FILE){
				var fileNm = data.list[i].stored_FILE_NM
				var sfileNm = data.list[i].stored_SFILE_NM
				var sfileNm_only = data.list[i].stored_SFILE_NM.substring(0, data.list[i].stored_SFILE_NM.lastIndexOf("."))
				var exe = data.list[i].stored_SFILE_NM.substring(data.list[i].stored_SFILE_NM.lastIndexOf(".")+1)
				
							
				result_list += "<ul class=\"preViewList\">";
				result_list += "<li>";
				result_list += "<a href=\"javascript:downFile('"+fileNm+"', '"+sfileNm+"','LAW')\">";
//				result_list += "<span class=\"iconStyle "+exe+"\">한글아이콘</span> "+
				result_list += data.list[i].stored_FILE_NM;
				result_list += "</a>";
				result_list += "<a href=\"javascript:fileOpen("+data.list[i].stored_FIELD_FILEID+")\" class=\"btnInTable\" id=\"btnInTable_"+
					data.list[i].stored_FIELD_FILEID + "\">첨부문서 확인</a>"; 	// key = file_name
				result_list += "<div class=\"preViewOpen\" id=\"preViewOpen_"+
					data.list[i].stored_FIELD_FILEID + "\" style=\"display: none;\">";
				result_list += data.list[i].stored_FILE_DESC;
				result_list += "</div>";
				result_list += "</li>";
				result_list += "</ul>";
				fileContentOpen(FIELD_FILEID);
			}

			result_list += "</div>";
			if (i != data.list.length - 1) {
				result_list += "<hr class=\"margin20\">";
			}

		}
		result_list += "</div>";
		result_list += "</div>";

		$("#rule_data_list").html(result_list);
		$("#pagelist").html(pageList_area);
	} else {

		$("#rule_data_list").html("검색결과가 없습니다.");
		$("#pagelist").html("");
	}

}


var fileOpen = function(id) {
	if (!$("#preViewOpen_" + id).is(":visible")) {
		$("#preViewOpen_" + id).show();
		$("#btnInTable_" + id).html("첨부문서 닫기");
		$("#btnInTable_" + id).val("N");
		fileContentOpen(id);
	} else {
		$("#preViewOpen_" + id).hide();
		$("#btnInTable_" + id).html("첨부문서 확인");
		$("#btnInTable_" + id).val("Y");
	}
}

var fileContentOpen = function(file_id){
	console.log("show~~~~~~~"+file_id);

	var index = INDEX_FILE;
	var pQuery_tmp= $("#hidden_pQuery_tmp").val();
	
	var query = "keyword_FIELD_FILEID:(" + file_id + ")";

	$.ajax({
		contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		type : "POST",
		url : "../SearchRestApi.jsp",
		data : {
			index : index,
			fileId : file_id,
			file_open : "Y",
			pQuery_tmp : pQuery_tmp,
			query : query
		},
		dataType : "json",
		cache: false,
		timeout : 5000,
		success : function(data) {	
			if(data.list!== null && data.list !== undefined){
				$("#preViewOpen_"+file_id).html(data.list[0].stored_FILE_DESC);
			}else{
				$("#preViewOpen_"+file_id).html("");
			}
		},
		 complete: function (data) {},
		error: function(jqxhr, status, error){
			console.log(jqxhr.statusText + ",  " + status + ",   " + error);
			console.log(jqxhr.status);
			console.log(jqxhr.responseText);
		}

	});
	 
}

var goPage = function(pageNo) {
	$("#hidden_pageNum").val(pageNo);

	var pQuery = search_form_check();
	var listSize = $("#hidden_listNum").val();
	var sort = $("#hidden_sortGbn").val();
	var index = $("#hidden_indexKey").val();
	var pageNo = $("#hidden_pageNum").val();
	search(index, pQuery, pageNo, listSize, sort);
}

var mkSortSelectBox = function() {
	var obj = $(".sortSelect")[0]
	$(obj).append("<option value=\"expact\">정확도순</option>");
	$(obj).append("<option value=\"keyword_FIELD_CREATEDT_ASC\">날짜순</option>");
	$(obj).append("<option value=\"keyword_FIELD_CREATEDT_DESC\">날짜역순</option>");
	$(obj).append("<option value=\"keyword_FIELD_TITLE_ASC\">제목순</option>");
	$(obj).append("<option value=\"keyword_FIELD_TITLE_DESC\">제목역순</option>");
}



var checkboxChanged = function(obj) {
	if (obj.checked == true) {
		// 자문구분
		if (obj.id.indexOf("ruleGbn_0") != -1) {
			$("#ruleGbn_1").prop('checked', true);
			$("#ruleGbn_2").prop('checked', true);
			$("#ruleGbn_3").prop('checked', true);
			$("#ruleGbn_4").prop('checked', true);
			$("#ruleGbn_5").prop('checked', true);
			$("#ruleGbn_6").prop('checked', true);
			$("#ruleGbn_7").prop('checked', true);
		} else if (obj.id.indexOf("ruleGbn_1") != -1) {
			if ($("#ruleGbn_2").prop('checked') &&
					$("#ruleGbn_3").prop('checked') &&
					$("#ruleGbn_4").prop('checked') &&
					$("#ruleGbn_5").prop('checked') &&
					$("#ruleGbn_6").prop('checked') &&
					$("#ruleGbn_7").prop('checked')) {
				$("#ruleGbn_0").prop('checked', true);
			}
		} else if (obj.id.indexOf("ruleGbn_2") != -1) {
			if ($("#ruleGbn_1").prop('checked') &&
					$("#ruleGbn_3").prop('checked') &&
					$("#ruleGbn_4").prop('checked') &&
					$("#ruleGbn_5").prop('checked') &&
					$("#ruleGbn_6").prop('checked') &&
					$("#ruleGbn_7").prop('checked')) {
				$("#ruleGbn_0").prop('checked', true);
			}
		} else if (obj.id.indexOf("ruleGbn_3") != -1) {
			if ($("#ruleGbn_2").prop('checked') &&
					$("#ruleGbn_1").prop('checked') &&
					$("#ruleGbn_4").prop('checked') &&
					$("#ruleGbn_5").prop('checked') &&
					$("#ruleGbn_6").prop('checked') &&
					$("#ruleGbn_7").prop('checked')) {
				$("#ruleGbn_0").prop('checked', true);
			}
		} else if (obj.id.indexOf("ruleGbn_4") != -1) {
			if ($("#ruleGbn_2").prop('checked') &&
					$("#ruleGbn_3").prop('checked') &&
					$("#ruleGbn_1").prop('checked') &&
					$("#ruleGbn_5").prop('checked') &&
					$("#ruleGbn_6").prop('checked') &&
					$("#ruleGbn_7").prop('checked')) {
				$("#ruleGbn_0").prop('checked', true);
			}
		} else if (obj.id.indexOf("ruleGbn_5") != -1) {
			if ($("#ruleGbn_2").prop('checked') &&
					$("#ruleGbn_3").prop('checked') &&
					$("#ruleGbn_4").prop('checked') &&
					$("#ruleGbn_1").prop('checked') &&
					$("#ruleGbn_6").prop('checked') &&
					$("#ruleGbn_7").prop('checked')) {
				$("#ruleGbn_0").prop('checked', true);
			}
		} else if (obj.id.indexOf("ruleGbn_6") != -1) {
			if ($("#ruleGbn_2").prop('checked') &&
					$("#ruleGbn_3").prop('checked') &&
					$("#ruleGbn_4").prop('checked') &&
					$("#ruleGbn_5").prop('checked') &&
					$("#ruleGbn_1").prop('checked') &&
					$("#ruleGbn_7").prop('checked')) {
				$("#ruleGbn_0").prop('checked', true);
			}
		} else if (obj.id.indexOf("ruleGbn_7") != -1) {
			if ($("#ruleGbn_2").prop('checked') &&
					$("#ruleGbn_3").prop('checked') &&
					$("#ruleGbn_4").prop('checked') &&
					$("#ruleGbn_5").prop('checked') &&
					$("#ruleGbn_6").prop('checked') &&
					$("#ruleGbn_1").prop('checked')) {
				$("#ruleGbn_0").prop('checked', true);
			}
		}
		
		
		// 연혁 구분
		if (obj.id.indexOf("stateGbn_0") != -1) {
			$("#stateGbn_1").prop('checked', true);
			$("#stateGbn_2").prop('checked', true);
			$("#stateGbn_3").prop('checked', true);
		} else if (obj.id.indexOf("stateGbn_1") != -1) {
			if ($("#stateGbn_2").prop('checked') &&
					$("#stateGbn_3").prop('checked')) {
				$("#stateGbn_0").prop('checked', true);
			}
		} else if (obj.id.indexOf("stateGbn_2") != -1) {
			if ($("#stateGbn_1").prop('checked') &&
					$("#stateGbn_3").prop('checked')) {
				$("#stateGbn_0").prop('checked', true);
			}
		} else if (obj.id.indexOf("stateGbn_3") != -1) {
			if ($("#stateGbn_1").prop('checked') &&
					$("#stateGbn_2").prop('checked')) {
				$("#stateGbn_0").prop('checked', true);
			}
		} 

		// 파일구분
		if (obj.id.indexOf("file_gbn_0") != -1) {
			$("#file_gbn_1").prop('checked', true);
			$("#file_gbn_2").prop('checked', true);
			$("#file_gbn_3").prop('checked', true);
		} else if (obj.id.indexOf("file_gbn_1") != -1) {
			if ($("#file_gbn_2").prop('checked')&&
					$("#file_gbn_3").prop('checked')) {
				$("#file_gbn_0").prop('checked', true);
			}
		} else if (obj.id.indexOf("file_gbn_2") != -1) {
			if ($("#file_gbn_1").prop('checked')&&
					$("#file_gbn_3").prop('checked')) {
				$("#file_gbn_0").prop('checked', true);
			}
		} else if (obj.id.indexOf("file_gbn_3") != -1) {
			if ($("#file_gbn_1").prop('checked') &&
					$("#file_gbn_2").prop('checked') ) {
				$("#file_gbn_0").prop('checked', true);
			}
		}

	} else {
		// 자문구분
		if (obj.id.indexOf("ruleGbn_0") != -1) {
			$("#ruleGbn_1").prop('checked', false);
			$("#ruleGbn_2").prop('checked', false);
			$("#ruleGbn_3").prop('checked', false);
			$("#ruleGbn_4").prop('checked', false);
			$("#ruleGbn_5").prop('checked', false);
			$("#ruleGbn_6").prop('checked', false);
			$("#ruleGbn_7").prop('checked', false);
		} else if (obj.id.indexOf("ruleGbn_1") != -1) {
			$("#ruleGbn_0").prop('checked', false);
		} else if (obj.id.indexOf("ruleGbn_2") != -1) {
			$("#ruleGbn_0").prop('checked', false);
		} else if (obj.id.indexOf("ruleGbn_3") != -1) {
			$("#ruleGbn_0").prop('checked', false);
		} else if (obj.id.indexOf("ruleGbn_4") != -1) {
			$("#ruleGbn_0").prop('checked', false);
		} else if (obj.id.indexOf("ruleGbn_5") != -1) {
			$("#ruleGbn_0").prop('checked', false);
		} else if (obj.id.indexOf("ruleGbn_6") != -1) {
			$("#ruleGbn_0").prop('checked', false);
		} else if (obj.id.indexOf("ruleGbn_7") != -1) {
			$("#ruleGbn_0").prop('checked', false);
		}

		// 연혁구분
		if (obj.id.indexOf("stateGbn_0") != -1) {
			$("#stateGbn_1").prop('checked', false);
			$("#stateGbn_2").prop('checked', false);
			$("#stateGbn_3").prop('checked', false);
		} else if (obj.id.indexOf("stateGbn_1") != -1) {
				$("#stateGbn_0").prop('checked', false);
			
		} else if (obj.id.indexOf("stateGbn_2") != -1) {
				$("#stateGbn_0").prop('checked', false);
			
		} else if (obj.id.indexOf("stateGbn_3") != -1) {
				$("#stateGbn_0").prop('checked', false);
			
		} 

		// 파일구분
		if (obj.id.indexOf("file_gbn_0") != -1) {
			$("#file_gbn_1").prop('checked', false);
			$("#file_gbn_2").prop('checked', false);
			$("#file_gbn_3").prop('checked', false);
		} else if (obj.id.indexOf("file_gbn_1") != -1) {
			$("#file_gbn_0").prop('checked', false);
		} else if (obj.id.indexOf("file_gbn_2") != -1) {
			$("#file_gbn_0").prop('checked', false);
		} else if (obj.id.indexOf("file_gbn_3") != -1) {
			$("#file_gbn_0").prop('checked', false);
		}
	}

}

var searchTrim = function(str) {
	return str.replace(/(^\s*)|(\s*$)/g, "");
}

var ReplaceStr = function(strOriginal, strFind, strChange) {
	return strOriginal.split(strFind).join(strChange);
}

var searchRemoveSpecial = function(pQuery) {
	// 특수문자 추가
	pQuery = ReplaceStr(pQuery, "-", " ");
	pQuery = ReplaceStr(pQuery, "_", " ");
	pQuery = ReplaceStr(pQuery, "!", " ");
	pQuery = ReplaceStr(pQuery, "@", " ");
	pQuery = ReplaceStr(pQuery, "#", " ");
	pQuery = ReplaceStr(pQuery, "$", " ");
	pQuery = ReplaceStr(pQuery, "%", " ");
	pQuery = ReplaceStr(pQuery, "^", " ");
	pQuery = ReplaceStr(pQuery, "&", " ");
	pQuery = ReplaceStr(pQuery, "*", " ");
	pQuery = ReplaceStr(pQuery, "(", " ");
	pQuery = ReplaceStr(pQuery, ")", " ");
	pQuery = ReplaceStr(pQuery, "~", " ");
	pQuery = ReplaceStr(pQuery, "+", " ");
	pQuery = ReplaceStr(pQuery, "|", " ");
	pQuery = ReplaceStr(pQuery, "[", " ");
	pQuery = ReplaceStr(pQuery, "]", " ");
	pQuery = ReplaceStr(pQuery, "{", " ");
	pQuery = ReplaceStr(pQuery, "}", " ");
	pQuery = ReplaceStr(pQuery, ":", " ");
	pQuery = ReplaceStr(pQuery, ";", " ");
	pQuery = ReplaceStr(pQuery, "'", " ");
	pQuery = ReplaceStr(pQuery, "\"", " ");
	pQuery = ReplaceStr(pQuery, "\\", " ");
	pQuery = ReplaceStr(pQuery, ",", " ");
	pQuery = ReplaceStr(pQuery, "?", " ");
	pQuery = ReplaceStr(pQuery, "<", " ");
	pQuery = ReplaceStr(pQuery, ">", " ");
	pQuery = ReplaceStr(pQuery, "=", " ");
	pQuery = ReplaceStr(pQuery, "`", " ");
	pQuery = ReplaceStr(pQuery, "/", " ");
	pQuery = ReplaceStr(pQuery, ".", " ");

	return pQuery;
}


var pageOpen = function(url){
	window.open(url,"","scrollbars=yes, toolbar=no, width=1400, height=900");
}