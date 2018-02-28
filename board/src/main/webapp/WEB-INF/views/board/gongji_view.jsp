<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href='<c:url value="/resources/bootstrap/css/bootstrap.min.css" />' rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<title>게시글 보기</title>
<script>
    $(document).ready(function(){
    	var reno;
    	
        //listReply(); // **댓글 목록 불러오기
        listReply2(); // ** json 리턴방식
        
        // ** 댓글 쓰기 버튼 클릭 이벤트 (ajax로 처리)
        $("#btnReply").click(function(){
        	//댓글 내용과 댓글 글쓴이 변수로 받은 뒤, 내용이 없다면 return 처리
            var replytext=$("#replytext").val();
            if(replytext == ""){
            	alert("댓글 내용을 입력하세요");
                return;
            }
            var replyer=$("#replyer").val();
            if(replyer == ""){
            	alert("이름을 입력하세요");
                return;
            }
            //댓글 내용과 댓글 글쓴이 내용 초기화
            $("#replytext").val("");
            $("#replyer").val("");
            var bno="${dto.id}"
            var param="replytext="+replytext+"&id="+bno+"&replyer="+replyer;
            $.ajax({
                type: "post",
                url: "${path}/app/board/reply/insert.do",
                data: param,
                success: function(){
                    alert("댓글이 등록되었습니다.");
                    listReply2();
                }
            });
        });
    	        
        //게시글 삭제
        $("#btnDelete").click(function(){
            if(confirm("삭제하시겠습니까?")){
                document.form1.action = "${path}/app/board/gongji_delete.do";
                document.form1.submit();
            }
        });
        
        //게시글 수정
        $("#btnUpdete").click(function(){
            //var title = document.form1.title.value; ==> name속성으로 처리할 경우
            //var content = document.form1.content.value;
            //아래는 id속성으로 처리한 경우
            var title = $("#title").val();
            var content = $("#content").val();
            if(title == ""){
                alert("제목을 입력하세요");
                document.form1.title.focus();
                return;
            }
            if(content == ""){
                alert("내용을 입력하세요");
                document.form1.content.focus();
                return;
            }
            
            document.form1.action="${path}/app/board/gongji_update.do"
            // 폼에 입력한 데이터를 서버로 전송
            document.form1.submit();
        });
        
        //목록으로 돌아가기
        $("#btnBack").click(function(){
        	location.href = "${path}/app/board/gongji_list.do?curPage="+${curPage};
        });

    });
    
// Controller방식
// **댓글 목록1
function listReply(){
    $.ajax({
        type: "get",
        url: "${path}/app/board/reply/list.do?id=${dto.id}",
        success: function(result){
        // responseText가 result에 저장됨.
            $("#listReply").html(result);
        }
    });
}
// RestController방식 (Json)
// **댓글 목록2 (json)
function listReply2(){
    $.ajax({
        type: "get",
        contentType: "application/x-www-form-urlencoded; charset=UTF-8", //==> 생략가능(RestController이기때문에 가능)
        url: "${path}/app/board/reply/listJson.do?id=${dto.id}",
        success: function(result){
            console.log(result);
            var output = "<table class='table'>";
            for(var i in result){
                output += "<tr>";
                output += "<td id='detailReply_"+result[i].rno+"'><input type=text class='form-control' style='border:none;' id='replyer_"+result[i].rno+"' value='"+result[i].replyer+" ("+result[i].date+")' readonly /><br>";
                output += "<textarea type=text style='border:none;' class='form-control' id='replyValue_"+result[i].rno+"' readonly >"+result[i].replytext+"</textarea><br>";
                output += "<button class='btn btn-default pull-right' type='button' id='btnReplyDelete' onclick='replyDelete("+result[i].rno+")'>삭제</button>";
                output += "<button class='btn btn-default pull-right' type='button' id='btnReplyUpdate' onclick='replyUpdate("+result[i].rno+")'>수정</button></td>";
                output += "</tr>";
            }
            output += "</table>";
            $("#listReply").html(output);
        }
    });
}  

//댓글 삭제
function replyDelete(rno){
	 $.ajax({
         type: "get",
         //contentType: "application/json", //==> 생략가능(RestController이기때문에 가능)
         url: "${path}/app/board/reply/delete/"+rno,
         success: function(result){
        	 alert("댓글이 삭제되었습니다.");
        	 listReply2();
         }
	 });
}

//댓글 수정 준비
function replyUpdate(rno){
	var replyer = $("#replyer_"+rno).val();
	var replytext = $("#replyValue_"+rno).val();
	var output = "<input type=text class='form-control' id='replyer_"+rno+"' value='"+replyer+"' readonly /><br>";
	output += "<textarea class='form-control' id='replyValue_"+rno+"' >"+replytext+"</textarea><br>";
	output += "<input type='button' class='btn btn-default pull-right' onclick='replyCancle("+rno+")' value='취소'/>";
	output += "<input type='button' class='btn btn-default pull-right' onclick='replyUpdate2("+rno+")' value='수정'/>";
	$("#detailReply_"+rno).html(output);
}

//댓글 수정 처리 함수
function replyUpdate2(rno){
   var replytext = $('#replyValue_'+rno).val();//textarea에 입력된 값 가져오기
   if (replytext != "") {
      $.ajax({
            url : '${path}/app/board/reply/update',
            type : 'post',
            data : {'replytext' : replytext, 'rno' : rno},
            success : function(data){
            	alert("댓글이 수정되었습니다.");
            	listReply2(); //댓글 수정후 목록 출력 
            }
        });
   }
}

//댓글 수정 취소
function replyCancle(rno){
/* 	var val1 = $("#replyer_"+rno).val();
	var val2 = $("#replyValue_"+rno).val();
	var output = "<input type=text style='border:none;' id='replyer_"+rno+"' value='"+val1+"' readonly /><br>";
    output += "<input type=text style='border:none;' id='replyValue_"+rno+"' value='"+val2+"' readonly />";
    output += "<button class='btn btn-default pull-right' type='button' id='btnReplyDelete' onclick='replyDelete("+rno+")'>삭제</button>";
    output += "<button class='btn btn-default pull-right' type='button' id='btnReplyUpdate' onclick='replyUpdate("+rno+")'>수정</button>";
	$("#detailReply_"+rno).html(output);
	return; */
	listReply2()
}
</script>
</head>
<body>
<h2 align=center>게시글 보기</h2>
<br>
<form name="form1" method="post">
    <table class="table">
        <tr>
	        <td>작성일자</td>
	        <td>${dto.date}</td>
        </tr>
    <tr>
    <td>제목</td>
    <td><input class="form-control" name="title" id="title" size="80" value="${dto.title}" placeholder="제목을 입력해주세요"></td>
    </tr>
    <tr>
    <td>내용</td>
    <td><textarea class="form-control" name="content" id="content" rows="15" cols="80" placeholder="내용을 입력해주세요">${dto.content}</textarea></td>
    </tr>
    <tr>
    <td colspan=2>
        <!-- 게시물번호를 hidden으로 처리 -->
        <input type="hidden" name="id" value="${dto.id}">
        <button class="btn btn-default pull-right" type="button" id="btnUpdete">수정</button>
        <button class="btn btn-default pull-right" type="button" id="btnDelete">삭제</button>
		<button class="btn btn-default pull-right" type="button" id="btnBack">목록으로</button>
    </td>
    </tr>
    </table>
</form>
	
	<!-- **댓글 목록 출력할 위치 -->
    <div id="listReply"></div>
	
	<!-- **댓글 작성 폼 출력 위치 -->
	<input class="form-control" name="replyer" id="replyer" size="80" placeholder="이름을 입력해주세요">
    <textarea class="form-control" rows="5" cols="80" id="replytext" placeholder="댓글을 작성해주세요"></textarea>
    <br>
    <button class="btn btn-default pull-right" type="button" id="btnReply">댓글 작성</button>
    <br><br>

    
</body>
</html>