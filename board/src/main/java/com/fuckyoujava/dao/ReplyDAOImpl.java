package com.fuckyoujava.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.fuckyoujava.dto.ReplyVO;

@Repository // 현재 클래스를 dao bean으로 등록
public class ReplyDAOImpl implements ReplyDAO {

	@Inject
	SqlSession sqlSession;
	
	@Override
	public List<ReplyVO> list(int id) {
		return sqlSession.selectList("reply.listReply", id);
	}

	@Override
	public void create(ReplyVO vo) {
		
		sqlSession.insert("reply.insertReply", vo);
	}

	@Override
	public void update(ReplyVO vo) {
		sqlSession.update("reply.updateReply", vo);
	}

	@Override
	public void delete(String rno) {
		sqlSession.delete("reply.deleteReply", rno);
	}

}
