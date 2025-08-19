		var preWord;
		var n = 0, findLength = 0;
		function findWordInPage() {
			var word = document.getElementById('findWord').value;
			if (word == '') { alert('검색어를 입력하세요.'); return; }
			
			if (navigator.userAgent.indexOf('MSIE') > -1 || navigator.userAgent.indexOf('Trident') > -1) { // IE
				var reFind = true;
				if (preWord != word) { preWord = word; reFind = false; }
				
				if (!reFind) { // 해당 단어 첫 검색
					$(".findWordResult").removeAttr('class');
					
					n = 0; findLength = 0;
					
					var range = window.document.body.createTextRange();
					range.moveToElementText(regulCont);
					if (range) {
						while (range.findText(word)) {
							range.pasteHTML("<fwr class='findWordResult'>" + range.text + "</fwr>");
							range.moveStart("character", range.text.length);
							
							n++; findLength++;
						}
					}
					
					if (n == 0) {
						alert('결과가 없습니다.');
					}
					n = 0;
				}
				else { // 해당 단어 다시 검색
					var found;
					
					var range = window.document.body.createTextRange();
					range.moveToElementText(regulCont);
					
					for (var i=0; i<=n && (found = range.findText(word)) != false; i++) {
						range.moveStart("character", 1);
						range.moveEnd("textedit");
					}
					
					if (found) {
						range.moveStart("character", -1);
						range.findText(word);
						range.select();
						range.scrollIntoView();
						n++
					}
					
					if (n == 0) {
						alert('결과가 없습니다.');
					}
					if (n == findLength) {
						n = 0;
					}
				}
			}
			else { // None IE
				if (!window.find(word)) {
					while (window.find(word, false, true)) {
						n++;
					}
				}
				else {
					n++;
				}
			}
		} // findWordInPage()