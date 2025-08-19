

Ext.onReady(function(){

	
	//부서리스트 호출
	var dsDept = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/bylaw/user/getDeptName.do'
		}),
		reader:new Ext.data.JsonReader({root:'result'},['deptName','codeId'])
	});
	
	//검색리스트 호출
    var search_gridStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/bylaw/user/userList.do'
		}),
		reader:new Ext.data.JsonReader({root:'records'},['userNameCR','userNoCR','e_mailCR','deptNameCR','teamname','codeIdCR'])
	});
    
	// 직원검색 그리드
    var search_grid = new Ext.grid.GridPanel({
		id:'p_grid',    
		region: 'west',
		ddGroup          : 'gridDDGroup',
        store            : search_gridStore,
		enableDragDrop   : true,
        stripeRows       : true,
        autoExpandColumn : 'name',
		split: true, 
		collapsible: true, 
		collapseMode: 'mini', 					
		width: 450, 
		minSize: 250,
        title            : '직원검색',
		selModel         : new Ext.grid.RowSelectionModel({singleSelect : true}),
        columns          : [
            	    	    {header: "부서명", width: 230, sortable: true, dataIndex: 'deptNameCR'},
            	    		{ id : 'name', header: "성 명", width: 50, sortable: true, dataIndex: 'userNameCR'},
            	    		{header: "직함", width: 70, sortable: true, dataIndex: 'teamname'}
                		],
		tbar:[
		      	{	xtype:'combo', 			width:150, 
		      		fieldLabel:'',			name:'Deptcd',
		      		id:'deptNameCOM',		typeAhead: true, 
		      		triggerAction: 'all', 	lazyRender:true, 
		      		editable:false,			store:dsDept,
		      		displayField:'deptName',valueField:'codeId',
		      		emptyText:'부서선택',
		      		listeners:{
								beforerender:function(){
									dsDept.on('beforeload', function(){
										dsDept.baseParams = {
											job:'getDeptName'
										}
									});
								},
								select:function(cb, data, idx){
									search_gridStore.on('beforeload', function(){
										search_gridStore.baseParams = {
											job: 'userList',
											Deptcd : Ext.getCmp('deptNameCOM').getValue()
										}
									});
									search_gridStore.load({
										params:{
										
										}
									});
								}
		      		}
		      	},
				{xtype:'textfield',width:180,fieldLabel:'search',name:'schText',id:'schText', emptyText:'성명을 입력해주세요...',enableKeyEvents:true,
					listeners:{
					keydown :function(el, e){
						if(e.getKey() == 13) {
							var schTxt = Ext.getCmp('schText').getValue();
							search_gridStore.on('beforeload', function(){
								search_gridStore.baseParams = {
									job: 'userList',
									schTxt : schTxt,
									Deptcd : Ext.getCmp('deptNameCOM').getValue()
								};
							});
							search_gridStore.load({
								params:{
								
								}
							});
						}
					}
				}},
			new Ext.Button ({
				id:'butSch', text:'<b>검색</b>',iconCls:'byprogress',
				listeners:{
					click:function(btn, eObj){
						var schTxt = Ext.getCmp('schText').getValue();
						search_gridStore.on('beforeload', function(){
							search_gridStore.baseParams = {
								job: 'userList',
								schTxt : schTxt,
								Deptcd : Ext.getCmp('deptNameCOM').getValue()
							}
						});
						search_gridStore.load({
							params:{
							
							}
						});
					}
				}
			})
		],
		listeners:{
			render:function(cmp){
    		//gridStore.on('beforeload', function(){
    		//		gridStore.baseParams = {
			//			job:'userList'
			//		}
			//	});
    		//gridStore.load({
			//		
			//	});
			}
		}
    });	 
    
	var chkedData;	//선택된 위원정보

	//위원관리그리드 셀렉트모델
	var smProgGrid = new Ext.grid.CheckboxSelectionModel({
		singleSelect: true,
		listeners:{
			selectionchange:function(){
				chkedData = smProgGrid.getSelected();
				//선택된 데이터로 필요 로직 처리
			},
			//rowselect : ( SelectionModel this, Number rowIndex, Ext.data.Record r )
			rowselect:function(){

			}
		}
	});    

    //위원관리 그리드를 위한 그리드뷰 설정
	var gridView = new Ext.grid.GridView({ 
	   	//forceFit: true, 
	     getRowClass : function (row, index) { 
	       var cls = ''; 
	       var data = row.data;
    	   cls = data.nowstateCd+'-row';
	       return cls; 
	    } 
	});  //end gridView
	
	
	//위원관리 그리드 정보 호출
	var wewonGridStore = new Ext.data.Store ({
		id:'p_ds',
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH+'/bylaw/commitee/selectWewonList.do'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result', totalProperty: 'total', idProperty: 'WEWONINFOID'
		}, [
		    	'WEWONINFOID',
		    	{
		    		name: 'STARTDT',
		    		type: 'date',
		    		dateFormat: 'Y-m-d'
		    	},{
		    		name: 'ENDDT',
		    		type: 'date',
		    		dateFormat: 'Y-m-d'
		    	},
		    	'USERNAME',
		    	'USERID',
		    	'DEPTNM', 
		    	'WEWONGBN'
		])
	});	
	
	//위원관리 그리드
	var gridGbn = '';
	var pageSize = 20;		//한번에 표시할 검색결과 숫자
	var startDt_edit = new Ext.form.DateField({format:'Y-m-d'});
	var endDt_edit = new Ext.form.DateField({format:'Y-m-d'});
	var wewonGbn_Store = new Ext.data.ArrayStore({
		fields: ['id','wewonGbn'],
		data:[['위원장','위원장'],['간사','간사'],['위원','위원'],['노동조합지부장','노동조합지부장']]
	});
	
    function wewonGbn_name(val){ 
        return wewonGbn_Store.queryBy(function(rec){ 
            return rec.data.id == val; 
        }).itemAt(0).data.wewonGbn;
    } 
    
	var wewonGbn_edit = new Ext.form.ComboBox({
		typeAhead: true,
		triggerAction: 'all',
		mode: 'local',
		store: wewonGbn_Store,
		displayField: 'wewonGbn'
	});
	var wewonGrid = new Ext.grid.EditorGridPanel({
		id:'p_grid2',
		region: 'center',
		store:wewonGridStore,
		autoWidth:true,
		//autoHeight:true,
		height:640,
		view: gridView,
		cm:new Ext.grid.ColumnModel({
			columns:[
				smProgGrid,
				{header:"이름",  dataIndex:'USERNAME'},
				{header:"사번",  dataIndex:'USERID'},
				{header:"부서", dataIndex:'DEPTNM'},
				{header:"위촉일",  dataIndex:'STARTDT', renderer: Ext.util.Format.dateRenderer('Y-m-d'), editor: startDt_edit},
				{header:"종료일", dataIndex:'ENDDT', renderer: Ext.util.Format.dateRenderer('Y-m-d'), editor: endDt_edit},
				{header:"역할", dataIndex:'WEWONGBN',renderer: wewonGbn_name, editor: wewonGbn_edit}
			]
		}),
		sm:smProgGrid,
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		viewConfig:{
			forceFit:true
		},
		bbar:new Ext.PagingToolbar({
			pageSize:pageSize, 
			store: wewonGridStore,
			displayInfo:true, 
			displayMsg:'전체 {2}의 결과중 {0} - {1}',
			emptyMsg:"검색된 결과가 없습니다."
		}),
        title: '위원관리',
        listeners:{
        	afteredit:function(e){
        		var startDt = '';
        		var endDt = '';
        		var wewonGbn = '';
        		if(e.field == 'STARTDT'){
        			startDt = Ext.util.Format.date(e.value, 'Y-m-d');
        		}else if(e.field == 'ENDDT'){
        			endDt = Ext.util.Format.date(e.value, 'Y-m-d');
        		}else if(e.field == 'WEWONGBN'){
        			wewonGbn = e.value
        		}
        		var schTxt = Ext.getCmp('schText01').getValue();
				var sm = wewonGrid.getSelectionModel(), 
                sel = sm.getSelected();
				var id = sel.data.WEWONINFOID;
				var wewonGbn
        		Ext.Ajax.request({
      			     url:CONTEXTPATH+'/bylaw/commitee/updateWewon.do',
      			     params:{
      			    	 job:'updateWewon',
      			    	 wewoninfoid : id,
      			    	 startdt : startDt,
      			    	 enddt : endDt,
      			    	 wewongbn : wewonGbn
      			     },
      			     success:function(res,opts){
      			    	 result=Ext.util.JSON.decode(res.responseText);
       					 if(result.success){
          				    	Ext.Msg.alert('확인', '수정되었습니다!!');
          			    		wewonGridStore.load({
          			    			params:{
          			    				job: 'selectWewonList',
          			    				schTxt : schTxt,
          			    				start:0, 
          			    				limit:pageSize
          			    			}
          			    		});
       					 }else{
       						Ext.Msg.alert('에러', '수정할 수 없습니다.'+result.data.msg);
       					 }
      			     }
        		});
        	}
        	
        },
		tbar:[
				/*{ 
		            text: '모든위원', 
		            toggleGroup: 'orientation-selector',
		            pressed:true,
		            listeners:{
						click:function(btn, eObj){
							var schTxt = Ext.getCmp('schText01').getValue();
							wewonGridStore.on('beforeload', function(){
								gridGbn = 'all';
								wewonGridStore.baseParams = {
									job: 'selectWewonList',
									schTxt : schTxt,
									gridGbn : gridGbn
								}
							});
							wewonGridStore.load({
								params:{
      			    				start:0, 
      			    				limit:pageSize
								}
							});
						}
					}
		        },*/ { 
		            text: '현재위원', 
		            pressed:true,
		            toggleGroup: 'orientation-selector',
		            listeners:{
						click:function(btn, eObj){
							var schTxt = Ext.getCmp('schText01').getValue();
							wewonGridStore.on('beforeload', function(){
								gridGbn = 'present';
								wewonGridStore.baseParams = {
									job: 'selectWewonList',
									schTxt : schTxt,
									gridGbn : gridGbn
								}
							});
							wewonGridStore.load({
								params:{
      			    				start:0, 
      			    				limit:pageSize
								}
							});
						}
					}
		        }, { 
		            text: '종료위원', 
		            toggleGroup: 'orientation-selector',
		            listeners:{
						click:function(btn, eObj){
							var schTxt = Ext.getCmp('schText01').getValue();
							wewonGridStore.on('beforeload', function(){
								gridGbn = 'past';
								wewonGridStore.baseParams = {
									job: 'selectWewonList',
									schTxt : schTxt,
									gridGbn : gridGbn
								}
							});
							wewonGridStore.load({
								params:{
      			    				start:0, 
      			    				limit:pageSize
								}
							});
						}
					}
		        },
		      
			  ' ',{xtype:'textfield',width:180,fieldLabel:'search',name:'schText01',id:'schText01', emptyText:'이름검색',enableKeyEvents:true,
					listeners:{
					keydown :function(el, e){
						if(e.getKey() == 13) {
							var schTxt = Ext.getCmp('schText01').getValue();
							wewonGridStore.on('beforeload', function(){
								wewonGridStore.baseParams = {
									job: 'selectWewonList',
									schTxt : schTxt
								}
							});
							wewonGridStore.load({
								params:{
      			    				start:0, 
      			    				limit:pageSize
								}
							});
						}
					}
				}},
			new Ext.Button ({
				id:'butSch', text:'<b>검색</b>',iconCls:'byprogress',
				listeners:{
					click:function(btn, eObj){
						var schTxt = Ext.getCmp('schText01').getValue();
						wewonGridStore.on('beforeload', function(){
							wewonGridStore.baseParams = {
								job: 'selectWewonList',
								schTxt : schTxt
							}
						});
						wewonGridStore.load({
							params:{
  			    				start:0, 
  			    				limit:pageSize
							}
						});
					}
				}
			}),
			'->',
			new Ext.Button ({
				id:'butDel', text:'<b>삭제</b>',
				listeners:{
					click:function(btn, eObj){
						
						var sm = wewonGrid.getSelectionModel(), 
		                sel = sm.getSelected();
						var id = sel.data.WEWONINFOID;
		                if (sm.hasSelection()){ 
		                    Ext.Msg.show({ 
		                        title: '위원 삭제', 
		                        buttons: Ext.MessageBox.OKCANCEL, 
		                        msg: '위원 '+ sel.data.USERNAME + '을(를) 삭제하시겠습니까?', 
		                        fn: function(btn){
		                        	
		                            if (btn == 'ok'){ 
		                            	
		                    			Ext.Ajax.request({
			                   			     url:CONTEXTPATH+'/bylaw/commitee/delWewon.do',
			                   			     params:{
			                   			    	 job:'delWewon',
			                   			    	 wewoninfoid : id
			                   			     },
			                   			     success:function(res,opts){
			                   			    	 result=Ext.util.JSON.decode(res.responseText);
			                    					 if(result.success){
				                   				    	Ext.Msg.alert('Status', '삭제되었습니다!!');
				                   			    		wewonGridStore.load({
				                   			    			params:{
				                   			    				job: 'selectWewonList',
				                   			    				schTxt : schTxt,
				                  			    				start:0, 
				                  			    				limit:pageSize
				                   			    			}
				                   			    		});
			                    					 }else{
			                    						Ext.Msg.alert('에러', '삭제할 수 없습니다.'+result.data.msg);
			                    					 }
			                   			     }
		                    			});
		                            } 
		                        } 
		                    }); 
		                }; 
						
						
						var schTxt = Ext.getCmp('schText01').getValue();
						wewonGridStore.on('beforeload', function(){
							wewonGridStore.baseParams = {
								job: 'selectWewonList',
								schTxt : schTxt
							}
						});
						wewonGridStore.load({
							params:{
  			    				start:0, 
  			    				limit:pageSize
							}
						});
					}
				}
			})
				
		]
		
	});			
	 
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [
					new Ext.BoxComponent({ // raw
			            region: 'north',
			            el: 'topMenuHolder',
			            height: 70
					}),
					search_grid,
					wewonGrid
		]
    });
    
    
    
    
    // Drag&Drop 설정
	var searchGridDropTarget = new Ext.dd.DropTarget('p_grid2', {
		ddGroup     : 'gridDDGroup',
		notifyEnter : function(ddSource, e, data) {

		},
		notifyDrop  : function(ddSource, e, data){

			// Reference the record (single selection) for readability
			var selectedRecord = ddSource.dragData.selections[0];


			// Load the record into the form
			formPanel.getForm().loadRecord(selectedRecord);

			// Delete record from the grid.  not really required.
			//ddSource.grid.store.remove(selectedRecord);
			Ext.Ajax.request({
			     url:CONTEXTPATH+'/bylaw/commitee/insertWewon.do',
			     params:{
			    	 job:'insertWewon',
			    	 username : Ext.getCmp('userNameCR').getValue(),
			    	 userno : Ext.getCmp('userNoCR').getValue(),
			    	 deptcd : Ext.getCmp('codeIdCR').getValue(),
			    	 deptName : Ext.getCmp('deptNameCR').getValue(),
			    	 position : Ext.getCmp('teamname').getValue()
			     },
			     success:function(res,opts){
			    	 result=Ext.util.JSON.decode(res.responseText);
 					 if(result.success){
				    	 Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
		  					if (btn == 'ok'){
							
								Ext.getCmp('userNameCR').setValue('');
								Ext.getCmp('userNoCR').setValue('');
								Ext.getCmp('is_managerCR').setValue('Y');
								Ext.getCmp('deptNameCR').setValue('부서를 선택해주세요');
								Ext.getCmp('e_mailCR').setValue('');

                       		}
			        	});
			    		wewonGridStore.load({
			    			params:{
			    				job: 'selectWewonList',
  			    				start:0, 
  			    				limit:pageSize
			    			}
			    		});
 					 }else{
 						Ext.Msg.alert('에러', '등록을 실패했습니다'+result.data.msg);
 					 }
			     },
			     failure:function(){
			    	 result=Ext.util.JSON.decode(res.responseText);
					Ext.Msg.alert('에러', '등록을 실패했습니다'+result.data.msg);
			     }
			});

			return(true);
		}
	});
	
	
	//위원등록을 위한 숨겨진 폼
	var userName = new Ext.form.TextField({
		fieldLabel : '성 명 ',
		name:'username', width:250, allowBlank:false, id:'userNameCR'
	});

	var sabun = new Ext.form.TextField({
		fieldLabel : '사 번 ',
		name:'userno', width:250, allowBlank:false, id:'userNoCR'
	});

	var Email = new Ext.form.TextField({
		fieldLabel : 'e-mail ',
		name:'e_mail', width:250, allowBlank:false, id:'e_mailCR'
	});
	
	var formPanel = new Ext.form.FormPanel({
		renderTo     : 'wewonForm',
		title      : '사용자 등록 화면',
		bodyStyle  : 'padding: 10px; background-color: #DFE8F6',
		labelWidth:90, width:500, autoHeight:true, monitorValid:true,frame:true,
		items: {
			xtype: 'fieldset', title: '새 사용자 등록',
			items      : [
				userName,
				sabun,
				{xtype: 'radiogroup', fieldLabel: '사용자등급', id:'is_managerCR',
					itemCls: 'x-radio-group-alt', columns: 2, values:['Y'],
					items: [
				        {boxLabel: '전체관리자', inputValue:'Y', name:'is_manager'},
				        {boxLabel: '규정담당자', inputValue:'N', name:'is_manager'},
				        {boxLabel: '감사팀권한', inputValue:'G', name:'is_manager'}
					]
				},
				{xtype:'combo', width:250, fieldLabel:'소속부서',name:'deptName',id:'deptNameCR',
					typeAhead: true, triggerAction: 'all', lazyRender:true, editable:false,
					store:dsDept,displayField:'deptName',valueField:'codeId',
					listeners:{
						beforerender:function(){
							dsDept.on('beforeload', function(){
								dsDept.baseParams = {
									job:'getDeptName'
								}
							});
						},
						select:function(cb, data, idx){
							Ext.getCmp('codeIdCR').setValue(data.get('codeId'));
						}
					}
				},
				Email,
				{xtype:'hidden',name:'deptcd', id:'codeIdCR'},
				{xtype:'hidden',name:'position', id:'teamname'}
			]
		}

	});
	
	
	//페이지 로딩후 실행
	wewonGridStore.load({
		params:{
			job: 'selectWewonList',
			gridGbn : 'present',
			start:0, 
			limit:pageSize
		}
	});
    
});

	
		