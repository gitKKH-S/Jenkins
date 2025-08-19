$(document).ready(function() {
	
	searchSubmit();
	
});

function searchSubmit(){
	
	let sort ="expact";
	let pQuery_tmp = $("#pQuery_tmp").val();
	
	param['pQuery_tmp']= $("#pQuery_tmp").val();
	console.log("??");
	console.log(pQuery_tmp);
	search_ajax(sort,pQuery_tmp);
}

/**
 * 검색데몬과 RestApi 통신하여 데이터 호출
 * */
function search_ajax(sort,pQuery_tmp){
	
	let url = CONTEXTPATH+"/web/searchAPI.do";
	
	/**
	 * 검색카테고리 통합검색용
	 * */
	$.when(
	        $.ajax({
	        	contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				type : "POST",
				url : url,
				data : {
					index_key : "suit",
					pQuery_tmp : pQuery_tmp,
					query:pQuery_tmp,
					pageNo : "1",
					listSize : "3",
					sort : sort
				},
				dataType : "json",
				cache: false,
	        }),
	        $.ajax({
	        	contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				type : "POST",
				url : url,
				data : {
					index_key : "consult",
					pQuery_tmp : pQuery_tmp,
					query:pQuery_tmp,
					pageNo : "1",
					listSize : "3",
					sort : sort
				},
				dataType : "json",
				cache: false,
	        }),
	        $.ajax({
	        	contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				type : "POST",
				url : url,
				data : {
					index_key : "agree",
					pQuery_tmp : pQuery_tmp,
					query:pQuery_tmp,
					pageNo : "1",
					listSize : "3",
					sort : sort
				},
				dataType : "json",
				cache: false,
	        }),
	        $.ajax({
	        	contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				type : "POST",
				url : url,
				data : {
					index_key : "pds",
					pQuery_tmp : pQuery_tmp,
					query:pQuery_tmp,
					pageNo : "1",
					listSize : "3",
					sort : sort
				},
				dataType : "json",
				cache: false,
	        })
	    ).done(function(suitData, consultData, agreeData, pdsData) {
	    	
	    	let totalCnt =0;
	        if(suitData[0].count > 0){
	        	totalCnt = totalCnt+ suitData[0].count;
	        }
	        
	        if(consultData[0].count > 0){
	        	totalCnt = totalCnt + consultData[0].count;
	        }
	        
	        if(agreeData[0].count > 0){
	        	totalCnt = totalCnt + agreeData[0].count;
	        }
	        
	        if(pdsData[0].count > 0){
	        	totalCnt = totalCnt + pdsData[0].count;
	        }
	        
	        if(totalCnt >0){
	        	writeContent_all(suitData, consultData, agreeData, pdsData);
	        }else{
	        	$("#searchResults").html(noResultsContent());
	        }
	    	
	    	
	    	
	    	
	    	
	    }).fail(function(xhr, status, error) {
	        console.error("AJAX 요청 중 오류 발생:", status, error);
	    });
}


/**
 * 통합검색 카테고리 그리기
 * */
function writeContent_all(suitData, consultData, agreeData, pdsData){
	
	let result_list = ``;
	/**
	 * 소송 카테고리
	 * */
	if(!suitData[0].error && suitData[0].count > 0){
		
		let suitSearchCnt =suitData[0].count.toLocaleString('ko-KR');
		
		result_list +=`<div class="subTTW">`;
		result_list +=`<div class="subTTC left"><strong class="subTT">소송&nbsp;<span>(${suitSearchCnt}건)</span></strong></div>`;
		result_list +=`<div class="subTTC right">`;
		result_list +=`	<a href="#" class="innerBtn" onclick="sendPost('./suitSearch.do')">더보기</a>`;
		result_list +=`</div>`;
		result_list +=`</div>`;
		result_list +=`<div class="innerB">`;
		result_list +=`	<div class="srchResultW">`;
		result_list += 		writeSuitContent(suitData[0]);
		result_list +=`	</div>`;
		result_list +=`</div>`;
		result_list +=`<hr class="margin30">`;
		
	}
	
	/**
	 * 자문 카테고리
	 * */
	if(!consultData[0].error && consultData[0].count > 0){
		let consultSearchCnt = consultData[0].count.toLocaleString('ko-KR');
		
		result_list +=`<div class="subTTW">`;
		result_list +=`<div class="subTTC left"><strong class="subTT">자문&nbsp;<span>(${consultSearchCnt}건)</span></strong></div>`;
		result_list +=`<div class="subTTC right">`;
		result_list +=`	<a href="#" class="innerBtn" onclick="sendPost('./consultSearch.do')">더보기</a>`;
		result_list +=`</div>`;
		result_list +=`</div>`;
		result_list +=`<div class="innerB">`;
		result_list +=`	<div class="srchResultW">`;
		result_list += 		writeConsultContent(consultData[0]);
		result_list +=`	</div>`;
		result_list +=`</div>`;
		result_list +=`<hr class="margin30">`;
		
	}
	
	/**
	 * 협약 카테고리
	 * */
	if(!agreeData[0].error && agreeData[0].count > 0){
		
		let agreeSearchCnt = agreeData[0].count.toLocaleString('ko-KR');
		
		result_list +=`<div class="subTTW">`;
		result_list +=`<div class="subTTC left"><strong class="subTT">협약&nbsp;<span>(${agreeSearchCnt}건)</span></strong></div>`;
		result_list +=`<div class="subTTC right">`;
		result_list +=`	<a href="#" class="innerBtn" onclick="sendPost('./agreeSearch.do')">더보기</a>`;
		result_list +=`</div>`;
		result_list +=`</div>`;
		result_list +=`<div class="innerB">`;
		result_list +=`	<div class="srchResultW">`;
		result_list += 		writeAgreeContent(agreeData[0]);
		result_list +=`	</div>`;
		result_list +=`</div>`;
		result_list +=`<hr class="margin30">`;
		
	}
	
	/**
	 * 자료실 카테고리
	 * */
	if(!pdsData[0].error && pdsData[0].count > 0){
		
		let pdsSearchCnt = pdsData[0].count.toLocaleString('ko-KR');
		
		result_list +=`<div class="subTTW">`;
		result_list +=`<div class="subTTC left"><strong class="subTT">자료실&nbsp;<span>(${pdsSearchCnt}건)</span></strong></div>`;
		result_list +=`<div class="subTTC right">`;
		result_list +=`	<a href="#" class="innerBtn" onclick="sendPost('./pdsSearch.do')">더보기</a>`;
		result_list +=`</div>`;
		result_list +=`</div>`;
		result_list +=`<div class="innerB">`;
		result_list +=`	<div class="srchResultW">`;
		result_list += 		writePdsContent(pdsData[0]);
		result_list +=`	</div>`;
		result_list +=`</div>`;
		result_list +=`<hr class="margin30">`;
		
	}
	
	
	$("#searchResults").html(result_list);
}



/**
 * 소송 카테고리 검색결과 반복 부분
 * */
const writeSuitContent= function(data){
	let result_list =""; 

	for (var i = 0; i <data.list.length; i++) {
		
		const item = data.list[i];

	    const lwsNo     = item.stored_lws_no     || "";			/*소송문서번호*/
	    const incdntNo    = item.stored_incdnt_no     || "";		/*사건번호*/
	    const title  = item.stored_field_title  || "";					/*사건명*/
	    const regDate  = item.stored_field_reg_date || "";		/*소제기일*/
	    const contents  = item.stored_field_contents  || "";		/*내용*/
	    const lwsMngNo     = item.stored_lws_mng_no     || "";   /*소송PK*/
	    const instMngNo     = item.stored_inst_mng_no     || "";   /*심급PK*/
	    const attachListRaw = item.stored_attach_list || "";	/*첨부파일 리스트*/
		const attachEntries = attachListRaw.split("###").filter(e => e.trim() !== "");
	    
		
		result_list += `<a href="javascript:searchPageOpen('${lwsMngNo}','${instMngNo}','SUIT')">`;
	    result_list += `<h3 class="subSSTitle">${lwsNo} ${incdntNo} ${title} ${regDate}</h3>`;
	    result_list += `</a>`;
	    result_list += `<div class="textBox">`;
	    result_list += `<p>${contents}</p>`;
		
///////////////// 첨부파일 리스트 //////////////
		result_list +=`<ul class="preViewList">`;
		
		for (let j = 0; j < attachEntries.length; j++) {
			const parts = attachEntries[j].split("@@@");
			const fileKey = parts[0];			/*첨부파일PK*/
			const fileNm = parts[1];			/*첨부파일 제목*/
			const fileExt = parts[2];			/*첨부파일 확장자*/
			const fileSize = parts[3];			/*첨부파일사이즈*/
			const srvrFileNm = parts[4];  /*서버 파일명*/
			const folders = parts[5];  /*구분*/
			
			
			result_list += `<li>`;
			result_list += `<a href="javascript:downFile('${fileNm}', '${srvrFileNm}', '${folders}')"> `;
			result_list += `<span class="iconStyle ${fileExt}"></span>&nbsp; ${fileNm} </a>`;
			result_list += `<a href="javascript:fileOpen('suitfile','${fileKey}')" class="btnInTable" id="btnInTable_${fileKey}">첨부문서 확인</a>`;
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
	
	return result_list;
}

/**
 * 자문 카테고리 검색결과 반복 부분
 * */
const writeConsultContent= function(data){
	let result_list =""; 
	
	for (var i = 0; i <data.list.length; i++) {
		const item = data.list[i];

	    const docNo     = item.stored_cnstn_doc_no     || "";			/*자문문서번호*/
	    const title     = item.stored_field_title     || "";					/*자문제목*/
	    const regDate   = item.stored_field_reg_date  || "";			/*자문의뢰일자*/
	    const deptName  = item.stored_cnstn_rqst_dept_nm || "";	/*의뢰부서명*/
	    const empName   = item.stored_cnstn_rqst_emp_nm  || "";	/*의뢰직원명*/
	    const contents  = item.stored_field_contents  || "";			/*내용*/
	    const cnstnMngNo     = item.stored_cnstn_mng_no     || ""; /*자문PK*/
	    const cnstnGbn     = item.stored_cnstn_gbn     || "";   /*자문 구분*/
	    const attachListRaw = item.stored_attach_list || "";		/*첨부파일 리스트*/
		const attachEntries = attachListRaw.split("###").filter(e => e.trim() !== "");
		
		result_list += `<a href="javascript:searchPageOpen('${cnstnMngNo}','${cnstnMngNo}','CONSULT')">`;
		result_list += `<h3 class="subSSTitle">(${cnstnGbn}) ${docNo} ${title} ${regDate} ${deptName} ${empName}</h3>`;
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
			result_list += `<a href="javascript:fileOpen('consultfile','${fileKey}')" class="btnInTable" id="btnInTable_${fileKey}">첨부문서 확인</a>`;
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
	
	return result_list;
}

/**
 * 협약 카테고리 검색결과 반복 부분
 * */
const writeAgreeContent= function(data){
	let result_list =""; 
	
	for (var i = 0; i <data.list.length; i++) {
		const item = data.list[i];

	    const docNo         = item.stored_cvtn_doc_no     || "";			/*협약문서번호*/
	    const title         = item.stored_field_title     || "";					/*협약제목*/
	    const regDate       = item.stored_field_reg_date  || "";			/*협약의뢰일자*/
	    const deptName      = item.stored_cvtn_rqst_dept_nm || "";	/*의뢰부서명*/
	    const empName       = item.stored_cvtn_rqst_emp_nm  || "";	/*의뢰직원명*/
	    const contents      = item.stored_field_contents  || "";			/*내용*/
	    const cvtnGbn       = item.stored_cvtn_gbn     || "";   /*자문 구분*/
	    const cvtnMngNo     = item.stored_cvtn_mng_no     || "";   /*협약PK*/
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
			result_list += `<a href="javascript:fileOpen('agreefile','${fileKey}')" class="btnInTable" id="btnInTable_${fileKey}">첨부문서 확인</a>`;
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
	
	return result_list;
}

/**
 * 자료실 카테고리 검색결과 반복 부분
 * */
const writePdsContent= function(data){
	let result_list =""; 
	
	for (var i = 0; i <data.list.length; i++) {
		
		const item = data.list[i];

		const bbsid  = item.stored_bbsid  || "";					/*게시물PK*/
	    const title  = item.stored_field_title  || "";					/*사건명*/
	    const regDate  = item.stored_field_reg_date || "";		/*소제기일*/
	    const contents  = item.stored_field_contents  || "";	/*내용*/

	    const attachListRaw = item.stored_attach_list || "";	/*첨부파일 리스트*/
		const attachEntries = attachListRaw.split("###").filter(e => e.trim() !== "");
	    
	    result_list += `<a href="javascript:searchPageOpen('${bbsid}','${bbsid}','PDS')">`;
	    result_list += `<h3 class="subSSTitle">${title} ${regDate}</h3>`;
	    result_list += `</a>`;
	    result_list += `<div class="textBox">`;
	    result_list += `<p>${contents}</p>`;
		
///////////////// 첨부파일 리스트 //////////////
		result_list +=`<ul class="preViewList">`;
		
		for (let j = 0; j < attachEntries.length; j++) {
			const parts = attachEntries[j].split("@@@");
			const fileKey = parts[0];			/*첨부파일PK*/
			const fileNm = parts[1];			/*첨부파일 제목*/
			const fileExt = parts[2];			/*첨부파일 확장자*/
			//const fileSize = parts[3];			/*첨부파일사이즈*/
			const srvrFileNm = parts[4];		/*서버 파일명*/
			const folders = parts[5];		/*구분*/
			
			result_list += `<li>`;
			result_list += `<a href="javascript:downFile('${fileNm}', '${srvrFileNm}', '${folders}')"> `;
			result_list += `<span class="iconStyle ${fileExt}"></span>&nbsp; ${fileNm} </a>`;
			result_list += `<a href="javascript:fileOpen('pdsfile','${fileKey}')" class="btnInTable" id="btnInTable_${fileKey}">첨부문서 확인</a>`;
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
	
	return result_list;
}