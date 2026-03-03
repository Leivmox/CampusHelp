package com.yqn.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yqn.mapper.UserMapper;
import com.yqn.pojo.User;
import com.yqn.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author Leivmox
 */
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {
    
    @Autowired
    private UserMapper userMapper;
    
    @Override
    public List<User> listWithAssociation() {
        return userMapper.selectAllWithAssociation();
    }
    
    @Override
    public User getByIdWithAssociation(Long id) {
        return userMapper.selectByIdWithAssociation(id);
    }
}
