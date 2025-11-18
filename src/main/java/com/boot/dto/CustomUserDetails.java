// 이 파일은 자동 로그인 기능 롤백으로 인해 더 이상 사용되지 않습니다.
// package com.boot.dto;
//
// import org.springframework.security.core.GrantedAuthority;
// import org.springframework.security.core.userdetails.UserDetails;
//
// import java.util.Collection;
// import java.util.Collections;
//
// public class CustomUserDetails implements UserDetails {
//
//     private LoginDTO loginDTO;
//
//     public CustomUserDetails(LoginDTO loginDTO) {
//         this.loginDTO = loginDTO;
//     }
//
//     public LoginDTO getLoginDTO() {
//         return loginDTO;
//     }
//
//     @Override
//     public Collection<? extends GrantedAuthority> getAuthorities() {
//         return Collections.singletonList(() -> "ROLE_USER");
//     }
//
//     @Override
//     public String getPassword() {
//         return loginDTO.getMemberPw();
//     }
//
//     @Override
//     public String getUsername() {
//         return loginDTO.getMemberId();
//     }
//
//     @Override
//     public boolean isAccountNonExpired() {
//         return true;
//     }
//
//     @Override
//     public boolean isAccountNonLocked() {
//         return true;
//     }
//
//     @Override
//     public boolean isCredentialsNonExpired() {
//         return true;
//     }
//
//     @Override
//     public boolean isEnabled() {
//         return true;
//     }
//
//     public String getMemberName() {
//         return loginDTO.getMemberName();
//     }
//
//     public String getUserType() {
//         if ("kakao".equals(loginDTO.getSocialLogin())) {
//             return "kakao";
//         }
//         return "customer";
//     }
// }
