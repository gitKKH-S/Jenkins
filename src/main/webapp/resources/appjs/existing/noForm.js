var noFormDoc;
var formCreat;
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	noFormDoc= function(pstate){
		var node = tree.getSelectionModel().getSelectedNode();
		var catId = node.attributes.catId;
		var Bookid = node.attributes.bookId;
		var Pcatid = node.attributes.pCatId;
		var Ord = node.attributes.ord;
		var result;
		if(pstate!='I'){
			Ext.Ajax.request({
				url : CONTEXTPATH + '/bylaw/adm/getDocInfo.do',
				params : {
					Bookid : Bookid
				},
				success : function(res, opts) {
					result = Ext.util.JSON.decode(res.responseText);
					formCreat(result.data, pstate, catId, Bookid, Pcatid);
				},
				failure : function() {
					alert('DB에러 발생');
				}
			});
		}else{
			formCreat(result,pstate,catId,Bookid,result);
		}
	}
	
	//부서창고 
	var dsDept = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/bylaw/user/getDeptName.do'
		}),
		reader:new Ext.data.JsonReader({root:'result'},['deptName','codeId'])
	});
	//유저 창고
	var gridStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/bylaw/user/userList.do'
		}),
		reader:new Ext.data.JsonReader({root:'records'},['userNameCR','userNoCR','e_mailCR','deptNameCR','teamname','phone','codeIdCR'])
	});
	//유저 창고
	var bookcdStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:CONTEXTPATH+'/bylaw/code/getCodeList.do'
		}),
		reader:new Ext.data.JsonReader({root:'result'},['CODEID','CODE'])
	});
	formCreat = function(result,pstate,catId,Bookid,Pcatid){
		var node = tree.getSelectionModel().getSelectedNode();
		var path= node.getPath();
		var aB = false;
		var Bookcode,Title,Bookcd,Revcd,Revcha,Promulno,Promuldt,Startdt,Enddt,Statecd,Ord,Otherlaw,Deptname,Legislator,Obookid,username,userid,phone,grade,dept;
		var formTitle = '비정형문서 등록';
		var node = tree.getSelectionModel().getSelectedNode();
		var path = node.parentNode.getPath();
		var Docid = catId;
		if(pstate!='I'){
			Bookcode = result.BOOKCODE;
			Bookcd = result.BOOKCD;
			Title = result.TITLE;
			Revcd = result.REVCD;
			Revcha = result.REVCHA;
			Promuldt = result.PROMULDT;
			Startdt = result.STARTDT;
			Enddt = result.ENDDT;
			Ord = result.ORD;
			Otherlaw = result.OTHERLAW;
			Deptname = result.DEPTNAME;
			dept = result.DEPT;
			Obookid = result.OBOOKID;
			username = result.USERNAME;
			userid = result.USERID;
			phone = result.PHONE;
			Legislator = result.LEGISLATOR;
			grade = result.grade;
			if (Pcatid == '' || Pcatid == undefined) {
				Docid = result.Pcatid;
			} else {
				Docid = Pcatid;
			}
      

			if (pstate == 'U') {
				formTitle = Title + '문서정보 수정';
				aB = true;
			} else if (pstate == 'RE') {
				formTitle = Title + '개정';
				Revcha = Number(result.REVCHA) + 1;
				Promuldt = new Date();
				Startdt = new Date();
				Enddt = '9998-12-31';
				Revcd = '개정';
			}  else if (pstate == 'P') {
				formTitle = Title + '폐지';
				Revcha = Number(result.REVCHA) + 1;
				Promuldt = new Date();
				Startdt = new Date();
				Enddt = '9998-12-31';
				Revcd = '폐지';
			} else if (pstate == 'OLDADD'){
				formTitle = Title + Number(Number(result.REVCHA) - 1) + '차 연혁등록';
				Revcha = Number(result.REVCHA) - 1;
				Enddt = result.STARTDT;
				Statecd = '연혁';
				if (Revcha == '0') {
					Revcd = '제정';
				} else {
					Revcd = '개정';
				}
			}
		}else if(pstate=='I'){
			Revcha = 0;
			Promuldt = new Date();
			Startdt = new Date();
			Enddt = '9998-12-31';
			Revcd = '제정';
	    }

		var rmInsert = new Ext.FormPanel({
	        labelWidth:80,
	        url : CONTEXTPATH+'/bylaw/adm/noFormInsert.do',
	        enctype:'multipart/form-data',
	        frame:true,
	        width:385,
	        autoHeight:true,
	        defaultType:'textfield',
	    	monitorValid:true,
	    	fileUpload:true,
	    	items: {
	    		xtype:'fieldset',
	    		title:formTitle,
	        items:[
	            {
	        		xtype: 'textfield', fieldLabel:'규정명', name: 'title', value:Title, allowBlank:false,width:230
            	},
            	//{xtype: 'textfield', fieldLabel:'문서번호', name: 'Bookcode', value:Bookcode, allowBlank:false},
            	{xtype:'combo' ,fieldLabel:'규정구분' ,name:'bookcd' 
            	   ,store:bookcdStore,value:Bookcd
                   ,typeAhead: true, triggerAction: 'all', lazyRender:true, editable:false,allowBlank:false
                   ,displayField:'CODE',valueField:'CODE',emptyText:'규정구분선택...'
                   ,listeners:{
						beforerender:function(){
							bookcdStore.on('beforeload', function(){
								bookcdStore.baseParams = {
									codename:'BOOKCD'
									,limit : 20
								}
							});
						}
                   }
            	},
            	{
                xtype:'combo'
                    ,fieldLabel:'제개정구분'
                    ,name:'revcd',width:230
                    ,store:new Ext.data.SimpleStore({
                        id:0 ,fields:['file', 'locale']  ,data:[
                           ['제정', '제정'] ,['개정', '개정'] ,['전부개정', '전부개정'] ,['폐지', '폐지']
                       ]
                    })
                   ,mode:'local'  ,editable:false ,forceSelection:true ,valueField:'file'
                   ,displayField:'locale' ,triggerAction:'all' ,selectOnFocus:true ,value:Revcd
	            },{
		        xtype: 'textfield', fieldLabel:'개정차수', name: 'revcha', allowBlank:false, value:Revcha,width:230,readOnly:true
           		},
           		//{xtype: 'textfield', fieldLabel:'공포번호', name: 'Promulno', allowBlank:false, value:Promulno},
           		{
	        	xtype: 'datefield', fieldLabel:'공포일', name: 'promuldt', format : 'Y-m-d', value:Promuldt,width:230
	            },{
	        	xtype: 'datefield', fieldLabel:'시행일', name: 'startdt', format : 'Y-m-d', value:Startdt,width:230
	            },{
	        	xtype: 'datefield', fieldLabel:'종료일', name: 'enddt', format : 'Y-m-d', value:Enddt,width:230
	            },
				/****
	            {
                xtype:'combo' ,fieldLabel:'현행/연혁' ,name:'Statecd' ,
                store:new Ext.data.SimpleStore({
	                id:0 ,fields:['file', 'locale']
	               ,data:[
	                   ['입안', '입안'] ,['심의조정', '심의조정'],['현행', '현행'],['연혁', '연혁']
	               ]
	            })
	           ,mode:'local' ,editable:false ,forceSelection:true ,valueField:'file'
	           ,displayField:'locale' ,triggerAction:'all' ,selectOnFocus:true ,value:Statecd
	            },
	           
	            //{xtype: 'textfield', fieldLabel:'정렬순서', name: 'Ord', allowBlank:false, value:Ord	},
	            {
            	xtype: 'textfield', fieldLabel:'타법', name:'Otherlaw',  value:Otherlaw, width:230
            	},
            	 ******/
            	{xtype:'combo', width:230, fieldLabel:'소속부서',name:'deptname',id:'deptNameCR',
					typeAhead: true, triggerAction: 'all', lazyRender:true, editable:false,allowBlank:true,
					store:dsDept,displayField:'deptName',valueField:'codeId',emptyText:'부서선택...',value:userid,value:Deptname,
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
							gridStore.on('beforeload', function(){
    							gridStore.baseParams = {
    								job: 'userList',
    								Deptcd : Ext.getCmp('codeIdCR').getValue()
    							}
    						});
							gridStore.load({
    							params:{
    							}
    						});
							Ext.getCmp('usernameCR').setValue('');
							Ext.getCmp('userIdCR').setValue('');
							Ext.getCmp('phoneCR').setValue('');
						}
					}
				},
            	{xtype:'combo', width:230, fieldLabel:'담당자',name:'username',id:'usernameCR',
					typeAhead: true, triggerAction: 'all', lazyRender:true, editable:false,allowBlank:true,
					store:gridStore,displayField:'userNameCR',valueField:'userNoCR',emptyText:'담당자선택...',value:username,
					listeners:{
						beforerender:function(){
							gridStore.on('beforeload', function(){
								gridStore.baseParams = {
									job: 'userList',
    								Deptcd : Ext.getCmp('codeIdCR').getValue()
								}
							});
						},
						select:function(cb, data, idx){
							Ext.getCmp('userIdCR').setValue(data.get('userNoCR'));
							Ext.getCmp('phoneCR').setValue(data.get('phone'));
						}
					}
				},
				{xtype:'hidden',name:'dept', id:'codeIdCR',value:dept},
            	{xtype: 'hidden',name: 'userid', id:'userIdCR',value:userid},
            	{xtype: 'textfield', fieldLabel:'담당자연락처', name: 'phone', id: 'phoneCR', value:phone, width:230},
   	         	/*{
                    xtype:'combo'
                        ,fieldLabel:'자료등급'
                        ,name:'grade',width:230
                        ,store:new Ext.data.SimpleStore({
                            id:0 ,fields:['file', 'locale']  ,data:[
								['1', '1급 별도관리자료'] ,['2', '2급 중요보호자료'] ,['3', '3급 표준자료'] ,['4', '4급 보호자료']
								,['5', '5급 일반보호자료']
                           ]
                        })
                       ,mode:'local'  ,editable:false ,forceSelection:true ,valueField:'file'
                       ,displayField:'locale' ,triggerAction:'all' ,allowBlank:false,selectOnFocus:true ,value:grade
   	            },*/
            	/*{
                    xtype:'combo'
                        ,fieldLabel:'제·개정 방법'
                        ,name:'Legislator',width:230
                        ,store:new Ext.data.SimpleStore({
                            id:0 ,fields:['file', 'locale']  ,data:[
								['', ''] ,['내부결재', '내부결재'] ,['이사회의결', '이사회의결'] ,['주주총회의결', '주주총회의결']
                           ]
                        })
                       ,mode:'local'  ,editable:false ,forceSelection:true ,valueField:'file'
                       ,displayField:'locale' ,triggerAction:'all' ,selectOnFocus:true ,value:Legislator
   	            },*/
            	{
	           		enctype:'multipart/form-data', allowBlank:aB,
	                id :'file', inputType :'file', name :'bylawFile', fieldLabel :'제정문',
	                blankText :'Please choose a file',
	                anchor :'95%', required :true, autoShow :true,
	                //readOnly:true,
	                xtype :'textfield'
/***
		                ,
	                listeners:{
	                	blur:{fn:function(){
		                	if(Ext.getCmp('file').getValue()!=''){ 
								var frm2 = document.ViewForm;
								if(frm2.hwphtml.value == ''){
									frm2.folder.value = Ext.getCmp('file').getValue().replace(/\\/gi,"/");
									frm2.action="hiddenHtml.jsp";
									frm2.target="bonhtml";
									frm2.submit();
								}
		                	}else{
		                		return;
		                	}
	                	}}
            		}
***/
            	}
	            ]
		},
	        buttons:[{
	                text:'등록',
	                formBind: true,
	                width:70,
	                iconCls:'icon_save',
	                handler:function(){ 
	                	//if(document.ViewForm.hwphtml.value==''){
	                	//	return;
	                	//}
	        		rmInsert.getForm().submit({
	                        method:'POST',
	                        enctype:'multipart/form-data',
	                        fileUpload: true,
	                        params: {
	        					bookid:Bookid,
	        					pcatid: Docid,
	        					pstate:pstate,
	        					obookid:Obookid,
				    			state:'noForm',
				    			noformyn:'Y',
				    			ord:Ord//,
				    			//bonhtml:document.ViewForm.hwphtml.value
				              },
				              waitTitle:'Connecting',
		                        waitMsg:'자료를 저장중입니다....',

		                        success:function(form, action){

		                        	Ext.Msg.alert('Status', '등록을 성공했습니다!!', function(btn, text){
									   if (btn == 'ok'){
					                        obj = Ext.util.JSON.decode(action.response.responseText);
					                        var bookid = obj.key.bookid;
					                        var statehistoryid = obj.key.statehistoryid;
					                        Ext.getCmp('center').activate('center22');
					                        getDocInfo(bookid,'Y');
					                        tree.root.reload();
											tree.expandPath(path);
					                        win2.close();
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
	                            rmInsert.getForm().reset();
	                        }
	                    });
	                }
	            }]
	    });


		var win2 = new Ext.Window({
			title: '비정형문서 등록',
			  closable:true,
			  width:400,
			  autoHeight:true,
			  items: [rmInsert],
			  plain:true, modal:true,iconCls:'icon_rev'
			 })
		win2.show('div');
	}
})