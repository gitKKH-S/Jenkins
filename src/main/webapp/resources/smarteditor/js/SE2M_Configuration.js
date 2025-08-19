/*
 * Smart Editor 2 Configuration : This setting must be changed by service
 */
window.nhn = window.nhn || {};
nhn.husky = nhn.husky || {};
nhn.husky.SE2M_Configuration = nhn.husky.SE2M_Configuration || {};

/**
 * CSS LazyLoad�� ���� ���
 */
nhn.husky.SE2M_Configuration.SE2B_CSSLoader = {
	sCSSBaseURI : "css"
};

/**
 * �������� ����
 */
nhn.husky.SE2M_Configuration.SE_EditingAreaManager = {
	sCSSBaseURI : "css",					// smart_editor2_inputarea.html ������ �����
	sBlankPageURL : "smart_editor2_inputarea.html",
	sBlankPageURL_EmulateIE7 : "smart_editor2_inputarea_ie8.html",
	aAddtionalEmulateIE7 : [] // IE8 default ���, IE9 ~ ������ ���
};

/**
 * [�����ټ�]
 * ����Ű ALT+,  ALT+. �� �̿��Ͽ� ����Ʈ������ ������ ����/���� ��ҷ� �̵��� �� �ִ�.
 * 		sBeforeElementId : ����Ʈ������ ���� ���� ����� id
 * 		sNextElementId : ����Ʈ������ ���� ���� ����� id 
 * 
 * ����Ʈ������ ���� �̿��� ���� ���� (��:����Ʈ�����Ͱ� ����� ��α� ���� ������������ ���� ����) �� �ش��ϴ� ������Ʈ���� TabŰ�� ������ ������ �������� ��Ŀ���� �̵���ų �� �ִ�.
 * 		sTitleElementId : ���� �ش��ϴ� input ����� id. 
 */
nhn.husky.SE2M_Configuration.SE2M_Accessibility = {
    sBeforeElementId : '',
    sNextElementId : '',
    sTitleElementId : ''
};

/**
 * ��ũ ��� �ɼ�
 */
nhn.husky.SE2M_Configuration.SE2M_Hyperlink = {
	bAutolink : true	// �ڵ���ũ��� ��뿩��(�⺻��:true)
};

nhn.husky.SE2M_Configuration.Quote = {
	sImageBaseURL : 'http://static.se2.naver.com/static/img'
};

nhn.husky.SE2M_Configuration.SE2M_ColorPalette = {
	bUseRecentColor : false
};