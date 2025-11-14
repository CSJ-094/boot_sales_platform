package com.boot.config;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@Component
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        // 인증된 사용자 정보 가져오기
        User user = (User) authentication.getPrincipal();
        String memberId = user.getUsername(); // UserDetails의 getUsername()은 memberId를 반환

        // 세션에 memberId 저장
        HttpSession session = request.getSession();
        session.setAttribute("memberId", memberId);

        // 로그인 성공 후 리다이렉트할 기본 URL (SecurityConfig의 defaultSuccessUrl과 동일하게)
        response.sendRedirect("/mainpage");
    }
}