<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<jsp:include page="../includes/head.jsp" />
<sec:csrfMetaTags />
</head>

<body id="page-top">

    <!-- Page Wrapper -->
    <div id="wrapper">

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">

            <!-- Main Content -->
            <div id="content">

                <!-- Topbar -->
<%-- <jsp:include page="../includes/header.jsp" /> --%>
				<!-- End of Topbar -->

                <!-- Begin Page Content -->
                <div class="container-fluid">

                    <!-- Page Heading -->
                    <h1 class="h3 mb-2 text-gray-800">Board Read Page</h1>

                    <!-- DataTales Example -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Board Read Page</h6>
                        </div>
                        <div class="card-body">
                        	<form method="post">
                        	<sec:csrfInput/>
                        		<div class="form-group">
		                           <label for="bno" class="text-dark font-weight-bold">bno</label>
		                           <input class="form-control" id="bno" name="bno" disabled value="${board.bno}">
	                           </div>
	                        	<div class="form-group">
		                           <label for="title" class="text-dark font-weight-bold">Title</label>
		                           <input class="form-control" id="title" name="title" disabled value="${board.title}">
	                           </div>
	                           <div class="form-group">
		                           <label for="content" class="text-dark font-weight-bold">Content</label>
		                           <textarea rows="10" class="form-control" id="content" name="content" disabled >${board.content}</textarea>
	                           </div>
	                           <div class="form-group">
		                           <label for="nickName" class="text-dark font-weight-bold">nickName</label>
		                           <input class="form-control" id="nickName" name="nickName" disabled value="${board.nickName}">
	                           </div>
	                           <div class="form-group">
		                           <label for="nickName" class="text-dark font-weight-bold">1</label>
		                           <input class="form-control" id="category" name="category" disabled value="${board.category}">
	                           </div>
	                           <div class="form-group">
		                           <label for="nickName" class="text-dark font-weight-bold">regDate</label>
		                           <input class="form-control" id="regDate" name="regDate" disabled value="${board.regDate}">
	                           </div>
	                           <div class="form-group">
		                           <label for="nickName" class="text-dark font-weight-bold">see</label>
		                           <input class="form-control" id="see" name="see" disabled value="${board.see}">
	                           </div>
	                           <sec:authentication property="principal" var="pinfo"/>
	                           <sec:authorize access="isAuthenticated()">
	                           <c:if test="${pinfo.username == board.nickName }">
	                           <a class="btn btn-warning" href="modify${cri.params}&bno=${board.bno}">Modify</a>
	                           </c:if>
	                           </sec:authorize>
	                           <a class="btn btn-primary" href="list${cri.params}">List</a>
                           </form>
                        </div>
                    </div>
                    
                    <!-- File -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">File Attach</h6>
                        </div>
                        <div class="card-body">
                        	<div class="form-group uploadDiv">
                        		<label for="files" class="btn btn-primary px-4"><i class='fas fa-file mr-2'></i>File</label>
	                           <input type="file" class="form-control d-none" id="files" name="files" multiple>
                           </div>
                           <div class="uploadResult">
	                           	<ul class="list-group">
	                           	</ul>
                           </div>
                        </div>
                    </div>
                    
   <!-- reply-->
					<div class="card shadow mb-4">
						<div class="card-header py-3 clearfix">
							<h6 class="m-0 font-weight-bold text-primary float-left"><i class="fa fa-comments"></i> Reply</h6>
							<button class="btn btn-primary float-right btn-sm" id="btnRegFrm">New Reply</button>
						</div>
						<ul id="replyUL" class="list-group list-group-flush">
						</ul>	
						<div class="card-footer text-center">
							<button class="btn btn-primary btn-block" id="btnShowMore">더보기</button>
						</div>
					</div>
					<!-- end of reply-->
				</div>
				<!-- /.container-fluid -->

			</div>
			<!-- End of Main Content -->
			
<script src="${pageContext.request.contextPath}/resources/js/reply.js"></script>
<script>
$(function(){
	console.log(replyService);

	var lno = '${lecture.lno}';
	var $ul = $("#replyUL");

	showList();
	function showList(lastRno, amount){
		replyService.getList({bno:bno, lastRno :lastRno, amount: amount},
			function(data) {
				console.log(data)
				if(!data) {
					 return;
				}

				if(data.length == 0) {
					$("#btnShowMore").text("댓글이 없습니다").prop("disabled", true);
					return;
				}

				var str = "";
				for(var i in data){
					str += '<li class="list-group-item" data-rno="'+ data[i].rno + '"> '
					str += '	<div class="clearfix">' 
					str += '		<div class="float-left text-dark font-weight-bold">' +data[i].writer + '</div> '
					str += '		<div class="float-right">' + replyService.displayTime(data[i].replyDate) + '</div>'
					str += '	</div> '
					str += '	<div>' + data[i].reply +'</div>'
					str += '</li>'
				}
				$("#btnShowMore").text("더보기").prop("disabled", false);
				// console.log(str);
				$ul.append(str);
			}
		)
	}
	// **************************** reply frm add **********************************
	$("#btnRegFrm").click(function() {
		<sec:authorize access="isAnonymous()">
		if(confirm("로그인이 필요한 페이지입니다. 로그인 페이지로 이동하시겠습니까?")) {
			location.href = "/customLogin"
		}
		else {
			return;
		}
		</sec:authorize>
		
		$("#reply").val("");
		$("#replyDate").closest("div").hide();
		$(".btns button").hide();
		$("#btnReg").show();
		$("#myModal").modal("show");
	})

	// ***************************** add *******************************************
	$("#btnReg").click(function() {
		var reply = {reply:$("#reply").val(), writer : $("#writer").val(), bno: bno};
		replyService.add(reply, 
				function(data) {
					alert(data)
					var count = $ul.find("li").length;
					$ul.html("");
					$("#myModal").find("input").val("");
					$("#myModal").modal("hide");
					showList(0, count + 1);
				}
			);
		})
	//************************* get *********************************************
	$ul.on("click","li",function() {
		// alert($(this).data("rno"));
		var rno = $(this).data("rno");
		replyService.get(rno, function(data){
			$("#reply").val(data.reply);
			$("#writer").val(data.writer);
			$("#replyDate").val(replyService.displayTime(data.replyDate)).prop("readonly", true).closest("div").show();
			$(".btns button").hide();
			$("#btnMod, #btnRmv").show();
			$("#myModal").data("rno", data.rno).modal("show");
		});
	})

	//*************************** modify ***************************************
	$("#btnMod").click(function() {
		var reply = {reply:$("#reply").val(), rno : $("#myModal").data("rno"), writer : $("#writer").val()};
		replyService.modify(reply, function(data) {
			alert(data)
			$("#myModal").modal("hide");
			// showList();
			$ul.find("li").each(function() {
				if($(this).data("rno") == reply.rno) {
					$(this).children().eq(0).find("div").first().text(reply.writer);
					$(this).children().eq(1).text(reply.reply);
				}
			})
		})
	})


	//************************** remove *****************************************
	$("#btnRmv").click(function() {
		var rno = $("#myModal").data("rno");
		replyService.remove(rno,function(data) {
			alert(data)
			$("#myModal").modal("hide");
			// showList();
			$ul.find("li").each(function() {
				if($(this).data("rno") == rno) {
					$(this).remove();
				}
			})
		})
	});

	//************************** 더보기 버튼  *************************************
	$("#btnShowMore").click(function() {
		var lastRno = $ul.find("li:last").data("rno");
		// alert(lastRno);
		showList(lastRno);
	})
	
	// 첨부파일 불러오기  (비동기 통신시 url생략시 내 url 따라감)
	$.getJSON("/lecture/getCourses/"+lno).done(function(data) {
		console.log(data);
		showCourses(data);
	}) 
}); // end of ready
    
	function showImage(fileCallPath) {
		$("#pictureModal")
			.find("img").attr("src","/display?fileName="+fileCallPath)
		.end().modal("show");
	}
    
	function showCourses(resultArr) {
		var str = "";
		for(var i in resultArr) {
			str += "<li class='list-group-item' "
			str += "data-uuid='" + resultArr[i].uuid + "' ";
			str += "data-path='" + resultArr[i].path + "' ";
			str += "data-origin='" + resultArr[i].origin + "' ";
			str += "data-size='" + resultArr[i].size + "' "
			str += "data-image='" + resultArr[i].image + "' "
			str += "data-mime='" + resultArr[i].mime + "' "
			str += "data-ext='" + resultArr[i].ext + "' "
			str += ">"
			if(resultArr[i].image) {
				str += "<a href='javascript:showImage(\"" + resultArr[i].fullPath + "\")'>"
				str += "<img src='/display?fileName=" + resultArr[i].thumb + "'>";
				str += "</a>"
			}
			else {
				str += "<a href='/download?fileName=" + resultArr[i].fullPath + "'>";
				str += "<i class='fas fa-paperclip'></i> " + resultArr[i].origin + "</a>";
			}
			str += "</li>";
		}
		$(".uploadResult ul").append(str);
	}    
</script>
            <!-- Footer -->
<%-- <jsp:include page="../includes/footer.jsp" /> --%>
            <!-- End of Footer -->

        </div>
        <!-- End of Content Wrapper -->

    </div>
    <!-- End of Page Wrapper -->
<script>
	var csrfHeader = $("meta[name='_csrf_header']").attr("content");
	var csrfToken = $("meta[name='_csrf']").attr("content");
	
	$(document).ajaxSend(function(e, xhr) {
		xhr.setRequestHeader(csrfHeader, csrfToken);
	})

$(function() {
	var result = '${result}';
});
</script>
    <!-- List Modal-->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Reply Modal</h5>
                    <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
					<div class="form-gorup">
						<label for="reply" class="text-dark font-weight-bold ">Reply</label>
						<input class="form-control" id="reply" name="reply" placeholder="댓글을 입력해주세요">
					</div>
					<div class="form-gorup">
						<label for="writer" class="text-dark font-weight-bold ">Replyer</label>
						<input class="form-control" id="writer" name="writer" disabled value="${pinfo.username}">
					</div>
					<div class="form-gorup">
						<label for="replyDate" class="text-dark font-weight-bold ">Reply Date</label>
						<input class="form-control" id="replyDate" name="replyDate" placeholder="">
					</div>
				</div>
                <div class="modal-footer text-right">
					<div class="btns">
					<button class="btn btn-primary " id="btnReg">Register</button>
					<button class="btn btn-warning " id="btnMod">Modify</button>
					<button class="btn btn-danger " id="btnRmv">Remove</button>
					</div>
                    <button class="btn btn-secondary" type="button" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
<%-- <jsp:include page="../includes/foot.jsp" /> --%>
</body>

</html>
