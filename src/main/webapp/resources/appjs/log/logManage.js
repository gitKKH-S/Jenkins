
Ext.onReady(function(){
	var pageno = 1;
	var pagesize = 30;
	
	
    var xg = Ext.grid;		//shortCut
    
    var logListData = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH + '/bylaw/log/selectLogList.do'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result', totalProperty: 'total', idProperty: 'LOG_MNG_NO'
		}, ['LOG_MNG_NO', 'LOG_CRT_DT','LOG_SE','ACSR_NM','ACSR_NO','ACSR_DEPT_NO','ACSR_DEPT_NM','ACSR_IP_ADDR','LOG_CRT_URL_ADDR','TRSM_ARTCL_CN','RMRK_CN']),
		autoLoad:true
	});

    logListData.on('beforeload', function(){
    	logListData.baseParams = {
			start:0,
			limit:pagesize,
			pagesize:pagesize
		};
	});
    
    var gridLog = new xg.GridPanel({
		store:logListData,
		cm:new xg.ColumnModel({
			columns:[
//				new Ext.grid.RowNumberer(),		//줄번호 먹이기
				{header:"접속일", dataIndex:'LOG_CRT_DT'},
				{header:"메뉴구분", width:80, dataIndex:'LOG_SE'},
				{header:"접속자명", width:80, dataIndex:'ACSR_NM'},
				{header:"접속자사번", width:80, dataIndex:'ACSR_NO'},
				{header:"접속자부서", width:80, dataIndex:'ACSR_DEPT_NM'},
				{header:"접속자부서코드", width:80, dataIndex:'ACSR_DEPT_NO'},
				{header:"접속자아이피", width:80, dataIndex:'ACSR_IP_ADDR'},
				{header:"접속경로", width:80, dataIndex:'LOG_CRT_URL_ADDR'},
				{header:"상세정보", width:80, dataIndex:'RMRK_CN'},
				{header:"접속파라미터", width:80, dataIndex:'TRSM_ARTCL_CN'}
			]
		}),
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		
		tbar:[
			{xtype: 'radiogroup', fieldLabel: '구분', id:'mgbn',width:300,
				 columns: 6, value:['ALL'],
				items: [
			        {boxLabel: '전체',    inputValue:'ALL',     name:'mgbn'}
			        ,{boxLabel: '소송',   inputValue:'suit',    name:'mgbn'}
			        ,{boxLabel: '자문',   inputValue:'consult', name:'mgbn'}
			        ,{boxLabel: '협약',   inputValue:'agree',   name:'mgbn'}
			        ,{boxLabel: '게시판', inputValue:'pds',     name:'mgbn'}
			        ,{boxLabel: '외부',   inputValue:'out',     name:'mgbn'}
			        ,{boxLabel: '로그인', inputValue:'login',   name:'mgbn'}
				],
				listeners: {
	                change: function(radiogroup, radio){
	                	logListData.load({
	                		params:{
	                			start:0, limit:pagesize,pagesize:pagesize,
	                			mgbn:radio.inputValue,
	                			schtxt : Ext.getCmp('schText').getValue(),
	                			stitle : 'Y'
	                		}
	                	});     
	                }
	            }

			},'->',
  			{xtype:'textfield',width:180,fieldLabel:'search',name:'schText',id:'schText', emptyText:'검색어를 입력하시기 바랍니다....',enableKeyEvents:true,
  				listeners:{
  				keydown :function(el, e){
  					if(e.getKey() == 13) {
  						var schTxt = Ext.getCmp('schText').getValue();
  						logListData.load({
  							params:{
  								start:0, limit:pagesize,pagesize:pagesize,
  								mgbn:Ext.getCmp('mgbn').getValue().getGroupValue(),
  								Schtxt : schTxt,
  								stitle : 'Y'
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
  						logListData.load({
  							params:{
  								start:0, limit:pagesize,pagesize:pagesize,
  								mgbn:Ext.getCmp('mgbn').getValue().getGroupValue(),
  								Schtxt : schTxt,
  								stitle : 'Y'
  							}
  						});
  					}
  				}
  			}),'-'
  		],
  		
		bbar:new Ext.PagingToolbar({
			pagesize:pagesize, 
			store: logListData,
			displayInfo:true, 
			displayMsg:'전체 {2}의 결과중 {0} - {1}',
			emptyMsg:"검색된 결과가 없습니다."
		}),
		viewConfig:{
			forceFit:true
		},
		region: 'center',
        iconCls: 'icon-grid',
		listeners:{
			rowclick:function(grid, idx, e){
			},
			render:function(obj){
				logListData.on('beforeload', function(){
					logListData.baseParams = {
							start:0,
							limit:pagesize,
							pagesize:pagesize,
							mgbn:'ALL'
		    		}
				}),
				logListData.load({
				})
			}
		}
	});
    
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [new Ext.BoxComponent({ // raw
            region: 'north',
            el: 'topMenuHolder',
            height: 75
        }), gridLog
		]
    });
});
