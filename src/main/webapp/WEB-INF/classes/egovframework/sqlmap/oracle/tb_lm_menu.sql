=======>자료실
CREATE OR REPLACE VIEW VW_SEARCH_PDS
(
   DOCGBN,
   PST_MNG_NO,
   MENU_MNG_NO,
   BBS_SE,
   TITLE,
   CONTENTS,
   WRITER,
   WRITERID,
   DEPTID,
   DEPTNAME,
   UPDT,
   PATH,
   URLINFO
)
AS
   SELECT '자료실' AS docgbn,
          PST_MNG_NO,
          b.MENU_MNG_NO,
          BBS_SE,
          title,
          contents,
          writer,
          writerid,
          deptid,
          deptname,
          updt,
          t.PATH,
         CONCAT( '/web/pds/pdsView.do.do?PST_MNG_NO=' , PST_MNG_NO) AS urlinfo
     FROM TB_BBS_MNG b,
          (    SELECT MENU_MNG_NO,
                         LPAD ('', (LEVEL - 1) * 2, '')
                      || SYS_CONNECT_BY_PATH (MENUTITLE, '>')
                         AS PATH
                 FROM TB_COM_MENU a
           START WITH a.menuparid = 10000181
           CONNECT BY PRIOR a.MENU_MNG_NO = a.menuparid) t
    WHERE b.MENU_MNG_NO = t.MENU_MNG_NO;

=======>자료실파일
CREATE OR REPLACE VIEW VW_SEARCH_PDSFILE
(
   FILEID,
   PST_MNG_NO,
   PCFILENAME,
   SERVERFILENAME,
   FILEEXT,
   FILECD,
   FILEPATH
)
AS
   SELECT f."FILEID",
          f."PST_MNG_NO",
          f."PCFILENAME",
          f."SERVERFILENAME",
          f."FILEEXT",
          f."FILECD",
             'E:/Tomcat 7.0_Tomcat7test/webapps/goyang/dataFile/pds/'
          || serverfilename
             AS filepath
     FROM TB_BBS_FILE f
    WHERE PST_MNG_NO IN
             (SELECT PST_MNG_NO
                FROM TB_BBS_MNG b,
                     (    SELECT MENU_MNG_NO,
                                    LPAD ('', (LEVEL - 1) * 2, '')
                                 || SYS_CONNECT_BY_PATH (MENUTITLE, '>')
                                    AS PATH
                            FROM TB_COM_MENU a
                      START WITH a.menuparid = 10000181
                      CONNECT BY PRIOR a.MENU_MNG_NO = a.menuparid) t
               WHERE b.MENU_MNG_NO = t.MENU_MNG_NO);

=======>게시판
/* Formatted on 2021/01/03 오전 11:04:16 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE VIEW VW_SEARCH_bbs
(
   DOCGBN,
   PST_MNG_NO,
   MENU_MNG_NO,
   BBS_SE,
   TITLE,
   CONTENTS,
   WRITER,
   WRITERID,
   DEPTID,
   DEPTNAME,
   UPDT,
   PATH,
   URLINFO
)
AS
   SELECT '게시판' AS docgbn,
          PST_MNG_NO,
          b.MENU_MNG_NO,
          BBS_SE,
          title,
          contents,
          writer,
          writerid,
          deptid,
          deptname,
          updt,
          t.PATH,
          '/web/pds/pdsView.do.do?PST_MNG_NO=' || PST_MNG_NO AS urlinfo
     FROM TB_BBS_MNG b,
          (    SELECT MENU_MNG_NO,
                         LPAD ('', (LEVEL - 1) * 2, '')
                      || SYS_CONNECT_BY_PATH (MENUTITLE, '>')
                         AS PATH
                 FROM TB_COM_MENU a
           START WITH a.menuparid = 10000225
           CONNECT BY PRIOR a.MENU_MNG_NO = a.menuparid) t
    WHERE b.MENU_MNG_NO = t.MENU_MNG_NO;


=======>게시판파일
CREATE OR REPLACE VIEW VW_SEARCH_PDSFILE
(
   FILEID,
   PST_MNG_NO,
   PCFILENAME,
   SERVERFILENAME,
   FILEEXT,
   FILECD,
   FILEPATH
)
AS
   SELECT f."FILEID",
          f."PST_MNG_NO",
          f."PCFILENAME",
          f."SERVERFILENAME",
          f."FILEEXT",
          f."FILECD",
             'E:/Tomcat 7.0_Tomcat7test/webapps/goyang/dataFile/pds/'
          || serverfilename
             AS filepath
     FROM TB_BBS_FILE f
    WHERE PST_MNG_NO IN
             (SELECT PST_MNG_NO
                FROM TB_BBS_MNG b,
                     (    SELECT MENU_MNG_NO,
                                    LPAD ('', (LEVEL - 1) * 2, '')
                                 || SYS_CONNECT_BY_PATH (MENUTITLE, '>')
                                    AS PATH
                            FROM TB_COM_MENU a
                      START WITH a.menuparid = 10000225
                      CONNECT BY PRIOR a.MENU_MNG_NO = a.menuparid) t
               WHERE b.MENU_MNG_NO = t.MENU_MNG_NO);

========>조례
CREATE OR REPLACE VIEW VW_SEARCH_RULE
(
   BOOKID,
   NOFORMYN,
   TITLE,
   BOOKCD,
   DEPTNAME,
   PROMULDT,
   STATECD,
   BON,
   URLINFO
)
AS
   SELECT bookid,
          noformyn,
          title,
          bookcd,
          deptname,
          promuldt,
          DECODE (statecd,
                  '5000', '현행',
                  '6000', '폐지',
                  '7000', '연혁')
             AS statecd,
          XMLSCHTXT || MAINPITH || REVREASON || jenmun AS bon,
             '/web/regulation/regulationViewPop.do?bookid='
          || bookid
          || '&noformyn='
          || noformyn
             AS urlinfo
     FROM tb_lm_rulehistory;

==========>조례파일
CREATE OR REPLACE  VIEW VW_SEARCH_RULEFILE
(
   BOOKID,
   STATEHISTORYID,
   FILEID,
   PCFILENAME,
   SERVERFILE,
   FILECD,
   STATECD,
   FILEPATH
)
AS
   SELECT a."BOOKID",
          a."STATEHISTORYID",
          a."FILEID",
          a."PCFILENAME",
          a."SERVERFILE",
          a."FILECD",
          a."STATECD",
          'E:/Tomcat 7.0_Tomcat7test/webapps/goyang/dataFile/law/attach/'
             AS filepath
     FROM TB_LM_RULESEARCHFILE a;


==========>협약정보
CREATE OR REPLACE  VIEW VW_SEARCH_agree
(
   agreeid,
   agreeno,
   title,
   content,
   area,
   agreecd,  -- 협약유형
	committee,  --소관위원회
	organcd,  --협약상대유형
	agreedt, --협약체결일
	urlinfo
)
AS
SELECT
	agreeid,
	agreeno, -- 협약번호 (리스트노출 0)
	title, --협약제목 (리스트노출 0)
	content || collaboration1 || collaboration2||writer||deptname||phone||chujin || result || prehyup || zipno || sinm || sggnm ||emdnm||organchk1||organchk2||purpose||manage||agreegbn ||organ AS content ,
	sinm|| ' ' || sggnm|| ' ' ||emdnm AS area,  --지역
	agreecd,  -- 협약유형
	committee,  --소관위원회
	organcd,  --협약상대유형
	agreedt, --협약체결일
	'/web/agree/agreeViewPop.do?agreeid='||agreeid AS urlinfo
FROM
	tb_su_agree
WHERE
	openyn='Y' AND statecd='완료';


==========>협약파일
CREATE OR REPLACE VIEW VW_SEARCH_agreeFILE
(
   FILEID,
   agreeid,
   PCFILENAME,
   SERVERFILENAME,
   FILEEXT,
   FILECD,
   FILEPATH
)
AS
SELECT
	fileid,
	gbnid,
	viewfilenm,
	serverfilenm,
	ext,
	DECODE(filegbn, 'agree', '협약등록문서', 'agreebon', '협약서', 'agreebon1', '사전보고서', 'result', '결과등록문서', 'agreebon2', '결과보고서','') AS filegbn,
	 'E:/Tomcat 7.0_Tomcat7test/webapps/goyang/dataFile/agree/' || serverfilenm  AS filepath
FROM
	tb_su_agree_file
WHERE
filegbn IN ('agree','result','agreebon','agreebon1','agreebon2');


===>자문정보
CREATE OR REPLACE  VIEW VW_SEARCH_consult
(
   docgbn,
   consultid,
   chckid,
   title,
   content,
   writedt,
   inoutcon,
	urlinfo
) AS 
SELECT 
	'자문의뢰' AS docgbn
	,consultid
	,consultid AS chckid
	,title
	,aprvmemo||basis||writer||writerdeptnm||chrgempnm AS content
	,writedt
	,if(inoutcon='I','내부자문','외부자문') AS inoutcon 
	,'/web/consult/consultViewPop.do?consult='||consultid AS urlinfo
	FROM tb_su_consult WHERE openyn='Y' AND inoutcon IN ('I','O') AND openyn='Y' AND statcd='완료'
UNION all
SELECT 
	'자문검토의견' AS docgbn
	,a.consultid
	,a.chckid
	,b.title
	,a.writerdeptnm||a.chckconts AS content
	,b.writedt 
	,if(b.inoutcon='I','내부자문','외부자문') AS inoutcon  
	,'/web/consult/consultViewPop.do?consult='||a.consultid AS urlinfo
	FROM TB_SU_CONSULT_CHCK_INFO a,tb_su_consult b WHERE a.consultid=b.consultid AND openyn='Y' AND statcd='완료'
;

===>자문파일
CREATE OR REPLACE VIEW VW_SEARCH_consultFILE
(
   FILEID,
   gbnid,
   PCFILENAME,
   SERVERFILENAME,
   FILEEXT,
   FILECD,
   FILEPATH
)
AS
SELECT
	fileid,
	gbnid,
	viewfilenm,
	serverfilenm,
	ext,
	DECODE(filegbn,'consult','자문요청서','consultans','검토의견'),
	 'E:/Tomcat 7.0_Tomcat7test/webapps/goyang/dataFile/consult/' || serverfilenm  AS filepath
FROM
	tb_su_consult_file
WHERE
	filegbn IN ('consult','consultans');