<!--
/**
 * @author ���ǻ� (ggonsika@naver.com, http://blog.naver.com/ggonsika)
 * 
 * �� ���� �̸��� �������� �����ֽð� (^^)
 * ����� ������� ������ ���ϼŵ� ���� ó���� ��������ϸ�
 * ����ī��, ���� ������ �ʼ��Դϴ�.
 */

/**
 * �Ϲ����� ���� Class
 *
 * ������
 * @param message �����޽���
 */
function JException(message) {
	/** Ŭ������ */
	this.name = "JException";
	/** �����޽��� */
	this.message = message;
	
	/**
	 * Ŭ�������� ��´�.
	 */
	this.getName = function() {
		return this.name;
	}
	
	/**
	 * �����޽����� ��´�.
	 */
	this.getMessage = function() {
		return this.message;
	}
}

/**
 * �迭�� Index �� �ʰ��������� ���� Class
 *
 * ������
 * @param message �����޽���
 */
function JArrayIndexOutOfBoundsException(message) {
	/** �����޽��� */
	this.message = message;
	
	this.getMessage = function() {
		return this.message;
	}
}

/**
 * Instance �� null �϶��� ���� Class
 *
 * ������
 * @param message �����޽���
 */
function JNullPointerException(message) {
	/** �����޽��� */
	this.message = message;
	
	this.getMessage = function() {
		return this.message;
	}
}
//-->
