package com.yqn.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yqn.mapper.UserLikeMapper;
import com.yqn.pojo.UserLike;
import com.yqn.service.UserLikeService;
import org.springframework.stereotype.Service;

@Service
public class UserLikeServiceImpl extends ServiceImpl<UserLikeMapper, UserLike> implements UserLikeService {
    // 里面什么都不用写，全靠父类 ServiceImpl
}