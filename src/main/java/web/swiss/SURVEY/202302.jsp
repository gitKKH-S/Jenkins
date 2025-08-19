<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge" >
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" >
	<meta name="viewport" content="user-scalable=1, initial-scale=0.1, width=device-width, target-densitydpi=device-dpi" >
	<meta http-equiv="Expires" content="-1" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	
    <link href="../CALL/bootstrap-3.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<STYLE>
		BODY { FONT-SIZE:14PX;}
		.TITLE_BOX { BORDER:1PX SOLID BLACK; FONT-SIZE:26PX; FONT-WEIGHT:; PADDING:10PX; }
		.EMPTY_LINE { HEIGHT : 30PX; }
		.TABLE_TITLE { display:none; }
		.PART_TITLE { FONT-WEIGHT:BOLD; FONT-SIZE:20PX; COLOR:BLUE }
		.QUESTION_NO { DISPLAY:none; COLOR:RED; FONT-WEIGHT:BOLD; }
		.TABLE_QUESTION { WIDTH:60%; VERTICAL-ALIGN:TOP; }
		.TABLE_OBJECT { TEXT-ALIGN:CENTER; }
		.INPUT_TXT { WIDTH:99%; HEIGHT:30PX; RESIZE:VERTICAL; }
		.DESC_BOX { BORDER:1PX SOLID BLACK; PADDING:10PX; background:#f5f5f5; font-weight:bold; }
		.BTN_SUBMIT { TEXT-ALIGN:CENTER; }
		
		.container { margin:0; padding:0; width:100%; }
		label { font-weight:normal; }
		
		.table th { text-align: center; } 
		.table tr { background:white; }
		.table td { text-align: center; }
		
		.td2 { text-align: left !important; WIDTH:60%; VERTICAL-ALIGN:TOP; }
		
		.QUESTION_TITLE { FONT-WEIGHT:BOLD; text-align:left; }
	</STYLE>
	
	<SCRIPT>
	function modify_survey(){
		$.ajax({
			type: "POST",
			url: "/swiss/SURVEY/proc/rcv.jsp",
			dataType: 'text',
			data: $("#survey_form").serialize(),
			beforeSend:function(){
				$('.wrap-loading').show();
			},
			complete:function(){
				$('.wrap-loading').hide();
			},
			success : function(result){
				alert("success");
			},
			error : function(result){
				alert("fail out modify_survey");
			}
		})
	}	
	
	function go_Submit(){
		if(chk_Form()){
			//window.alert("저장기능은 아직 작업중입니다.");
			modify_survey();
		}else{
			return false;
		}
		
	}
	
	function chk_Form(){
		var offset = 0;

		var chk_q1_1 = $(":input:radio[name=q1_1]:checked").val();
		if(!chk_q1_1){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q1_1").css('color','red');
			offset = $("#label_q1_1").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q1_1").css('color','black');
		}
		
		var chk_q1_2 = $(":input:radio[name=q1_2]:checked").val();
		if(!chk_q1_2){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q1_2").css('color','red');
			offset = $("#label_q1_2").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q1_2").css('color','black');
		}

		var chk_q2 = $(":input:radio[name=q2]:checked").val();
		if(!chk_q2){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q2").css('color','red');
			offset = $("#label_q2").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q2").css('color','black');
			
			switch(chk_q2){
				case "1":
					var chk_q2_1 = $(":input:radio[name=q2_1]:checked").val();
					if(!chk_q2_1){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q2_1").css('color','red');
						offset = $("#label_q2_1").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q2_1").css('color','black');
					}
					
					var chk_q2_2 = $(":input:radio[name=q2_2]:checked").val();
					if(!chk_q2_2){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q2_2").css('color','red');
						offset = $("#label_q2_2").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q2_2").css('color','black');
					}		
					
					var chk_q2_3 = $("#q2_3").val().trim();
					//alert("chk_q2_3=["+chk_q2_3+"]");
					if(!chk_q2_3){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q2_3").css('color','red');
						offset = $("#label_q2_3").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q2_3").css('color','black');
					}
					break;
				case "2":
					var chk_q2_4 = $("#q2_4").val().trim();
					//alert("chk_q2_4=["+chk_q2_4+"]");
					if(!chk_q2_4){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q2_4").css('color','red');
						offset = $("#label_q2_4").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q2_4").css('color','black');
					}
					break;
				default:
					
					break;
			}
		}

		var chk_q3_1 = $(":input:radio[name=q3_1]:checked").val();
		alert("q3_1="+chk_q3_1);
		if(!chk_q3_1){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q3_1").css('color','red');
			offset = $("#label_q3_1").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q3_1").css('color','black');
			
			switch(chk_q3_1){
				case "1":
					var chk_q3_1_1 = $(":input:radio[name=q3_1_1]:checked").val();
					if(!chk_q3_1_1){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q3_1_1").css('color','red');
						offset = $("#label_q3_1_1").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q3_1_1").css('color','black');
					}
					
					var chk_q3_1_2 = $(":input:radio[name=q3_1_2]:checked").val();
					if(!chk_q3_1_2){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q3_1_2").css('color','red');
						offset = $("#label_q3_1_2").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q3_1_2").css('color','black');
					}		
					
					var chk_q3_1_3 = $(":input:radio[name=q3_1_3]:checked").val();
					//alert("chk_q3_1_3=["+chk_q3_1_3+"]");
					if(!chk_q3_1_3){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q3_1_3").css('color','red');
						offset = $("#label_q3_1_3").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q3_1_3").css('color','black');
					}
					
					var chk_q3_1_4 = $("#q3_1_4").val().trim();
					//alert("chk_q3_1_4=["+chk_q3_1_4+"]");
					if(!chk_q3_1_4){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q3_1_4").css('color','red');
						offset = $("#label_q3_1_4").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q3_1_4").css('color','black');
					}					
					break;
				case "2":
					var chk_q3_1_5 = $("#q3_1_5").val().trim();
					//alert("chk_q3_1_5=["+chk_q3_1_5+"]");
					if(!chk_q3_1_5){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q3_1_5").css('color','red');
						offset = $("#label_q3_1_5").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q3_1_5").css('color','black');
					}
					break;
				default:
					
					break;
			}
			
		}
		
		var chk_q3_2 = $(":input:radio[name=q3_2]:checked").val();
		if(!chk_q3_2){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q3_2").css('color','red');
			offset = $("#label_q3_2").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q3_2").css('color','black');
		}
	
		var chk_q4 = $(":input:radio[name=q4]:checked").val();
		//alert("q4="+chk_q4);
		if(!chk_q4){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q4").css('color','red');
			offset = $("#label_q4").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q4").css('color','black');
			
			switch(chk_q4){
				case "1":
					var chk_q4_1 = $(":input:radio[name=q4_1]:checked").val();
					if(!chk_q4_1){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q4_1").css('color','red');
						offset = $("#label_q4_1").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q4_1").css('color','black');
					}
					
					var chk_q4_2 = $(":input:radio[name=q4_2]:checked").val();
					if(!chk_q4_2){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q4_2").css('color','red');
						offset = $("#label_q4_2").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q4_2").css('color','black');
					}		
					
					var chk_q4_3 = $(":input:radio[name=q4_3]:checked").val();
					//alert("chk_q4_3=["+chk_q4_3+"]");
					if(!chk_q4_3){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q4_3").css('color','red');
						offset = $("#label_q4_3").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q4_3").css('color','black');
					}
					
					var chk_q4_4 = $(":input:radio[name=q4_4]:checked").val();
					//alert("chk_q4_4=["+chk_q4_4+"]");
					if(!chk_q4_4){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q4_4").css('color','red');
						offset = $("#label_q4_4").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q4_4").css('color','black');
					}		
					
					var chk_q4_5 = $("#q4_5").val().trim();
					//alert("chk_q4_5=["+chk_q4_5+"]");
					if(!chk_q4_5){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q4_5").css('color','red');
						offset = $("#label_q4_5").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q4_5").css('color','black');
					}
				
					break;
				case "2":
					var chk_q4_6 = $("#q4_6").val().trim();
					//alert("chk_q4_1_6=["+chk_q4_6+"]");
					if(!chk_q4_6){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q4_6").css('color','red');
						offset = $("#label_q4_6").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q4_6").css('color','black');
					}
					break;
					
				default:
					
					break;
			}
		}

		var chk_q5_1 = $(":input:radio[name=q5_1]:checked").val();
		if(!chk_q5_1){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q5_1").css('color','red');
			offset = $("#label_q5_1").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q5_1").css('color','black');
		}
		
		var chk_q5_2 = $(":input:radio[name=q5_2]:checked").val();
		if(!chk_q5_2){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q5_2").css('color','red');
			offset = $("#label_q5_2").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q5_2").css('color','black');
		}
		
		var chk_q5_3 = $(":input:radio[name=q5_3]:checked").val();
		if(!chk_q5_3){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q5_3").css('color','red');
			offset = $("#label_q5_3").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q5_3").css('color','black');
		}		
		
		var chk_q6_1 = $(":input:radio[name=q6_1]:checked").val();
		if(!chk_q6_1){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q6_1").css('color','red');
			offset = $("#label_q6_1").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q6_1").css('color','black');
		}
		
		var chk_q6_2 = $(":input:radio[name=q6_2]:checked").val();
		if(!chk_q6_2){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q6_2").css('color','red');
			offset = $("#label_q6_2").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q6_2").css('color','black');
		}
		
		var chk_q6_3 = $(":input:radio[name=q6_3]:checked").val();
		if(!chk_q6_3){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q6_3").css('color','red');
			offset = $("#label_q6_3").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q6_3").css('color','black');
		}
		
		var chk_q7_1 = $(":input:radio[name=q7_1]:checked").val();
		if(!chk_q7_1){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q7_1").css('color','red');
			offset = $("#label_q7_1").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q7_1").css('color','black');
		}
		
		var chk_q7_2 = $(":input:radio[name=q7_2]:checked").val();
		if(!chk_q7_2){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q7_2").css('color','red');
			offset = $("#label_q7_2").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q7_2").css('color','black');
		}
		
		var chk_q7_3 = $(":input:radio[name=q7_3]:checked").val();
		if(!chk_q7_3){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q7_3").css('color','red');
			offset = $("#label_q7_3").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q7_3").css('color','black');
		}		

		var chk_q8_1 = $(":input:radio[name=q8_1]:checked").val();
		if(!chk_q8_1){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q8_1").css('color','red');
			offset = $("#label_q8_1").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q8_1").css('color','black');
		}	
		
		var chk_q8_2 = $("#q8_2").val().trim();
		//alert("chk_q8_2=["+chk_q8_2+"]");
		if(!chk_q8_2){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q8_2").css('color','red');
			offset = $("#label_q8_2").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q8_2").css('color','black');
		}

		var chk_q9 = $(":input:radio[name=q9]:checked").val();
		if(!chk_q9){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q9").css('color','red');
			offset = $("#label_q9").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q9").css('color','black');
			
			switch(chk_q9){
				case "1":
					var chk_q9_1 = $(":input:radio[name=q9_1]:checked").val();
					if(!chk_q9_1){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q9_1").css('color','red');
						offset = $("#label_q9_1").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q9_1").css('color','black');
					}
					
					var chk_q9_2 = $(":input[name=q9_2]").val().trim();
					//alert("chk_q9_2=["+chk_q9_2+"]");
					if(!chk_q9_2){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q9_2").css('color','red');
						offset = $("#label_q9_2").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q9_2").css('color','black');
					}
					
					var chk_q9_3 = $(":input[name=q9_3]").val().trim();
					//alert("chk_q9_3=["+chk_q9_3+"]");
					if(!chk_q9_3){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q9_3").css('color','red');
						offset = $("#label_q9_3").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q9_3").css('color','black');
					}					
					break;
				case "2":
					var chk_q9_4 = $(":input[name=q9_4]").val().trim();
					//alert("chk_q9_4=["+chk_q9_4+"]");
					if(!chk_q9_4){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q9_4").css('color','red');
						offset = $("#label_q9_4").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q9_4").css('color','black');
					}
					break;
				default:
					
					break;
			}
		}

		var chk_q10 = $(":input:radio[name=q10]:checked").val();
		if(!chk_q10){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q10").css('color','red');
			offset = $("#label_q10").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q10").css('color','black');
			
			switch(chk_q10){
				case "1":
					var chk_q10_1 = $(":input:radio[name=q10_1]:checked").val();
					if(!chk_q10_1){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q10_1").css('color','red');
						offset = $("#label_q10_1").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q10_1").css('color','black');
					}
					
					var chk_q10_2 = $(":input[name=q10_2]").val().trim();
					//alert("chk_q10_2=["+chk_q10_2+"]");
					if(!chk_q10_2){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q10_2").css('color','red');
						offset = $("#label_q10_2").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q10_2").css('color','black');
					}
					
					var chk_q10_3 = $(":input[name=q10_3]").val().trim();
					//alert("chk_q10_3=["+chk_q10_3+"]");
					if(!chk_q10_3){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q10_3").css('color','red');
						offset = $("#label_q10_3").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q10_3").css('color','black');
					}					
					break;
				case "2":
					var chk_q10_4 = $(":input[name=q10_4]").val().trim();
					//alert("chk_q10_4=["+chk_q10_4+"]");
					if(!chk_q10_4){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q10_4").css('color','red');
						offset = $("#label_q10_4").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q10_4").css('color','black');
					}
					break;
				default:
					
					break;
			}
		}

		var chk_q11 = $(":input:radio[name=q11]:checked").val();
		if(!chk_q11){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q11").css('color','red');
			offset = $("#label_q11").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q11").css('color','black');
			
			switch(chk_q11){
				case "1":
					var chk_q11_1 = $(":input:radio[name=q11_1]:checked").val();
					if(!chk_q11_1){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q11_1").css('color','red');
						offset = $("#label_q11_1").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q11_1").css('color','black');
					}
					
					var chk_q11_2 = $(":input[name=q11_2]").val().trim();
					//alert("chk_q11_2=["+chk_q11_2+"]");
					if(!chk_q11_2){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q11_2").css('color','red');
						offset = $("#label_q11_2").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q11_2").css('color','black');
					}
					
					var chk_q11_3 = $(":input[name=q11_3]").val().trim();
					//alert("chk_q11_3=["+chk_q11_3+"]");
					if(!chk_q11_3){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q11_3").css('color','red');
						offset = $("#label_q11_3").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q11_3").css('color','black');
					}					
					break;
				case "2":
					var chk_q11_4 = $(":input[name=q11_4]").val().trim();
					//alert("chk_q11_4=["+chk_q11_4+"]");
					if(!chk_q11_4){
						alert("응답하지 않은 설문이 있습니다.");
						$("#label_q11_4").css('color','red');
						offset = $("#label_q11_4").offset(); //í´ë¹ ìì¹ ë°í
						$("html, body").animate({scrollTop: offset.top},400);
						return false;
					}else{
						$("#label_q11_4").css('color','black');
					}
					break;
				default:
					
					break;
			}
		}

		var chk_q12 = $(":input[name=q12]").val().trim();
		//alert("chk_q12=["+chk_q12+"]");
		if(!chk_q12){
			alert("응답하지 않은 설문이 있습니다.");
			$("#label_q12").css('color','red');
			offset = $("#label_q12").offset(); //í´ë¹ ìì¹ ë°í
			$("html, body").animate({scrollTop: offset.top},400);
			return false;
		}else{
			$("#label_q12").css('color','black');
		}
	
		return true;

	}
	</SCRIPT>
</head>
<BODY style="padding:10px;">
<form class="form-signin" name="survey_form" id="survey_form" onsubmit="go_Submit();return false;">
	<div class="container">
	  <div class="panel panel-default">
	    <div class="panel-body" style="background:#f5f5f5; font-weight:bold; font-size:16px;">
	    	안녕하세요. 한국교육개발원 고등교육취업통계팀입니다.<br><br>
			2023년도 고등교육기관 졸업자 취업통계조사를 위한 졸업생정보 조사에 임해주신 취업담당자분들께 감사의 말씀을 드립니다.<br>
			한국교육개발원 고등교육 취업통계팀에서는 취업통계조사 및 시스템의 개선방안 마련을 위해 취업통계 담당자분들의 의견을 수렴하고자 합니다.<br>
			바쁘시더라도 조사에 협조 부탁드립니다.<br>
			감사합니다.<BR><br>
			◎ 설문조사 기간 : 2023.07.11.(화) ~ 2023.07.21.(금)
	    </div>
	  </div>
	</DIV>	
	
<div class="container max-width no-padding">
  <div class="panel panel-primary" STYLE="BACKGROUND:;">
    <div class="panel-heading" style="font-weight:bold; font-size:18px;">응답자 기본사항</div>
    <div class="panel-body">
		<DIV CLASS="QUESTION_TITLE" id="label_q1_1">
			<SPAN CLASS="QUESTION_NO">1-1.</SPAN>귀 교에서 사용하고 있는 취업통계 조사 유형은 무엇입니까?
		</DIV> 
		<DIV CLASS="QUESTION_OBJECT">
			<input class="form-check-input" type="radio" name="q1_1" value="1" id="q1_1_1">
			<label class="form-check-label" for="q1_1_1">
				(나)타입(취업담당자 혼자 조사)
			</label>
			<input class="form-check-input" type="radio" name="q1_1" value="2" id="q1_1_2" style="margin-left:20px;">
			<label class="form-check-label" for="q1_1_2">
				(다)타입(전산담당자와 함께 조사)
			</label>			
		</DIV>
	
		<DIV CLASS="EMPTY_LINE"></DIV>
		
		<DIV CLASS="QUESTION_TITLE" id="label_q1_2">
			<SPAN CLASS="QUESTION_NO">1-2.</SPAN>귀하의 취업통계조사 업무 경력은 얼마나 되었습니다?
		</DIV>
		<DIV CLASS="QUESTION_OBJECT">
			<input class="form-check-input" type="radio" name="q1_2" value="1" id="q1_2_1">
			<label class="form-check-label" for="q1_2_1">1년미만</label>
			<input class="form-check-input" type="radio" name="q1_2" value="2" id="q1_2_2" style="margin-left:20px;">
			<label class="form-check-label" for="q1_2_2">1년 이상~2년 미만</label>
			<input class="form-check-input" type="radio" name="q1_2" value="3" id="q1_2_3" style="margin-left:20px;">
			<label class="form-check-label" for="q1_2_3">2년 이상~3년 미만</label>			
			<input class="form-check-input" type="radio" name="q1_2" value="4" id="q1_2_4" style="margin-left:20px;">
			<label class="form-check-label" for="q1_2_4">3년 이상~4년 미만</label>			
			<input class="form-check-input" type="radio" name="q1_2" value="5" id="q1_2_5" style="margin-left:20px;">
			<label class="form-check-label" for="q1_2_5">4년 이상</label>			
		</DIV>
    </div>
  </div>
</div>	
		
<div class="container">
  <div class="panel panel-danger">
  	<div class="panel-heading" style="font-weight:bold; font-size:18px;">취업통계 조사지원</div>
    <div class="panel-body">
		<DIV CLASS="QUESTION_TITLE" id="label_q2">
			<SPAN CLASS="QUESTION_NO">2.</SPAN>취업통계조사 지침서를 조사 시 활용하였습니까?
		</DIV>
		<DIV CLASS="QUESTION_OBJECT">
			<input class="form-check-input" type="radio" name="q2" value="1" id="q2_1" onclick="javascript:$('#q2_t1').css('display','block');$('#q2_t2').css('display','none');">
			<label class="form-check-label" for="q2_1">
				그렇다
			</label>
			<input class="form-check-input" type="radio" name="q2" value="2" id="q2_2" onclick="javascript:$('#q2_t1').css('display','none');$('#q2_t2').css('display','block');" style="margin-left:20px;">
			<label class="form-check-label" for="q2_2">
				아니다
			</label>			
		</DIV>
					
		<div id="q2_t1" style="display:none;">
			<DIV CLASS="TABLE_TITLE">※ 지침서 만족도 조사 (‘① 그렇다’ 선택한 자만 하단에 조사항목 표가 다음과 같이 나타남)</DIV>
			<div class="table-responsive">
				<TABLE CLASS="table table-bordered table-hover">
					<TR CLASS="warning">
						<TH WIDTH="60%">설문문항</TH>
						<TH>매우 아니다	</TH>
						<TH>아니다</TH>
						<TH>보통이다</TH>
						<TH>그렇다</TH>
						<TH>매우 그렇다</TH>
					</TR>
					<TR>
						<TD class="td2" id="label_q2_1"><SPAN CLASS="QUESTION_NO">2-1.</SPAN>지침서가 취업통계조사 시 도움이 되었습니까?</TD>
						<TD><input class="form-check-input" type="radio" name="q2_1" value="1" id="q2_1_1"></TD>
						<TD><input class="form-check-input" type="radio" name="q2_1" value="2" id="q2_1_2"></TD>
						<TD><input class="form-check-input" type="radio" name="q2_1" value="3" id="q2_1_3"></TD>
						<TD><input class="form-check-input" type="radio" name="q2_1" value="4" id="q2_1_4"></TD>
						<TD><input class="form-check-input" type="radio" name="q2_1" value="5" id="q2_1_5"></TD>
					</TR>
					<TR>
						<TD class="td2" id="label_q2_2"><SPAN CLASS="QUESTION_NO">2-2.</SPAN>지침서가 내용을 이해하기 쉽게 기술되어 있습니까?</TD>
						<TD><input class="form-check-input" type="radio" name="q2_2" value="1" id="q2_2_1"></TD>
						<TD><input class="form-check-input" type="radio" name="q2_2" value="2" id="q2_2_2"></TD>
						<TD><input class="form-check-input" type="radio" name="q2_2" value="3" id="q2_2_3"></TD>
						<TD><input class="form-check-input" type="radio" name="q2_2" value="4" id="q2_2_4"></TD>
						<TD><input class="form-check-input" type="radio" name="q2_2" value="5" id="q2_2_5"></TD>
					</TR>
					<TR>
						<TD class="td2" id="label_q2_3"><SPAN CLASS="QUESTION_NO">2-3.</SPAN>지침서에 개선이 필요한 경우, 자유롭게 기술해 주십시오.</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q2_3" id="q2_3" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
				</TABLE>
			</div>
		</div>
		
		<div id="q2_t2" style="display:none;">
			<DIV CLASS="TABLE_TITLE">※ 미활용 이유 조사 (‘② 아니다’ 선택한 자만 하단에 조사항목 표가 다음과 같이 나타남)</DIV>
			<div class="table-responsive">
				<TABLE CLASS="table table-bordered table-hover">
					<TR>
						<TD class="td2" style="font-weight:bold;" id="label_q2_4"><SPAN CLASS="QUESTION_NO">2-4</SPAN>지침서 미활용 사유를 기술해 주십시오.</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q2_4" id="q2_4" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
				</TABLE>
			</div>
		</div>	
		
		<DIV CLASS="EMPTY_LINE"></DIV>
		
		<DIV CLASS="QUESTION_TITLE" id="label_q3_1">
			<SPAN CLASS="QUESTION_NO">3-1.</SPAN>취업통계조사 비대면 연수에 참석하였습니까?
		</DIV>
		<DIV CLASS="QUESTION_OBJECT">
			<input class="form-check-input" type="radio" name="q3_1" value="1" id="q3_1_1" onclick="javascript:$('#q3_1_t1').css('display','block');$('#q3_1_t2').css('display','none');">
			<label class="form-check-label" for="q3_1_1">
				그렇다
			</label>
			<input class="form-check-input" type="radio" name="q3_1" value="2" id="q3_1_2" onclick="javascript:$('#q3_1_t1').css('display','none');$('#q3_1_t2').css('display','block');" style="margin-left:20px;">
			<label class="form-check-label" for="q3_1_2">
				아니다
			</label>	
		</DIV>
		
		<div id="q3_1_t1" style="display:none;">	
			<DIV CLASS="TABLE_TITLE">※ 연수 만족도 조사 (‘① 그렇다’ 선택한 자만 하단에 조사항목 표가 다음과 같이 나타남)</DIV>
			<div class="table-responsive">
				<TABLE CLASS="table table-bordered table-hover">
					<TR CLASS="warning">
						<TH WIDTH="60%">설문문항</TH>
						<TH>매우 아니다	</TH>
						<TH>아니다</TH>
						<TH>보통이다</TH>
						<TH>그렇다</TH>
						<TH>매우 그렇다</TH>
					</TR>
					<TR>
						<TD class="td2" id="label_q3_1_1"><SPAN CLASS="QUESTION_NO">3-1-1.</SPAN>비대면 연수가 취업통계조사 시 도움이 되었습니까?</TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_1" value="1" id="q3_1_1_1"></TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_1" value="2" id="q3_1_1_2"></TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_1" value="3" id="q3_1_1_3"></TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_1" value="4" id="q3_1_1_4"></TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_1" value="5" id="q3_1_1_5"></TD>
					</TR>
					<TR>
						<TD class="td2" id="label_q3_1_2"><SPAN CLASS="QUESTION_NO">3-1-2.</SPAN>연수 발표자료가 취업통계조사 시 도움이 되었습니까?</TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_2" value="1" id="q3_1_2_1"></TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_2" value="2" id="q3_1_2_2"></TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_2" value="3" id="q3_1_2_3"></TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_2" value="4" id="q3_1_2_4"></TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_2" value="5" id="q3_1_2_5"></TD>
					</TR>
					<TR>
						<TD class="td2" id="label_q3_1_3"><SPAN CLASS="QUESTION_NO">3-1-3.</SPAN>연수 녹화영상이 취업통계조사 시 도움이 되었습니까?</TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_3" value="1" id="q3_1_3_1"></TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_3" value="2" id="q3_1_3_2"></TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_3" value="3" id="q3_1_3_3"></TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_3" value="4" id="q3_1_3_4"></TD>
						<TD><input class="form-check-input" type="radio" name="q3_1_3" value="5" id="q3_1_3_5"></TD>
					</TR>			
					<TR>
						<TD class="td2" id="label_q3_1_4"><SPAN CLASS="QUESTION_NO">3-1-4.</SPAN>연수에 개선이 필요한 경우, 자유롭게 기술해 주십시오.</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q3_1_4" id="q3_1_4" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
				</TABLE>
			</div>
		</div>	
		
		<div id="q3_1_t2" style="display:none;">		
			<DIV CLASS="TABLE_TITLE">미참석 이유 조사 (‘② 아니다’ 선택한 자만 하단에 조사항목 표가 다음과 같이 나타남)</DIV>
			<div class="table-responsive">
				<TABLE CLASS="table table-bordered table-hover">
					<TR>
						<TD class="td2" id="label_q3_1_5" style="font-weight:bold;"><SPAN CLASS="QUESTION_NO">3-1-5.</SPAN>미참석 사유를 기술해 주십시오.</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q3_1_5" id="q3_1_5" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
				</TABLE>
			</div>
		</div>
		
		<DIV CLASS="EMPTY_LINE"></DIV>
		
		<DIV CLASS="QUESTION_TITLE" id="label_q3_2">
			<SPAN CLASS="QUESTION_NO">3-2.</SPAN>취업통계조사 연수 진행방식 중 가장 선호하는 것은 무엇입니까?
		</DIV>
		<DIV CLASS="QUESTION_OBJECT">
			<input class="form-check-input" type="radio" name="q3_2" value="1" id="q3_2_1">
			<label class="form-check-label" for="q3_2_1">비대면 연수</label>
			<input class="form-check-input" type="radio" name="q3_2" value="2" id="q3_2_2" style="margin-left:20px;">
			<label class="form-check-label" for="q3_2_2">대면 연수</label>				
		</DIV>

		<DIV CLASS="EMPTY_LINE"></DIV>
		
		<DIV CLASS="QUESTION_TITLE" id="label_q4">
			<SPAN CLASS="QUESTION_NO">4.</SPAN>취업통계조사와 관련하여 문의응대(전화문의, Q&A게시판, 원격지원) 경험이 있습니까?
		</DIV>
		<DIV CLASS="QUESTION_OBJECT">
			<input class="form-check-input" type="radio" name="q4" value="1" id="q4_1" onclick="javascript:$('#q4_t1').css('display','block');$('#q4_t2').css('display','none');">
			<label class="form-check-label" for="q4_1">
				그렇다
			</label>
			<input class="form-check-input" type="radio" name="q4" value="2" id="q4_2" onclick="javascript:$('#q4_t1').css('display','none');$('#q4_t2').css('display','block');" style="margin-left:20px;">
			<label class="form-check-label" for="q4_2">
				아니다
			</label>	
		</DIV>
		
		<div id="q4_t1" style="display:none;">		
			<DIV CLASS="TABLE_TITLE">※ 문의응대 만족도 조사 (‘① 그렇다’ 선택한 자만 하단에 조사항목 표가 다음과 같이 나타남)</DIV>
			<div class="table-responsive">
				<TABLE CLASS="table table-bordered table-hover">
					<TR CLASS="warning">
						<TH WIDTH="60%">설문문항</TH>
						<TH>매우 아니다	</TH>
						<TH>아니다</TH>
						<TH>보통이다</TH>
						<TH>그렇다</TH>
						<TH>매우 그렇다</TH>
					</TR>
					<TR>
						<TD class="td2" id="label_q4_1"><SPAN CLASS="QUESTION_NO">4-1.</SPAN>문의응대가 문의해결에 도움이 되었습니까?</TD>
						<TD><input class="form-check-input" type="radio" name="q4_1" value="1" id="q4_1_1"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_1" value="2" id="q4_1_2"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_1" value="3" id="q4_1_3"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_1" value="4" id="q4_1_4"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_1" value="5" id="q4_1_5"></TD>
					</TR>
					<TR>
						<TD class="td2" id="label_q4_2"><SPAN CLASS="QUESTION_NO">4-2.</SPAN>문의에 관한 해결이 신속하게 처리되었습니까?</TD>
						<TD><input class="form-check-input" type="radio" name="q4_2" value="1" id="q4_2_1"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_2" value="2" id="q4_2_2"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_2" value="3" id="q4_2_3"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_2" value="4" id="q4_2_4"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_2" value="5" id="q4_2_5"></TD>
					</TR>
					<TR>
						<TD class="td2" id="label_q4_3"><SPAN CLASS="QUESTION_NO">4-3.</SPAN>응대직원의 태도는 친절하였습니까?</TD>
						<TD><input class="form-check-input" type="radio" name="q4_3" value="1" id="q4_3_1"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_3" value="2" id="q4_3_2"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_3" value="3" id="q4_3_3"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_3" value="4" id="q4_3_4"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_3" value="5" id="q4_3_5"></TD>
					</TR>			
					<TR>
						<TD class="td2" id="label_q4_4"><SPAN CLASS="QUESTION_NO">4-4.</SPAN>응대직원의 전문지식과 업무능력은 적절하였습니까?</TD>
						<TD><input class="form-check-input" type="radio" name="q4_4" value="1" id="q4_4_1"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_4" value="2" id="q4_4_2"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_4" value="3" id="q4_4_3"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_4" value="4" id="q4_4_4"></TD>
						<TD><input class="form-check-input" type="radio" name="q4_4" value="5" id="q4_4_5"></TD>
					</TR>			
					<TR>
						<TD class="td2" id="label_q4_5"><SPAN CLASS="QUESTION_NO">4-5.</SPAN>문의응대에 개선이 필요한 경우, 자유롭게 기술해 주십시오.</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q4_5" id="q4_5" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
				</TABLE>
			</div>
		</div>

		<div id="q4_t2" style="display:none;">
			<DIV CLASS="TABLE_TITLE">미문의 사유 조사 (‘② 아니다’ 선택한 자만 하단에 조사항목 표가 다음과 같이 나타남)</DIV>
			<div class="table-responsive">
				<TABLE CLASS="table table-bordered table-hover">
					<TR>
						<TD class="td2" id="label_q4_6" style="font-weight:bold;"><SPAN CLASS="QUESTION_NO">4-6.</SPAN>미문의 사유를 기술해 주십시오.</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q4_6" id="q4_6" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
				</TABLE>
			</div>
		</div>

    </div>
  </div>
</div>	

<div class="container">
  <div class="panel panel-info">
    <div class="panel-heading" style="font-weight:bold; font-size:18px;">취업통계 조사시스템</div>
    <div class="panel-body">

		<DIV CLASS="QUESTION_TITLE">
			<SPAN CLASS="QUESTION_NO">5.</SPAN>서비스 품질 만족도 조사
		</DIV>
		
		<div class="table-responsive">
			<TABLE CLASS="table table-bordered table-hover">
				<TR CLASS="warning">
					<TH WIDTH="60%">설문문항</TH>
					<TH>매우 아니다	</TH>
					<TH>아니다</TH>
					<TH>보통이다</TH>
					<TH>그렇다</TH>
					<TH>매우 그렇다</TH>
				</TR>
				<TR>
					<TD class="td2" id="label_q5_1"><SPAN CLASS="QUESTION_NO">5-1.</SPAN>조사시스템은 안정적인 서비스를 제공하고 있습니까?</TD>
					<TD><input class="form-check-input" type="radio" name="q5_1" value="1" id="q5_1_1"></TD>
					<TD><input class="form-check-input" type="radio" name="q5_1" value="2" id="q5_1_2"></TD>
					<TD><input class="form-check-input" type="radio" name="q5_1" value="3" id="q5_1_3"></TD>
					<TD><input class="form-check-input" type="radio" name="q5_1" value="4" id="q5_1_4"></TD>
					<TD><input class="form-check-input" type="radio" name="q5_1" value="5" id="q5_1_5"></TD>
				</TR>
				<TR>
					<TD class="td2" id="label_q5_2"><SPAN CLASS="QUESTION_NO">5-2.</SPAN>시스템 오류나 장애 발생 시 바로 조치 되고 있습니까?</TD>
					<TD><input class="form-check-input" type="radio" name="q5_2" value="1" id="q5_2_1"></TD>
					<TD><input class="form-check-input" type="radio" name="q5_2" value="2" id="q5_2_2"></TD>
					<TD><input class="form-check-input" type="radio" name="q5_2" value="3" id="q5_2_3"></TD>
					<TD><input class="form-check-input" type="radio" name="q5_2" value="4" id="q5_2_4"></TD>
					<TD><input class="form-check-input" type="radio" name="q5_2" value="5" id="q5_2_5"></TD>
				</TR>
				<TR>
					<TD class="td2" id="label_q5_3"><SPAN CLASS="QUESTION_NO">5-3.</SPAN>조사시스템의 응답 속도는 만족할 수준입니까?</TD>
					<TD><input class="form-check-input" type="radio" name="q5_3" value="1" id="q5_3_1"></TD>
					<TD><input class="form-check-input" type="radio" name="q5_3" value="2" id="q5_3_2"></TD>
					<TD><input class="form-check-input" type="radio" name="q5_3" value="3" id="q5_3_3"></TD>
					<TD><input class="form-check-input" type="radio" name="q5_3" value="4" id="q5_3_4"></TD>
					<TD><input class="form-check-input" type="radio" name="q5_3" value="5" id="q5_3_5"></TD>
				</TR>			
			</TABLE>	
		</div>
		
		<DIV CLASS="EMPTY_LINE"></DIV>
		
		<DIV CLASS="QUESTION_TITLE">
			<SPAN CLASS="QUESTION_NO">6.</SPAN>정보 품질 만족도 조사
		</DIV>
		
		<div class="table-responsive">
			<TABLE CLASS="table table-bordered table-hover">
				<TR CLASS="warning">
					<TH WIDTH="60%">설문문항</TH>
					<TH>매우 아니다	</TH>
					<TH>아니다</TH>
					<TH>보통이다</TH>
					<TH>그렇다</TH>
					<TH>매우 그렇다</TH>
				</TR>
				<TR>
					<TD class="td2" id="label_q6_1"><SPAN CLASS="QUESTION_NO">6-1.</SPAN>조사시스템의 데이터 및 정보는 정확하며 신뢰할 수 있습니까?</TD>
					<TD><input class="form-check-input" type="radio" name="q6_1" value="1" id="q6_1_1"></TD>
					<TD><input class="form-check-input" type="radio" name="q6_1" value="2" id="q6_1_2"></TD>
					<TD><input class="form-check-input" type="radio" name="q6_1" value="3" id="q6_1_3"></TD>
					<TD><input class="form-check-input" type="radio" name="q6_1" value="4" id="q6_1_4"></TD>
					<TD><input class="form-check-input" type="radio" name="q6_1" value="5" id="q6_1_5"></TD>
				</TR>
				<TR>
					<TD class="td2" id="label_q6_2"><SPAN CLASS="QUESTION_NO">6-2.</SPAN>조사시스템에 필요한 정보가 시의적절하게 제공되고 있습니까?</TD>
					<TD><input class="form-check-input" type="radio" name="q6_2" value="1" id="q6_2_1"></TD>
					<TD><input class="form-check-input" type="radio" name="q6_2" value="2" id="q6_2_2"></TD>
					<TD><input class="form-check-input" type="radio" name="q6_2" value="3" id="q6_2_3"></TD>
					<TD><input class="form-check-input" type="radio" name="q6_2" value="4" id="q6_2_4"></TD>
					<TD><input class="form-check-input" type="radio" name="q6_2" value="5" id="q6_2_5"></TD>
				</TR>
				<TR>
					<TD class="td2" id="label_q6_3"><SPAN CLASS="QUESTION_NO">6-3.</SPAN>조사시스템에서 제공되는 정보는 활용성이 높습니까?</TD>
					<TD><input class="form-check-input" type="radio" name="q6_3" value="1" id="q6_3_1"></TD>
					<TD><input class="form-check-input" type="radio" name="q6_3" value="2" id="q6_3_2"></TD>
					<TD><input class="form-check-input" type="radio" name="q6_3" value="3" id="q6_3_3"></TD>
					<TD><input class="form-check-input" type="radio" name="q6_3" value="4" id="q6_3_4"></TD>
					<TD><input class="form-check-input" type="radio" name="q6_3" value="5" id="q6_3_5"></TD>
				</TR>			
			</TABLE>
		</div>

		<DIV CLASS="EMPTY_LINE"></DIV>
		
		<DIV CLASS="QUESTION_TITLE">
			<SPAN CLASS="QUESTION_NO">7.</SPAN>사용자 편의 만족도 조사
		</DIV>
		
		<div class="table-responsive">
			<TABLE CLASS="table table-bordered table-hover">
				<TR CLASS="warning">
					<TH WIDTH="60%">설문문항</TH>
					<TH>매우 아니다	</TH>
					<TH>아니다</TH>
					<TH>보통이다</TH>
					<TH>그렇다</TH>
					<TH>매우 그렇다</TH>
				</TR>
				<TR>
					<TD class="td2" id="label_q7_1"><SPAN CLASS="QUESTION_NO">7-1.</SPAN>조사시스템은 조사 프로세스에 따라 효율적으로 구성되어 있습니까?</TD>
					<TD><input class="form-check-input" type="radio" name="q7_1" value="1" id="q7_1_1"></TD>
					<TD><input class="form-check-input" type="radio" name="q7_1" value="2" id="q7_1_2"></TD>
					<TD><input class="form-check-input" type="radio" name="q7_1" value="3" id="q7_1_3"></TD>
					<TD><input class="form-check-input" type="radio" name="q7_1" value="4" id="q7_1_4"></TD>
					<TD><input class="form-check-input" type="radio" name="q7_1" value="5" id="q7_1_5"></TD>
				</TR>
				<TR>
					<TD class="td2" id="label_q7_2"><SPAN CLASS="QUESTION_NO">7-2.</SPAN>조사시스템의 사용 방법이 쉽고 명확합니까?</TD>
					<TD><input class="form-check-input" type="radio" name="q7_2" value="1" id="q7_2_1"></TD>
					<TD><input class="form-check-input" type="radio" name="q7_2" value="2" id="q7_2_2"></TD>
					<TD><input class="form-check-input" type="radio" name="q7_2" value="3" id="q7_2_3"></TD>
					<TD><input class="form-check-input" type="radio" name="q7_2" value="4" id="q7_2_4"></TD>
					<TD><input class="form-check-input" type="radio" name="q7_2" value="5" id="q7_2_5"></TD>
				</TR>
				<TR>
					<TD class="td2" id="label_q7_3"><SPAN CLASS="QUESTION_NO">7-3.</SPAN>매뉴얼이나 도움말 기능이 조사에 효과적입니까?</TD>
					<TD><input class="form-check-input" type="radio" name="q7_3" value="1" id="q7_3_1"></TD>
					<TD><input class="form-check-input" type="radio" name="q7_3" value="2" id="q7_3_2"></TD>
					<TD><input class="form-check-input" type="radio" name="q7_3" value="3" id="q7_3_3"></TD>
					<TD><input class="form-check-input" type="radio" name="q7_3" value="4" id="q7_3_4"></TD>
					<TD><input class="form-check-input" type="radio" name="q7_3" value="5" id="q7_3_5"></TD>
				</TR>			
			</TABLE>
		</div>
		
		<DIV CLASS="EMPTY_LINE"></DIV>
		
		<DIV CLASS="QUESTION_TITLE">
			<SPAN CLASS="QUESTION_NO">8.</SPAN>조사 시스템 만족도 조사
		</DIV>
		
		<div class="table-responsive">
			<TABLE CLASS="table table-bordered table-hover">
				<TR CLASS="warning">
					<TH WIDTH="60%">설문문항</TH>
					<TH>매우 아니다	</TH>
					<TH>아니다</TH>
					<TH>보통이다</TH>
					<TH>그렇다</TH>
					<TH>매우 그렇다</TH>
				</TR>
				<TR>
					<TD class="td2" id="label_q8_1"><SPAN CLASS="QUESTION_NO">8-1.</SPAN>조사시스템에 대해 전반적으로 만족하십니까?</TD>
					<TD><input class="form-check-input" type="radio" name="q8_1" value="1" id="q8_1_1"></TD>
					<TD><input class="form-check-input" type="radio" name="q8_1" value="2" id="q8_1_2"></TD>
					<TD><input class="form-check-input" type="radio" name="q8_1" value="3" id="q8_1_3"></TD>
					<TD><input class="form-check-input" type="radio" name="q8_1" value="4" id="q8_1_4"></TD>
					<TD><input class="form-check-input" type="radio" name="q8_1" value="5" id="q8_1_5"></TD>
				</TR>
				<TR>
					<TD class="td2" id="label_q8_2"><SPAN CLASS="QUESTION_NO">8-2.</SPAN>조사시스템에 개선이 필요한 경우, 자유롭게 기술해 주십시오.</TD>
					<TD COLSPAN="5"><TEXTAREA NAME="q8_2" id="q8_2" CLASS="INPUT_TXT"/></TEXTAREA></TD>
				</TR>			
			</TABLE>
		</div>
    </div>
  </div>
</div>	

<div class="container">
  <div class="panel panel-success">
    <div class="panel-heading" style="font-weight:bold; font-size:18px;">자료제공</div>
    <div class="panel-body">
		<DIV CLASS="QUESTION_TITLE" id="label_q9">
			<SPAN CLASS="QUESTION_NO">9.</SPAN>[조사결과] - [분석장표] 메뉴를 사용하신 적이 있습니까?
		</DIV>
		<DIV CLASS="QUESTION_OBJECT">
			<input class="form-check-input" type="radio" name="q9" value="1" id="q9_1" onclick="javascript:$('#q9_t1').css('display','block');$('#q9_t2').css('display','none');">
			<label class="form-check-label" for="q9_1">
				그렇다
			</label>
			<input class="form-check-input" type="radio" name="q9" value="2" id="q9_2" onclick="javascript:$('#q9_t1').css('display','none');$('#q9_t2').css('display','block');" style="margin-left:20px;">
			<label class="form-check-label" for="q9_2">
				아니다
			</label>	
		</DIV>
		
		<div id="q9_t1" style="display:none;">
			<DIV CLASS="TABLE_TITLE">※ 분석장표 만족도 조사 (‘① 그렇다’ 선택한 자만 하단에 조사항목 표가 다음과 같이 나타남)</DIV>
			<div class="table-responsive">
				<TABLE CLASS="table table-bordered table-hover">
					<TR CLASS="warning">
						<TH WIDTH="60%">설문문항</TH>
						<TH>매우 아니다	</TH>
						<TH>아니다</TH>
						<TH>보통이다</TH>
						<TH>그렇다</TH>
						<TH>매우 그렇다</TH>
					</TR>
					<TR>
						<TD class="td2" id="label_q9_1"><SPAN CLASS="QUESTION_NO">9-1.</SPAN>분석장표가 업무에 도움이 되었습니까?</TD>
						<TD><input class="form-check-input" type="radio" name="q9_1" value="1" id="q9_1_1"></TD>
						<TD><input class="form-check-input" type="radio" name="q9_1" value="2" id="q9_1_2"></TD>
						<TD><input class="form-check-input" type="radio" name="q9_1" value="3" id="q9_1_3"></TD>
						<TD><input class="form-check-input" type="radio" name="q9_1" value="4" id="q9_1_4"></TD>
						<TD><input class="form-check-input" type="radio" name="q9_1" value="5" id="q9_1_5"></TD>
					</TR>
					<TR>
						<TD class="td2" id="label_q9_2"><SPAN CLASS="QUESTION_NO">9-2.</SPAN>분석장표를 주로 어떤 목적으로 사용하십니까?</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q9_2" id="q9_2" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
					<TR>
						<TD class="td2" id="label_q9_3"><SPAN CLASS="QUESTION_NO">9-3.</SPAN>분석장표에 개선이 필요한 경우, 자유롭게 기술해 주십시오.</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q9_3" id="q9_3" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
				</TABLE>
			</div>
		</div>
		
		<div id="q9_t2" style="display:none;">
			<DIV CLASS="TABLE_TITLE">※ 미사용 이유 조사 (‘② 아니다’ 선택한 자만 하단에 조사항목 표가 다음과 같이 나타남)</DIV>
			<div class="table-responsive">
				<TABLE CLASS="table table-bordered table-hover">
					<TR>
						<TD class="td2" id="label_q9_4" style="font-weight:bold;"><SPAN CLASS="QUESTION_NO">9-4.</SPAN>분석장표 미사용 사유를 기술해 주십시오.</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q9_4" id="q9_4" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
				</TABLE>
			</div>
		</div>
		
		<DIV CLASS="EMPTY_LINE"></DIV>
		
		<DIV CLASS="QUESTION_TITLE" id="label_q10">
			<SPAN CLASS="QUESTION_NO">10.</SPAN>[진로탐색] - 시각화장표 관련 메뉴(학교현황, 취업통계)를 사용하신 적이 있습니까?
		</DIV>
		<DIV CLASS="QUESTION_OBJECT">
			<input class="form-check-input" type="radio" name="q10" value="1" id="q10_1" onclick="javascript:$('#q10_t1').css('display','block');$('#q10_t2').css('display','none');">
			<label class="form-check-label" for="q10_1">
				그렇다
			</label>
			<input class="form-check-input" type="radio" name="q10" value="2" id="q10_2" onclick="javascript:$('#q10_t1').css('display','none');$('#q10_t2').css('display','block');" style="margin-left:20px;">
			<label class="form-check-label" for="q10_2">
				아니다
			</label>
		</DIV>
		
		<div id="q10_t1" style="display:none;">
			<DIV CLASS="TABLE_TITLE">※ 시각화장표 만족도 조사 (‘① 그렇다’ 선택한 자만 하단에 조사항목 표가 다음과 같이 나타남)</DIV>
			<div class="table-responsive">
				<TABLE CLASS="table table-bordered table-hover">
					<TR CLASS="warning">
						<TH WIDTH="60%">설문문항</TH>
						<TH>매우 아니다	</TH>
						<TH>아니다</TH>
						<TH>보통이다</TH>
						<TH>그렇다</TH>
						<TH>매우 그렇다</TH>
					</TR>
					<TR>
						<TD class="td2" id="label_q10_1"><SPAN CLASS="QUESTION_NO">10-1.</SPAN>시각화장표가 업무에 도움이 되었습니까?</TD>
						<TD><input class="form-check-input" type="radio" name="q10_1" value="1" id="q10_1_1"></TD>
						<TD><input class="form-check-input" type="radio" name="q10_1" value="2" id="q10_1_2"></TD>
						<TD><input class="form-check-input" type="radio" name="q10_1" value="3" id="q10_1_3"></TD>
						<TD><input class="form-check-input" type="radio" name="q10_1" value="4" id="q10_1_4"></TD>
						<TD><input class="form-check-input" type="radio" name="q10_1" value="5" id="q10_1_5"></TD>
					</TR>
					<TR>
						<TD class="td2" id="label_q10_2"><SPAN CLASS="QUESTION_NO">10-2.</SPAN>시각화장표를 주로 어떤 목적으로 사용하십니까?</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q10_2" id="q10_2" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
					<TR>
						<TD class="td2" id="label_q10_3"><SPAN CLASS="QUESTION_NO">10-3.</SPAN>시각화장표에 개선이 필요한 경우, 자유롭게 기술해 주십시오.</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q10_3" id="q10_3" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
				</TABLE>
			</div>
		</div>
		
		<div id="q10_t2" style="display:none;">
			<DIV CLASS="TABLE_TITLE">※ 미사용 이유 조사 (‘② 아니다’ 선택한 자만 하단에 조사항목 표가 다음과 같이 나타남)</DIV>
			<div class="table-responsive">
				<TABLE CLASS="table table-bordered table-hover">
					<TR>
						<TD class="td2" style="font-weight:bold;"><SPAN CLASS="QUESTION_NO">10-4.</SPAN>시각화장표 미사용 사유를 기술해 주십시오.</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
				</TABLE>
			 </div>
		</div>

		<DIV CLASS="EMPTY_LINE"></DIV>
		
		<DIV CLASS="QUESTION_TITLE" id="label_q11">
			<SPAN CLASS="QUESTION_NO">11.</SPAN>[진로탐색] - [청년진로] 메뉴를 사용하신 적이 있습니까?
		</DIV>
		<DIV CLASS="QUESTION_OBJECT">
			<input class="form-check-input" type="radio" name="q11" value="1" id="q11_1" onclick="javascript:$('#q11_t1').css('display','block');$('#q11_t2').css('display','none');">
			<label class="form-check-label" for="q11_1">
				그렇다
			</label>
			<input class="form-check-input" type="radio" name="q11" value="2" id="q11_2" onclick="javascript:$('#q11_t1').css('display','none');$('#q11_t2').css('display','block');" style="margin-left:20px;">
			<label class="form-check-label" for="q11_2">
				아니다
			</label>
		</DIV>
		
		<div id="q11_t1" style="display:none;">
			<DIV CLASS="TABLE_TITLE">※ 청년진로 만족도 조사 (‘① 그렇다’ 선택한 자만 하단에 조사항목 표가 다음과 같이 나타남)</DIV>
			<div class="table-responsive">
				<TABLE CLASS="table table-bordered table-hover">
					<TR CLASS="warning">
						<TH WIDTH="60%">설문문항</TH>
						<TH>매우 아니다	</TH>
						<TH>아니다</TH>
						<TH>보통이다</TH>
						<TH>그렇다</TH>
						<TH>매우 그렇다</TH>
					</TR>
					<TR>
						<TD class="td2" id="label_q11_1"><SPAN CLASS="QUESTION_NO">11-1.</SPAN>청년진로가 업무에 도움이 되었습니까?</TD>
						<TD><input class="form-check-input" type="radio" name="q11_1" value="1" id="q11_1_1"></TD>
						<TD><input class="form-check-input" type="radio" name="q11_1" value="2" id="q11_1_2"></TD>
						<TD><input class="form-check-input" type="radio" name="q11_1" value="3" id="q11_1_3"></TD>
						<TD><input class="form-check-input" type="radio" name="q11_1" value="4" id="q11_1_4"></TD>
						<TD><input class="form-check-input" type="radio" name="q11_1" value="5" id="q11_1_5"></TD>
					</TR>
					<TR>
						<TD class="td2" id="label_q11_2"><SPAN CLASS="QUESTION_NO">11-2.</SPAN>청년진로를 주로 어떤 목적으로 사용하십니까?</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q11_2" id="q11_2" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
					<TR>
						<TD class="td2" id="label_q11_3"><SPAN CLASS="QUESTION_NO">11-3.</SPAN>청년진로에 개선이 필요한 경우, 자유롭게 기술해 주십시오.</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q11_3" id="q11_3" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
				</TABLE>
			</div>
		</div>
		
		<div id="q11_t2" style="display:none;">
			<DIV CLASS="TABLE_TITLE">※ 미사용 이유 조사 (‘② 아니다’ 선택한 자만 하단에 조사항목 표가 다음과 같이 나타남)</DIV>
			<div class="table-responsive">
				<TABLE CLASS="table table-bordered table-hover">
					<TR>
						<TD class="td2" id="label_q11_4" style="font-weight:bold;"><SPAN CLASS="QUESTION_NO">11-4.</SPAN>청년진로 미사용 사유를 기술해주십시오.</TD>
						<TD COLSPAN="5"><TEXTAREA NAME="q11_4" id="q11_4" CLASS="INPUT_TXT"/></TEXTAREA></TD>
					</TR>
				</TABLE>
			</div>
		</div>
		
		<DIV CLASS="EMPTY_LINE"></DIV>
		
		<DIV CLASS="QUESTION_TITLE">
			<SPAN CLASS="QUESTION_NO">12.</SPAN>지역통계 수요가 증대함에 따라, 취업통계연보에 ‘학교 소재지(17개 시도)별 취업통계 현황’이 수록될 예정입니다.
		</DIV>

		<DIV CLASS="DESC_BOX">
			<span style="font-weight:bold; font-size:16px;">※ 학교 소재지별 취업통계 현황 장표 4종(안)</span><br>
			<span style="font-weight:normal;">
 			&nbsp&nbsp&nbsp&nbsp- 학교 소재지별 기업유형별 취업현황<br>
 			&nbsp&nbsp&nbsp&nbsp- 학교 소재지별 산업분류별 취업현황<br>
 			&nbsp&nbsp&nbsp&nbsp- 학교 소재지별 근무지역(17개 시도)별 취업현황<br>
 			&nbsp&nbsp&nbsp&nbsp- 학교 소재지별 진학지역(17개 시도)별 취업현황<br>
 			</span>
		</DIV>
		
		<DIV CLASS="EMPTY_LINE"></DIV>
		
		<div class="table-responsive">
			<TABLE CLASS="table table-bordered table-hover">
				<TR>
					<TD class="td2" id="label_q12" style="font-weight:bold;"><SPAN CLASS="QUESTION_NO">12.</SPAN>학교 소재지별 취업통계 현황 장표 4종(안)외 지역통계로 유용한 정보는 무엇입니까?</TD>
					<TD COLSPAN="5"><TEXTAREA NAME="q12" id="q12" CLASS="INPUT_TXT"/></TEXTAREA></TD>
				</TR>
			</TABLE>
		</div>
    </div>
  </div>
</div>	

	<input type="hidden" name="SURVEY_CODE" id="SURVEY_CODE" value="<%=request.getParameter("SURVEY_CODE")%>" />
	<input type="hidden" name="USERID" id="USERID" value="<%=request.getParameter("USERID")%>" />
	
	<div style="text-align:center; background:yellow;"><button class="btn btn-lg btn-primary btn-block" type="button" onclick="javascript:go_Submit();">저장</button></div>

</form>
	
	<DIV CLASS="EMPTY_LINE"></DIV>
	<DIV CLASS="EMPTY_LINE"></DIV>
	<DIV CLASS="EMPTY_LINE"></DIV>
	<DIV CLASS="EMPTY_LINE"></DIV>
	<DIV CLASS="EMPTY_LINE"></DIV>

</BODY>
</html>
<script src="../CALL/bootstrap-3.3.2/dist/js/jquery-1.12.3.min.js"></script>
<script src="../CALL/bootstrap-3.3.2/dist/js/bootstrap.min.js"></script>
