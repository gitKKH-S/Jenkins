<%@ page language="java"  pageEncoding="UTF-8"%>
<script src="${resourceUrl}/appjs/commitee/commission.js" type="text/javascript"></script>
<script>
//심의대상규정선택창
	var lawWin;
	var opinionWin;
function showLawWin(lawList){
	lawWin = new Ext.Window({
		height:500,
		width:700,
		modal:true,
		title: '심의대상규정'
	});
	lawWin.render(Ext.getBody());
	lawWin.body.update('<iframe src="lawListForCommission.do?lawList='+lawList+'" width="100%" height="100%" scroll="no" frameborder="no"></iframe>');	 
	lawWin.show();
}
function hideLawWin(){
	lawWin.hide();
}
function showOpinionWin(opinionId,commissionId, opGbn){
	var titles="의견등록";
	if(opGbn=='C'){
		titles="위원장 의견등록";
	}else if(opGbn=='G'){
		titles="간사 의견등록";
	}else if(opGbn=='N'){
		titles="노동조합지부장";
	}
	opinionWin = new Ext.Window({
		height:500,
		width:500,
		modal:true,
		title: titles
	});
	opinionWin.render(Ext.getBody());
	opinionWin.body.update('<iframe src="opinionWrite.do?opinionid='+opinionId+'&commissionid='+commissionId+'&opgbn='+opGbn+'" width="100%" height="100%" scroll="no" frameborder="no"></iframe>');	 
	opinionWin.show();
}
function hideOpinionWin(){
	opinionWin.hide();
}
function showOpinionViewWin(opinionId, opGbn){
	var titles="의견보기";
	if(opGbn=='C'){
		titles="위원장 의견보기";
	}else if(opGbn=='G'){
		titles="간사 의견보기";
	}
	opinionWin = new Ext.Window({
		height:300,
		width:700,
		modal:true,
		title: titles
	});
	opinionWin.render(Ext.getBody());
	opinionWin.body.update('<iframe src="opinionView.do?opinionid='+opinionId+'&opgbn='+opGbn+'" width="100%" height="100%" scroll="no" frameborder="no"></iframe>');
	opinionWin.show();
}
function showFileForm(commissionId, fileCd){
	opinionWin = new Ext.Window({
		height:110,
		width:400,
		modal:true,
		title: '파일등록'
	});
	opinionWin.render(Ext.getBody());
	opinionWin.body.update('<iframe src="fileUploadForm.do?filecd='+fileCd+'&commissionid='+commissionId+'" width="100%" height="100%" scroll="no" frameborder="no"></iframe>');
	opinionWin.show();
}

function reloadWewonGrid(job,commissionId){
	wewonGridStore.load({
		params:{
			job: job,
			start:0, 
			limit:100,
			commissionId:commissionId,
			gridGbn:'present'
		}
	});
}
</script>
<form name="ViewForm" method="post">
  	<input type="hidden" name="Serverfile">
	<input type="hidden" name="Pcfilename">
	<input type="hidden" name="folder">
</form>
