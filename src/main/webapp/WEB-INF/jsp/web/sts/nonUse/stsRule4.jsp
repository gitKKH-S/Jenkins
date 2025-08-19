<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<table class="infoTable write" style="width:100%">
			<colgroup>
				<col style="width:10%;">
				<col style="width:10%;">
				<col style="width:10%;">
				<col style="width:*;">
				<col style="width:*;">
			</colgroup>
			<tr>
				<th>차트종류</th>
				<td>
					<select id="selChartType" class="subSearchType">
		                <option id="opChartType00" value="column">막대차트</option>
		                <option id="opChartType01" value="line">라인차트</option>
		                <option id="opChartType02" value="pie">파이차트</option>
		            </select>
				</td>
				<th>검색구분</th>
				<td>
					<input type="radio" name="searchGbn" class="searchGbn" value="d" checked="checked" /><label>  일별  </label>
			        <input type="radio" name="searchGbn" class="searchGbn" value="m" /><label>  월별  </label>
			        <input type="radio" name="searchGbn" class="searchGbn" value="y" /><label>  년도별    </label>
				</td>
				<td>
					<input type="text" id="txtStartDate" maxlength="12" style="width:150px" readonly />
			        ~
			        <input type="text" id="txtEndDate" maxlength="12" style="width:150px" readonly/>
				</td>
			</tr>
		</table>
	</div>
	<div class="subBtnW center">
		<a href="#" id="btnSubmit" class="sBtn type1">검색</a>
	</div>
	<div class="innerB">
		<div id="dvChart"></div>
	</div>
</div>
