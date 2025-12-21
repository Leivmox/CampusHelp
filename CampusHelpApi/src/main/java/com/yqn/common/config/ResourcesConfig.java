package com.yqn.common.config; // 请根据实际包结构调整

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 通用资源映射配置
 */
@Configuration
public class ResourcesConfig implements WebMvcConfigurer {
    // 读取 yml 中的路径 D:/campus-project/uploadPath
    @Value("${project.profile}")
    private String localPath;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        /**
         * 资源映射路径
         * 访问 http://localhost:8080/profile/avatar/xxx.jpg
         * 会自动寻找 D:/campus-project/uploadPath/avatar/xxx.jpg
         */
        registry.addResourceHandler("/profile/**")
                .addResourceLocations("file:" + localPath + "/");
    }
}