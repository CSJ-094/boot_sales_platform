package com.boot.service;

import com.boot.dao.MemDAO;
import com.boot.dto.MemDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor // final 필드에 대한 생성자 주입
public class UserService {

    private final MemDAO userMapper;
    private final PasswordEncoder passwordEncoder;

    public MemDTO getUserById(String memberId) {
        return userMapper.getUserById(memberId);
    }

    public List<MemDTO> getUserList() {
        return userMapper.getUserList();
    }

    /**
     * 회원 정보를 수정합니다. 비밀번호가 제공되면 암호화하여 업데이트합니다.
     * @param member 수정할 회원 정보 DTO
     */
    public void updateUserInfo(MemDTO member) {
        // 1. 새 비밀번호가 입력되었는지 확인
        if (member.getMemberPw() != null && !member.getMemberPw().isEmpty()) {
            // 1-1. 새 비밀번호를 암호화하여 설정
            String encodedPw = passwordEncoder.encode(member.getMemberPw());
            member.setMemberPw(encodedPw);
        } else {
            // 1-2. 새 비밀번호가 없으면 기존 비밀번호를 유지
            MemDTO originalInfo = userMapper.getUserById(member.getMemberId());
            member.setMemberPw(originalInfo.getMemberPw());
        }

        // 2. DAO를 통해 회원 정보 수정
        userMapper.modify(member);
    }
}
