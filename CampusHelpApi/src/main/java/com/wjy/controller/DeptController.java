package com.wjy.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wjy.pojo.Class;
import com.wjy.pojo.Dept;
import com.wjy.service.ClassService;
import com.wjy.service.DeptService;
import com.wjy.common.tools.MessageTools;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * @author Leivmox
 */
@RestController
@RequestMapping("/dept")
public class DeptController {
    @Autowired
    private DeptService deptService;
    @Autowired
    private MessageTools message;
    @Autowired
    private ClassService classService;

    // 获取全部dept
    @GetMapping
    public Map<String, Object> depts() {
        List<Dept> depts = deptService.list();
        return message.message(true, "请求成功", "dept", depts);
    }

    // 根据id获取dept
    @GetMapping("/{id}")
    public Map<String, Object> dept(@PathVariable Long id) {
        Dept dept = deptService.getById(id);
        return message.message(true, "请求成功", "dept", dept);
    }

    // 添加dept
    @PostMapping
    public Map<String, Object> saveDept(@RequestBody Dept dept) {
        // 确保schoolId不会为null
        if(dept.getSchoolId() == 0) {
            return message.message(false, "学校ID不能为空", "", null);
        }

        QueryWrapper<Dept> wrapper = new QueryWrapper<>();
        wrapper.eq("school_id", dept.getSchoolId())
                .eq("name", dept.getName());

        Dept one = deptService.getOne(wrapper);
        if (one == null) {
            deptService.save(dept);
            return message.message(true, "添加系别成功", "", null);
        }

        return message.message(true, "error, 该系已存在", "", null);
    }

    // 删除
    @DeleteMapping("/{id}")
    public Map<String, Object> delDept(@PathVariable Long id) {
        int classCount = classService.count(new QueryWrapper<Class>().eq("dept_id", id));
        if (classCount > 0) {
            return message.message(false, "该院系存在关联班级，禁止删除", "", null);
        }
        boolean remove = deptService.removeById(id);
        if (remove) {
            return message.message(true, "删除成功", "", null);
        }
        return message.message(false, "error, 删除失败", "", null);
    }
}
