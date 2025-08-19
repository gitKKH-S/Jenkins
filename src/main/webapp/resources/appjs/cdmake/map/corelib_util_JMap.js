<!--
/**
 * @author ���ǻ� (ggonsika@naver.com, http://blog.naver.com/ggonsika)
 * 
 * �� ���� �̸��� �������� �����ֽð� (^^)
 * ����� ������� ������ ���ϼŵ� ���� ó���� ��������ϸ�
 * ����ī��, ���� ������ �ʼ��Դϴ�.
 */

/**
 * [����]
 * java �� Map �������̽��� �����ϰ� ��밡���ϴ�.
 * ���� ���� ���̹Ƿ� �������� ���ڿ��� ���ȴ�.
 * key ���� null �� ���� �ʴ´ٸ� try.. catch ���� ���ġ �ʾƵ� �ȴ�.

 * [������]
 * 1. JMap()
 *
 * [�ʼ� Ŭ����]
 *   - common_cls_JException.js
 *
 * [Public Method]
 *   - map.get(key):object - ������ key �� �ش��ϴ� value �� ��´�
 *   - map.remove(key):void - ������ key �� �ش��ϴ� value �� �����Ѵ�
 *   - map.keys():array - ��ü Key ������ �迭�� ��´�
 *   - map.values():array - ���� ��ü ������ �迭�� ��´�
 *   - map.containsKey(key):boolean - key �� ���ԵǾ� �ִٸ� true �� ��ȯ�Ѵ�.
 *   - map.isEmpty():boolean - ���� ����ִٸ� true �� ��ȯ�Ѵ�.
 *   - map.clear():void - ���� ����
 *   - map.size():int - ���� ũ�⸦ ��´�
 *   - map.toString():string - ��ü�� ���ڿ��� ��ȯ�Ѵ� (key^value|key^value|... ����)
 *
 * [��뿹]
 * <html>
 * <head>
 * <script language=javascript src="corelib_util_JException.js"></script>
 * <script language=javascript src="corelib_util_JMap.js"></script>
 * <script language=javascript>
 * <!--
 *     try {
 *         var map = new JMap();
 *         map.put(null, "testValue1");
 *         alert(map.get("0"));
 *     } catch (e) {
 *         alert(e.getMessage());
 *     }
 * -->
 * </script>
 * </head>
 * </html>
 * 
 */
function JMap() {
	
	/** �迭�� index ��� */
	this._INDEX_KEY = 0;
	this._INDEX_VALUE = 1;
	
	/** private ������ ���� Array */
	this._elementData = new Array(0);

	this.put = function(key, value) {
		var index = this._findIndexByKey(key);
		if (index >= 0) {
			(this._elementData[index])[this._INDEX_VALUE] = value;
		} else {
			var pair = new Array(2);
			pair[this._INDEX_KEY] = key;
			pair[this._INDEX_VALUE] = value;
			this._elementData.splice(this._elementData.length, 0, pair);
		}
	}
	
	/**
	 * public
	 * ������ key �� �ش��ϴ� value �� ��´�
	 * @param key Ű��
	 * @return Ű�� �ش��ϴ� ��
	 */
	this.get = function(key) {
		var index = this._findIndexByKey(key);
		if (index >= 0) {
			return (this._elementData[index])[this._INDEX_VALUE];
		}
		return null;
	}
	
	/**
	 * public
	 * ������ key �� �ش��ϴ� value �� �����Ѵ�
	 * @param key Ű��
	 */
	this.remove = function(key) {
		var removeIndex = this._findIndexByKey(key);
		if (removeIndex >= 0) {
			this._elementData.splice(removeIndex, 1);
		}
	}
	
	/**
	 * public
	 * ���� ��ü Key ������ �迭�� ��´�
	 * @return key ������ Array
	 */
	this.keys = function() {
		var keys = new Array(this._elementData.length);
		for (var i = 0; i < this._elementData.length; i++) {
			keys[i] = (this._elementData[i])[this._INDEX_KEY];
		}
		return keys;
	}
	
	/**
	 * public
	 * ���� ��ü ������ �迭�� ��´�.
	 * @return key ������ Array
	 */
	this.values = function() {
		var values = new Array(this._elementData.length);
		for (var i = 0; i < this._elementData.length; i++) {
			values[i] = (this._elementData[i])[this._INDEX_VALUE];
		}
		return values;
	}
	
	/**
	 * public
	 * �ʿ� key �� ���ԵǾ� �ִٸ� true
	 * @param key Ű��
	 * @return Ű�� ���� ����
	 */
	this.containsKey = function(key) {
		return (this._findIndexByKey(key) >= 0);
	}
	
	/**
	 * public
	 * ���� ����ִٸ� true
	 * @return ���� ��������� ����
	 */
	this.isEmpty = function() {
		return (this.size() == 0);
	}
	
	/**
	 * public
	 * ���� ����
	 */
	this.clear = function() {
		this._elementData.splice(0, this._elementData.length);
	}
	
	/**
	 * public
	 * ���� ũ�⸦ ��´�
	 * @return ���� ũ��
	 */
	this.size = function() {
		return this._elementData.length;
	}
	
	/**
	 * public
	 * ��ü�� ���ڿ��� ��ȯ�Ѵ� (key^value|key^value|... ����)
	 * @return ���ڿ�
	 */
	this.toString = function() {
		var str = "";
		for (var i = 0; i < this._elementData.length; i++) {
			if (i > 0) {
				str += "|";
			}
			str += (this._elementData[i]).join("^");
		}
		return str;
	}
	
	/**
	 * private
	 * �ش� key �� index �� ã�´�.
	 * ã�� ���ϸ� -1 �� return �Ѵ�. (0���� �񱳰� ���� ����)
	 * @param key Ű��
	 * @exception JException 
	 */
	this._findIndexByKey = function(key) {
		if (key == null) {
			throw new JNullPointerException("map's key is null");
		}
		
		for (var i = this._elementData.length - 1; i >= 0; i--) {
			var oldKey = (this._elementData[i])[this._INDEX_KEY];
			if (key == oldKey) {
				return i;
			}
		}
		return -1;
	}
} // End of JMap Class

//-->
