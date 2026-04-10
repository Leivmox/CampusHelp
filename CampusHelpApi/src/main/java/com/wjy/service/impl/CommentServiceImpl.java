package com.wjy.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wjy.mapper.CommentMapper;
import com.wjy.pojo.Comment;
import com.wjy.service.CommentService;
import org.springframework.stereotype.Service;

/**
 * @author Leivmox
 */
@Service
public class CommentServiceImpl extends ServiceImpl<CommentMapper, Comment> implements CommentService {
}