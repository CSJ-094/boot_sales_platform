function check_ok(){
	var reg_frm = document.forms["reg_frm"]; // 폼 객체 참조

	if(reg_frm.selId.value.length==0){
		alert("판매자 아이디를 입력해주세요.");
		reg_frm.selId.focus();
		return;
	}
	if(reg_frm.selId.value.length < 4){
		alert("판매자 아이디는 4글자 이상이어야 합니다.");
		reg_frm.selId.focus();
		return;
	}
	if(reg_frm.selPw.value.length==0){
		alert("비밀번호를 입력해주세요.");
		reg_frm.selPw.focus();
		return;
	}
	if(reg_frm.pwd_chk.value!=reg_frm.selPw.value){
		alert("비밀번호를 제대로 확인해주세요.");
		reg_frm.pwd_chk.focus();
		return;
	}
	if(reg_frm.selName.value.length==0){
		alert("판매자명을 입력해주세요.");
		reg_frm.selName.focus();
		return;
	}
	if(reg_frm.selCName.value.length==0){
		alert("상호명을 입력해주세요.");
		reg_frm.selCName.focus();
		return;
	}
	if(reg_frm.selEmail.value.length==0){
		alert("이메일을 입력해주세요.");
		reg_frm.selEmail.focus();
		return;
	}
	if(reg_frm.selPhone.value.length==0){
		alert("휴대폰 번호를 입력해주세요.");
		reg_frm.selPhone.focus();
		return;
	}
	if(reg_frm.selZipcode.value.length==0){
		alert("우편 번호가 비었습니다.");
		return;
	}
	if(reg_frm.selAddr2.value.length==0){
		alert("상세 주소가 비었습니다.");
		return;
	}
	if(reg_frm.selIdCheck.value=="N"){ // ID 변경
		alert("판매자 아이디 중복 체크를 해주세요.");
		return;
	}
	if(reg_frm.selEmailCheck.value=="N"){ // ID 변경
		alert("이메일 중복 체크를 해주세요.");
		return;
	}
	if (!reg_frm.mail_check_input.readOnly) {
		alert("이메일 인증을 해주세요");
		return;
	}
	reg_frm.submit();
}

function fn_selIdCheck(){ // 함수명 변경
    var selIdValue = $("#sel_id").val(); // ID 변경

    if(selIdValue == ""){
        alert("판매자 아이디를 입력해주세요.");
        return;
    }
    if(selIdValue.length < 4){
        alert("판매자 아이디는 4글자 이상이어야 합니다.");
        return;
    }

    $.ajax({
        url: "/seller/id_check",           // URL 변경
        type: "post",
        dataType: "text",
        data: {
            selId: selIdValue // 파라미터 이름 변경
        },
        success: function(result){
            if(result.trim() == "n"){
                $("#selIdCheck").attr("value", "N"); // ID 변경
                alert("중복된 판매자 아이디입니다.");
            } else if(result.trim() == "y"){
                $("#selIdCheck").attr("value", "Y"); // ID 변경
                alert("사용 가능한 판매자 아이디입니다.");
            }
        },
        error: function() {
            alert("오류입니다. 다시 시도해주세요.");
        }
    });
}

function fn_selEmailCheck(){ // 함수명 변경
    var selEmailValue = $("#sel_email").val(); // ID 변경

    if(selEmailValue == ""){
        alert("이메일을 입력해주세요.");
        return;
    }

    $.ajax({
        url: "/seller/email_check",        // URL 변경
        type: "post",
        dataType: "text",
        data: {
            selEmail: selEmailValue // 파라미터 이름 변경
        },
        success: function(result){
            if(result.trim() == "n"){
                $("#selEmailCheck").attr("value", "N"); // ID 변경
                alert("중복된 이메일입니다.");
            } else if(result.trim() == "y"){
                $("#selEmailCheck").attr("value", "Y"); // ID 변경
                alert("사용 가능한 이메일입니다.");
            }
        },
        error: function() {
            alert("오류입니다. 다시 시도해주세요.");
        }
    });
}

var code = "";

function fn_selEmailNumCheck() { // 함수명 변경
	if($("#sel_email").val() == ""){ // ID 변경
		alert("이메일이 공백입니다.");
	}else{
		var email = {
			email : $("#sel_email").val() // ID 변경
		}
	}

	// jQuery ajax 사용
	$.ajax({
		type: "post",
		url: "/mailCheck", // 이메일 인증은 LoginController의 mailCheck 사용
		data: email,
		success: function(data) {
			console.log("인증번호 받아옴: " + data);
			code = data.trim();
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
			$('#sel_email').prop('readonly', true); // ID 변경
		} else {
			$resultMsg.text('인증번호가 불일치 합니다. 다시 확인해주세요!').css('color', 'red');
		}
	});
});
```
```
