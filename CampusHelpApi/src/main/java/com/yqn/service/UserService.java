package com.yqn.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.yqn.pojo.User;

import java.util.List;

/**
 * @author Leivmox
 */
public interface UserService extends IService<User> {
    
    List<User> listWithAssociation();
    
    User getByIdWithAssociation(Long id);
}
