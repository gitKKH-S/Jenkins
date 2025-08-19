let INDEX_DOC="agree";
let INDEX_FILE="agreefile";

/**
 * 검색한 키워드 저장
 * 결과내 검색 체크, 체크해제시 기존 검색 키워드 표시하기 위해사용
 * */
let savedKeyword = "";

$(document).ready(function() {
	// 정렬 사용
	mkSortSelectBox();

	// 1) 페이지 로드 직후, 라디오값 기준으로 그룹 상태 초기화
	  //협약유형, 협약구분
	  setOnlyAllChecked('CVTN_CTRT_TYPE_CD_NM');
	  setOnlyAllChecked('INSD_OTSD_TASK_SE');
	  setOnlyAllChecked('CVTN_GBN');
	  
	  
	  // 2) 각 체크박스 클릭 시 토글 로직 실행
	  $('input[type="checkbox"]').on('change', function() {
	    const name = this.name;
	    const isAll = this.value === '';
	    
	    // FILE_SE_NM 그룹은 schGbn=field_attach일 때만 토글 허용
	    if (name === 'FILE_SE_NM' && $('input[name="schGbn"]:checked').val() !== 'field_attach') {
	      // 체크/해제해도 항상 disabled 상태 유지
	      return;
	    }
	    
	    if (isAll) {
	      // “전체” 체크박스 토글
	      if (this.checked) {
	        // 체크 → 나머지 off + disabled
	        $(`input[name='${name}']`).not(this)
	          .prop('checked', false)
	          .prop('disabled', true);
	      } else {
	        // 해제 → 나머지 enabled
	        $(`input[name='${name}']`).not(this)
	          .prop('disabled', false);
	      }
	    } else {
	      // 개별 체크박스 선택 → “전체” 해제 + enabled
	      $(`input[name='${name}'][value='']`)
	        .prop('checked', false)
	        .prop('disabled', false);
	    }
	  });
	
	  
	  
	  
	//화면 초기화
	init();
	
	$("#indexKey").val(INDEX_DOC);
	//카테고리 처음 왔을때 검색 키워드 입력
	$("#schTxt").val($("#pQuery_tmp").val());
	
	//검색시작
	searchSubmit();
	
});

/**
 * 조건 초기화
 * */
var init = function(){
	
	//검색조건
	chSchGbn("");
	$('input[name="schGbn"][value=""]').prop('checked', true);
	
	//검색어 
	$("#schTxt").val("");
	savedKeyword ="";
	
	//정렬
	$("#sortSelect option:eq(0)").prop("selected",true);
	
	//관리번호
	$("#CVTN_DOC_NO").val("");
	
	
	//협약의뢰일
	$('#CVTN_RQST_YMDStart').val("");
	$('#CVTN_RQST_YMDEnd').val("");
	
	//협약체결예정일
	$('#CVTN_CNCLS_PRNMNT_YMDStart').val("");
	$('#CVTN_CNCLS_PRNMNT_YMDEnd').val("");
	
	//의뢰부서
	$("#CVTN_RQST_DEPT_NM").val("");
	
	//의뢰직원
	$("#CVTN_RQST_EMP_NM").val("");
	
	//법률/계약전문관
	$("#CVTN_TKCG_EMP_NM").val("");
	
	//위임/자문변호사
	$("#JDAF_CORP_EMP_NMS").val("");
	
	 //협약유형, 협약구분
	 setOnlyAllChecked('CVTN_CTRT_TYPE_CD_NM');
	 setOnlyAllChecked('INSD_OTSD_TASK_SE');
	 setOnlyAllChecked('CVTN_GBN');
}


/**
 * 검색 조건에따라 조건 막기 
 * */
function chSchGbn(type){
	
	if(type == "field_attach"){
		setOnlyAllChecked('FILE_SE_NM');
//		//첨부파일 검색 선택시 정렬 제외한 조건 막기
//		
//		//의뢰일
//		$('#datepickStart').prop('disabled', true);   // 막기
//		$('#datepickEnd').prop('disabled', true);   // 막기
//		
//		//법률/계약전문관
//		$("#CNSTN_TKCG_EMP_NM").prop('disabled', true);   // 막기
//		
//		//위임/자문변호사
//		$("#JDAF_CORP_EMP_NMS").prop('disabled', true);   // 막기
//		
//		//의뢰부서
//		$("#CNSTN_RQST_DEPT_NM").prop('disabled', true);   // 막기
//		
//		//의뢰자
//		$("#CNSTN_RQST_EMP_NM").prop('disabled', true);   // 막기
//		
//		//관리번호
//		$("#CNSTN_DOC_NO").prop('disabled', true);   // 막기
//		
	}else{
		disableEntireGroup('FILE_SE_NM');
//		//의뢰일
//		$('#datepickStart').prop('disabled', false);   // 열기
//		$('#datepickEnd').prop('disabled', false);   // 열기
//		
//		//법률/계약전문관
//		$("#CNSTN_TKCG_EMP_NM").prop('disabled', false);   // 열기
//		
//		//위임/자문변호사
//		$("#JDAF_CORP_EMP_NMS").prop('disabled', false);   // 열기
//		
//		//의뢰부서
//		$("#CNSTN_RQST_DEPT_NM").prop('disabled', false);   // 열기
//		
//		//의뢰자
//		$("#CNSTN_RQST_EMP_NM").prop('disabled', false);   // 열기
//		
//		//관리번호
//		$("#CNSTN_DOC_NO").prop('disabled', false);   // 열기
//		
	}
}


/** 
 * name=group 인 체크박스 중
 * - value=='' (“전체”) 만 checked=true, disabled=false
 * - 나머지는 checked=false, disabled=true 
 */
function setOnlyAllChecked(group){
  $(`input[name="${group}"]`).each(function(){
    if (this.value === '') {
      $(this).prop({ checked: true,  disabled: false });
    } else {
      $(this).prop({ checked: false, disabled: true });
    }
  });
}

/** name=group 인 체크박스 전체를 checked=false, disabled=true */
function disableEntireGroup(group){
  $(`input[name="${group}"]`).prop({ checked: false, disabled: true });
}

/**
 * 검색버튼 클릭시 검색
 * pQuery : 키워드 검색 쿼리 
 * listSize : 화면에 표시해줄 건수(기본10건) 적용 
 * sort :정렬 기본 정확도순 
 *       expact : 정확도순, 
 *       keyword_field_title_asc : 제목정순, 
 *       keyword_field_title_desc : 제목역순, 
 *       keyword_field_reg_date_asc : 날짜정순,  
 *       keyword_field_reg_date_desc : 날짜역순,
 * pageNo : 페이징 처리가 없어 1페이지 고정
 * 
 * */
function searchSubmit(){
	//검색 입력창 
	let pQuery_tmp = $("#schTxt").val();
	
	param['pQuery_tmp']= pQuery_tmp;
	
	if(pQuery_tmp !== ""){
		
		//검색 정렬
		let sort = $("#sortSelect").val();
		//검색 페이지
		let pageNo = 1;
		let listSize =10;
		
		let schGbn =  $('input[name="schGbn"]:checked').val();
		
		//첨부파일 검색
		if(schGbn =="field_attach"){
			$("#indexKey").val(INDEX_FILE);
			 let index = $("#indexKey").val();
			 searchFile_ajax(index,pageNo,listSize,sort);
		}else{
			$("#indexKey").val(INDEX_DOC);
			 let index = $("#indexKey").val();
			 search_ajax(index,pageNo,listSize,sort);
		}
		
		
	}else{
		//alert("검색어를 입력하세요.");
		 Swal.fire({
         title: '검색어를 입력해주세요!',
         text: '검색창에 키워드를 입력한 후, 검색 버튼을 눌러주세요.',
         icon: 'warning',
         confirmButtonText: '확인',
         confirmButtonColor: '#3085d6', // 원하는 버튼 색상 코드로 변경
         width: '460px',      // 너무 크지 않은 크기로 설정
         scrollbarPadding: false,  // body padding-right 자동 조정을 비활성화
         //padding: '1em'
      allowEnterKey: true, // 기본값이 true이지만 명시적으로 설정
      didOpen: () => {
          //팝업이 열린 후, 엔터키가 눌리면 팝업을 닫는 이벤트 리스너 추가
          const handleEnterClose = (e) => {
            if (e.key === 'Enter') {
              e.preventDefault();
              Swal.close();
            }
          };
          // 팝업 영역에 이벤트 리스너 등록 (포커스가 다른 곳에 있더라도 캡처)
          document.addEventListener('keydown', handleEnterClose);

          // 팝업 종료 시 이벤트 리스너를 제거하도록 설정
          Swal._removeEnterListener = () => {
            document.removeEventListener('keydown', handleEnterClose);
          };
        },
        willClose: () => {
          // 팝업이 닫힐 때 등록했던 엔터키 이벤트 리스너 제거
          if (Swal._removeEnterListener) {
            Swal._removeEnterListener();
          }
        }
		 });
		
	}
}

/**
 * 검색데몬과 RestApi 통신하여 데이터 호출
 * 검색조건 (협약 검색)
 * */
function search_ajax(index,pageNo,listSize,sort){
	
	var pQuery_tmp = $("#schTxt").val();
	
	//검색 키워드 저장
	savedKeyword = pQuery_tmp;
	
	
	//관리번호
	let cvtn_doc_no = $("#CVTN_DOC_NO").val();
	
	//협약유형
	let cvtn_ctrt_type_cd_nm ="";
	$("input[name='CVTN_CTRT_TYPE_CD_NM']:checked").each(function () {
		cvtn_ctrt_type_cd_nm +=" " + $(this).val();
    });
	cvtn_ctrt_type_cd_nm = cvtn_ctrt_type_cd_nm.trim().replace(/\s+/g, " OR ");
	
	
	//협약구분
	let insd_otsd_task_se ="";
	$("input[name='INSD_OTSD_TASK_SE']:checked").each(function () {
		insd_otsd_task_se +=" " + $(this).val();
    });
	insd_otsd_task_se = insd_otsd_task_se.trim().replace(/\s+/g, " OR ");
	
	//구분
	let cvtn_gbn ="";
	$("input[name='CVTN_GBN']:checked").each(function () {
		cvtn_gbn +=" " + $(this).val();
    });
	cvtn_gbn = cvtn_gbn.trim().replace(/\s+/g, " OR ");
	
	//협약의뢰일
	let start_date = $("#CVTN_RQST_YMDStart").val();
	let end_date = $("#CVTN_RQST_YMDEnd").val();
	
	//협약체결예정일
	let start_date2 = $("#CVTN_CNCLS_PRNMNT_YMDStart").val();
	let end_date2 = $("#CVTN_CNCLS_PRNMNT_YMDEnd").val();
	
	
	//의뢰부서
	let cvtn_rqst_dept_nm = $("#CVTN_RQST_DEPT_NM").val();
	
	//의뢰직원
	let cvtn_rqst_emp_nm = $("#CVTN_RQST_EMP_NM").val();
	
	//법률/계약전문관
	let cvtn_tkcg_emp_nm = $("#CVTN_TKCG_EMP_NM").val();
	
	//위임/자문변호사
	let jdaf_corp_emp_nms = $("#JDAF_CORP_EMP_NMS").val();
	
	
	//검색 조건
	let field_rd = $('input[name="schGbn"]:checked').val();
	
	//결과내 검색
	let rs_check ="";
	if($('#reSearch').is(':checked')) {
		rs_check="Y";
	}	
	
	//이전 검색쿼리 
	const old_keyword = $("#old_keyword").val().trim();	
	
	//이전 검색키워드
	const old_pQuery_tmp = $("#old_pQuery_tmp").val().trim();	
	
	$("#agree_data_list").html("");
	
	$.ajax({
		contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		type : "POST",
		url : CONTEXTPATH+"/web/searchAPI.do",
		data : {
			index_key : index,
			pQuery_tmp : pQuery_tmp,
			query:pQuery_tmp,
			pageNo : pageNo,
			listSize : listSize,
			sort : sort,
			old_keyword:old_keyword,
			old_pQuery_tmp:old_pQuery_tmp,
			field_rd:field_rd,
			rs_check:rs_check,
			
			cvtn_doc_no : cvtn_doc_no,
			cvtn_ctrt_type_cd_nm : cvtn_ctrt_type_cd_nm,
			insd_otsd_task_se:insd_otsd_task_se,
			cvtn_gbn:cvtn_gbn,
			start_date : start_date,
			end_date : end_date,
			start_date2 : start_date2,
			end_date2 : end_date2,
			cvtn_rqst_dept_nm : cvtn_rqst_dept_nm,
			cvtn_rqst_emp_nm : cvtn_rqst_emp_nm,
			cvtn_tkcg_emp_nm : cvtn_tkcg_emp_nm,
			jdaf_corp_emp_nms : jdaf_corp_emp_nms
			
		},
		dataType : "json",
		cache : false,
		timeout : 5000,
		success : function(data) {

			if(data.count >0){
				
				//검색쿼리 저장
				$("#old_keyword").val(data.old_keyword);
				$("#old_pQuery_tmp").val(data.old_pQuery_tmp);
				
				$("#agreeSearchCnt").html("("+data.count.toLocaleString('ko-KR')+"건)");
				
				writeAgreeContent(data);
				 // 페이징 네비게이션 업데이트
	            renderPagination(data.count, pageNo);
			}else{
				
				$("#agreeSearchCnt").html("(0건)");
				$("#agree_data_list").html(noResultsContent());
				$("#pagelist").html("");
			}
			
			
			
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

/**
 * 검색데몬과 RestApi 통신하여 데이터 호출
 * 검색조건 (첨부파일 검색)
 * */
function searchFile_ajax(index,pageNo,listSize,sort){
	
	var pQuery_tmp = $("#schTxt").val();
	
	//검색 키워드 저장
	savedKeyword = pQuery_tmp;
	
	
	//관리번호
	let cvtn_doc_no = $("#CVTN_DOC_NO").val();
	
	//협약유형
	let cvtn_ctrt_type_cd_nm ="";
	$("input[name='CVTN_CTRT_TYPE_CD_NM']:checked").each(function () {
		cvtn_ctrt_type_cd_nm +=" " + $(this).val();
    });
	cvtn_ctrt_type_cd_nm = cvtn_ctrt_type_cd_nm.trim().replace(/\s+/g, " OR ");
	
	
	//협약구분
	let insd_otsd_task_se ="";
	$("input[name='INSD_OTSD_TASK_SE']:checked").each(function () {
		insd_otsd_task_se +=" " + $(this).val();
    });
	insd_otsd_task_se = insd_otsd_task_se.trim().replace(/\s+/g, " OR ");
	
	//구분
	let cvtn_gbn ="";
	$("input[name='CVTN_GBN']:checked").each(function () {
		cvtn_gbn +=" " + $(this).val();
    });
	cvtn_gbn = cvtn_gbn.trim().replace(/\s+/g, " OR ");
	
	//협약의뢰일
	let start_date = $("#CVTN_RQST_YMDStart").val();
	let end_date = $("#CVTN_RQST_YMDEnd").val();
	
	//협약체결예정일
	let start_date2 = $("#CVTN_CNCLS_PRNMNT_YMDStart").val();
	let end_date2 = $("#CVTN_CNCLS_PRNMNT_YMDEnd").val();
	
	
	//의뢰부서
	let cvtn_rqst_dept_nm = $("#CVTN_RQST_DEPT_NM").val();
	
	//의뢰직원
	let cvtn_rqst_emp_nm = $("#CVTN_RQST_EMP_NM").val();
	
	//법률/계약전문관
	let cvtn_tkcg_emp_nm = $("#CVTN_TKCG_EMP_NM").val();
	
	//위임/자문변호사
	let jdaf_corp_emp_nms = $("#JDAF_CORP_EMP_NMS").val();
	
	
	//첨부파일
	let file_se_nm ="";
	$("input[name='FILE_SE_NM']:checked").each(function () {
		file_se_nm +=" " + $(this).val();
    });
	file_se_nm = file_se_nm.trim().replace(/\s+/g, " OR ");
	
	//결과내 검색
	let rs_check ="";
	if($('#reSearch').is(':checked')) {
		rs_check="Y";
	}	
	
	//이전 검색쿼리 
	const old_keyword = $("#old_keyword").val().trim();	
	
	//이전 검색키워드
	const old_pQuery_tmp = $("#old_pQuery_tmp").val().trim();	
	
	
	
	$("#agree_data_list").html("");
	
	$.ajax({
		contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		type : "POST",
		url : CONTEXTPATH+"/web/searchAPI.do",
		data : {
			index_key : index,
			pQuery_tmp : pQuery_tmp,
			query:pQuery_tmp,
			pageNo : pageNo,
			listSize : listSize,
			sort : sort,
			old_keyword:old_keyword,
			old_pQuery_tmp:old_pQuery_tmp,
			rs_check:rs_check,
			
			file_se_nm:file_se_nm,
			cvtn_doc_no : cvtn_doc_no,
			cvtn_ctrt_type_cd_nm : cvtn_ctrt_type_cd_nm,
			insd_otsd_task_se:insd_otsd_task_se,
			cvtn_gbn:cvtn_gbn,
			start_date : start_date,
			end_date : end_date,
			start_date2 : start_date2,
			end_date2 : end_date2,
			cvtn_rqst_dept_nm : cvtn_rqst_dept_nm,
			cvtn_rqst_emp_nm : cvtn_rqst_emp_nm,
			cvtn_tkcg_emp_nm : cvtn_tkcg_emp_nm,
			jdaf_corp_emp_nms : jdaf_corp_emp_nms
			
		},
		dataType : "json",
		cache : false,
		timeout : 5000,
		success : function(data) {

			if(data.count >0){
				
				//검색쿼리 저장
				$("#old_keyword").val(data.old_keyword);
				$("#old_pQuery_tmp").val(data.old_pQuery_tmp);
				
				$("#agreeSearchCnt").html("("+data.count.toLocaleString('ko-KR')+"건)");
				
				writeAgreeFileContent(data);
				 // 페이징 네비게이션 업데이트
	            renderPagination(data.count, pageNo);
			}else{
				
				$("#agreeSearchCnt").html("(0건)");
				
				$("#agree_data_list").html(noResultsContent());
				$("#pagelist").html("");
			}
			
			
			
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

/**
 * 협약 카테고리 검색결과 반복 부분
 * */
function writeAgreeContent(data){
	let result_list =""; 
	
	for (var i = 0; i < data.list.length; i++) {
		const item = data.list[i];

	    const docNo         = item.stored_cvtn_doc_no     || "";			/*협약문서번호*/
	    const title         = item.stored_field_title     || "";					/*협약제목*/
	    const regDate       = item.stored_field_reg_date  || "";			/*협약의뢰일자*/
	    const deptName      = item.stored_cvtn_rqst_dept_nm || "";	/*의뢰부서명*/
	    const empName       = item.stored_cvtn_rqst_emp_nm  || "";	/*의뢰직원명*/
	    const contents      = item.stored_field_contents  || "";			/*내용*/
	    const cvtnMngNo     = item.stored_cvtn_mng_no     || "";   /*협약PK*/
	    const cvtnGbn       = item.stored_cvtn_gbn     || "";   /*협약 구분*/
	    const attachListRaw = item.stored_attach_list || "";		/*첨부파일 리스트*/
		const attachEntries = attachListRaw.split("###").filter(e => e.trim() !== "");

	    
		result_list += `<a href="javascript:searchPageOpen('${cvtnMngNo}','${cvtnMngNo}','AGREE')">`;
	    result_list += `<h3 class="subSSTitle">(${cvtnGbn}) ${docNo} ${title} ${regDate} ${deptName} ${empName}</h3>`;
	    result_list += `</a>`;
	    result_list += `<div class="textBox">`;
	    result_list += `<p>${contents}</p>`;
		
		///////////////// 첨부파일 리스트 //////////////
		result_list +=`<ul class="preViewList">`;
		
		for (let j = 0; j < attachEntries.length; j++) {
			const parts = attachEntries[j].split("@@@");
			const fileKey = parts[0];		/*첨부파일PK*/
			const fileNm = parts[1];		/*첨부파일제목*/
			const fileExt = parts[2];		/*첨부파일확장자*/
			const fileSize = parts[3];		/*첨부파일사이즈*/
			const srvrFileNm = parts[4];  /*서버 파일명*/
			const folders = parts[5];  /*구분*/
			
			result_list += `<li>`;
			result_list += `<a href="javascript:downFile('${fileNm}', '${srvrFileNm}', '${folders}')"> `;
			result_list += `<span class="iconStyle ${fileExt}"></span>&nbsp; ${fileNm} </a>`;
			result_list += `<a href="javascript:fileOpen('${INDEX_FILE}','${fileKey}')" class="btnInTable" id="btnInTable_${fileKey}">첨부문서 확인</a>`;
			result_list += `<div class="preViewOpen" id="preViewOpen_${fileKey}" style="display: none;"></div>`;
			result_list += `</li>`;
		}
		result_list +=`</ul>`;
		
////////////////////////////////////////
		result_list +=`</div>`;
		
		// 마지막 항목이 아닌 경우에만 hr 추가
	    if (i < data.list.length - 1) {
	        result_list += `<hr class="margin20">`;
	    }
	}
	
	$("#agree_data_list").html(result_list);
}

/**
 * 협약 카테고리(첨부파일) 검색결과 반복 부분
 * */
function writeAgreeFileContent(data){
	let result_list =""; 
	
	for (var i = 0; i < data.list.length; i++) {
		const item = data.list[i];

		const docNo      = item.stored_cvtn_doc_no     || "";			/*협약문서번호*/
	    const title      = item.stored_field_title     || "";					/*첨부파일제목*/
	    const cvtn_ttl   = item.stored_cvtn_ttl     || "";			/*협약제목*/
	    const regDate    = item.stored_field_reg_date  || "";			/*협약의뢰일자*/
	    const deptName   = item.stored_cvtn_rqst_dept_nm || "";	/*의뢰부서명*/
	    const empName    = item.stored_cvtn_rqst_emp_nm  || "";	/*의뢰직원명*/
	    const contents   = item.stored_field_contents  || "";			/*첨부파일 내용*/
	    const srvrFileNm = item.stored_srvr_file_nm || "";    /*서버파일명*/
	    const folders    = item.stored_folders || "";    /*구분*/
	    const fileExt    = item.stored_ext || "";				/*첨부파일 확장자*/
	    const cvtnMngNo  = item.stored_cvtn_mng_no     || "";   /*협약PK*/
	    const cvtnGbn       = item.stored_cvtn_gbn     || "";   /*협약 구분*/
	    const fileNm = item.stored_phys_file_nm;
	    
	    result_list += `<a href="#none">`;
	    result_list += `<h3 class="subSSTitle" onclick="javascript:downFile('${fileNm}', '${srvrFileNm}', '${folders}')">`;
	    result_list += `<span class="iconStyle ${fileExt}"></span>&nbsp; ${title}</h3>`;
	    result_list += `<p class="fileSubTitle" onclick="javascript:searchPageOpen('${cvtnMngNo}','${cvtnMngNo}','AGREE')">(${cvtnGbn}) ${docNo} ${cvtn_ttl} ${regDate} ${deptName} ${empName}</p>`;
	    result_list += `</a>`;
	    result_list += `<div class="textBox">`;
	    result_list += `<p>${contents}</p>`;
////////////////////////////////////////
		result_list +=`</div>`;
		
		// 마지막 항목이 아닌 경우에만 hr 추가
	    if (i < data.list.length - 1) {
	        result_list += `<hr class="margin20">`;
	    }
	}
	
	$("#agree_data_list").html(result_list);
}


/**
 * 결과내 검색 클릭시 동작 
*/
function changeRsCheck() {
	let rsCheck = $('#reSearch').is(':checked');
	
	if(rsCheck){
		//검색 입력창 공백
		$("#schTxt").val('');
		$("#schTxt").focus();
	}else{
		//검색 입력창 기존 검색 키워드 입력
		$("#schTxt").val(savedKeyword);
	}
}
