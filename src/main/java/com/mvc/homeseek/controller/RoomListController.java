package com.mvc.homeseek.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mvc.homeseek.model.biz.RoomListBiz;
import com.mvc.homeseek.model.dto.MemberDto;
import com.mvc.homeseek.model.dto.RoomDto;


@Controller
public class RoomListController {
	
	private Logger logger = LoggerFactory.getLogger(RoomListController.class);
	 
	@Autowired
	private RoomListBiz roomlistbiz;
	 
	// 전체 조회
	@RequestMapping("/listroom.do")
	public String roomList(@RequestParam(value="page",defaultValue="1")int page, Model model, String word) {
		logger.info("[ Room List ]");
		
		Map<String,Object> pagingMap = roomlistbiz.selectRoomList(page);
		List<RoomDto> list = (List<RoomDto>) pagingMap.get("list");
		
		for(int i=0; i<list.size(); i++) {
			list.get(i).setRoom_photo((list.get(i).getRoom_photo()).split(",")[0]); /*room_photo의 0번째 가져오기*/
			logger.info(i + "번째 room_photo" + list.get(i).getRoom_photo());
		}

		
		model.addAttribute("list",list);
		model.addAttribute("pageBean",pagingMap.get("pageBean"));
		model.addAttribute("word",word);
		
		return "roomList";
	}
	
	// 스크롤 페이징 확인위해서 
	@RequestMapping("search.do")
	public String roomList2(Model model,String word) throws Exception{
		logger.info("[ Room List 2 ]");

		/*----------------엘라스틱에서 검색 결과 가져오기 시작-------------------*/
		String search = "";
	
		String search_addr;
		
		if(word==null) {
			search_addr ="https://search-homeseek-el7f4oyyavqa3vi5cx63opdygm.us-east-2.es.amazonaws.com:443/homeseek/_search?&pretty&size=100";
		}else {
			try {
				search = URLEncoder.encode(word,"UTF-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			search_addr = "https://search-homeseek-el7f4oyyavqa3vi5cx63opdygm.us-east-2.es.amazonaws.com:443/homeseek/_search?q="+search+"&pretty&size=100";
		}
		
		
	
		URL search_url = new URL(search_addr); 
		HttpsURLConnection search_conn = (HttpsURLConnection) search_url.openConnection();
		search_conn.setDoOutput(true);
		 
		
		BufferedReader search_br = new BufferedReader(new InputStreamReader(search_conn.getInputStream()));
		StringBuilder search_sb = new StringBuilder();
		String search_res = "";
		
		while((search_res = search_br.readLine()) != null) {
			search_sb.append(search_res);
		} 
		 
		JSONObject search_obj = new JSONObject(search_sb.toString());
		search_br.close();
		
		List<RoomDto> searchList = roomlistbiz.searchToRoomList(search_obj);
		/*--------------엘라스틱에서 검색 결과 가져오기 끝-------------------*/		
		
		
		List<RoomDto> list = new ArrayList<>();
		
		if(searchList.size() < 8) { 
			for(int i=0; i<searchList.size(); i++) {
				searchList.get(i).setRoom_photo(searchList.get(i).getRoom_photo().split(",")[0]); 
				list.add(searchList.get(i));
			}
		}else {
			// 8개까지만 넘기기
			for(int i=0; i<8; i++) {
				searchList.get(i).setRoom_photo(searchList.get(i).getRoom_photo().split(",")[0]); 
				list.add(searchList.get(i));
			}
		}
		
		model.addAttribute("list",list);
		model.addAttribute("word",word);
		
		return "roomList";
	}
	
	@RequestMapping("/appendList.do")
	@ResponseBody
	public Object appendList(String cnt,String word) throws Exception {
		
		/*----------------엘라스틱에서 검색 결과 가져오기 시작-------------------*/
		String search = "";
		String search_addr;
		
		
		
		if(word=="") {
			search_addr ="https://search-homeseek-el7f4oyyavqa3vi5cx63opdygm.us-east-2.es.amazonaws.com:443/homeseek/_search?&pretty&size=100";

		}else {
			try {
				search = URLEncoder.encode(word,"UTF-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			search_addr = "https://search-homeseek-el7f4oyyavqa3vi5cx63opdygm.us-east-2.es.amazonaws.com:443/homeseek/_search?q="+search+"&pretty&size=100";

		}
		
		
		URL search_url = new URL(search_addr); 
		HttpsURLConnection search_conn = (HttpsURLConnection) search_url.openConnection();
		search_conn.setDoOutput(true);
		
		BufferedReader search_br = new BufferedReader(new InputStreamReader(search_conn.getInputStream()));
		StringBuilder search_sb = new StringBuilder();
		String search_res = "";
		
		while((search_res = search_br.readLine()) != null) {
			search_sb.append(search_res);
		}
		
		JSONObject search_obj = new JSONObject(search_sb.toString());
		search_br.close();
		
		List<RoomDto> searchList = roomlistbiz.searchToRoomList(search_obj);
		/*--------------엘라스틱에서 검색 결과 가져오기 끝-------------------*/
		
		int num = Integer.parseInt(cnt); // 몇번 로딩을 시켰는지 확인
		
		List<RoomDto> roomList = new ArrayList<RoomDto>();
		
		Map<String,Object> resMap = new HashMap<>();
		
		int index = num*8; // for문 시작할 숫자
		
		logger.info("searchList size : " + searchList.size());
		
		
		if(cnt == "0") { 
			resMap.put("msg", true);
			return resMap;
		}
		
		if(searchList.size() <= index || searchList.get(index) == null)  {
			//시작하는 index가 searchList의 사이즈보다 크거나 존재하지 않을때
			resMap.put("msg",true);
			return resMap;
		}
		else {
			if(index >= searchList.size() || (index+7) >= searchList.size()) {
				for(int i=index; i<searchList.size(); i++) {
					roomList.add(searchList.get(i));
				}
			}else {
				for(int i=index; i<index+8; i++) {
					roomList.add(searchList.get(i));
				}
			}
		}
		
		logger.info("roomList size() : " + roomList.size());
		
		for(int i=0; i<roomList.size(); i++) {
			roomList.get(i).setRoom_photo(roomList.get(i).getRoom_photo().split(",")[0]); 
			roomList.get(i).setRoom_type(roomlistbiz.changToKorean(roomList.get(i).getRoom_type()));
		}
		
		
		resMap.put("roomlist",roomList);
		
		return resMap;
	}
	
	@RequestMapping("mypageroomlist.do")
	public String mypageRoomList(HttpSession session, Model model) {
		
		logger.info("[ RoomListController ] mypageRoomList");
		
		MemberDto dto = (MemberDto) session.getAttribute("login");
		List<RoomDto> roomlist = new ArrayList<RoomDto>();
		String room_id = dto.getMember_id();
		
		roomlist = roomlistbiz.mypageMyRoomList(room_id);
		
		model.addAttribute("roomlist", roomlist);
		
		return "mypageMyroomlist";
	}
	
	@RequestMapping("muldeleteroomlist.do")
	@ResponseBody
	public int muldeleteMyRoomList(@RequestParam(value="room_no[]") int[] room_nos, HttpSession session) {
		
		MemberDto dto = (MemberDto) session.getAttribute("login");
		
		String room_id = dto.getMember_id();
		
		int res = 0;
		
		if(room_id != null) {
			for(int room_no : room_nos) {
				roomlistbiz.muldeleteMyRoomList(room_no);
			}
			res = 1;
		}
		return res;
	}
	
}
