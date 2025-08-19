<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.mten.util.*"%>
<style type=text/css>
/* style rows on mouseover */
.x-grid3-row-over .x-grid3-cell-inner {
	font-weight: bold;
}
*{
	font-family: "돋움", "굴림";
}
.adviceMsg {
	font-size:12px;
	font-weight:bold;
	color:#666;
	text-align:center;
}
</style>

<script src="${pageContext.request.contextPath}/webjars/jquery-ui/1.11.4/jquery-ui.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/jquery-ui/1.11.4/jquery-ui.min.css">
<script>
$(document).ready(function() {
	
});

Ext.onReady(function(){
	//DATA Holder
	
	var pageno = 1;
	var pageSize = 15;
	
	
	var POPUP_MNG_NO;
	var POPUP_TTL;
	var POPUP_CN;
	var gbn;

	var buttonHolder;		//하단 버튼
	var gridPop;			//popup 그리드
	var sch1dan;			//1단 서치폼
	var popSel;				//selection model
    var popList; 			//데이터소스
    
    var xg = Ext.grid;		//shortCut
    var win2;				//팝업등록창
    
    popList = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: '${pageContext.request.contextPath}/bylaw/popmn/selectPopList.do'
		}),
		reader: new Ext.data.JsonReader({
			root: 'result', totalProperty: 'total', idProperty: 'POPUP_MNG_NO'
		}, ['POPUP_MNG_NO', 'POPUP_TTL','POPUP_CN','POPUP_PSTG_BGNG_YMD','POPUP_PSTG_END_YMD']),
		autoLoad:true
	});
    
    popList.on('beforeload', function(){
    	popList.baseParams = {
			start:0,
			limit:pageSize
		};
	});
    
    function clearFileUpload(id){
        // get the file upload element
        fileField     = document.getElementById(id);
        // get the file upload parent element
        parentNod     = fileField.parentNode;
        // create new element
        tmpForm        = document.createElement("form");
        parentNod.replaceChild(tmpForm,fileField);
        tmpForm.appendChild(fileField);
        tmpForm.reset();
        parentNod.replaceChild(fileField,tmpForm);
    }
    
    var saveBtn = new Ext.Button({
		id:'saveBtn',
        text:'  저 장 ',
        iconCls:'icon_save',
        formBind: true,
        width:60,
        handler:function(){ 
        	popInsert.getForm().submit({
                    method:'POST',
                    enctype:'multipart/form-data',
                    fileUpload:true,
                    params: {
                    	job:'insertPop'
	                },
		            waitTitle:'Connecting',
                    waitMsg:'자료를 저장중입니다....',

                    success:function(form, action){
                    	Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
						   if (btn == 'ok'){
							   popList.load({
									params:{
										start:0,
										limit:pageSize
									}
								});
							   popInsert.getForm().reset();
							   clearFileUpload('popFile');
							   win2.hide();
                           }
					    });
                    },
                    failure:function(form, action){
                        if(action.failureType == 'server'){
                            obj = Ext.util.JSON.decode(action.response.responseText);
                            Ext.Msg.alert('Login Failed!', obj.errors.reason);
                        }else{
                            Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText);
                        }
                        popInsert.getForm().reset();
                    }
                });//rmInsert_submit()
        }//handler
	})
	var popInsert = new Ext.FormPanel({
        labelWidth:80,
        id : 'formW',
        url:'${pageContext.request.contextPath}/bylaw/popmn/insertPop.do',
        enctype:'multipart/form-data',
        frame:true,
        width:385,
        autoHeight:true,
        defaultType:'textfield',
    	monitorValid:true,
    	fileUpload:true,
        items:[
            {xtype: 'textfield', fieldLabel:'제목',id:'POPUP_TTL', name: 'POPUP_TTL', allowBlank:false,width:280},
        	{xtype: 'textarea', fieldLabel:'내용',id:'POPUP_CN', name: 'POPUP_CN', allowBlank:false,width:280,height:120},
       		{xtype: 'datefield', fieldLabel:'시작일',id:'POPUP_PSTG_BGNG_YMD', name: 'POPUP_PSTG_BGNG_YMD', format : 'Y-m-d',width:280},
       		{xtype: 'datefield', fieldLabel:'종료일',id:'POPUP_PSTG_END_YMD', name: 'POPUP_PSTG_END_YMD', format : 'Y-m-d', width:280},
       		{xtype: 'textfield', fieldLabel:'width',id:'POPUP_WDTH_SZ', name: 'POPUP_WDTH_SZ', allowBlank:false,width:280,value:180},
       		{xtype: 'textfield', fieldLabel:'height',id:'POPUP_VRTC_SZ', name: 'POPUP_VRTC_SZ', allowBlank:false,width:280,value:230},
       		{
           		enctype:'multipart/form-data', allowBlank:true,
                id :'popFile', inputType :'file', name :'popFile', fieldLabel :'첨부파일',
                blankText :'Please choose a file',
                anchor :'99%', required :true, autoShow :true,
                xtype :'textfield'
        	},
        	{xtype:'hidden',name:'POPUP_MNG_NO', id:'POPUP_MNG_NO',value:''},
        	{xtype:'hidden',name:'FILE_MNG_NO', id:'FILE_MNG_NO',value:''},
        	{xtype:'hidden',name:'SRVR_FILE_NM', id:'SRVR_FILE_NM',value:''},
        	{xtype:'displayfield',fieldLabel:'첨부파일',name:'fName', id:'fName',value:''}
        ]
   	 });
	
	var dellButt = new Ext.Button({
		id:'but_dell',
		text:'  삭 제 ',iconCls:'icon_del',width:60,
		handler:function(){
			Ext.MessageBox.wait('데이터를 삭제중입니다...','Wait',{interval:100, text:'서버에서 데이터 삭제중 ...'});
			Ext.Ajax.request({
				url: '${pageContext.request.contextPath}/bylaw/popmn/deletePop.do',
				params: {
					POPUP_MNG_NO:Ext.getCmp('POPUP_MNG_NO').getValue() 
				},
				success: function(res, opts){
					Ext.MessageBox.alert('성공','데이터가 삭제 되었습니다.');
					popList.load({
						params:{
							start:0,
							limit:pageSize
						}
					});
					popInsert.getForm().reset();
					win2.hide();
				},
				failure: function(res, opts){
					Ext.MessageBox.alert('실패','서버와의 연결상태가 좋지 않습니다.');
				}
			});
		}
	});
	
	var saveButt = new Ext.Button({
		id:'tb_mnPop',
		text:'<b>팝업창 등록</b>', iconCls:'icon_save',
		handler:function(){
		    win2 = new Ext.Window({
			title: '<b>팝업창 등록</b>',
			closable:true,
			closeAction:'hide',
			width:400,
			autoHeight:true,
			items: [popInsert],
			buttons:[saveBtn],
			plain:true, modal:true
		 })
		    Ext.getCmp('fName').hide();
		    popInsert.getForm().reset();
		    Ext.getCmp('POPUP_WDTH_SZ').setValue('180');
			Ext.getCmp('POPUP_VRTC_SZ').setValue('230');
			win2.show('div');
		}
	});
	
	buttonHolder = new Ext.Toolbar({
		renderTo:'buttonHolder',
		autoHeight:true,width:616,
		items:[
			{xtype: 'tbfill'},
			saveButt
		]
	});
	
	


//////////////////////////////////////////
//	그리드 설정
//////////////////////////////////////////
	//규정 그리드
	gridPop = new xg.GridPanel({
		renderTo:'gridPop',
		store:popList,
		cm:new xg.ColumnModel({
			columns:[
//				new Ext.grid.RowNumberer(),		//줄번호 먹이기
				{header:"제목", width:140,dataIndex:'POPUP_TTL'},
				{header:"시작일", width:80, dataIndex:'POPUP_PSTG_BGNG_YMD'},
				{header:"종료일", width:80, dataIndex:'POPUP_PSTG_END_YMD'}
			]
		}),
		loadMask:{
			msg:'로딩중입니다. 잠시만 기다려주세요...'
		},
		stripeRows:true,
		bbar:new Ext.PagingToolbar({
			pageSize:15, 
			store: popList,
			displayInfo:true, 
			displayMsg:'전체 {2}의 결과중 {0} - {1}',
			emptyMsg:"검색된 결과가 없습니다."
		}),
		viewConfig:{
			forceFit:true
		},
		width:616,height:461,
        iconCls: 'icon-grid',
		listeners:{
			rowclick:function(grid, idx, e){
				var selModel= grid.getSelectionModel();
				var histData = selModel.getSelected();
				var POPUP_MNG_NO = histData.get('POPUP_MNG_NO');
				Ext.Ajax.request({
				     url:'${pageContext.request.contextPath}/bylaw/popmn/selectView.do',
				     params:{
						POPUP_MNG_NO:POPUP_MNG_NO
				     },
				     success:function(res,opts){
						result=Ext.util.JSON.decode(res.responseText);
						win2 = new Ext.Window({
							title: '<b>팝업창 수정</b>',
							closable:true,
							closeAction:'hide',
							width:400,
							autoHeight:true,
							items: [popInsert], 
							buttons:[saveBtn,dellButt],
							plain:true, modal:true
						 })
							win2.show('div');
						Ext.getCmp('POPUP_TTL').setValue(result.POPUP_TTL);
						Ext.getCmp('POPUP_CN').setValue(result.POPUP_CN);
						Ext.getCmp('POPUP_PSTG_BGNG_YMD').setValue(result.POPUP_PSTG_BGNG_YMD);
						Ext.getCmp('POPUP_PSTG_END_YMD').setValue(result.POPUP_PSTG_END_YMD);
						Ext.getCmp('POPUP_WDTH_SZ').setValue(result.POPUP_WDTH_SZ);
						Ext.getCmp('POPUP_VRTC_SZ').setValue(result.POPUP_VRTC_SZ);
						Ext.getCmp('POPUP_MNG_NO').setValue(result.POPUP_MNG_NO);
						Ext.getCmp('FILE_MNG_NO').setValue(result.FILE_MNG_NO);
						Ext.getCmp('SRVR_FILE_NM').setValue(result.SRVR_FILE_NM);
						Ext.getCmp('fName').setValue("<a href=\"javascript:downpage(\'"+result.PHYS_FILE_NM+"\',\'"+result.SRVR_FILE_NM+"\',\'BBS\')\">"+result.PHYS_FILE_NM+"</a>");
						Ext.getCmp('popFile').setValue('');
						
						if(result.PHYS_FILE_NM){
							Ext.getCmp('fName').show();	
						}else{
							Ext.getCmp('fName').hide();
						}
						
				     },
				     failure:function(){
				    	 alert('DB에러 발생');
				     }
				});
			},
			render:function(obj){
				popList.on('beforeload', function(){
					popList.baseParams = {
							start:0,
							limit:pageSize
		    		}
				}),
				popList.load({
				})
			}
		}
	});
});
function downpage(PHYS_FILE_NM,SRVR_FILE_NM,folder){
	form=document.forms[0];
	form.PHYS_FILE_NM.value=PHYS_FILE_NM;
	form.SRVR_FILE_NM.value=SRVR_FILE_NM;
	form.folder.value=folder;
	form.action="${pageContext.request.contextPath}/Download.do";
	form.submit();
}
</script>
<form name="fView" method="post">
	<input type="hidden" name="SRVR_FILE_NM"/>
	<input type="hidden" name="PHYS_FILE_NM"/>
	<input type="hidden" name="folder"/>
</form>	
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
		<div id="gridPop"></div>
		</td>
	</tr>
</table>
<div id="buttonHolder"></div>