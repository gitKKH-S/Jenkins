	function downFile(viewfilenm, serverfilenm,folder){
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("action", CONTEXTPATH+"/Download.do");
		newForm.append($("<input/>", {type:"hidden", name:"Serverfile", value:serverfilenm}));
		newForm.append($("<input/>", {type:"hidden", name:"Pcfilename", value:viewfilenm}));
		newForm.append($("<input/>", {type:"hidden", name:"folder", value:folder}));
		newForm.appendTo("body");
		newForm.submit();
	}
	
	var openWin
	function popOpen(pname,url,wth,hht){
		var cw = wth;
		var ch = hht;
		var sw = screen.availWidth;
		var sh = screen.availHeight;
		var px = (sw-cw)/2;
		var py = (sh-ch)/2;
		var property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=no,status=no,toolbar=no";
		openWin = window.open(url, pname, property);
		if(pname == "Edit"){
			openWin.opener = opener;
		}
		window.openWin.focus();
	}