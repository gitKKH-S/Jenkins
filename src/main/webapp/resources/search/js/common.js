/**
 * 소송, 자문, 협약, 자료실 정렬 공통 사용
 * */
var mkSortSelectBox = function() {
	var obj = $(".sortSelect")[0]
	$(obj).append("<option value=\"expact\">정확도순</option>");
	$(obj).append("<option value=\"keyword_field_reg_date_asc\">날짜순</option>");
	$(obj).append("<option value=\"keyword_field_reg_date_desc\">날짜역순</option>");
	$(obj).append("<option value=\"keyword_field_title_asc\">제목순</option>");
	$(obj).append("<option value=\"keyword_field_title_desc\">제목역순</option>");
}



/**
 * 페이지 네비게이션 렌더링 (그룹별 이동, 10페이지씩)
 * 디자인: 
 * <div class="numberingW" id="pagelist">
 *   <ul>
 *     <li><a href="javascript:goPage('1')">《</a></li>
 *     … 페이지 번호 …
 *     <li><a href="javascript:goPage('51')">》</a></li>
 *   </ul>
 * </div>
 *
 * @param {number} totalCount - 전체 검색 건수
 * @param {number} pageNum    - 현재 페이지 번호
 */
function renderPagination(totalCount, pageNum) {
    const listSize = 10;                   // 한 페이지에 보여줄 항목 수
    const itemsPerPage = listSize;
    const totalPages = Math.ceil(totalCount / itemsPerPage);

    // 페이지 그룹 단위 (10개씩)
    const maxVisiblePages = 10;
    const currentGroup  = Math.floor((pageNum - 1) / maxVisiblePages);
    const startPage     = currentGroup * maxVisiblePages + 1;
    const endPage       = Math.min(startPage + maxVisiblePages - 1, totalPages);

    // 컨테이너 초기화
    const paginationDiv = document.getElementById('pagelist');
    paginationDiv.innerHTML = '';
    const ul = document.createElement('ul');

    // « 맨 처음
    ul.appendChild(createLiLink('《', 1));

    // ‹ 이전 그룹
    const prevTarget = startPage > 1 ? startPage - 1 : 1;
    ul.appendChild(createLiLink('〈', prevTarget, startPage === 1));

    // 페이지 번호
    for (let i = startPage; i <= endPage; i++) {
        const isActive = (i === pageNum);
        const hrefFn   = isActive ? 'javascript:;' : `javascript:goPage(${i})`;
        const li = document.createElement('li');
        if (isActive) li.classList.add('active');

        const a  = document.createElement('a');
        a.setAttribute('href', hrefFn);
        a.textContent = i;
        li.appendChild(a);
        ul.appendChild(li);
    }

    // › 다음 그룹
    const nextTarget = endPage < totalPages ? endPage + 1 : totalPages;
    ul.appendChild(createLiLink('〉', nextTarget, endPage === totalPages));

    // » 맨 마지막
    ul.appendChild(createLiLink('》', totalPages));

    paginationDiv.appendChild(ul);
}

/**
 * 편의 함수: <li><a href="javascript:goPage('n')">label</a></li>
 * disabled일 땐 클래스 'disabled' 추가
 */
function createLiLink(label, page, disabled = false) {
    const li = document.createElement('li');
    if (disabled) li.classList.add('disabled');

    const a = document.createElement('a');
    a.setAttribute('href', `javascript:goPage('${page}')`);
    a.textContent = label;

    // disabled 상태면 클릭 무효화
    if (disabled) {
        a.onclick = e => e.preventDefault();
    }

    li.appendChild(a);
    return li;
}

// 예시: 페이지를 실제로 로드하는 함수
function goPage(pageNo) {
    const listSize = 10;
    const sort     = $("#sortSelect").val();
    const index    = $("#indexKey").val();
    search_ajax(index, pageNo, listSize, sort);
}


/**
 * 검색결과 없음 표시
 * */
const noResultsContent= function(){
	let result_list =""; 
	
	result_list += `<div class="ts_lt2"  style="text-align: center;">`;
	result_list += `<div style="margin: 20px 0 20px 0;">`;
	result_list += `	<i data-feather="alert-circle" class="alert_icon"></i>`;
	result_list += `	<p style=" font-size: 20px; font-weight: 600; margin-bottom: 20px;"><span style=" color: #f62812; background-color: #fdf9be;"  id="noResultsKeyword"></span> 검색결과가 없습니다.</p>`;
	result_list += `	<p style="line-height: 180%;">단어의 철자가 정확한지 확인해 보세요.</p>`;
	result_list += `	<p style="line-height: 180%;">두 단어 이상의 검색어인 경우, 띄어쓰기를 확인해 보세요.</p>`;
	result_list += `	<p style="line-height: 180%;">검색어의 단어 수를 줄이거나, 보다 일반적인 검색어로 다시 검색해 보세요.</p>`;
	result_list += `</div>`;
	result_list += `</div>`;
	
	return result_list;
}


/**
 * 첨부파일 내용 불러오기
 * */
var fileContentOpen = function(index,file_id){
	
	var pQuery_tmp = $("#schTxt").val();
	
	$.ajax({
		contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		type : "POST",
		url : CONTEXTPATH+"/web/searchAPI.do",
		data : {
			index_key : index,
			file_mng_no : file_id,
			pQuery_tmp : pQuery_tmp,
			query : ""
		},
		dataType : "json",
		cache: false,
		timeout : 5000,
		success : function(data) {	
			if(data.list!== null && data.list !== undefined){
				$("#preViewOpen_"+file_id).html(data.list[0].stored_field_contents);
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

/**
 * 파일 미리보기
 * */
var fileOpen = function(index, id) {
	if (!$("#preViewOpen_" + id).is(":visible")) {
		$("#preViewOpen_" + id).show();
		$("#btnInTable_" + id).html("첨부문서 닫기");
		$("#btnInTable_" + id).val("N");
		fileContentOpen(index,id);
	} else {
		$("#preViewOpen_" + id).hide();
		$("#btnInTable_" + id).html("첨부문서 확인");
		$("#btnInTable_" + id).val("Y");
	}
}



