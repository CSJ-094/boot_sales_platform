package com.boot.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    // application.properties 또는 application.yml 에서 파일 경로를 관리하는 것이 더 좋습니다.
    private String resourcePath = "/upload/**"; // 웹에서 접근할 경로
    private String savePath = "file:///C:/temp/product_upload/"; // 실제 파일이 저장된 경로

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler(resourcePath)
                .addResourceLocations(savePath);
    }
}