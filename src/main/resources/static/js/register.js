function check_ok(){
	if(reg_frm.memberId.value.length==0){
		alert("아이디를 써주세요.");
		reg_frm.memberId.focus();
		return;
	}
	if(reg_frm.memberId.value.length < 4){
		alert("아이디는 4글자 이상이여야 합니다.");
		reg_frm.memberId.focus();
		return;
	}
	if(reg_frm.memberPw.value.length==0){
		alert("비밀번호를 써주세요.");
		reg_frm.memberPw.focus();
		return;
	}
	if(reg_frm.pwd_chk.value!=reg_frm.memberPw.value){
		alert("비밀번호를 제대로 확인해주세요.");
		reg_frm.pwd_chk.focus();
		return;
	}
	if(reg_frm.memberName.value.length==0){
		alert("이름을 써주세요.");
		reg_frm.memberName.focus();
		return;
	}
	if(reg_frm.memberEmail.value.length==0){
		alert("이메일을 써주세요.");
		reg_frm.memberEmail.focus();
		return;
	}
	if(reg_frm.memberPhone.value.length==0){
		alert("폰 번호를 써주세요.");
		reg_frm.memberPhone.focus();
		return;
	}
	if(reg_frm.memberZipcode.value.length==0){
		alert("우편 번호가 비었습니다.");
		return;
	}
	if(reg_frm.memberAddr2.value.length==0){
		alert("상세 주소가 비었습니다.");
		return;
	}
	if(reg_frm.idCheck.value=="N"){
		alert("아이디 중복 체크를 해주세요.");
		return;
	}
	if(reg_frm.emailCheck.value=="N"){
		alert("이메일 중복 체크를 해주세요.");
		return;
	}
	if (!reg_frm.mail_check_input.readOnly) { //테스트 시 인증 번거로우면 이부분 주석처리 하시면 됩니다.
		alert("이메일 인증을 해주세요");
		return;
	}
	reg_frm.submit();
}

function fn_idCheck(){
		if($("#member_id").val() == ""){
			alert("아이디가 공백입니다.");
		}else if($("#member_id").val().length < 4){
			alert("아이디가 4글자 이상이어야 합니다.");
		}else{
		var params = {
	                memberId : $("#member_id").val() // 🚩 KEY 수정 완료: memberId
	                }

	                $.ajax({
	                    url : "idCheck", 
	                    type : "post", 
	                    dataType : 'text', // 🚩 dataType을 'text'로 변경 (Controller 응답에 맞춤)
	                    data : params, 

	                    

	                    success : function(result){
	                   	console.log(result);
	                    
	                        if(result.trim() == "false"){ // 🚩 문자열 비교
	                            $("#idCheck").attr("value", "N");
	                            alert("중복된 아이디입니다.");

	                        }else if(result.trim() == "true"){ // 🚩 문자열 비교
	                            $("#idCheck").attr("value", "Y");
	                            alert("사용가능한 아이디입니다.");
	                            

	                        }else if(member_id == ""){
	                            alert("아이디가 확인되지 않았습니다. 다시 시도해주세요");
	                        }
	                    },error: function() {
					alert("오류입니다.");
				}
		 });
	 }
}
function fn_emailCheck(){
		if($("#member_email").val() == ""){
			alert("이메일이 공백입니다.");
		}else{
		var params = {
	                memberEmail : $("#member_email").val() // 🚩 KEY 수정 완료: memberEmail
	                }

	                $.ajax({
	                    url : "emailCheck", 
	                    type : "post", 
	                    dataType : 'text', // 🚩 dataType을 'text'로 변경 (Controller 응답에 맞춤)
	                    data : params, 

	                    

	                    success : function(result){
	                   	console.log(result);
	                    
	                        if(result.trim() == "false"){ // 🚩 문자열 비교
	                            $("#emailCheck").attr("value", "N");
	                            alert("중복된 이메일 입니다.");

	                        }else if(result.trim() == "true"){ // 🚩 문자열 비교
	                            $("#emailCheck").attr("value", "Y");
	                            alert("사용가능한 이메일입니다.");

	                        }else if(result == ""){
	                            alert("이메일이 확인되지 않았습니다. 다시 시도해주세요");
	                        }
	                    },error: function() {
					alert("오류입니다.");
				}
	 	});
	 }
}
var code = "";

function fn_emailNumCheck() {
	if($("#member_email").val() == ""){
		alert("이메일이 공백입니다.");
	}else{
		var email = {
			email : $("#member_email").val()
		}
	}

	// jQuery ajax 사용
	$.ajax({
		type: "post",
		url: "mailCheck",
		data: email,
		success: function(data) {
			console.log("인증번호 받아옴: " + data);
			code = data.trim(); // 혹시 공백 있을까봐 trim
			$("#mail_check_input").prop("disabled", false);
			alert("인증번호가 전송되었습니다.");
		},
		error: function(xhr, status, error) {
			alert("인증번호 전송 실패: " + error);
		}
	});
}
$(document).ready(function() {
	$('#mail_check_input').blur(function () {
		const inputCode = $(this).val();
		const $resultMsg = $('#mail_check_warn');


		if (inputCode === code) {
			$resultMsg.text('인증번호가 일치합니다.').css('color', 'green');
			$('#mail_check_input').prop('readonly', true);
			$('#member_email').prop('readonly', true);
		} else {
			$resultMsg.text('인증번호가 불일치 합니다. 다시 확인해주세요!').css('color', 'red');
		}
	});
});
