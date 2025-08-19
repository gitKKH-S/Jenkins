Ext.QuickTips.init();

//유저관리 트리 시작

Ext.onReady(function(){
	var frm_window;
	//컨텍스트 메뉴 필요하면 여기에
	var rootContext = new Ext.menu.Menu({
		id:'rootContextMenu',
		items:[
			{
				id:'root_addDept', cls:'icon_addDept', text:'권한 추가',
				handler:function(){
					frm_window = new Ext.Window({
						closable:true, width:520, autoHeight:true, modal:true,
						items: [
							new Ext.FormPanel({
								url:CONTEXTPATH+'/bylaw/user/createRole.do',
								labelWidth:90, width:500, autoHeight:true, monitorValid:true, frame:true,
								items: {
									xtype: 'fieldset', title: '새 권한 추가',
									items: [
										{xtype:'textfield',width:300, fieldLabel: '권한명', name:'CD_NM', id:'CD_NM', allowBlank:false}
									]
								},
								buttons: [
									{ 
										text: '저 장', formBind: true,
										handler: function(){
											var fp = this.ownerCt.ownerCt;
											fp.getForm().submit({
												method: 'POST',
												params: {
													job:'createDept'
												},
												waitTitle: '처리중 ...',
												waitMsg: '자료를 저장중입니다....',
												success: function(form, action){
													Ext.Msg.alert('Status', '권한정보가 정상적으로 생성되었습니다.', function(btn, text){
														if (btn == 'ok'){
															var result = action.result;
															treeMM.root.reload();
															frm_window.close();
															
														}
													});
												},
												failure: function(form, action){
													
												}
											});
										}
									}
								]
							})
						],
						plain:true
					});
					frm_window.show('div');
				}
			}
		]
	});
	
	var docContext = new Ext.menu.Menu({
		id:'docContextmenu',
		items:[
			{
				id:'doc_updateUser', cls:'icon_updateUser', text:'사용자정보 수정',
				handler:function(){
					Ext.getCmp('u_section').activate('u_mod');
				}
			},
			{
				id:'doc_delUser', cls:'icon_delUser', text:'사용자 삭제',
				handler:function(){
					var node = treeMM.getSelectionModel().getSelectedNode();
					var MNGR_MNG_NO = node.id;
					var path = node.parentNode.getPath();
					Ext.MessageBox.wait('작업을 처리중입니다.','Wait',{interval:100, text:'데이터 처리중...'});
					Ext.Ajax.request({
						url: CONTEXTPATH+'/bylaw/user/deleteUser.do', method : 'post', timeout:300000000000000,
						params: {MNGR_MNG_NO:MNGR_MNG_NO}, 
						success: function(res, opts){
							var result = Ext.util.JSON.decode(res.responseText);
							Ext.MessageBox.hide();
							Ext.MessageBox.alert('결과',result.data.msg);  
							treeMM.root.reload();
							treeMM.expandPath(path);
						},
						failure: function(res, opts){
							var result=res.responseText;
							Ext.MessageBox.hide();
							treeMM.root.reload();
							treeMM.expandPath(path);
							// Ext.MessageBox.alert('error','통신상태가 원활하지 않습니다. 잠시후 다시 시도해주세요.');      
						}
					});
				}
			}
		]
	});
	
	var folContext = new Ext.menu.Menu({
		id:'folContextMenu',
		items:[
			{
				id:'fol_createUser', cls:'icon_createUser', text:'새 사용자 추가',
				handler:function(){
					var node = treeMM.getSelectionModel().getSelectedNode();
					var MNGR_AUTHRT_CD = node.id;
					var MNGR_DEPT_NM = node.attributes.text;
					//Ext.getCmp('deptNameCR').setValue(MNGR_DEPT_NM);
					Ext.getCmp('DEPT_NO').setValue(MNGR_AUTHRT_CD);
					Ext.getCmp('u_section').activate('u_create');
				}
			},
			{
				id:'fol_deleteDept', cls:'icon_deleteDept', text:'권한 삭제',
				handler:function(){
					var node = treeMM.getSelectionModel().getSelectedNode();
					var MNGR_AUTHRT_CD = node.id;
					Ext.MessageBox.wait('작업을 처리중입니다.','Wait', {interval:100, text:'데이터 처리중...'});
					Ext.Ajax.request({
						url: CONTEXTPATH+'/bylaw/user/deleteRole.do', method : 'post',
						params: {CD_MNG_NO:MNGR_AUTHRT_CD},
						success: function(res, opts){
							var data = Ext.util.JSON.decode(res.responseText);
							Ext.MessageBox.hide();
							if (data.data.result == 'Y') {
								Ext.MessageBox.alert('결과', data.data.msg);
								treeMM.root.reload();
							}else if(data.data.result == 'N'){
								Ext.MessageBox.alert('에러', data.data.msg);
							}
						},
						failure: function(res, opts){
							Ext.MessageBox.alert('에러','통신상태가 원활하지 않습니다. 잠시후 다시 시도해주세요.');      
						}
					});
				}
			}
		]
	});
	
	//트리시작
	var Tree = Ext.tree;
	
	treeMM = new Tree.TreePanel({
		id:'treeMM',
		renderTo:'treeHolder',
		useArrows: true,
		autoScroll: true,
		animate : true,
		enableDD: true,
		containerScroll: true,
		border: false,
		dataUrl: CONTEXTPATH+'/bylaw/user/getNodes.do',
		root: {
			nodeType: 'async', text:'사용자관리', draggable:false, id: 'ROLE', cls:'deptRoot',
			listeners:{
				contextmenu:function(node,e){
					node.select();
					rootContext.showAt(e.getXY());
				}
			}
		},
		listeners: {
			click: function(node, e){
				Ext.getCmp('u_section').activate('u_info');
				node.select();
				var nodeKind = node.attributes.cls;
				if(nodeKind == 'admin' || nodeKind == 'user' ){
					viewUserInfo(node);
					setUserInfo(node);
				}
			},
			beforenodedrop: function(e){ //DD시 노드 드랍전 실행, e.dropNode의 정보는 드랍전 원래의 정보
				var point = e.point;
				var node = e.dropNode;
				var pNode = node.parentNode;
				var targetNode = e.target;
				var MNGR_MNG_NO = node.id;
				var MNGR_AUTHRT_CD = '';
				if(point=='below' || point=='above'){
					MNGR_AUTHRT_CD = targetNode.parentNode.id;
				}else if(point=='append'){
					MNGR_AUTHRT_CD = targetNode.id;
				}
				if(node.attributes.cls == 'dept'){
					Ext.MessageBox.alert('에러','부서는 이동하실 수 없습니다.');
					return false;
				}else if(MNGR_AUTHRT_CD==0){
					Ext.MessageBox.alert('에러','사용자는 부서에 속해야 합니다..');
					return false;
				}
			},
			nodedrop: function(e){
				var point = e.point;
				var node = e.dropNode;
				var pNode = node.parentNode;
				var targetNode = e.target;
				var MNGR_MNG_NO = node.id;
				
				var nodeInfo = node.attributes;
				var MNGR_AUTHRT_NM = nodeInfo.MNGR_AUTHRT_NM;
				var EMP_NO = nodeInfo.EMP_NO;
				
				var MNGR_AUTHRT_CD = '';
				if(point=='below' || point=='above'){
					MNGR_AUTHRT_CD = pNode.id;
				}else if(point=='append'){
					MNGR_AUTHRT_CD = targetNode.id;
				}
				
				if(MNGR_AUTHRT_CD == '10000580') {
					// 전체관리자
					MNGR_AUTHRT_NM = 'Y';
				} else if(MNGR_AUTHRT_CD == '100006864') {
					// 소송관리권한
					MNGR_AUTHRT_NM = 'C';
				} else if(MNGR_AUTHRT_CD == '100000224') {
					// 소송접수권한
					MNGR_AUTHRT_NM = 'L';
				} else if(MNGR_AUTHRT_CD == '100006865') {
					// 자문관리권한
					MNGR_AUTHRT_NM = 'J';
				} else if(MNGR_AUTHRT_CD == '100000225') {
					// 자문접수권한
					MNGR_AUTHRT_NM = 'M';
				} else if(MNGR_AUTHRT_CD == '100000223') {
					// 협약관리권한
					MNGR_AUTHRT_NM = 'A';
				} else if(MNGR_AUTHRT_CD == '100000226') {
					// 협약접수권한
					MNGR_AUTHRT_NM = 'N';
				} 
				else if(MNGR_AUTHRT_CD == '100000227') {
					// 인지대/송달료권한
					MNGR_AUTHRT_NM = 'B';
				} 
				else if(MNGR_AUTHRT_CD == '100000228') {
					// 소송비용권한
					MNGR_AUTHRT_NM = 'D';
				} else if(MNGR_AUTHRT_CD == '100000229') {
					// 소송비용회수권한
					MNGR_AUTHRT_NM = 'E';
				} else if(MNGR_AUTHRT_CD == '100000230') {
					// 자문료권한
					MNGR_AUTHRT_NM = 'F';
				} else if(MNGR_AUTHRT_CD == '100000231') {
					// 과장권한
					MNGR_AUTHRT_NM = 'G';
				} else if(MNGR_AUTHRT_CD == '100000232') {
					// 법률고문담당권한
					MNGR_AUTHRT_NM = 'I';
				} else if(MNGR_AUTHRT_CD == '100000233') {
					// 자문팀장
					MNGR_AUTHRT_NM = 'Q';
				} else if(MNGR_AUTHRT_CD == '100000234') {
					// 협약팀장
					MNGR_AUTHRT_NM = 'R';
				}
				
				Ext.Ajax.request({
					url: CONTEXTPATH+'/bylaw/user/moveNode.do',
					params: {
						MNGR_MNG_NO: MNGR_MNG_NO,
						MNGR_AUTHRT_CD: MNGR_AUTHRT_CD,
						EMP_NO: EMP_NO,
						MNGR_AUTHRT_NM: MNGR_AUTHRT_NM
					},
					success: function(res, opts){
						var result = Ext.util.JSON.decode(res.responseText);
						if(result.data.result=="Y"){
							Ext.MessageBox.alert('결과','사용자가 성공적으로 이동되었습니다..');
						}else{
							Ext.MessageBox.alert('에러','사용자의 이동중 오류가 발생하였습니다.'); 
							location.href = CONTEXTPATH+"bylaw/user/userMn.do";
						}
					},
					failure: function(res,opts){
						Ext.MessageBox.alert('서버에러','서버와의 통신이 원활하지 않습니다.');  
						return false;
					}
				});
			},
			contextmenu: function(node, e){
				node.select();
				var nodeKind = node.attributes.cls;
				if(nodeKind=='dept'){
					folContext.showAt(e.getXY());
				}else if(nodeKind == 'admin' || nodeKind == 'user'){
					viewUserInfo(node);
					setUserInfo(node);
					docContext.showAt(e.getXY());
				}
			},
			expandnode:function(node){
				if (node.attributes.cls == 'dept') {
					node.getUI().addClass('deptOpen');
				}
			},
			collapsenode:function(node){
				if(node.attributes.cls=='dept'){
					node.getUI().removeClass('deptOpen');
				}
			}
		}
	});
	
	treeMM.getRootNode().expand();
	
	function viewUserInfo(node){
		var nodeInfo = node.attributes;
		var MNGR_EMP_NM = nodeInfo.MNGR_EMP_NM;
		var EMP_NO = nodeInfo.EMP_NO;
		var MNGR_AUTHRT_NM = nodeInfo.MNGR_AUTHRT_NM;
		
		if (MNGR_AUTHRT_NM == 'Y'){
			MNGR_AUTHRT_NM = '전체관리자';
		} else if (MNGR_AUTHRT_NM == 'C'){
			MNGR_AUTHRT_NM = '소송관리권한';
		} else if (MNGR_AUTHRT_NM == 'L'){
			MNGR_AUTHRT_NM = '소송접수권한';
		} else if (MNGR_AUTHRT_NM == 'J'){
			MNGR_AUTHRT_NM = '자문관리권한';
		} else if (MNGR_AUTHRT_NM == 'M'){
			MNGR_AUTHRT_NM = '자문접수권한';
		} else if (MNGR_AUTHRT_NM == 'A'){
			MNGR_AUTHRT_NM = '협약관리권한';
		} else if (MNGR_AUTHRT_NM == 'N'){
			MNGR_AUTHRT_NM = '협약접수권한';
		} else if(MNGR_AUTHRT_NM == 'B') {
			MNGR_AUTHRT_NM = '소장접수권한';
		} else if(MNGR_AUTHRT_NM == 'D') {
			MNGR_AUTHRT_NM = '소송비용권한';
		} else if(MNGR_AUTHRT_NM == 'E') {
			MNGR_AUTHRT_NM = '소송비용회수권한';
		} else if(MNGR_AUTHRT_NM == 'F') {
			MNGR_AUTHRT_NM = '자문료권한';
		} else if(MNGR_AUTHRT_NM == 'G') {
			MNGR_AUTHRT_NM = '과장권한';
		} else if(MNGR_AUTHRT_NM == 'I') {
			MNGR_AUTHRT_NM = '법률고문담당권한';
		} else if(MNGR_AUTHRT_NM == 'Q') {
			MNGR_AUTHRT_NM = '자문팀장권한';
		} else if(MNGR_AUTHRT_NM == 'R') {
			MNGR_AUTHRT_NM = '협약팀장권한';
		}
		
		var MNGR_DEPT_NM = nodeInfo.MNGR_DEPT_NM;
		var e_mail = nodeInfo.E_MAIL;
		var u_info = Ext.get('u_info');
		var htmlSrc = '<div id="userInfoTop">'+
				'<table width="100%" border="0" cellspacing="0" cellpadding="0">'+
					'<tr>'+
						'<td width="121">'+
							'<img src="'+CONTEXTPATH+'/resources/images/userman/userInfo_head.gif" width="121" height="107" alt="userinfo_left">'+
						'</td>'+
						'<td valign="top" background="'+CONTEXTPATH+'/resources/images/userman/userInfo_bg.gif">'+
							'<p class="ui_cNum">이름 : '+MNGR_EMP_NM+'</p>'+
							'<p class="ui_cNum">사번 : '+EMP_NO+'</p>'+
						'</td>'+
						'<td width="321">'+
							'<img src="'+CONTEXTPATH+'/resources/images/userman/userInfo_imgLeft.gif" width="321" height="107" alt="userinfo_right">'+
						'</td>'+
					'</tr>'+
				'</table>'+
			'</div>'+
			'<div id="userInfoEtc"><ul>'+
				'<li><strong>사용자 등급</strong> : '+MNGR_AUTHRT_NM+'</li>'+
				'<li><strong>소속 부서</strong> : '+MNGR_DEPT_NM+'</li>'+
				//'<li><strong>e - mail</strong> : '+e_mail+'</li>'+
			'</ul></div>';
		u_info.update(htmlSrc);
	}
	
	function setUserInfo(node){
		//var node = treeMM.getSelectionModel().getSelectedNode();
		if(node){
			var nodeInfo = node.attributes;
			Ext.getCmp('MNGR_EMP_NM').setValue(nodeInfo.MNGR_EMP_NM);
			Ext.getCmp('EMP_NOMOD').setValue(nodeInfo.EMP_NO);
			Ext.getCmp('is_managerCR2').setValue(nodeInfo.MNGR_AUTHRT_NM);
			Ext.getCmp('deptNameMOD').setValue(nodeInfo.MNGR_DEPT_NM);
			Ext.getCmp('codeIdMOD').setValue(nodeInfo.DEPTCD);
			Ext.getCmp('MNGR_MNG_NO').setValue(nodeInfo.MNGR_MNG_NO);
			Ext.getCmp('teamnameMOD').setValue(nodeInfo.position);	
			//Ext.getCmp('e_mail').setValue(nodeInfo.e_mail);
		}
	}
});
