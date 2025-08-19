var wewonGridStore;
Ext.onReady(function(){ 

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
	wewonGridStore = new Ext.data.Store ({
		id:'p_ds',
		proxy: new Ext.data.HttpProxy({
			url: CONTEXTPATH+'/bylaw/commitee/selectWewonList.do'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result', totalProperty: 'total', idProperty: 'wewonInfoId'
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
	wewonGrid = new Ext.grid.EditorGridPanel({
		id:'p_grid2',
		region: 'west',
		store:wewonGridStore,
		width:250,
		collapsible: true, 
        stripeRows : true,
        margins:'0 5 0 0',
		view: gridView,
		cm:new Ext.grid.ColumnModel({
			columns:[
				{header:"이름", width:80, dataIndex:'USERNAME'},
				{header:"부서", width:90, dataIndex:'DEPTNM'},
				{header:"역할", width:70, dataIndex:'WEWONGBN'}
			]
		}),
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		viewConfig:{
			forceFit:true
		},
        title: '위원'
		
	});

    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [
			new Ext.BoxComponent({ // raw
	            region: 'north',
	            el: 'topMenuHolder',
	            height: 75
	        }),
	        wewonGrid,
	        {
	        	region: 'center',
	        	html:'<iframe id="content" name="content" src="commissionList.do" frameborder="0" style="width:100%;height:100%;padding:10px;" scrolling="yes"></iframe>'
	        }
		]
    });
    
	//페이지 로딩후 실행
	wewonGridStore.load({
		params:{
			job: 'selectWewonList',
			start:0, 
			limit:100,
			gridGbn:'present'
		}
	});
	
	window.onresize = resetHeight;
    function resetHeight(){
    	document.getElementById("content").style.height = viewport.getHeight()-50;
    }
    resetHeight();
}); 
	
		