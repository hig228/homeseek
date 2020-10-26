<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.mvc.homeseek.model.dto.MemberDto" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>homeseek : 방 올리기</title>
</head>
<body>
	<!-- header.jsp include -->
	<%@ include file="/WEB-INF/views/form/header.jsp" %>
	<%
		MemberDto memberDto = (MemberDto) (session.getAttribute("login"));
	%>
	<section>
	
	<!-- 제목 -->
	<div id="top_title">
		<h3>방 올리기</h3>
	</div>
	
	<form name="form" id="form" method="post">
		<input type="button" onClick="goPopup();" value="팝업" /> 
		도로명주소 전체(포맷)
		<input type="text" id="roadFullAddr" name="roadFullAddr" /><br> 
	</form>
	
	<hr id="top_line">
	
	<!-- 입력폼 -->
	<div class="form_div">
		<form action="insertres.do" class="insert_form" method="POST">
		<%-- <input type="hidden" name="room_id" value="${memberDto.getMember_id }"> --%>
			
		
				<div id="insert_div1">
					<label for="insert_roomname" id="1st_col">매물이름</label>
						<input type="text" name="room_name" id="insert_name">
				
	
				
					<label for="insert_type" id="2nd_col">매물종류</label>
						<select name="room_type" id="insert_roomtype">
							<option value="1">월세</option>
							<option value="2">전세</option>
							<option value="3">매매</option>
							<option value="4">반전세</option>
							<option value="5">단기임대</option>
						</select>				
				</div>
				
				<div id="insert_div2">
					<label for="insert_deposit" id="1st_col">보증금</label>
						<input type="text" name="room_deposit" id="insert_deposit">
				
					
					<label for="insert_price" id="2nd_col">매물가격</label>
						<input type="text" name="room_price" id="insert_price">
					
				
					<label for="insert_ext" id="3rd_col">매물면적</label>
						<input type="text" name="room_extent" placeholder="단위 : 제곱미터" id="insert_ext">
				
				</div>
				
				<!--  -->
				<div id="insert_div3">
					<p id="addr_notice">※ 띄어쓰기를 포함한 정확한 도로명 주소로 입력해주세요.</p>
					<p id="addr_notice">※ 정확한 주소가 아닐경우 위치확인이 어렵습니다.</p>			
					<label for="insert_addr" id="addr_label">매물주소</label>
					
					도로명주소 전체(포맷)
				<!-- 	<input type="text" id="roadFullAddr" name="roadFullAddr" /><br> -->
					<input type="button" onclick="goPopup()" id="juso_popup" value="주소 입력하기">
					<input type="text" name="room_addr" placeholder="도로명주소로 입력해주세요" id="insert_addr">
					<div id="show_map"></div>
				</div>
				
				<div id="insert_div4">
					<label for="insert_kind" id="1st_col">건물 종류</label>
						<select name="room_kind" id="insert_kind">
							<option value="1">아파트</option>
							<option value="2">빌라</option>
							<option value="3">주택</option>
							<option value="4">오피스텔</option>
							<option value="5">상가사무실</option>
						</select>
					
				
					<label for="insert_structure" id="2nd_col">방 구조</label>
						<select name="room_structure" id="insert_structure">
							<option value="1">방 1개</option>
							<option value="2">방 2개</option>
							<option value="3">방 3개이상</option>
						</select>
					
				
					<label for="insert_floor" id="3rd_col">방 층수</label>
					<input type="text" name="room_floor" id="insert_floor">
				</div>	
				
				<div id="insert_div5">
					<label for="insert_cpdate" id="1st_col">준공 날짜</label>
					<input type="date" name="room_cpdate" id="insert_cpdate">
					
				
					<label for="insert_avdate" id="2nd_col">입주 가능일</label>
					<input type="date" name="room_avdate" id="insert_avdate">
					<br>
					<label for="summernote" id="1st_col">상세설명</label>
					<div id="insert_detail">
						<textarea rows="10" cols="60" class="summernote" name="room_detail"></textarea>
					</div>
				</div>
				
				<div class="control">
						<input type="submit" value="작성">
						<input type="button" value="취소" onclick="location.href='main.do'">
				</div>
			
		</form>
	</div>
	</section>
	
	<hr id="botton_line">
	<!-- footer.jsp -->
	<%@ include file="form/footer.jsp"%>
	
</body>



<!-- include libraries(jQuery, bootstrap) -->
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.js"></script>

<!-- include summernote css/js-->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>

<!-- include summernote-ko-KR -->
<script src="/resources/js/summernote-ko-KR.js"></script>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=da88af3e239bedd2a1aa7bd1a3b5db5b&libraries=services"></script>
<script>
var mapContainer = document.getElementById('show_map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();

// 주소로 좌표를 검색합니다
geocoder.addressSearch('제주특별자치도 제주시 첨단로 242', function(result, status) {

    // 정상적으로 검색이 완료됐으면 
     if (status === kakao.maps.services.Status.OK) {

        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

        // 결과값으로 받은 위치를 마커로 표시합니다
        var marker = new kakao.maps.Marker({
            map: map,
            position: coords
        });

        // 인포윈도우로 장소에 대한 설명을 표시합니다
        var infowindow = new kakao.maps.InfoWindow({
            content: '<div style="width:150px;text-align:center;padding:6px 0;">매물 위치</div>'
        });
        infowindow.open(map, marker);

        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
        map.setCenter(coords);
    } 
});    
</script>




<!-- 도로명주소API js -->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/loadAddress.js" type="text/javascript"></script>

<!-- services 라이브러리 불러오기 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=da88af3e239bedd2a1aa7bd1a3b5db5b&libraries=services"></script>

<!-- summerNote.js -->
<script src="${pageContext.request.contextPath}/resources/js/summerNote-roomInsert.js" type="text/javascript"></script>


<!-- roomInsert.css -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/roomInsert.css" type="text/css" />


<!-- roomInsert.js -->
<script src="resources/js/roomInsert.js" type="text/javascript"></script>
</html>











