var draggedEventIsAllDay;
var activeInactiveWeekends = true;

function getDisplayEventDate(event) {
	var displayEventDate;
	if (event.allDay == false) {
		var startTimeEventInfo = moment(event.start).format('HH:mm');
		var endTimeEventInfo = moment(event.end).format('HH:mm');
		displayEventDate = startTimeEventInfo + " - " + endTimeEventInfo;
	} else {
		displayEventDate = "하루종일";
	}
	return displayEventDate;
}

function filtering(event) {
/*
	var show_username = true;
	var show_type = true;
	var username = $('input:checkbox.filter:checked').map(function () {
		return $(this).val();
	}).get();
	var types = $('#type_filter').val();
	
	show_username = username.indexOf(event.username) >= 0;
	if (types && types.length > 0) {
		if (types[0] == "all") {
			show_type = true;
		} else {
			show_type = types.indexOf(event.type) >= 0;
		}
	}
	return show_username && show_type;
*/
}

function calDateWhenResize(event) {
	var newDates = {
		startDate: '',
		endDate: ''
	};
	if (event.allDay) {
		newDates.startDate = moment(event.start._d).format('YYYY-MM-DD');
		newDates.endDate = moment(event.end._d).subtract(1, 'days').format('YYYY-MM-DD');
	} else {
		newDates.startDate = moment(event.start._d).format('YYYY-MM-DD HH:mm');
		newDates.endDate = moment(event.end._d).format('YYYY-MM-DD HH:mm');
	}
	return newDates;
}

function calDateWhenDragnDrop(event) {
	// 드랍시 수정된 날짜반영
	var newDates = {
		startDate: '',
		endDate: ''
	}
	// 날짜 & 시간이 모두 같은 경우
	if(!event.end) {
		vevent.end = event.start;
	}
	//하루짜리 all day
	if (event.allDay && event.end === event.start) {
		newDates.startDate = moment(event.start._d).format('YYYY-MM-DD');
		newDates.endDate = newDates.startDate;
	}
	//2일이상 all day
	else if (event.allDay && event.end !== null) {
		newDates.startDate = moment(event.start._d).format('YYYY-MM-DD');
		newDates.endDate = moment(event.end._d).subtract(1, 'days').format('YYYY-MM-DD');
	}
	//all day가 아님
	else if (!event.allDay) {
		newDates.startDate = moment(event.start._d).format('YYYY-MM-DD HH:mm');
		newDates.endDate = moment(event.end._d).format('YYYY-MM-DD HH:mm');
	}
	return newDates;
}

var calendar = $('#calendar').fullCalendar({
	eventRender: function (event, element, view) {
		//일정에 hover시 요약
		element.popover({
			title: $('<div />', {
				class: 'popoverTitleCalendar',
				text: event.title
			}).css({
				'background': event.backgroundColor,
				'color': event.textColor
			}),
			content: $('<div />', {
				class: 'popoverInfoCalendar'
			}).append(isEmpty(event.MSG)),
			delay: {
				show: "800",
				hide: "50"
			},
			trigger: 'hover',
			placement: 'top',
			html: true,
			container: 'body'
		});
		return filtering(event);
	},
	//주말 숨기기 & 보이기 버튼
	customButtons: {
		viewWeekends: {
			text: '주말',
			click: function () {
				activeInactiveWeekends ? activeInactiveWeekends = false : activeInactiveWeekends = true;
				$('#calendar').fullCalendar('option', {
					weekends: activeInactiveWeekends
				});
			}
		}
	},
	header: {
		left: 'today, prevYear, nextYear, viewWeekends',
		center: 'prev, title, next',
		right: 'month,agendaWeek,agendaDay,listWeek'
	},
	views: {
		month: {
			columnFormat: 'dddd'
		},
		agendaWeek: {
			columnFormat: 'M/D ddd',
			titleFormat: 'YYYY년 M월 D일',
			eventLimit: false
		},
		agendaDay: {
			columnFormat: 'dddd',
			eventLimit: false
		},
		listWeek: {
			columnFormat: ''
		}
	},
	
	/* ****************
	 *  일정 받아옴 
	 * ************** */
	events: function (start, end, timezone, callback) {
		$.ajax({
			type: "post",
			url: CONTEXTPATH+"/web/suit/selectCalData.do",
			dataType:"JSON",
			data:getCalParam($.fullCalendar.moment(start).format("YYYY-MM-DD"), $.fullCalendar.moment(end).format("YYYY-MM-DD")),
			success: function (response) {
				var fixedDate = response.map(function (array) {
					if (array.allDay && array.start !== array.end) {
						// 이틀 이상 AllDay 일정인 경우 달력에 표기시 하루를 더해야 정상출력
						array.end = moment(array.end).add(1, 'days');
					}
					return array;
				})
				callback(fixedDate);
			}
		});
	},
	eventAfterAllRender: function (view) {
		if (view.name == "month") {
			$(".fc-content").css('height', 'auto');
		}
	},
	//일정 리사이즈
	eventResize: function (event, delta, revertFunc, jsEvent, ui, view) {
		$('.popover.fade.top').remove();
		/** 리사이즈시 수정된 날짜반영
		 * 하루를 빼야 정상적으로 반영됨. */
		var newDates = calDateWhenResize(event);
		//리사이즈한 일정 업데이트
		$.ajax({
			type: "get",
			url: "",
			data: { },
			success: function (response) {
				alert('수정: ' + newDates.startDate + ' ~ ' + newDates.endDate);
			}
		});
	},
	eventDragStart: function (event, jsEvent, ui, view) {
		draggedEventIsAllDay = event.allDay;
	},
	//일정 드래그앤드롭
	eventDrop: function (event, delta, revertFunc, jsEvent, ui, view) {
		$('.popover.fade.top').remove();
		//주,일 view일때 종일 <-> 시간 변경불가
		if (view.type === 'agendaWeek' || view.type === 'agendaDay') {
			if (draggedEventIsAllDay !== event.allDay) {
				alert('드래그앤드롭으로 종일<->시간 변경은 불가합니다.');
				location.reload();
				return false;
			}
		}
		// 드랍시 수정된 날짜반영
		var newDates = calDateWhenDragnDrop(event);
		
		//드롭한 일정 업데이트
		$.ajax({
			type: "get",
			url: "",
			data: { },
			success: function (response) {
				alert('수정: ' + newDates.startDate + ' ~ ' + newDates.endDate);
			}
		});
	},
	select: function (startDate, endDate, jsEvent, view) {
		$(".fc-body").unbind('click');
		$(".fc-body").on('click', 'td', function (e) {
		
		$("#contextMenu")
			.addClass("contextOpened")
			.css({
				display: "block",
				left: e.pageX,
				top: e.pageY
			});
			return false;
		});
		
		var today = moment();
		
		if (view.name == "month") {
			startDate.set({
				hours: today.hours(),
				minute: today.minutes()
			});
			startDate = moment(startDate).format('YYYY-MM-DD HH:mm');
			endDate = moment(endDate).subtract(1, 'days');
			
			endDate.set({
				hours: today.hours() + 1,
				minute: today.minutes()
			});
			endDate = moment(endDate).format('YYYY-MM-DD HH:mm');
		} else {
			startDate = moment(startDate).format('YYYY-MM-DD HH:mm');
			endDate = moment(endDate).format('YYYY-MM-DD HH:mm');
		}
		//날짜 클릭시 카테고리 선택메뉴
		var $contextMenu = $("#contextMenu");
		$contextMenu.on("click", "a", function (e) {
			e.preventDefault();
			//닫기 버튼이 아닐때
			if ($(this).data().role !== 'close') {
				newEvent(startDate, endDate, $(this).html());
			}
			$contextMenu.removeClass("contextOpened");
			$contextMenu.hide();
		});
		
		$('body').on('click', function () {
			$contextMenu.removeClass("contextOpened");
			$contextMenu.hide();
		});
	},
	//이벤트 클릭시 수정이벤트
	eventClick: function (event, jsEvent, view) {
//		var gbn = $("#gbn").val();
		var gbn = event.GBN;
//		if (gbn == "S") {
		if (gbn == "SUIT") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","calInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "calInfo");
			newForm.attr("action", CONTEXTPATH+"/web/suit/caseViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:event.DOCPK2}));
			newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:event.DOCPK1}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
//		} else if (gbn == "C") {
		} else if (gbn == "CONSULT") {
			// 자문 팝업
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","calInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "calInfo");
			newForm.attr("action", CONTEXTPATH+"/web/consult/consultViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"consultid", value:event.DOCPK1}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
//		} else if (gbn == "A") {
		} else if (gbn == "AGREE") {
			// 자문 팝업
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","calInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "calInfo");
			newForm.attr("action", CONTEXTPATH+"/web/agree/agreeViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:event.DOCPK1}));
			newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:event.MENU_NO}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "LWYR") {
			var cw=1200;
			var ch=600;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","lawyerInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "lawyerInfo");
			newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/lawyerViewPagePop.do");
			newForm.append($("<input/>", {type:"hidden", name:"LWYR_MNG_NO", value:event.DOCPK1}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "BOND") {
			var cw=900;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","infoView",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "infoView");
			newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/bondViewPage.do");
			newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:event.DOCPK3}));
			newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:event.DOCPK2}));
			newForm.append($("<input/>", {type:"hidden", name:"BND_MNG_NO", value:event.DOCPK1}));
			newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:''}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		}
	},
	locale: 'ko',
	timezone: "local",
	nextDayThreshold: "09:00:00",
	allDaySlot: true,
	displayEventTime: true,
	displayEventEnd: true,
	firstDay: 0, //월요일이 먼저 오게 하려면 1
	weekNumbers: false,
	selectable: true,
	weekNumberCalculation: "ISO",
	eventLimit: true,
	views: { month: {eventLimit: 12} },
	eventLimitClick: 'week', //popover
	navLinks: true,
	//defaultDate: moment('2019-05'), //실제 사용시 삭제
	timeFormat: 'HH:mm',
	defaultTimedEventDuration: '01:00:00',
	editable: true,
	minTime: '00:00:00',
	maxTime: '24:00:00',
	slotLabelFormat: 'HH:mm',
	weekends: true,
	nowIndicator: true,
	dayPopoverFormat: 'MM/DD dddd',
	longPressDelay: 0,
	eventLongPressDelay: 0,
	selectLongPressDelay: 0,
	height: '100%'
});

function isEmpty(value){
	if(value == null || value.length === 0 || value == undefined){
		return "";
	}else{
		return value;
	}
}

function getCalParam(start, end){
	return {
		start: start,
		end: end,
		docGbn:$("#docGbn").val(),
		dateGbn:$("#dateGbn").val()
	};
}

function reloadCalendar(){
	//window.location.href = CONTEXTPATH+'/web/suit/fullcalendar.do';
	var frm = document.frm;
	frm.action = "fullcalendar.do";
	frm.submit();
}