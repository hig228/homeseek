<%@page import="com.mvc.homeseek.model.dto.NoticeDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Notice 상세 글보기</title>
<script type="text/javascript"
	src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/noticeDetail.css"
	type="text/css" />
<script
	src="${pageContext.request.contextPath}/resources/js/noticeDetail.js"
	type="text/javascript"></script>
</head>
<body>

	<!-- header.jsp -->
	<%@ include file="form/header.jsp"%>

	<section>
		<h1>N O T I C E 상 세 보 기</h1>


		<table border="1">
			<tr>
				<th>글번호</th>
				<td><input type="hidden" name="notice_no"
					value="${dto.notice_no }"> <c:out value="${dto.notice_no}" /></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><input type="hidden" name="notice_id"
					value="${dto.notice_id }"> <c:out value="${dto.notice_id}" /></td>
			</tr>
			<tr>
				<th>작성일</th>
				<td><input type="hidden" name="notice_regdate"
					value="${dto.notice_regdate }"> <c:out
						value="${dto.notice_regdate}" /></td>
			</tr>
			<tr>
				<th>제목</th>
				<td><input type="hidden" name="notice_title"
					value="${dto.notice_title }"> <c:out
						value="${dto.notice_title}" /></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><input type="hidden" name="notice_content"
					value="${dto.notice_content }"> <c:out
						value="${dto.notice_content}" /></td>
			</tr>

		</table>

		<!-- 추가 : 수정,리스트로 버튼 -->
		<%
		if (dto != null) {//로그인(ㅇ)
			if (dto.getMember_role() == 'A') {//관리자(ㅇ)
		%>
		<a href='noticeupdateform.do?notice_no=<c:out value="${dto.notice_no}"/>'>Update</a>
		<a href='noticedelete.do?notice_no=<c:out value="${dto.notice_no}"/>'>Delete</a>
		<%
			}//일반회원(ㅇ)
			%>
			<a href="noticelist.do">List</a>
			<%
		} else {//로그인(x)
		%>
		<a href="noticelist.do">List</a>
		<%
		}
		%>
	</section>

	<!-- footer.jsp -->
	<%@ include file="form/footer.jsp"%>

</body>
</html>