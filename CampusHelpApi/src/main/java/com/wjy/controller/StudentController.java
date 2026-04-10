package com.wjy.controller;

import com.wjy.common.core.controller.BaseController;
import com.wjy.common.core.domain.AjaxResult;
import com.wjy.common.core.page.TableDataInfo;
import com.wjy.common.tools.MessageTools;
import com.wjy.pojo.Student;
import com.wjy.service.IStudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 学生管理Controller
 *
 * @author Leivmox
 * @date 2025-12-05
 */
@RestController
@RequestMapping("/student/stuage")
public class StudentController extends BaseController
{
    @Autowired
    private IStudentService studentService;

    @Autowired
    private MessageTools message;

    /**
     * 查询学生管理列表
     */
    @GetMapping("/list")
    public TableDataInfo list(Student student)
    {
        startPage();
        List<Student> list = studentService.selectStudentList(student);
        return getDataTable(list);
    }

    /**
     * 获取学生管理详细信息
     */
//    @GetMapping("/{id}")
//    public AjaxResult getInfo(@PathVariable("id") Long id)
//    {
//        return AjaxResult.success(studentService.selectStudentById(id));
//    }

    @GetMapping("/{id}")
    public Map<String, Object> findStudentById(@PathVariable Long id) {
        Student student = studentService.selectStudentById(id);
        return message.message(true, "请求成功", "student", student);
    }

    /**
     * 新增学生管理
     */
    @PostMapping
    public AjaxResult add(@RequestBody Student student)
    {
        return toAjax(studentService.insertStudent(student));
    }

    /**
     * 修改学生管理
     */
    @PutMapping
    public AjaxResult edit(@RequestBody Student student)
    {
        return toAjax(studentService.updateStudent(student));
    }

    /**
     * 删除学生管理
     */
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(studentService.deleteStudentByIds(ids));
    }
}
