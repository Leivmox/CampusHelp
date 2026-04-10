package com.wjy.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wjy.pojo.User;

import java.util.List;

/**
 * @author Leivmox
 */
public interface UserService extends IService<User> {
    
    List<User> listWithAssociation();
    
    User getByIdWithAssociation(Long id);
}
