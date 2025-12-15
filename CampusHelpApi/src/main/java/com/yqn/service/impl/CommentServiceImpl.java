package com.yqn.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yqn.mapper.CommentMapper;
import com.yqn.pojo.Comment;
import com.yqn.service.CommentService;
import org.springframework.stereotype.Service;

/**
 * @author Leivmox
 */
@Service
public class CommentServiceImpl extends ServiceImpl<CommentMapper, Comment> implements CommentService {
}