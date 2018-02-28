<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href='<c:url value="/resources/bootstrap/css/bootstrap.min.css" />' rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<title>게시글 작성</title>
<script>
    $(document).ready(function(){
        $("#btnSave").click(function(){
            //var title = document.form1.title.value; ==> name속성으로 처리할 경우
            //var content = document.form1.content.value;
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
            // 폼에 입력한 데이터를 서버로 전송
            document.form1.submit();
        });
        $("#btnBack").click(function(){
        	location.href = "${path}/app/board/gongji_list.do";
        });
    });
</script>
</head>
<body>
<h2 align=center>게시글 작성</h2>
<br>
<form name="form1" method="post" action="${path}/app/board/gongji_insert.do">
<table class="table">
    <tr>
	    <td>제목</td>
	    <td><input class="form-control" name="title" id="title" size="80" placeholder="제목을 입력해주세요"></td>
    </tr>
    <tr>
	    <td>내용</td>
	    <td><textarea class="form-control" name="content" id="content" rows="15" cols="80" placeholder="내용을 입력해주세요"></textarea></td>
    </tr>
    <tr>
	    <td colspan=2>
	    	<button class="btn btn-default pull-right" type="button" id="btnSave">확인</button>
	        <button class="btn btn-default pull-right" type="reset">다시쓰기</button>
	        <button class="btn btn-default pull-right" type="button" id="btnBack">목록으로</button>
	    </td>
    </tr>
</table>
</form>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="/resources/bootstrap/js/bootstrap.min.js"></script>
</body>
</html>
