package com.boot.config;

import com.boot.dao.LoginDAO;
import com.boot.dto.LoginDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.DisabledException; // DisabledException 임포트 추가
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MyUserDetailsService implements UserDetailsService {

    private final LoginDAO loginDAO;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // 1. USER_DB에서 사용자 조회 시도
        LoginDTO userLoginDTO = loginDAO.loginYn(username);

        if (userLoginDTO != null) {
            // ⭐️ 회원 상태 확인
            if (!"ACTIVE".equals(userLoginDTO.getMemberStatus())) {
                throw new DisabledException("비활성화된 계정입니다.");
            }

            List<GrantedAuthority> authorities = new ArrayList<>();
            authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
            return new User(userLoginDTO.getMemberId(), userLoginDTO.getMemberPw(), authorities);
        }

        // 2. USER_DB에 없으면 SELLER_DB에서 사용자 조회 시도
        LoginDTO sellerLoginDTO = loginDAO.sellerLoginYn(username);

        if (sellerLoginDTO != null) {
            List<GrantedAuthority> authorities = new ArrayList<>();
            authorities.add(new SimpleGrantedAuthority("ROLE_SELLER"));
            return new User(sellerLoginDTO.getSelId(), sellerLoginDTO.getSelPw(), authorities); // selId와 selPw를 사용하도록 수정
        }

        // 두 곳 모두에서 찾지 못하면 예외 발생
        throw new UsernameNotFoundException("User not found with username: " + username);
    }
}
