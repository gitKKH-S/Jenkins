
// 페이지 이동 [1] [2] ... 하는 HTML 코드를 생성해서 돌려준다.
//	funcName : 실제 페이지 이동을 위한 함수이름 (예: gotoPage)
//	pageNum : 현재 페이지 번호
//	pageSize : 한 페이지당 결과 갯수
//	total : 전체 결과 갯수
function pageNav( funcName, pageNum, pageSize, total )
{
	if( total < 1 )
		return "";

	var ret = "";
	var PAGEBLOCK=10;
	var totalPages = Math.floor((total-1)/pageSize) + 1;

	var firstPage = Math.floor((pageNum-1)/PAGEBLOCK) * PAGEBLOCK + 1;
	if( firstPage <= 0 ) // ?
		firstPage = 1;

	var lastPage = firstPage-1 + PAGEBLOCK;
	if( lastPage > totalPages )
		lastPage = totalPages;

	if( firstPage > PAGEBLOCK )
	{
//		ret += navAnchor(funcName, 1, "<img src='"+rootPath+"/jsp/lkms3/images/icon/first.gif' alt='처음'  align='absmiddle'  border=0>") + "\n";
//		ret += navAnchor(funcName, (firstPage-1), "<img src='"+rootPath+"/jsp/lkms3/images/icon/before.gif' alt='이전페이지' align='absmiddle'  border=0>") + "\n";
		ret += navAnchor(funcName, (firstPage-1), "◀ ") + "\n";
	}

	for( i=firstPage; i<=lastPage; i++ )
	{
		if( pageNum == i ){
			if( i != lastPage ) ret += "<a class='innerBtn active'><span  id='local_point' class='local_point'>" + i + "</span></a>&nbsp;\n";
			else ret += "<a class='innerBtn active'><span  id='local_point' class='local_point'>" + i + "</span></a>&nbsp;\n";
		}
		else if( i == lastPage )
			ret += navAnchor(funcName, i, "" + i + "</a>") + "&nbsp;\n";
		else
		  ret += navAnchor(funcName, i, "" + i + "") + "&nbsp;\n";
	}

	if( lastPage < totalPages )
	{
//		ret += navAnchor(funcName, (lastPage+1), "<img src='"+rootPath+"/jsp/lkms3/images/icon/next.gif' alt='다음페이지' align='absmiddle'  border=0>") + "\n";
//		ret += navAnchor(funcName, totalPages, "<img src='"+rootPath+"/jsp/lkms3/images/icon/last.gif' alt='마지막'  align='absmiddle'  border=0>") + "\n";
		ret += navAnchor(funcName, (lastPage+1), " ▶") + "\n";
	}

	return ret;
}

function navAnchor( funcName, pageNo, anchorText )
{
	return "<a href='javascript:" + funcName + "(" + pageNo + ")' class='innerBtn'>" + anchorText + "</a>";
}
function gotoPage( num ) {
	var f = document.lawSch;
	if (f==null) f = document.forms["goList"];
	if(f.startCount != null){
		f.startCount.value = num;
	}else{
		f.pageno.value = num;
	}
	f.submit();
}


