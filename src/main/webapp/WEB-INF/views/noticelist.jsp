<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>N O T I C E</title>
<!-- header.jsp -->
<%@ include file="form/header.jsp"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/noticeList.css"
	type="text/css" />
<script
	src="${pageContext.request.contextPath}/resources/js/noticeList.js"
	type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/js/paging.js"
	type="text/javascript"></script>

</head>
<style>
.off-screen {
	display: none;
}

.eval-contents {
	cursor: pointer;
}


#qnaSearch_bar, h1{
	width:70%; 
	margin-left:15%; 
	margin-right:15%;
}


#nav.paging{
    display:flex;
    justify-content:center;
    align-items:center;
}

#nav.paging > a{
    color: var(--color-light-grey);
    margin:8px;
}
#nav.paging > a.active{
    color: green;
    margin:8px;
}

/* 
.header ul.nav2{
	width:940px;
}
.header ul.nav{
	width:800px;
}

 */
table.table_notice{
	/* width:70%; */ 
	margin-left:15%; 
	margin-right:15%;
	/* display:flex; */
    justify-content:center;
    align-items:center;
	
	border-collapse: collapse;
	text-align: left;
	line-height: 1.5;
	border-top: 1px solid #7EAB7D;
	border-bottom: 3px solid #7EAB7D;
	border-left: 3px solid #7EAB7D;
	border-right: 3px solid #7EAB7D;
	margin: 20px 10px;
}
table.table_notice th {
	width: 150px;
	padding: 10px;
	font-weight: bold;
	vertical-align: top;
}
table.table_notice td {
	width: 350px;
	padding: 10px;
	vertical-align: top;
}
table.table_notice .even{
	background: #7EAB7D;
}

</style>
<body>
	<section>
		<div id="products">

			<h1>N O T I C E 리 스 트</h1>

			<div id="qnaSearch_bar">
				<a> 검 색 : <input id="noticeSearch" type="search" value="" placeholder="Notice검색해주세여" /></a>
			</div>

			<form action="" id="setRows">
				<input type="hidden" name="rowPerPage" value="10">
			</form>

			<table border="1" class="table_notice">
				<thead>
					<tr class="even">
						<th style="width: 50px;">번호</th>
						<th style="width: 100px;">작성자</th>
						<th style="width: 500px;">제목</th>
						<th style="width: 150px;">작성일</th>
						<th style="width: 50px;">조회수</th>
					</tr>
				</thead>
				<tbody id="noticeTable">
					<c:choose>
						<c:when test="${empty list }">
							<tr>
								<td colspan="5">--작성된 글이 존재하지 않습니다--</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach items="${list }" var="dto">
								<tr class="eval-contents"
									onclick="location.href='noticedetail.do?notice_no=${dto.notice_no}'">
									<td>${dto.notice_no}</td>
									<td>${dto.notice_id }</td>
									<td>${dto.notice_title }</td>
									<td><fmt:formatDate pattern="yyyy-MM-dd"
											value="${dto.notice_regdate}" /></td>
									<td>${dto.notice_hit}</td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
				
					<%
						if (dto != null) {
							if(dto.getMember_role() == 'A'){
					%>
					<tr class="even">
						<td colspan="5" align="right"><input type="button" value="글작성" onclick="location.href='noticeinsertform.do'" /></td>
					</tr>	
					<%}
						}else{
					%>
					
					<%
						}
					%>

			</table>
		</div>
	</section>

	<!-- footer.jsp -->
	<%@ include file="form/footer.jsp"%>
</body>
<script>
	$("#noticeSearch")
			.keyup(
					function() {
						var keyword = $(this).val();
						console.log(keyword);
						$
								.ajax({
									url : "${ pageContext.request.contextPath}/noticeSearch.do",
									data : {
										keyword : keyword
									},
									dataType : "json",
									method : "GET",
									success : function(data) {
										console.log(data.list);
										displayResultTable("noticeTable",
												data.list);

										var $setRows = $('#setRows');

										$setRows
												.submit(function(e) {
													e.preventDefault();
													var rowPerPage = $(
															'[name="rowPerPage"]')
															.val() * 1;// 1 을  곱하여 문자열을 숫자형로 변환

													var zeroWarning = 'Sorry, but we cat\'t display "0" rows page. + \nPlease try again.'
													if (!rowPerPage) {
														alert(zeroWarning);
														return;
													}
													$('#nav').remove();
													var $products = $('#products');
													var $products2 = $('#paging');

													$products
															.after('<div id="nav" class="paging pagination">');

													var $tr = $($products)
															.find(
																	'.eval-contents');
													var rowTotals = $tr.length;

													var pageTotal = Math
															.ceil(rowTotals
																	/ rowPerPage);
													var i = 0;

													for (; i < pageTotal; i++) {
														$('<a></a>').attr(
																'rel', i).html(
																i + 1)
																.appendTo(
																		'#nav');
													}

													$tr
															.addClass(
																	'off-screen')
															.slice(0,
																	rowPerPage)
															.removeClass(
																	'off-screen');

													var $pagingLink = $('#nav a');
													$pagingLink
															.on(
																	'click',
																	function(
																			evt) {
																		evt
																				.preventDefault();
																		var $this = $(this);
																		if ($this
																				.hasClass('active')) {
																			return;
																		}
																		$pagingLink
																				.removeClass('active');
																		$this
																				.addClass('active');

																		var currPage = $this
																				.attr('rel');
																		var startItem = currPage
																				* rowPerPage;
																		var endItem = startItem
																				+ rowPerPage;

																		$tr
																				.css(
																						'opacity',
																						'0.0')
																				.addClass(
																						'off-screen')
																				.slice(
																						startItem,
																						endItem)
																				.removeClass(
																						'off-screen')
																				.animate(
																						{
																							opacity : 1
																						},
																						100);

																	});

													$pagingLink
															.filter(':first')
															.addClass('active');

												});

										$setRows.submit();

									},
									error : function(xhr, status, err) {
										console.log("처리실패", xhr, status, err);
									}
								});
					});

	function displayResultTable(id, data) {
		var $container = $("#" + id);

		var html = "";
		var dateFormat = "";
		if (Object.keys(data).length > 0) {
			html += "<form action='' id='setRows'><input type='hidden' name='rowPerPage' value='10'></form>"
			for ( var i in data) {
				var list = data[i];
				html += `<tr class='eval-contents' onclick="location.href='noticedetail.do?notice_no=` + list.notice_no + `'">`;
				html += "<td>" + list.notice_no + "</td>";
				html += "<td>" + list.notice_id + "</td>";
				html += "<td>" + list.notice_title + "</td>";
				html += "<td>" + list.notice_regdate + "</td>";
				html += "<td>" + list.notice_hit + "</td>";
				html += "</td>";
				html += "</tr>";
			}
		} else {
			html += "<tr><td colspan='5'>검색된 결과가 없습니다.</td></tr>";
		}

		$container.html(html);

	}
	

//자바스크립트로 새로고침 1회만실행 코드 <-정답	
 if (self.name != 'reload') {
         self.name = 'reload';
         self.location.reload(true);
     }
     else self.name = ''; 

	
</script>
</html>