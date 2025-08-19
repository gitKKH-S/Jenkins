/**
 * ajax utf-8 encoding
 * @param frm
 * @return
 */
function lk_encodeComponents(frm) {
    var elmtList = frm.getElementsByTagName("input");
    for (var i=0; i < elmtList.length ;i++ ){
        if(elmtList[i].type == "text" || elmtList[i].type == "hidden") {
            //alert(elmtList[i].name +":"+ elmtList[i].value);
            elmtList[i].value = encodeURIComponent(elmtList[i].value);

        }
    }
    elmtList = frm.getElementsByTagName("textarea");
    for (var i=0; i < elmtList.length ;i++ ){
        //alert(elmtList[i].name +":"+ elmtList[i].value);
        elmtList[i].value = encodeURIComponent(elmtList[i].value);
    }
}
/**
 * decoding
 * @param frm
 * @return
 */
function lk_decodeComponents(frm) {
    var elmtList = frm.getElementsByTagName("input");
    for (var i=0; i < elmtList.length ;i++ ){
        if(elmtList[i].type == "text" || elmtList[i].type == "hidden") {
            //alert(elmtList[i].name +":"+ elmtList[i].value);
            elmtList[i].value = decodeURIComponent(elmtList[i].value);
        }
    }

    elmtList = frm.getElementsByTagName("textarea");
    for (var i=0; i < elmtList.length ;i++ ){
        //alert(elmtList[i].name +":"+ elmtList[i].value);
        elmtList[i].value = decodeURIComponent(elmtList[i].value);
    }
    elmtList = frm.getElementsByTagName("select");
    for (var i=0; i < elmtList.length ;i++ ){
        //alert(elmtList[i].name +":"+ elmtList[i].value);
        elmtList[i].value = decodeURIComponent(elmtList[i].value);
    }
}
/**
 *
 * @param field 체크 필드
 * @param def 체크 값
 * @param msg alert 메세지
 * @return
 */
function fInputBoxCheck(field, def, msg){
    if (trim(field.value) == def)    {
        alert(msg);
        field.focus();
        return false;
    }
    return true;
}

/**
 * 대문자변환
 *
 * @param str
 * @return
 */
function toUpperCase(str){
    if(isEmpty(str)) return str;
    return str.toUpperCase();
}
/**
 * EMAIL 유효성 검증
 *
 * @param email
 * @return
 */
function isValidEmail(email){
    if(!isEmpty(email)){
        //올바른 EMAIL 인지 검증
        var format = /^((\w|[\-\.])+)@((\w|[\-\.])+)\.([A-Za-z]+)$/;
        if (email.search(format) == -1) {
            alert("유효하지 않은 이메일 형식입니다.");
            return false
        }
        return true;
    }
}
/**
 * 사용자번호 체크
 *
 * @param obj
 * @param radioObj
 * @return
 */
function isValidJuminSaup(obj,radioObj) {
    if(obj.value.length > 0){
        if(radioObj[0].checked){
            if(!isValidJuminNo(obj.value)){
                obj.focus();
            }else{
                obj.value = jsGetFormat(obj.value,"-","6-7");
            }
        }else if(radioObj[1].checked){
            if(!isValidSaupNo(obj.value)){
                obj.focus();
            }else{
                obj.value = jsGetFormat(obj.value,"-","3-2-5");
            }
        }
    }
}

/**
 * 주민등록번호 유효성 검증
 *
 * @param regno
 * @return
 */
function isValidJuminNo(regno){

    //널인지?
    if(isEmpty(regno)){
        return null;
    }
    // 13자리 숫자인가? -> 주민번호
    if((getByteLength(regno) != 13) || (!isNum(regno)) ) {
        alert("주민등록번호는 13자리 숫자입니다.");
        return false;
    }

    //올바른 주민등록번호인지 검증
    var ju = regno.substring(0,6);
    var ju1 = regno.substring(6);
    juid = new Array(0,0,0,0,0,0,0,0,0,0,0,0,0);
    for(var i = 0; i<6;i++)
        juid[i] = ju.substring(i,i+1);
    for(i=0;i<7;i++)
        juid[i+6] = ju1.substring(i,i+1);
    for(var sum = 0, i = 0;i<12;i++)
        sum += juid[i] * ((i >7) ? (i-6) : (i+2));
    var mod = 11 - sum%11;
    if(mod >= 10)
        mod -= 10;
    if(mod != juid[12]) {
        alert("올바르지 않은 주민등록번호입니다.");
        return false;
    }
    else {
        return true;
    }
}



/**
 * 사업자번호 유효성 검증
 *
 * @param strNumb
 * @return
 */
function isValidSaupNo(strNumb){
    //널인지?
    if(isEmpty(strNumb)){
        return null;
    }
    // 10자리 숫자인가?
    if((getByteLength(strNumb) != 10) || (!isNum(strNumb)) ) {
        alert("사업자등록번호는 10자리 숫자입니다.");
        return false;
    }
    sumMod	=	0;
    sumMod	+=	Number(strNumb.substring(0,1));
    sumMod	+=	Number(strNumb.substring(1,2)) * 3 % 10;
    sumMod	+=	Number(strNumb.substring(2,3)) * 7 % 10;
    sumMod	+=	Number(strNumb.substring(3,4)) * 1 % 10;
    sumMod	+=	Number(strNumb.substring(4,5)) * 3 % 10;
    sumMod	+=	Number(strNumb.substring(5,6)) * 7 % 10;
    sumMod	+=	Number(strNumb.substring(6,7)) * 1 % 10;
    sumMod	+=	Number(strNumb.substring(7,8)) * 3 % 10;
    sumMod	+=	Math.floor(Number(strNumb.substring(8,9)) * 5 / 10);
    sumMod	+=	Number(strNumb.substring(8,9)) * 5 % 10;
    sumMod	+=	Number(strNumb.substring(9,10));
    if	(sumMod % 10	!=	0)
    {
        alert("올바르지 않은 사업자등록번호입니다.");
        return false;
    }
    return	true;
}
function getByteLength(s){

    var len = 0;
    if ( s == null ) return 0;
    for(var i=0;i<s.length;i++){
        var c = escape(s.charAt(i));
        if ( c.length == 1 ) len ++;
        else if ( c.indexOf("%u") != -1 ) len += 2;
        else if ( c.indexOf("%") != -1 ) len += c.length/3;
    }
    return len;
}
/**
 * 영문과 숫자로 이루어진 String 인지 체크한다.
 *
 * @param str
 * @return
 */
function isEngNum(str){
    var err = 0;
    for (var i=0; i<str.length; i++) {
        var chk = str.substring(i,i+1);
        if(!chk.match(/[0-9]|[a-z]|[A-Z]/))
            err = err + 1;
    }

    if (err > 0) return false;
    else return true;
}
/**
 * 빈값인지 리턴한다.
 *
 * @param pValue
 * @return
 */
function isEmpty(pValue){
    if( (pValue == "") || (pValue == null) ){
        return true;
    }
    return false;
}
//숫자검증
function isNum(str){

    if(isEmpty(str)) return false;

    for(var idx=0;idx < str.length;idx++){
        if(str.charAt(idx) < '0' || str.charAt(idx) > '9'){
            return false;
        }
    }
    return true;
}
/**
 *
 * @param frm
 * @return
 */
function fFormReset(frm){
    var len = frm.elements.length;

    for(i=0; i<len; i++)   {
        if(frm.elements[i].type == 'text' || frm.elements[i].type == 'TEXT')     {
            frm.elements[i].value = '';
        }
    }

}
/**
 * 8자리로 된 날짜 받아서 4자리/2자리/2자리로 추출반환
 *
 * @param str
 * @return
 */
function displayDate(str){
    if (str == "") return;
    document.write(str.substring(0,4) + "-" + ((str.substring(4,5) == "0")? str.substring(5,6):str.substring(4,6)) + "-" + ((str.substring(6,7) == "0")?str.substring(7,8):str.substring(6,8)));
}
/**
 *
 * @param numString
 * @return
 */
function formatCommas(numString) {
    if(numString =="") {
        return "0";
    }
    var re = /,|\s+/g;
    numString = numString.replace(re, "");
    re = /(-?\d+)(\d{3})/;
    while (re.test(numString)) {
        numString = numString.replace(re, "$1,$2");
    }
    return numString;
}
/**
 *
 * @param elm
 * @return
 */
function changeAmt(elm) {
    elm.value = elm.value.replace(/[^\d]/g, "");
    elm.value = formatCommas(elm.value);
}