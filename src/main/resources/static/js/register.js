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
