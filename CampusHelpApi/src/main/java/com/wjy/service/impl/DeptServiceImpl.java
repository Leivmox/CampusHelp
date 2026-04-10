package com.wjy.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wjy.mapper.DeptMapper;
import com.wjy.pojo.Dept;
import com.wjy.service.DeptService;
import org.springframework.stereotype.Service;

/**
 * @author Leivmox
 */
@Service
public class DeptServiceImpl extends ServiceImpl<DeptMapper, Dept> implements DeptService {
}
