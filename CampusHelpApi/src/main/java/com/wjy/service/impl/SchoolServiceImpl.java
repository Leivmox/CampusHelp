package com.wjy.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wjy.mapper.SchoolMapper;
import com.wjy.pojo.School;
import com.wjy.service.SchoolService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author Leivmox
 */
@Service
public class SchoolServiceImpl extends ServiceImpl<SchoolMapper, School> implements SchoolService {
    @Autowired
    private SchoolMapper schoolMapper;

    @Override
    public boolean save(School entity) {
        QueryWrapper<School> wrapper = new QueryWrapper<>();
        wrapper.eq("name", entity.getName());

        School school = schoolMapper.selectOne(wrapper);
        if (school == null) {
            schoolMapper.insert(entity);
            return true;
        }

        return false;
    }
}
