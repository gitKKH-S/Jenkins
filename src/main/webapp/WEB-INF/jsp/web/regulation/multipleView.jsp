<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019-05-31
  Time: 오후 4:29
  To change this template use File | Settings | File Templates. 
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<html>
<head>
    <title>동시보기</title>
    <link rel="stylesheet" href="${resourceUrl}/mnview/css/font-awesome-4.7.0/css/font-awesome.min.css">
    <link href="${resourceUrl}/mnview/css/regulationView.css" rel="stylesheet" type="text/css" media="screen">
    <link href="${resourceUrl}/mnview/css/button.css" rel="stylesheet" type="text/css" media="screen">
	<link rel="stylesheet" href="${resourceUrl}/mnview/css/view13pt.css">
	<link rel="stylesheet" href="${resourceUrl}/mnview/css/viewEtc.css">
	
    <link rel="stylesheet" type="text/css" href="${resourceUrl}/mnview/css/extgrid.css" />
    <script src="${resourceUrl}/PDFObject-master/pdfobject.min.js" type="text/javascript"></script>
    <style>
    	.docBon{
    		float:left;
    		width:49.8%;
    		height:90%;
    		border:#CCC 1px solid;
    		padding : 10px;
    	}
    </style>
    <script>
    function setFrame(){
        var conHeight = window.innerHeight - 50;
        var cnt = $("#wmain").children().length;
        if(cnt ==1){
        	cnt = 20+(10*(cnt-1));	
        }else{
        	cnt = 20+(5*(cnt-1));
        }
         
        var conWidth = window.innerWidth - cnt;
        $(".docBon").css('height', conHeight);
        $(".docBon").css('width', conWidth/$("#wmain").children().length);
        
        var height = window.innerHeight;
    	$('.innerbody').css('height',height-152);
    	$("form[name='HwpControl']").css("height",height-122);
    }
    function ViewBon(BOOKID,viewid,TITLE,NOFORMYN){
        $.ajax({
            url : "${pageContext.request.contextPath}/web/regulation/bonPop.do",
            dataType : "html",
            type : "POST",  // post 또는 get
            data : { bookid:BOOKID, NOFORMYN:NOFORMYN},   // 호출할 url 에 있는 페이지로 넘길 파라메터
            success : function(result){
                //overflow-y: scroll;align-items:center;display:flex;flex-direction:column; justify-content: flex-start;
            
            	var selectbox = "<select hkk='"+viewid+"' hkk2='"+TITLE+"' class='historys' style='float:left;margin-top:10px;border:#CCC 1px solid;'>";
            	$.ajax({
                    url : "${pageContext.request.contextPath}/web/regulation/historyListSelect.do",
                    dataType : "json",
                    type : "post",  // post 또는 get
                    async: false,
                    data : { bookid : BOOKID},   // 호출할 url 에 있는 페이지로 넘길 파라메터
                    success : function(data){
                    	var sdata = data.history;
                    	var option = "";
                    	for(var i=0; i<sdata.length; i++){
                    		var selected= "";
                    		if(BOOKID == sdata[i].BOOKID){
                    			selected = "selected";
                    		}
                    		option = option + "<option value='"+sdata[i].BOOKID+sdata[i].NOFORMYN+"' "+selected+">"+sdata[i].REVCHA+"차 "+sdata[i].REVCD+" "+sdata[i].PROMULDT+"</option>";
                    	}
                    	selectbox = selectbox+option+"</select>";
                    	if(NOFORMYN=='N'){
                    		$("#"+viewid).html(selectbox+"<div class=\"wclose\" style=\"cursor:pointer;float:right;padding:3px;\">x</div>"+result);
                            $("#"+viewid).css("overflow-y","auto");
                            
                            var height = window.innerHeight;
                        	$('.innerbody').css('height',height-152);	
                    	}else{
                    		if($.trim(result).toUpperCase().indexOf("HWP")>-1 || $.trim(result).toUpperCase().indexOf("DOC")>-1){
                    			$.ajax({
                    	            url : '${pageContext.request.contextPath}/bylaw/adm/goHwp.do',
                    	            dataType : "html",
                    	            type : "post",  // post 또는 get
                    	            data : { fileName : $.trim(result)},   // 호출할 url 에 있는 페이지로 넘길 파라메터
                    	            success : function(hwpbon){
                    	            	$("#"+viewid).html(selectbox+"<div class=\"wclose\" style=\"cursor:pointer;float:right;padding:3px;\">x</div><p class='title'>"+TITLE+"</p>"+hwpbon);
                    	            	var height = window.innerHeight;
                    	            	$("form[name='HwpControl']").css("height",height-122);
                    	            }
                    	        });
                    		}else if($.trim(result).toUpperCase().indexOf("PDF")>-1){
                    			$("#"+viewid).html(selectbox+"<div class=\"wclose\" style=\"cursor:pointer;float:right;padding:3px;\">x</div><p class='title'>"+TITLE+"</p><form id='f"+viewid+"' name='HwpControl'></form>");
                    			var height = window.innerHeight;
                    			var options = {
                    				    height : height-122,
                    					page : '2',
                    					pdfOpenParams : {
                    						view : 'FitV',
                    						pagemode : 'thumbs'
                    					}
                    				};
                    			PDFObject.embed("${pageContext.request.contextPath}/dataFile/law/attach/"+$.trim(result), "#f"+viewid);
                    			$("form[name='HwpControl']").css("height",height-122);
                    		}else{
                    			$("#"+viewid).html("<div id='innerbody' style='padding:50px;'>미리보기를 지원하지 않는 파일 형식 입니다.</div>");
                    		}
                    		
                    	}
                    	
                    }
            	});
            	
            	
                $("#schmodal").hide();
            }
        });
    }
    var findWordInPage;
    var gridCodeMan;
    Ext.QuickTips.init();
    $(window).load(function(){
    	var xg = Ext.grid;
		var myRecordObj = Ext.data.Record.create([
		                                      {name: 'BOOKID'},
		                                      {name: 'OBOOKID'},
		                                      {name: 'CATID'},
		                                      {name: 'BOOKCD'},
		                                      {name: 'BOOKCODE'},
		                                      {name: 'TITLE'},
		                                      {name: 'REVCD'},
		                                      {name: 'REVCHA'},
		                                      {name: 'PROMULDT'},
		                                      {name: 'STARTDT'},
		                                      {name: 'NOFORMYN'}
		                                      ]);
		
		var dsCode = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				type: 'rest',
				url: '${pageContext.request.contextPath}/bylaw/adm/schList.do'
			}),
			listeners: {
		        load: function(store, records, success) {
		        	
		        }
			},
			sorters: [
			          {
			              property : 'TITLE',
			              direction: 'DESC'
			          }
			      ]
			,
			reader: new Ext.data.JsonReader({
				root: 'data.slist',  totalProperty: 'total', idProperty: 'BOOKID'
			},
			myRecordObj
			)
		});
		
		var cmm = new xg.ColumnModel({
			columns:[
					new Ext.grid.RowNumberer({width: 30}),		//줄번호 먹이기
					{header:"규정명", width:555, dataIndex:'TITLE',sortable: true},
					{header:"제개정", width:65, dataIndex:'REVCD',sortable: true},
					{header:"개정일", width:130, dataIndex:'PROMULDT',sortable: true}
				]
		});
		gridCodeMan = new xg.GridPanel({
			id : "hkk",
			renderTo:'mContents',
			store:dsCode,
			autoWidth:true,
			overflowY: 'hidden',
			scroll:false,
			height: 593,
			cm:cmm,
			loadMask:{
				msg:'로딩중입니다. 잠시만 기다려주세요...'
			},
			stripeRows:true,
			viewConfig:{
				forceFit:true,
				enableTextSelection : true,
				emptyText: '<h1>관련데이터가 등록되어 있지 않습니다.</h1>'        
			},
	        iconCls: 'icon-grid',
			listeners: {
				rowcontextmenu:function(grid, idx, e){
					var selModel=grid.getSelectionModel();
					selModel.selectRow(idx);
					var rowData = selModel.getSelected();
				},
				rowclick:function(grid, idx, e){
					var selModel=grid.getSelectionModel();
					selModel.selectRow(idx);
					var rowData = selModel.getSelected();
					var BOOKID = rowData.get("BOOKID");
					var NOFORMYN = rowData.get("NOFORMYN");
					var TITLE = rowData.get("TITLE");
					var $div = $('<div id="B'+BOOKID+'" class="docBon" style="margin-left:5px;"><div class="wclose" style="cursor:pointer;float:right;padding:3px;">x</div></div>');
		            $("#wmain").append($div);
		            setFrame();
		           
		            ViewBon(BOOKID,"B"+BOOKID,TITLE,NOFORMYN);
		            
		            $("#schmodal").hide();
		            
		            $("form[name='HwpControl']").css("display","block");
				},
				cellclick: function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					
				},
				contextmenu:function(e){
					e.preventDefault();
				},
				//cellcontextmenu : ( Grid this, Number rowIndex, Number cellIndex, Ext.EventObject e )
				cellcontextmenu:function(grid, idx, cIdx, e){
					e.preventDefault();
				}
			}
		});
		
        setFrame();
        ViewBon($("#BOOKID",opener.document).val(),"mainbon",$("#TITLE",opener.document).val(),$("#NOFORMYN",opener.document).val());
        
        $('#addwin').click(function () {
            var $div = $('<div class="docBon" style="margin-left:5px;"><div class="wclose" style="cursor:pointer;float:right;padding:3px;">x</div></div>');
            $("#wmain").append($div);
            setFrame();
        });
        
        $("#wmain").on("click",".docBon .wclose",function(){
        	$(this).parent().remove();
        	setFrame();
        })
        
        $("#wmain").on("change",".historys",function(){
        	var data = this.value;
        	var bookid = data.substring(0,data.length-1);
 			var noform = data.substring(data.length-1,data.length); 
        	 
			ViewBon(bookid,$(this).attr("hkk"),$(this).attr("hkk2"),noform);
        })
        
        $('#showSch').click(function () {
            $("#schmodal").show();
        });
        $('#hideSch').click(function () {
            $("#schmodal").hide();
            $("form[name='HwpControl']").css("display","block");
        });
        $('#schBtn').click(function () {
        	dsCode.on('beforeload', function(){
    			dsCode.baseParams = {
    					schtext : $("#schtext").val()
    			}
    		});
    		dsCode.load();
        });
        
        schStdrModal = function() {
        	
        	dsCode.on('beforeload', function(){
    			dsCode.baseParams = {
    					schtxt : $("#schtext").val(),
    					statecd : '현행'
    			}
    		});
    		dsCode.load();
        };
        
        findWordInPage = function(){
        	$("#schmodal").show();
        	$("#schtext").val($("#findWord").val());
        	dsCode.on('beforeload', function(){
    			dsCode.baseParams = {
    					schtxt : $("#schtext").val(),
    					statecd : '현행'
    			}
    		});
    		dsCode.load();
    		
            $("form[name='HwpControl']").css("display","none");
        }
    });
    $(window).resize(function() {
        setFrame();
    });
    function printJo(Bookid,Contid,cont,bcontid){
    	var Contno;
    	var Contsubno;
    	
    	cw=502;
    	 ch=320;
    	  //스크린의 크기
    	 sw=screen.availWidth;
    	 sh=screen.availHeight;
    	 //열 창의 포지션
    	 px=(sw-cw)/2;
    	 py=(sh-ch)/2;
    	 //창을 여는부분	
    	 if(cont.indexOf('bu')>0){
    		 var contarr = cont.split('bu');
    		 Contno = contarr[0].substring(3,contarr[0].length);
    		 //alert(contarr[1]);
    		 Contsubno = contarr[1];
    	 }else{
    		 Contno = cont.substring(3,cont.length);
    	 }
    	//var Contno = contno.substring(3,contno.length);
    	//alert(Contno);
    	property="left="+px+",top="+py+",width=502,height=320,scrollbars=yes,resizable=no,status=no,toolbar=no";
    	//form=document.revi;
    	window.open("${pageContext.request.contextPath}/web/regulation/printJoPop.do?bookid="+Bookid+"&Contid="+Contid+"&Contno="+Contno+"&Contsubno="+Contsubno+"&print=P"+"&bcontid="+bcontid, Bookid, property);
    }
    function downpage(Pcfilename,Serverfile,folder){
    	form=document.ViewForm;
    	form.Pcfilename.value=Pcfilename;
    	form.Serverfile.value=Serverfile;
    	form.folder.value=folder;
    	form.action="${pageContext.request.contextPath}/Download.do";
    	form.submit();
    }
    </script>
</head>
<form name="ViewForm" method="post">
  	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
</form>
<body style="margin:10px">
	<div class="funGroup">
	    <div class="funRight">
	        <a class="funBtn srch" onclick="findWordInPage()"><i class="fa fa-search" aria-hidden="true" style="padding-top: 4px;"></i></a>
	        <input type="text" class="funBtn" id="findWord" placeholder="검색어를 입력하세요." onkeypress="if(event.keyCode == 13) findWordInPage()">
	        
	        <a class="funBtn" onclick="findWordInPage()"><i class="fa fa-columns" aria-hidden="true"></i> 목록선택</a>
	    </div>
	</div>
    <div id="wmain">
        <div id="mainbon"  class="docBon"></div>
    </div>
    
    <div id="schmodal">
    	<div id="extgrid">
    		<div class="funGroup">
			    <div class="funLeft2">
	        		<input type="text" class="funBtn" style="float:left;" id="schtext" placeholder="검색어를 입력하세요."  onkeypress="if(event.keyCode == 13) schStdrModal()" >
	        		<a class="funBtn srch" id="schBtn" style="float:left;"><i class="fa fa-search" aria-hidden="true" style="padding-top: 4px;"></i></a>
			    </div>
			    <div class="funRight2">
			        <a class="funBtn" style="float:right;" id="hideSch" title="닫기" ><i class="fa" aria-hidden="true" >x</i></a>
			    </div>
			</div>
    		<div id="mContents" style="padding-top:5px;"></div>
    	</div>
    </div>
</body>
</html>
<style>
	#schmodal{
		position : fixed;
		top : 0px;
		margin : 0px;
		width:100%;
		height:100%;
		z-index:100;
		background:rgba(0,0,0,0.4);
		display:none;
	}
	#schmodal > div{
		position : fixed;
		top : 20%;
		left : 20%;
		width:800px;
		height:600px;
		z-index:100;
		background:white;
	}
</style>