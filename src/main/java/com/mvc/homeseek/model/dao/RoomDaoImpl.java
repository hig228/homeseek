package com.mvc.homeseek.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.mvc.homeseek.model.dto.RoomDto;

@Repository
public class RoomDaoImpl implements RoomDao {

	@Autowired
	private SqlSessionTemplate sqlSession;

	private Logger logger = LoggerFactory.getLogger(RoomDao.class);

	@Override
	public int selectRoomInsert(RoomDto room_dto) {

		int res = 0;

		try {
			res = sqlSession.insert(NAMESPACE + "selectRoomInsert", room_dto);
		} catch (Exception e) {
			logger.info("[ERROR] : selectRoomInsert");
			e.printStackTrace();
		}

		return res;
	}

	// 보증금이 없을때
	@Override
	public int selectRoomInsert2(RoomDto room_dto) {

		int res = 0;

		try {
			res = sqlSession.insert(NAMESPACE + "selectRoomInsert2", room_dto);
		} catch (Exception e) {
			logger.info("[ERROR] : selectRoomInsert2");
			e.printStackTrace();
		}

		return res;
	}

}
