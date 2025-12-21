package com.yqn.common.config;

import org.springframework.beans.factory.annotation.Autowired; // 如果有拦截器需要用到
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 这是一个全能配置类：负责 跨域(CORS) + 资源映射(图片) + 拦截器(登录检查)
 * @author Leivmox
 */
@Configuration
public class CorsConfig implements WebMvcConfigurer {

    // 1. 读取 yml 中的图片存储路径
    // 确保你的 application.yml 里有 project.profile 这个配置
    @Value("${project.profile}")
    private String localPath;

    // ==========================================
    // 1. 跨域配置 (保持你原有的不变)
    // ==========================================
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowCredentials(true)
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE")
                .allowedHeaders("*")
                .exposedHeaders("*");
    }

    // ==========================================
    // 2. 图片资源映射 (这是解决图片不显示的关键!)
    // ==========================================
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 意思：只要前台访问 /profile/xxxxx
        // 就去硬盘的 D:/Lambda/.../uploadPath/xxxxx 找
        registry.addResourceHandler("/profile/**")
                .addResourceLocations("file:" + localPath + "/");

        System.out.println("【系统启动】资源映射已配置: /profile/** -> " + localPath);
    }

    // ==========================================
    // 3. 拦截器配置 (如果你项目里有 LoginInterceptor 就在这里注册)
    // ==========================================
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // ⚠️ 警告：
        // 如果你的项目里写了一个叫 "LoginInterceptor" 的类，但没在这里注册，它是不生效的。
        // 如果你将来要开启拦截器，请取消下面的注释，并确保 excludePathPatterns 包含 /profile/**

        /*
        registry.addInterceptor(new com.yqn.interceptor.LoginInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns("/user/login", "/user/register")
                .excludePathPatterns("/profile/**"); // 👈 图片路径绝对不能拦截！
        */
    }
}
