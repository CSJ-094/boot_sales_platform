<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>판매자 회원 가입 신청</title>
	<script type="text/javascript" src="<c:url value='/js/jquery.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/sellerRegister.js'/>"></script> <%-- 판매자용 JS 파일 --%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
	function daumZipCode() {
		new daum.Postcode(
				{
					oncomplete : function(data) {
						var addr = '';
						var extraAddr = '';

						if (data.userSelectedType === 'R') {
							addr = data.roadAddress;
						} else {
							addr = data.jibunAddress;
						}

						if (data.userSelectedType === 'R') {
							if (data.bname !== ''
									&& /[동|로|가]$/g.test(data.bname)) {
								extraAddr += data.bname;
							}
							if (data.buildingName !== ''
									&& data.apartment === 'Y') {
								extraAddr += (extraAddr !== '' ? ', '
										+ data.buildingName : data.buildingName);
							}
							if (extraAddr !== '') {
								extraAddr = ' (' + extraAddr + ')';
							}
							document.getElementById("selAddr1").value = extraAddr; // 필드명 변경

						} else {
							document.getElementById("selAddr2").value = ''; // 필드명 변경
						}

						document.getElementById('selZipcode').value = data.zonecode; // 필드명 변경
						document.getElementById("selAddr1").value = addr; // 필드명 변경
						document.getElementById("selAddr2").focus(); // 필드명 변경
					}
				}).open();
	}

</script>
<style>
/* mainpage.jsp 스타일을 기반으로 수정 */
	* { box-sizing: border-box; margin: 0; padding: 0; }
	body { 
		font-family: 'Noto Sans KR', 'Montserrat', sans-serif; 
		color: #333; 
		line-height: 1.6; 
		background-color: #f9f9f9; 
		min-height: 100vh;
	}

.container {
	width: 650px;
	margin: 50px auto;
	border: 1px solid #ccc;
	padding: 30px;
	box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
	border-radius: 4px;
	background-color: #ffffff;
}

.form-group {
	margin-bottom: 20px;
	display: flex;
	align-items: center;
}

.form-group label {
	flex-shrink: 0;
	width: 120px;
	font-weight: 500;
}

.form-group input[type="text"],
.form-group input[type="password"] {
	flex: 1;
	padding: 8px 10px;
	border: 1px solid #e0e0e0;
	border-radius: 3px;
}

.form-group button, .form-actions input[type="button"] {
	padding: 8px 15px; 
	border: none; 
	border-radius: 3px; 
	font-size: 13px;
	cursor: pointer;
	font-weight: 500;
	margin-left: 10px;
	flex-shrink: 0;
	transition: background-color 0.3s ease, color 0.3s ease;
	background-color: #4a4a4a;
	color: #fff;
}

.form-group button:hover, .form-actions input[type="button"]:hover {
	background-color: #b08d57;
	color: #2c2c2c;
}

.form-actions input[type="reset"] {
	padding: 8px 15px; 
	border: 1px solid #ccc;
	border-radius: 3px; 
	font-size: 13px;
	cursor: pointer;
	font-weight: 500;
	transition: background-color 0.3s ease;
	background-color: #f0f0f0;
	margin-left: 5px;
}
.form-actions input[type="reset"]:hover {
	background-color: #e0e0e0;
}


.form-title {
	text-align: center;
	margin-bottom: 30px;
}
.form-title h1 {
	font-weight: 700;
	color: #2c2c2c;
	font-size: 28px;
	border-bottom: 2px solid #b08d57;
	padding-bottom: 10px;
}

.form-actions {
	text-align: center;
	margin-top: 30px;
}

.form-group .form-control {
	padding: 8px 10px;
	border: 1px solid #e0e0e0;
	border-radius: 3px;
}

.zipcode-row {
	display: flex;
	align-items: center;
	flex: 1;
}

.zipcode-row input[name="selZipcode"] { /* 필드명 변경 */
	width: 120px;
	flex-grow: 0;
}

.zipcode-row button {
	flex-grow: 0;
	margin-left: 10px;
}


</style>
</head>
<body>
	<div class="container">
		<form name="reg_frm" method="post" action="<c:url value='/seller/registerOk'/>"> <%-- 폼 액션 변경 --%>
			<div class="form-title">
				<h1>판매자 회원 가입 신청</h1>
			</div>

			<div class="form-group">
				<label for="sel_id">판매자 ID</label> <%-- 라벨 변경 --%>
				<input type="text" id="sel_id" name="selId" size="20" placeholder="판매자 아이디를 입력하세요.(4글자 이상))"> <%-- 필드명 변경 --%>
				<button type="button" onclick="fn_selIdCheck()" id="selIdCheck" name="selIdCheck" value="N">중복 확인</button> <%-- 함수명, ID 변경 --%>
			</div>

			<div class="form-group">
				<label for="sel_pw">비밀번호</label> <input type="password" id="sel_pw" <%-- 필드명 변경 --%>
					name="selPw" size="20" placeholder="비밀번호를 입력하세요."> <%-- 필드명 변경 --%>
			</div>

			<div class="form-group">
				<label for="pwd_chk">비밀번호 확인</label> <input type="password" id="pwd_chk"
					name="pwd_chk" size="20" placeholder="비밀번호를 한번 더 입력하세요.">
			</div>

			<div class="form-group">
				<label for="sel_name">판매자명</label> <input type="text" <%-- 라벨, 필드명 변경 --%>
					id="sel_name" name="selName" size="20" placeholder="판매자명을 입력하세요."> <%-- 필드명 변경 --%>
			</div>
			
			<div class="form-group">
				<label for="sel_cname">상호명</label> <input type="text" <%-- 라벨, 필드명 변경 --%>
					id="sel_cname" name="selCName" size="20" placeholder="상호명을 입력하세요."> <%-- 필드명 변경 --%>
			</div>

			<div class="form-group">
				<label for="sel_email">이메일</label> <%-- 라벨 변경 --%>
				<input type="text" id="sel_email" name="selEmail" size="20" placeholder="이메일을 입력하세요."> <%-- 필드명 변경 --%>
				<button type="button" onclick="fn_selEmailCheck()" id="selEmailCheck" value="N">중복 확인</button> <%-- 함수명, ID 변경 --%>
				<button type="button" id="selEmailNumCheck" name="selEmailNumCheck" onclick="fn_selEmailNumCheck()">이메일 인증</button> <%-- 함수명, ID 변경 --%>
			</div>
			<div class="form-group">
				<label for="sel_email_auth">이메일 인증</label> <%-- 라벨 변경 --%>
				<input type="text" placeholder="인증번호 6자리를 입력해주세요." disabled="disabled"  maxlength="6" id="mail_check_input" name="mail_check_input">
			</div>
			<div class="form-group">
				<span id="mail_check_warn"></span>
			</div>

			<div class="form-group">
				<label for="sel_phone">휴대폰</label> <input type="text" <%-- 라벨, 필드명 변경 --%>
					id="sel_phone" name="selPhone" size="20" placeholder="휴대폰 번호를 입력하세요."> <%-- 필드명 변경 --%>
			</div>

			<div class="form-group">
				<label for ="selZipcode">우편번호</label> <%-- 라벨 변경 --%>
				<div class="zipcode-row">
					<input class="form-control" name="selZipcode" id="selZipcode" type="text" readonly placeholder="우편번호"> <%-- 필드명 변경 --%>
					<button type="button" class="btn btn-default" onclick="daumZipCode()">
						우편번호 찾기
					</button>
				</div>
			</div>
			
			<div class="form-group">
				<label for="selAddr1">주소</label> <%-- 라벨 변경 --%>
				<input class="form-control" name="selAddr1" id="selAddr1" type="text" readonly placeholder="도로명 주소 (검색 결과)"> <%-- 필드명 변경 --%>
			</div>
			<div class="form-group">
				<label for="selAddr2">상세 주소</label> <%-- 라벨 변경 --%>
				<input class="form-control" placeholder="상세 주소" name="selAddr2" id="selAddr2" type="text"> <%-- 필드명 변경 --%>
			</div>

			<div class="form-actions">
				<input type="button" value="등록" onclick="check_ok()">
				<input type="reset" value="초기화">
				<input type="button" value="돌아가기" onclick="location.href='<c:url value='/login'/>'">
			</div>
		</form>
	</div>
</body>
</html>