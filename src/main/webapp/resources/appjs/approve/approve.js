var gridUserListStore;
Ext.onReady(function(){
    	// Generic fields array to use in both store defs.
    	var fields = [
    	   {name: 'EMP_NM', mapping : 'EMP_NM'},
    	   {name: 'EMP_NO', mapping : 'EMP_NO'},
    	   {name: 'DEPT_NM', mapping : 'DEPT_NM'},
    	   {name: 'JBGD_NM', mapping : 'JBGD_NM'}
    	];
        gridUserListStore = new Ext.data.Store({
    		proxy:new Ext.data.HttpProxy({
    			url:CONTEXTPATH+'/web/getUserList.do'
    		}),
    		reader:new Ext.data.JsonReader({root:'records'},['EMP_NM','DEPT_NM','EMP_NO','JBGD_NM','GDEPTID','GDEPT'])
    	});

    	// Column Model shortcut array
    	var cols = [
    	    { id : 'dept' ,header: "부서명", sortable: true, dataIndex: 'DEPT_NM'},
    		{ id : 'name', header: "성 명",align :"center", sortable: true, dataIndex: 'EMP_NM'},
    		{header: "직급", sortable: true, dataIndex: 'JBGD_NM'}
    	];

    	// declare the source Grid
        var userListgrid = new Ext.grid.GridPanel({
        	id : 'mten',
    		ddGroup          : 'gridDDGroup',
            store            : gridUserListStore,
            columns          : cols,
    		enableDragDrop   : true,
            stripeRows       : true,
            autoExpandColumn : 'dept',
            width            : 435, 
            height           : 328,
    		//region           : 'west',
            hideHeaders: true,
            title            : '직원 목록',
            iconCls          : 'icon_perlist',
    		selModel         : new Ext.grid.RowSelectionModel({singleSelect : true}),
    		renderTo : 'grid',
    		tbar:[
    			{xtype:'textfield',width:160,fieldLabel:'search',name:'schText',id:'schText', emptyText:'부서명이나 이름을 입력해주세요...',enableKeyEvents:true,
    				listeners:{
    				keydown :function(el, e){
    					if(e.getKey() == 13) {
    						var schTxt = Ext.getCmp('schText').getValue();
    						goSchUser(schTxt);
    					}
    				}
    			}},'->',
    			new Ext.Button ({
    				id:'butSch', text:'<b>검색</b>',
    				listeners:{
    					click:function(btn, eObj){
    						var schTxt = Ext.getCmp('schText').getValue();
    						goSchUser(schTxt);
    					}
    				}
    			}),
    			new Ext.Button ({ 
    				id:'btnCls', text:'<b>닫기</b>',
    				listeners:{
    					click:function(btn, eObj){
    						$("#panel").hide();
    						$("#detptree").empty();
    					}
    				}
    			}),
    			
    		],
    		listeners:{
				rowclick:function(grid, idx, e){
					var selModel= grid.getSelectionModel();
					var histData = selModel.getSelected();
					var userName = histData.get('EMP_NM');
					var userNo = histData.get('EMP_NO');
					var deptNo = histData.get('GDEPTID');
					var deptName = histData.get('GDEPT');
					var insertV = true;
					
					$('input[name="signerid"]').each(function(index, element) {
						var value = $(element).val(); // jQuery 감싸서 사용 가능
						if(userNo==value){
							alert('이미 선택한 결재자입니다.');
							insertV = false;
						}
					});
					
					if(insertV){
						$(selObj).closest('tr').find('input[name="signer"]').val(userName);
						$(selObj).closest('tr').find('input[name="signerid"]').val(userNo);
						$(selObj).closest('tr').find('input[name="gdeptid"]').val(deptNo);
						$(selObj).closest('tr').find('input[name="gdept"]').val(deptName);
						$("#panel").hide();
						$("#detptree").empty();
					}
				}
			}
        });




	document.getElementById("ext-gen27").style.width = "140px";
});

function goSchUser(schTxt){
	 gridUserListStore.on('beforeload', function(){
		gridUserListStore.baseParams = {
			schTxt : schTxt
		}
	});
	gridUserListStore.load({
		params:{
		
		}
	});
}
