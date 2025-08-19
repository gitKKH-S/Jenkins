var Grpcd = '';
var Grpcd2 = '';
var stateCd = '';
var Orgname = '';
var Deptcd = '';
var suserid = '';
$.ajax({
	type:'post',
	url:CONTEXTPATH+'/login/getSession.do',
	dataType: "json",
	async: false,
	success:function(data){
		if(data.data.GRPCD){
			Grpcd = data.data.GRPCD;
			stateCd = '';
			Orgname = data.data.DEPTNAME;
			Deptcd = data.data.DEPTCD;
			suserid = data.data.USERNO;
		}else{
			alert("사용자 정보가 존재 하지 않습니다.");
			top.location.href=CONTEXTPATH+"/index.do"
		}
	},
	error:function(e){
		alert("사용자 정보가 존재 하지 않습니다.");
	}
})
