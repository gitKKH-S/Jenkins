<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script type="text/javascript" src="${resourceUrl}/appjs/3danmn/set3dan.js"></script>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/appjs/3danmn/icon.css" />
<style type=text/css>
/* style rows on mouseover */
.x-grid3-row-over .x-grid3-cell-inner {
	font-weight: bold;
}
*{
	font-family: "돋움", "굴림";
}
.adviceMsg {
	font-size:12px;
	font-weight:bold;
	color:#666;
	text-align:center;
}
</style>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="300px" height="350px" valign="top" bgcolor="#efefef">
			<div id="grid1sch"></div>
			<div id="grid1res"></div>
		</td>
		<td width="300px" valign="top" bgcolor="#efefef">
			<div id="grid2sch"></div>
			<div id="grid2res"></div>
		</td>
		<td  width="300px" valign="top" bgcolor="#efefef">
			<div id="grid3sch"></div>
			<div id="grid3res"></div>
		</td>
		<td  width="300px" valign="top" bgcolor="#efefef">
			<div id="grid4sch"></div>
			<div id="grid4res"></div>
		</td>
	</tr>
</table>
<div id="buttonHolder"></div>
