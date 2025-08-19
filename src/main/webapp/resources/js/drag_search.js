/* 
//====================================
// Nate Drag Search ver 1.0
// Last Mod Date : 2009.09.24
//====================================
*/

classLsTrmDragSrch = function() {

	var drag_spanName = "dragsearch";
	var dragsearch_btn = "dragsearch_btn";

	var selection_ori, selection, selection_pre, selection_tag;
	var arrPosition, drag_button_field, DragChkO, drag_position, drag_field;

	function removeChild(s) {
		s = document.getElementById(s);
		s.parentNode.removeChild(s);
		return s;
	}	

	function Drag_initialization() { 
		try{
			selection = '';
			selection_ori, drag_position, drag_field = null;
			if (document.getElementById(drag_spanName)) 
				removeChild(drag_spanName);
			if (document.getElementById(dragsearch_btn)) 
				document.getElementById(dragsearch_btn).style.display = "none";
			if (document.getElementById(dragsearch_btn)) 
				removeChild(dragsearch_btn);
		} catch(e) {}
	}

	function setLink() {	
		// Search	
	//	var search_url = "/LSW/lsTrmSrchR.do?query="+ encodeURIComponent(selection);
		var new_search = newLsTrmPopDrag(selection);
		if (new_search) 
			new_search.focus();
	
		Drag_initialization();
	/*
		if(window.event.preventDefault) {
			window.event.preventDefault(); 
			window.event.stopPropagation(); 
		} else {
			window.event.returnValue = false; 
			window.event.cancelBubble = true;
		}*/
	}

	function getSelectedText() {
			// Get Text
		if(window.getSelection) {
			selection_ori = window.getSelection();
			selection = window.getSelection().toString();
			selection_tag = selection;
		} else if(document.getSelection) {
			selection_ori = document.getSelection();
			selection = selection_ori;
			selection_tag = selection;
		} else if(document.selection) {
			selection_ori = document.selection.createRange();
			selection = selection_ori.text.toString();
			selection_tag = selection_ori.htmlText;
		}
		selection = selection.replace(/(^\s*)|(\s*$)/g, "");
		selection = selection.replace(/[\r|\n]/g, "");
	}

	function Character_byte(chr){
		if(escape(chr).length > 4)
			return 2;
		else
			return 1;
	}

	function ByteChk(str, limit) {
		var byte_count = 0;
		var len = str.length;
	
		for(i=0; i<len; i++){
			byte_count += Character_byte(str.charAt(i)); 
		}
		if(byte_count > limit) {
			return false;
		} else {
			return true;
		}
	}

	function pageX(elem) {
		var p = 0;
		while (elem.offsetParent) {
			p += elem.offsetLeft;
			elem = elem.offsetParent;
		}
		return p;
	}
	
	function pageY(elem) {
		var p = 0;
		while (elem.offsetParent) {
			p += elem.offsetTop;
			elem = elem.offsetParent;
		}
		return p;
	}

	function parentChkX(elem) {
		var diff = pageX(elem.parentNode) - pageX(elem);

		if (diff > 0 ) return pageX(elem.parentNode) + diff;
		else return pageX(elem);
	}

	function parentChkY(elem) {
		var diff = elem.parentNode.offsetTop - elem.offsetTop;
		
		if (diff > 0 ) return pageY(elem.parentNode);
		else return pageY(elem);
	}

	function parentX(elem) {
		return elem.parentNode == elem.offsetParent ? 
			pageX(elem) :
			parentChkX(elem);
	}

	function parentY(elem) {
		return elem.parentNode == elem.offsetParent ?
			pageY(elem) :
			parentChkY(elem);
	}

	function Dragsearch(event) {
		try {
		selection_pre = selection;
		if (drag_button_field || drag_position) Drag_initialization();
		
		// Get Text
		getSelectedText();


		if ((selection != "") && (selection.length > 1) && (selection != selection_pre)) {	
			bool_drag = true;
            var strlength = selection_tag.length;

			// ±æÀÌ 20byte(10À½Àý) Á¦ÇÑ
			bool_drag = ByteChk(selection, 20);
			bool_drag = true; // 드레그 한 char 갯수에 상관없이 무조건 검색할 수 있도록 함 
			if (bool_drag) {			
				if (navigator.appName == "Microsoft Internet Explorer") {
					strNode = window.event.srcElement.nodeName;
				} else if (navigator.appName == "Netscape") {
					strNode = event.target.nodeName;
				} else {
					strNode = window.event.srcElement.nodeName;
				}

				if(strNode=="INPUT"||strNode=="SELECT"||strNode=="TEXTAREA"||strNode=="FIELDSET")
					bool_drag = false;
                if((navigator.userAgent.indexOf("MSIE")!=-1)&&(bool_drag)){
                    if (strlength > 4) {
						var strtagcheck = selection_tag .substring ( strlength - 4, strlength);
						strtagcheck = strtagcheck.replace(/(^\s*)|(\s*$)/g, "");
                        if (strtagcheck.toUpperCase() == "<BR>") bool_drag = false;
                        if (selection_tag .toUpperCase().indexOf("</DT>") > 0) bool_drag = false;
                    }
                }
			}

			if (bool_drag) {										
				try {
					drag_position = document.createElement('drag')
					drag_position.id = drag_spanName;
					drag_position.style.position = 'absolute';
					
					if (navigator.userAgent.indexOf("MSIE") != -1) {				
						var drag_div = document.createElement('div');
						drag_div.appendChild(drag_position);
						drag_field = selection_ori.duplicate();
						drag_field.setEndPoint( "StartToEnd", selection_ori);
						drag_field.pasteHTML(drag_div.innerHTML);
						drag_position = document.getElementById(drag_spanName);
					} else {
						var range = selection_ori.getRangeAt(0);
						drag_field = document.createRange();
						drag_field.setStart(selection_ori.focusNode, range.endOffset);
						drag_field.insertNode(drag_position);
					}
					
					if(!document.getElementById(dragsearch_btn)){				
						var element_body = document.getElementsByTagName("body");
						var element_dragsearch_btn = document.createElement("drag");		
						element_dragsearch_btn.setAttribute("id", dragsearch_btn);
						element_body[0].appendChild(element_dragsearch_btn);
						document.getElementById(dragsearch_btn).style.display = "none";
					}
					
					drag_button_field = document.getElementById(dragsearch_btn);
					drag_button_field.style.display = 'block';	
					drag_button_field.style.width = '87px';
					drag_button_field.style.height = '22px'
					drag_button_field.style.background = 'url(https://law.go.kr/images/button/btn_diseh.gif)';
					drag_button_field.style.zIndex = '8000';
					drag_button_field.style.position = 'absolute';
					drag_button_field.style.cursor = 'pointer';

					if (navigator.userAgent.indexOf("MSIE") != -1)
						drag_button_field.style.margin = '-23px 0 0 -5px';
					else
						drag_button_field.style.margin = '-21px 0 0 -5px';	

					if (drag_button_field && drag_position){
						var drag_span = document.getElementById(drag_spanName);
						var span_top = 0, span_left = 0;
						
						// 현재 마우스 위치로 설정하기 위해 변경
						//span_left = parentX(drag_span);
						//span_top = parentY(drag_span);
						span_left = document.body.scrollLeft + event.clientX+10;
						span_top = document.body.scrollTop + event.clientY-10;
						
						if(span_top < 22) { 
							span_top = span_top + 40;
						}
						if(span_left + 70 > document.body.offsetWidth) {
							span_left = span_left - 60;
						}
						if(span_left == 0) {
						}
						arrPosition = [span_top, span_left];
						drag_button_field.style.top = arrPosition[0] +"px";
						drag_button_field.style.left = arrPosition[1] +"px";
					}
					if(drag_button_field.addEventListener) 
						drag_button_field.addEventListener('mouseup', setLink, false)
					else
						drag_button_field.attachEvent('onmouseup', setLink);
		
				} catch(e) { Drag_initialization(); }
				
				if (navigator.userAgent.indexOf("MSIE") != -1) {
					if(window.event.preventDefault) {
						window.event.preventDefault(); 
						window.event.stopPropagation(); 
					} else {
						window.event.returnValue = false; 
						window.event.cancelBubble = true;
					}
				}
	
				} else {
					Drag_initialization();
				}
			} else {
				Drag_initialization();
			}
		} catch(e) { Drag_initialization(); }
	}

	function InitDragsearch() {
		// Mozila
		if(document.addEventListener) {
			document.addEventListener('mouseup', Dragsearch, false)
		// IE
		} else {
			document.attachEvent('onmouseup', Dragsearch);
		}
		return;
	}
	
	function newLsTrmPopDrag(lsTrm){
		openScrollPop('https://law.go.kr/LSW/lsTrmScListP.do?q='+encodeURIComponent(lsTrm)+"&outmax=15&fsort=10",'870','578');
	
	}

InitDragsearch();

}

// 법령용어 검색 별도 팝업
goLsTrm = function() {
	
	var txt;
	if (window.getSelection) {
	    txt = window.getSelection();
    } else if (document.getSelection) {
	    txt = document.getSelection();
    } else if (document.selection) {
	    txt = document.selection.createRange().text;
    } else {
	    return;
    }
    if(txt == ""){
    	txt = "*.?";
    	openScrollPop('https://law.go.kr/LSW/lsTrmScListP.do?q='+encodeURIComponent(txt)+"&outmax=50&fsort=10",'870','578');
    }else{
    	openScrollPop('https://law.go.kr/LSW/lsTrmScListP.do?q='+encodeURIComponent(txt)+"&outmax=50&fsort=10",'870','578');
    }
	

}

function openScrollPop(url, width, height){
	if(width == null || width == ""){
		width = "900px";
	}

	if(height == null || height == ""){
		height = "630px";
	}
	
	var win = window.open(url,'', 'scrollbars=yes,toolbar=no,resizable=yes,status=no,location=yes,menubar=no,width=' + width + ',height=' +  height); 
	
	return false;
}
var lsTrmDragSrch = new classLsTrmDragSrch();
