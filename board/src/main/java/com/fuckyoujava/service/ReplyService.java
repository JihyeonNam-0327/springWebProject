package com.fuckyoujava.service;

import java.util.List;

import com.fuckyoujava.dto.ReplyVO;

public interface ReplyService {
	//댓글 목록
	//매개변수 : 원글 넘버
	public List<ReplyVO> list(int id);
	
	//댓글 입력
	public void create(ReplyVO vo);
	
	//댓글 수정
	public void update(ReplyVO vo);
	
	//댓글 삭제
	//매개변수 : 댓글 넘버
	public void delete(String rno);
}
