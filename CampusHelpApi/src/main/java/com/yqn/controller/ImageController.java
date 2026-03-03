package com.yqn.controller;

import com.yqn.common.core.domain.AjaxResult;
import com.yqn.common.tools.MessageTools;
import com.yqn.mapper.PostMapper;
import com.yqn.mapper.TaskMapper;
import com.yqn.mapper.UserMapper;
import com.yqn.pojo.Post;
import com.yqn.pojo.Task;
import com.yqn.pojo.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.*;

@RestController
@RequestMapping("/image")
@Slf4j
public class ImageController {

    @Value("${project.profile}")
    private String uploadPath;

    private static final String RESOURCE_PREFIX = "/profile";

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private PostMapper postMapper;

    @Autowired
    private TaskMapper taskMapper;

    @Autowired
    private MessageTools message;

    @GetMapping("/list")
    public Map<String, Object> listImages() {
        List<Map<String, Object>> allImages = new ArrayList<>();
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists() || !uploadDir.isDirectory()) {
            return message.message(true, "请求成功", "images", allImages);
        }

        Set<String> usedUrls = collectUsedUrls();

        processDirectory(uploadDir, "", allImages, usedUrls);

        allImages.sort((a, b) -> {
            boolean aUsed = (boolean) a.get("isUsed");
            boolean bUsed = (boolean) b.get("isUsed");
            if (aUsed != bUsed) {
                return aUsed ? 1 : -1;
            }
            return ((Long) b.get("size")).compareTo((Long) a.get("size"));
        });

        return message.message(true, "请求成功", "images", allImages);
    }

    private Set<String> collectUsedUrls() {
        Set<String> usedUrls = new HashSet<>();

        List<User> users = userMapper.selectList(null);
        for (User user : users) {
            if (user.getAvatar() != null && !user.getAvatar().isEmpty()) {
                usedUrls.add(user.getAvatar());
            }
        }

        List<Post> posts = postMapper.selectList(null);
        for (Post post : posts) {
            if (post.getImgUrl() != null && !post.getImgUrl().isEmpty()) {
                String[] urls = post.getImgUrl().split(",");
                for (String url : urls) {
                    usedUrls.add(url.trim());
                }
            }
        }

        List<Task> tasks = taskMapper.selectList(null);
        for (Task task : tasks) {
            if (task.getImgUrl() != null && !task.getImgUrl().isEmpty()) {
                String[] urls = task.getImgUrl().split(",");
                for (String url : urls) {
                    usedUrls.add(url.trim());
                }
            }
        }

        return usedUrls;
    }

    private void processDirectory(File dir, String relativePath, List<Map<String, Object>> allImages, Set<String> usedUrls) {
        File[] files = dir.listFiles();
        if (files == null) return;

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        for (File file : files) {
            if (file.isDirectory()) {
                String newRelativePath = relativePath.isEmpty() ? file.getName() : relativePath + "/" + file.getName();
                processDirectory(file, newRelativePath, allImages, usedUrls);
            } else if (isImageFile(file.getName())) {
                String url = RESOURCE_PREFIX + "/" + relativePath + "/" + file.getName();
                if (!relativePath.isEmpty()) {
                    url = RESOURCE_PREFIX + "/" + relativePath + "/" + file.getName();
                } else {
                    url = RESOURCE_PREFIX + "/" + file.getName();
                }

                boolean isUsed = usedUrls.contains(url);

                Map<String, Object> imageInfo = new HashMap<>();
                imageInfo.put("name", file.getName());
                imageInfo.put("url", url);
                imageInfo.put("path", relativePath);
                imageInfo.put("size", file.length());
                imageInfo.put("sizeText", formatFileSize(file.length()));
                imageInfo.put("lastModified", sdf.format(new Date(file.lastModified())));
                imageInfo.put("isUsed", isUsed);
                imageInfo.put("type", getTypeFromPath(relativePath));

                allImages.add(imageInfo);
            }
        }
    }

    private String getTypeFromPath(String path) {
        if (path == null || path.isEmpty()) return "common";
        String[] parts = path.split("/");
        if (parts.length > 0) {
            return parts[0];
        }
        return "common";
    }

    private boolean isImageFile(String fileName) {
        String lower = fileName.toLowerCase();
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") 
            || lower.endsWith(".gif") || lower.endsWith(".bmp") || lower.endsWith(".webp");
    }

    private String formatFileSize(long size) {
        if (size < 1024) {
            return size + " B";
        } else if (size < 1024 * 1024) {
            return String.format("%.2f KB", size / 1024.0);
        } else {
            return String.format("%.2f MB", size / (1024.0 * 1024));
        }
    }

    @DeleteMapping("/unused")
    public Map<String, Object> deleteUnusedImages() {
        try {
            Set<String> usedUrls = collectUsedUrls();
            
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists() || !uploadDir.isDirectory()) {
                return message.message(false, "上传目录不存在", null, null);
            }

            int deletedCount = 0;
            long deletedSize = 0;

            List<File> toDelete = new ArrayList<>();
            collectUnusedFiles(uploadDir, "", usedUrls, toDelete);

            for (File file : toDelete) {
                deletedSize += file.length();
                if (file.delete()) {
                    deletedCount++;
                    log.info("删除未使用图片: {}", file.getAbsolutePath());
                }
            }

            return message.message(true, 
                String.format("成功删除 %d 张未使用图片，释放空间 %s", deletedCount, formatFileSize(deletedSize)), 
                "deletedCount", deletedCount);
        } catch (Exception e) {
            log.error("删除未使用图片失败", e);
            return message.message(false, "删除失败: " + e.getMessage(), null, null);
        }
    }

    private void collectUnusedFiles(File dir, String relativePath, Set<String> usedUrls, List<File> toDelete) {
        File[] files = dir.listFiles();
        if (files == null) return;

        for (File file : files) {
            if (file.isDirectory()) {
                String newRelativePath = relativePath.isEmpty() ? file.getName() : relativePath + "/" + file.getName();
                collectUnusedFiles(file, newRelativePath, usedUrls, toDelete);
            } else if (isImageFile(file.getName())) {
                String url = RESOURCE_PREFIX + "/" + relativePath + "/" + file.getName();
                if (!usedUrls.contains(url)) {
                    toDelete.add(file);
                }
            }
        }
    }

    @DeleteMapping("/{url}")
    public Map<String, Object> deleteImage(@PathVariable String url) {
        try {
            if (url == null || url.isEmpty()) {
                return message.message(false, "图片URL不能为空", null, null);
            }

            Set<String> usedUrls = collectUsedUrls();
            if (usedUrls.contains(url)) {
                return message.message(false, "该图片正在使用中，无法删除", null, null);
            }

            String filePath = uploadPath + url.replace(RESOURCE_PREFIX, "");
            Path path = Paths.get(filePath);
            
            if (Files.exists(path)) {
                Files.delete(path);
                log.info("删除图片: {}", filePath);
                return message.message(true, "删除成功", null, null);
            } else {
                return message.message(false, "图片文件不存在", null, null);
            }
        } catch (Exception e) {
            log.error("删除图片失败", e);
            return message.message(false, "删除失败: " + e.getMessage(), null, null);
        }
    }

    @GetMapping("/stats")
    public Map<String, Object> getStats() {
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists() || !uploadDir.isDirectory()) {
            return message.message(true, "请求成功", "stats", createEmptyStats());
        }

        Set<String> usedUrls = collectUsedUrls();
        
        long totalSize = 0;
        long usedSize = 0;
        long unusedSize = 0;
        int totalCount = 0;
        int usedCount = 0;
        int unusedCount = 0;

        List<File> allFiles = new ArrayList<>();
        collectAllImageFiles(uploadDir, allFiles);

        for (File file : allFiles) {
            String url = buildUrl(file, uploadPath);
            totalSize += file.length();
            totalCount++;
            
            if (usedUrls.contains(url)) {
                usedSize += file.length();
                usedCount++;
            } else {
                unusedSize += file.length();
                unusedCount++;
            }
        }

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalCount", totalCount);
        stats.put("usedCount", usedCount);
        stats.put("unusedCount", unusedCount);
        stats.put("totalSize", totalSize);
        stats.put("totalSizeText", formatFileSize(totalSize));
        stats.put("usedSize", usedSize);
        stats.put("usedSizeText", formatFileSize(usedSize));
        stats.put("unusedSize", unusedSize);
        stats.put("unusedSizeText", formatFileSize(unusedSize));

        return message.message(true, "请求成功", "stats", stats);
    }

    private void collectAllImageFiles(File dir, List<File> allFiles) {
        File[] files = dir.listFiles();
        if (files == null) return;

        for (File file : files) {
            if (file.isDirectory()) {
                collectAllImageFiles(file, allFiles);
            } else if (isImageFile(file.getName())) {
                allFiles.add(file);
            }
        }
    }

    private String buildUrl(File file, String basePath) {
        String absolutePath = file.getAbsolutePath();
        String relativePath = absolutePath.substring(basePath.length());
        return RESOURCE_PREFIX + relativePath.replace("\\", "/");
    }

    private Map<String, Object> createEmptyStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalCount", 0);
        stats.put("usedCount", 0);
        stats.put("unusedCount", 0);
        stats.put("totalSize", 0L);
        stats.put("totalSizeText", "0 B");
        stats.put("usedSize", 0L);
        stats.put("usedSizeText", "0 B");
        stats.put("unusedSize", 0L);
        stats.put("unusedSizeText", "0 B");
        return stats;
    }
}
