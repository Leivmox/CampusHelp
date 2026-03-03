package com.yqn.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yqn.pojo.User;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * @author Leivmox
 */
public interface UserMapper extends BaseMapper<User> {
    
    @Select("SELECT * FROM user")
    @org.apache.ibatis.annotations.ResultMap("userResultMap")
    List<User> selectAllWithAssociation();
    
    @Select("SELECT * FROM user WHERE id = #{id}")
    @org.apache.ibatis.annotations.ResultMap("userResultMap")
    User selectByIdWithAssociation(Long id);
}
