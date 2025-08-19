///////////////////////////////////////////
//	TODO : 해당 리스트에 따라 버튼 다르게 표시
///////////////////////////////////////////
Ext.onReady(function(){
	//상단 메뉴
	var topToolbar = new Ext.Toolbar({
        renderTo:'topMenu',
        items: [
		
		new Ext.Button({
			id:'tb_doc',
			text:'문서 양식 관리', iconCls:'icon_standard',
			handler:function(){
				var quickCat = new Ext.Window({
					title:'문서 양식 관리', modal:true,
					height:550, width:900, iconCls:'icon_standard',
					resizable:false,
					plain: true, buttons: [
											{ text:'닫기', handler: function(){ quickCat.hide(); }
											}]
				});
				quickCat.render(Ext.getBody());
				quickCat.body.update('<iframe src="'+CONTEXTPATH+'/bylaw/docmn/docMn.do" width="100%" height="100%" scroll="no" frameborder="no"></iframe>');
				quickCat.show();
			}
		})
		,'-',			
		new Ext.Button({
			id:'tb_law',
			text:'법령관리', iconCls:'icon_mnPop',
			handler:function(){ goPage('LW'); }
		})
		,'-',
		new Ext.Button({
			id:'tb_memu',
			text:'메뉴관리', iconCls:'manageMenu',
			handler:function(){ goPage('C'); }
		}),'-',
		new Ext.Button({
			id:'tb_user',
			text:'사용자관리', iconCls:'manageUser',
			handler:function(){ goPage('U'); }
		}),'-',
		new Ext.Button({
			id:'tb_code',
			text:'코드관리', iconCls:'manageCode',
			handler:function(){ goPage('S'); }
		}),'-',
		new Ext.Button({
			id:'tb_mnPop',
			text:'팝업창관리', iconCls:'icon_mnPop',
			handler:function(){
			var popWin = new Ext.Window({
				title:'팝업창관리', modal:true,
				height:525, width:635, iconCls:'icon_mnPop',
				resizable:false
			});
			popWin.render(Ext.getBody());
			popWin.body.update('<iframe src="'+CONTEXTPATH+'/bylaw/popmn/popmn.do" width="100%" height="100%" scroll="no" frameborder="no"></iframe>');
			popWin.show();
		}
		})
		,'-',
		new Ext.Button({
			id:'tb_logview',
			text:'로그보기', iconCls:'icon_mnPop',
			handler:function(){ goPage('LO'); }
		})
		,'-',
		new Ext.Button({
			id:'tb_logPop',
			text:'웹로그분석', iconCls:'icon_mnPop',
			handler:function(){
			window.open(CONTEXTPATH+'/report.html','report','scrollbar=yes,width=1200,height=800,resizable=yes');
		}
		})
		,'-',	
		new Ext.Button({
			id:'tb_adminm1',
			text:'관리자메뉴얼', iconCls:'icon_standard',
			handler:function(){ 
				//window.open(CONTEXTPATH+'/jsp/lkms3/jsp/adminm2.pdf','um','width=1000,height=850,resizable=yes');
				window.open(CONTEXTPATH+'/dataFile/adminManual.pdf','um','scrollbar=yes,width=1200,height=800,resizable=yes');
			}
		})
		,'-',	
		new Ext.Button({
			id:'tb_adminm2',
			text:'편집기메뉴얼', iconCls:'icon_standard',
			handler:function(){ 
				//window.open(CONTEXTPATH+'/jsp/lkms3/jsp/adminm1.pdf','um','width=1000,height=850,resizable=yes');
				window.open(CONTEXTPATH+'/dataFile/editorManual.pdf','um','scrollbar=yes,width=700,height=800,resizable=yes');
			}
		})
		]
    });	
	//tb_bylaw - 규정관리 --ALL
	//tb_prog - 제/개정상태조회  -- ALL
	//tb_change - 일괄변경
	//tb_dan3 - 3단보기 관리
	//tb_quick - 퀵카테고리관리
	//tb_consult - 법률자문게시판
	//tb_memu - 메뉴관리
	//tb_user - 사용자관리
	//tb_code - 코드관리
	//tb_mkcd - CD제작
	//tb_mnPop - 환경설정
	//tb_approve - 승인관리

});
function goSch(schTxt){
	if(schTxt==''){
		Ext.Msg.alert('Status', '검색어를 입력해주세요...');
		return false;
	}
	schStore.on('beforeload',function(){
		schStore.baseParams={
			schtxt: schTxt,
			statecd:stateCd
		}
	});
	schStore.load();
}
function goPage(gbn){
	if(gbn=="U"){
		location.href=CONTEXTPATH+"/bylaw/user/userMn.do"; 
	}else if(gbn == 'P'){
		location.href=CONTEXTPATH+"/bylaw/adm/progressMn.do";
	}else if(gbn == 'S'){
		location.href=CONTEXTPATH+"/bylaw/code/codeMn.do";
	}else if(gbn == 'SE'){
		location.href=CONTEXTPATH+"/bylaw/setting/settingMn.do"; 
	}else if(gbn == 'C'){
		location.href=CONTEXTPATH+"/bylaw/menu/menuMn.do"; 
	}else if(gbn == 'LW'){
		location.href=CONTEXTPATH+"/bylaw/law/lawMn.do";
	}else if(gbn == 'SW'){
		location.href=CONTEXTPATH+"/bylaw/commitee/commiteeMn.do";
	}else if(gbn == 'SI'){
		location.href=CONTEXTPATH+"/bylaw/commitee/commission.do";
	}else if(gbn == 'LO'){
		location.href=CONTEXTPATH+"/bylaw/log/logMn.do";
	}
	
	
}
