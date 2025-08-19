	//파일 리스트 번호
	var fileIndex = 0;
	// 등록할 전체 파일 사이즈
	var totalFileSize = 0;
	// 파일 리스트
	var fileList = new Array();
	// 파일 사이즈 리스트
	var fileSizeList = new Array();
	// 등록 가능한 파일 사이즈 MB
	var uploadSize = 50;
	// 등록 가능한 총 파일 사이즈 MB
	var maxUploadSize = 500;

	var statusList = new Array();
	
	var yesList = new Array('hwp','doc','docx','ppt','pptx','xls','xlsx','pdf','png','jpg','jpeg','gif','zip','mp4','avi','mkv','mpg','flv','asf','mov','txt');
	
	var noList = new Array('exe', 'bat', 'sh', 'java', 'jsp', 'html', 'js', 'css', 'xml');
	
	var setstatusSel = 'N';
	
    $(document).ready(function(){
    	/*$.ajax({
            url : CONTEXTPATH+"/web/json/selectFilemn.do",
            dataType : "json",
            type : "post",  // post 또는 get
            data : {},   // 호출할 url 에 있는 페이지로 넘길 파라메터
            success : function(result){
            	uploadSize = result.ONEFILE;
            	maxUploadSize = result.ALLFILE;
            	var yesext = result.YESEXT;
            	var noext = result.NOEXT;
            	var yy = yesext.split(',');
            	yesList = new Array();
            	for ( var i in yy) {
            		if(typeof(yy[i])=='string'){
            			yesList.push(yy[i]);
                		try{
                			yesList.push(yy[i].toUpperCase());
                		} catch(e){
                			
                		}
            		}
            		//console.log("yesList===>"+yesList);
	            }
            	
            	var nn = noext.split(',');
            	noList = new Array();
            	for ( var i in nn) {
            		if(typeof(nn[i])=='string'){
            			noList.push(nn[i]);
                		try{
                			noList.push(nn[i].toUpperCase());
                		} catch(e){
                			
                		}
            		}
            		//console.log("noList===>"+noList);
	            }
            }
        });*/
    	
        var objDragAndDrop = $(".dragAndDropDiv");
        $(document).on("dragenter",".dragAndDropDiv",function(e){
            e.stopPropagation();
            e.preventDefault();
            $(this).css('border', '2px solid #0B85A1');
        });
        $(document).on("dragover",".dragAndDropDiv",function(e){
            e.stopPropagation();
            e.preventDefault();
        });
        $(document).on("drop",".dragAndDropDiv",function(e){
            $(this).css('border', '2px dotted #0B85A1');
            e.preventDefault();
            var files = e.originalEvent.dataTransfer.files;
            if(files != null){
                if(files.length < 1){
                    alert("폴더 업로드 불가");
                    return;
                }
                handleFileUpload(files,objDragAndDrop);
            }else{
                alert("ERROR");
            }
        });
        $(document).on('dragenter', function (e){
            e.stopPropagation();
            e.preventDefault();
        });

        $(document).on('dragover', function (e){
          e.stopPropagation();
          e.preventDefault();
          objDragAndDrop.css('border', '2px dotted #0B85A1');
        });

        $(document).on('drop', function (e){
            e.stopPropagation();
            e.preventDefault();
        });

        $("#filesel").on('change', function (e){
        	var fileName = e.target.files[0].name;
            if (fileName) {
            	handleFileUpload($('#filesel').prop('files'),objDragAndDrop);
            }
        });
        
        function handleFileUpload(files,obj)
        {
        	if($("#contid").val()==''){
        		alert("좌측에서 파일을 등록할 조를 선택하시기 바랍니다.");
        		return;
        	}
        	// 다중파일 등록
            if(files != null){
                for(var i = 0; i < files.length; i++){
                    // 파일 이름
                    var fileName = files[i].name;
                    var fileNameArr = fileName.split("\.");
                    // 확장자
                    var ext = fileNameArr[fileNameArr.length - 1];
                    // 파일 사이즈(단위 :MB)
                    var fileSize = files[i].size / 1024 / 1024;
                    
                    if($.inArray(ext, yesList) == -1){
                        // 확장자 체크
                        alert("등록 불가 확장자");
                        break;
                    }else if($.inArray(ext, noList) >= 0){
                        // 확장자 체크
                        alert("등록 불가 확장자");
                        break;
                    }else if(fileSize > uploadSize){
                        // 파일 사이즈 체크
                        alert("용량 초과\n업로드 가능 용량 : " + uploadSize + " MB");
                        break;
                    }else{
                    	if(fileIndex==0){
                    	}
                    	
                        // 전체 파일 사이즈
                        totalFileSize += fileSize;
                        
                        // 파일 배열에 넣기
                        fileList[fileIndex] = files[i];
                        
                        // 파일 사이즈 배열에 넣기
                        fileSizeList[fileIndex] = fileSize;
                        var status = new createStatusbar(obj); //Using this we can set progress.
                        status.setFileNameSize(files[i].name,files[i].size);
                        
                        statusList[fileIndex] = status;
                        // 업로드 파일 목록 생성
                        //addFileList(fileIndex, fileName, fileSize);
     
                        // 파일 번호 증가
                        fileIndex++;
                    }
                }
            }else{
                alert("ERROR");
            }
        	
        	
        	
           /*var form = $('#wform');
           var fd = new FormData(form);
           var other_data = $('#wform').serializeArray();
           $.each(other_data,function(key,input){
               fd.append(input.name,input.value);
           });
           var status = new Array();
          for (var i = 0; i < files.length; i++) 
          {
               
               fd.append('file'+i, files[i]);
               status.push(new createStatusbar(obj)); //Using this we can set progress.
               status[i].setFileNameSize(files[i].name,files[i].size);
               
          }
          sendFileToServer(fd,status);*/
          
        }

        var rowCount=0;
        function createStatusbar(obj){
        	var hkk = $(".hkk");
            rowCount++;
            var row="odd";
            if(rowCount %2 ==0) row ="even";
            this.statusbar = $("<div id='filedel"+(rowCount-1)+"' class='statusbar "+row+"'></div>");
            this.filename = $("<div class='filename'></div>").appendTo(this.statusbar);
            this.size = $("<div class='filesize'></div>").appendTo(this.statusbar);
            this.progressBar = $("<div style='width:90px;' class='progressBar'><div></div></div>").appendTo(this.statusbar);
            this.abort = $("<div class='abort'  onclick='deleteFile(" + (rowCount-1) + "); return false;'>삭제</div>").appendTo(this.statusbar);
            if(setstatusSel == 'Y'){
            	this.selBar = $("<div class=\"gbnBar\" style=\"width:30%\"><select id=\"filegbn\" onchange=\"setList(this.value,"+(rowCount-1)+")\"><option value=\"\">선택</option><option value=\"1\">준비서면</option><option value=\"2\">서증</option><option value=\"3\">보고자료</option></select></div>").appendTo(this.statusbar);
            }
            //obj.after(this.statusbar);
            
            this.statusbar.appendTo(hkk);
            
            this.setFileNameSize = function(name,size){
                var sizeStr="";
                var sizeKB = size/1024;
                if(parseInt(sizeKB) > 1024){
                    var sizeMB = sizeKB/1024;
                    sizeStr = sizeMB.toFixed(2)+" MB";
                }else{
                    sizeStr = sizeKB.toFixed(2)+" KB";
                }
                this.filename.html(name);
                this.size.html(sizeStr);
            }

            this.setProgress = function(progress){       
                var progressBarWidth =progress*this.progressBar.width()/ 100;  
                this.progressBar.find('div').animate({ width: progressBarWidth }, 10).html(progress + "% ");
                if(parseInt(progress) >= 100)
                {
                    this.abort.hide();
                }
            }

            this.setAbort = function(jqxhr){
                var sb = this.statusbar;
                this.abort.click(function()
                {
                    jqxhr.abort();
                    sb.hide();
                });
            }
        }
        function sendFileToServer(formData,status)
        {
            var uploadURL = "/docmn/web/doc/dragdrop/fileUpload/post.do"; //Upload URL
            var extraData ={}; //Extra Data.
            var jqXHR=$.ajax({
                    xhr: function() {
                    var xhrobj = $.ajaxSettings.xhr();
                    if (xhrobj.upload) {
                            xhrobj.upload.addEventListener('progress', function(event) {
                                var percent = 0;
                                var position = event.loaded || event.position;
                                var total = event.total;
                                if (event.lengthComputable) {
                                    percent = Math.ceil(position / total * 100);
                                }
                                //Set progress
                                status.setProgress(percent);
                            }, false);
                        }
                    return xhrobj;
                },
                url: uploadURL,
                type: "POST",
                contentType:false,
                processData: false,
                cache: false,
                data: formData,
                success: function(data){
                    status.setProgress(100);
                    //$("#status1").append("File upload Done<br>");           
                }
            }); 
            status.setAbort(jqXHR);
        }
    });
    
    // 업로드 파일 삭제
    function deleteFile(fIndex){
        // 전체 파일 사이즈 수정
        totalFileSize -= fileSizeList[fIndex];
        
        // 파일 배열에서 삭제
        delete fileList[fIndex];
        
        // 파일 사이즈 배열 삭제
        delete fileSizeList[fIndex];
        
        // 업로드 파일 테이블 목록에서 삭제
        $("#filedel" + fIndex).remove();
    }
    
    function setDocgbnSel(){
    	setstatusSel = 'Y';
    }