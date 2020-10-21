package com.mvc.homeseek.model.dao;

import java.util.List;

import com.mvc.homeseek.model.dto.MemberDto;
import com.mvc.homeseek.model.dto.RoomDto;

public interface RoomDetailDao {
	
	// room-detail-mapper의 namespace를 지정
	String NAMESPACE = "room-detail-mapper.";
	
	// List에서 사진 클릭했을 때 넘어오는 room_no로 상세보기
	public RoomDto selectRoomOne(int room_no);
	
}
