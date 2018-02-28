package com.fuckyoujava.app;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.fuckyoujava.dto.ReplyVO;
import com.fuckyoujava.service.ReplyService;

@RestController
public class ReplyController {

	@Inject
	ReplyService replyService;
	
	// 1. 댓글 입력
	@RequestMapping("board/reply/insert.do")
	public void insert(@ModelAttribute ReplyVO vo, HttpSession session) {
		replyService.create(vo);
	}
	
	// 2_1. 댓글 목록(@Controller방식 : veiw(화면)를 리턴)
	@RequestMapping("board/reply/list.do")
	public ModelAndView list(@RequestParam int id, ModelAndView mv) {
		List<ReplyVO> list = replyService.list(id);
		//뷰 이름 지정
		mv.setViewName("board/replyList");
		//뷰에 전달할 데이터 지정
		mv.addObject("list", list);
		//replyList.jsp로 포워딩
		return mv;
	}
	
	// 2_2. 댓글 목록(@RestController Json방식으로 처리 : 데이터를 리턴)
	@RequestMapping("board/reply/listJson.do")
	@ResponseBody //리턴 데이터를 Json으로 변환(생략가능)
	public List<ReplyVO> listJson(@RequestParam int id){
		List<ReplyVO> list = replyService.list(id);
		return list;
	}
	
	//댓글 수정
	@RequestMapping(value="board/reply/update", method= {RequestMethod.POST, RequestMethod.GET})
	public void update(@RequestParam int rno, @RequestParam String replytext) throws Exception {
		ReplyVO vo = new ReplyVO();
		vo.setRno(rno);
		vo.setReplytext(replytext);
		replyService.update(vo);
	}
    
    // 4. 댓글 삭제처리
    @RequestMapping(value="board/reply/delete/{rno}")
    public ResponseEntity<String> replyDelete(@PathVariable("rno") String rno){
        ResponseEntity<String> entity = null;
        try {
            replyService.delete(rno);
            // 댓글 삭제가 성공하면 성공 상태메시지 저장
            entity = new ResponseEntity<String>("success", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            // 댓글 삭제가 실패하면 실패 상태메시지 저장
            entity = new ResponseEntity<String>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
        // 삭제 처리 HTTP 상태 메시지 리턴
        return entity;
    }
	
}
