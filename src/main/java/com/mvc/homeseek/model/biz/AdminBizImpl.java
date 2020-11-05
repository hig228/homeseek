package com.mvc.homeseek.model.biz;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mvc.homeseek.model.dao.AdminDao;
import com.mvc.homeseek.model.dto.MemberDto;
import com.mvc.homeseek.model.dto.ReportDto;
import com.mvc.homseek.paging.Paging;

@Service
public class AdminBizImpl implements AdminBiz {
	
	@Autowired
	private AdminDao adminDao;
	@Override
	public List<MemberDto> allMember(Paging vo) {
		// TODO Auto-generated method stub
		return adminDao.allMember(vo);
	}
	@Override
	public List<ReportDto> allReport() {
		// TODO Auto-generated method stub
		return adminDao.allReport();
	}
	
	@Override
	public ReportDto reportRes(int report_no) {
		// TODO Auto-generated method stub
		return adminDao.reportRes(report_no);
	}
	@Override
	public int countMember() {
		// TODO Auto-generated method stub
		return adminDao.countMember();
	}


}
