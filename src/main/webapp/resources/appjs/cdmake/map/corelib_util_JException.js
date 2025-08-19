<!--
/**
 * @author 유건상 (ggonsika@naver.com, http://blog.naver.com/ggonsika)
 * 
 * 맨 위의 이름은 가능한한 남겨주시고 (^^)
 * 사용자 마음대로 수정을 가하셔도 법적 처벌은 얼토당토하며
 * 무한카피, 무한 배포는 필수입니다.
 */

/**
 * 일반적인 예외 Class
 *
 * 생성자
 * @param message 에러메시지
 */
function JException(message) {
	/** 클래스명 */
	this.name = "JException";
	/** 에러메시지 */
	this.message = message;
	
	/**
	 * 클래스명을 얻는다.
	 */
	this.getName = function() {
		return this.name;
	}
	
	/**
	 * 에러메시지를 얻는다.
	 */
	this.getMessage = function() {
		return this.message;
	}
}

/**
 * 배열의 Index 를 초과했을때의 예외 Class
 *
 * 생성자
 * @param message 에러메시지
 */
function JArrayIndexOutOfBoundsException(message) {
	/** 에러메시지 */
	this.message = message;
	
	this.getMessage = function() {
		return this.message;
	}
}

/**
 * Instance 가 null 일때의 예외 Class
 *
 * 생성자
 * @param message 에러메시지
 */
function JNullPointerException(message) {
	/** 에러메시지 */
	this.message = message;
	
	this.getMessage = function() {
		return this.message;
	}
}
//-->
