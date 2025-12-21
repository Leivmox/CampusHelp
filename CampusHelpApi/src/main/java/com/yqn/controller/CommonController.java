package com.yqn.controller;

import com.yqn.common.core.domain.AjaxResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * 通用请求处理 (文件上传/下载)
 */
@RestController
@RequestMapping("/common")
public class CommonController
{
    private static final Logger log = LoggerFactory.getLogger(CommonController.class);

    // 读取本地基础路径
    @Value("${project.profile}")
    private String uploadPath;

    // 服务器访问前缀 (配合 ResourcesConfig)
    private static final String RESOURCE_PREFIX = "/profile";

    // 允许的业务类型白名单 (安全起见，防止乱传)
    private static final List<String> ALLOWED_TYPES = Arrays.asList("avatar", "post", "chat", "comment", "feedback");

    /**
     * 通用上传请求（支持图片、文件）
     * * @param file 文件对象
     * @param type 业务类型 (avatar-头像, post-帖子, chat-聊天)
     */
    @PostMapping("/upload")
    public AjaxResult uploadFile(@RequestParam("file") MultipartFile file,
                                 @RequestParam(value = "type", defaultValue = "common") String type)
    {
        try
        {
            // 1. 校验文件
            if (file == null || file.isEmpty()){
                return AjaxResult.error("上传文件不能为空");
            }

            // 2. 校验并处理类型 (如果没有传type，或者type不合法，默认归类到 common)
            if (!ALLOWED_TYPES.contains(type)) {
                type = "common";
            }

            // 3. 构建相对路径: /avatar/202512
            String datePath = new SimpleDateFormat("yyyyMM").format(new Date());
            String relativePath = "/" + type + "/" + datePath;

            // 4. 构建绝对路径: D:/campus-project/uploadPath/avatar/202512
            File dir = new File(uploadPath + relativePath);
            if (!dir.exists()){
                dir.mkdirs();
            }

            // 5. 生成新文件名 (UUID + 原后缀)
            String originalFilename = file.getOriginalFilename();
            String suffix = originalFilename.substring(originalFilename.lastIndexOf("."));
            String fileName = UUID.randomUUID().toString() + suffix;

            // 6. 保存文件到磁盘
            File dest = new File(dir, fileName);
            file.transferTo(dest);

            // 7. 拼接返回给前端的URL
            // 结果示例: /profile/avatar/202512/sd2-231.jpg
            String fileUrl = RESOURCE_PREFIX + relativePath + "/" + fileName;

            // 8. 返回结果
            AjaxResult ajax = AjaxResult.success("上传成功");
            ajax.put("url", fileUrl);          // 完整的访问路径 (存数据库用这个)
            ajax.put("fileName", fileName);    // 新文件名
            ajax.put("originalFilename", originalFilename); // 原始文件名

            return ajax;
        }
        catch (IOException e)
        {
            log.error("上传文件失败", e);
            return AjaxResult.error("上传失败:" + e.getMessage());
        }
    }
}