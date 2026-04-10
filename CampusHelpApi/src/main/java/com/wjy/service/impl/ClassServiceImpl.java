package com.wjy.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wjy.mapper.ClassMapper;
import com.wjy.pojo.Class;
import com.wjy.service.ClassService;
import org.springframework.stereotype.Service;

/**
 * @author Leivmox
 */
@Service
public class ClassServiceImpl extends ServiceImpl<ClassMapper, Class> implements ClassService {
}
