package com.wjy.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wjy.mapper.TaskMapper;
import com.wjy.pojo.Task;
import com.wjy.service.TaskService;
import org.springframework.stereotype.Service;

/**
 * @author Leivmox
 */
@Service
public class TaskServiceImpl extends ServiceImpl<TaskMapper, Task> implements TaskService {
}
