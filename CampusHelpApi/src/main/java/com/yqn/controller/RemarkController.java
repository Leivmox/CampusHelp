package com.yqn.controller;

import com.yqn.common.core.controller.BaseController;
import com.yqn.common.core.domain.AjaxResult;
import com.yqn.common.core.page.TableDataInfo;
import com.yqn.pojo.Remark;
import com.yqn.pojo.Task;
import com.yqn.pojo.User;
import com.yqn.service.IRemarkService;
import com.yqn.service.TaskService; // 必须导入
import com.yqn.service.UserService; // 必须导入
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * remarkController
 * @author Leivmox
 * @date 2025-12-16
 */
@RestController
@RequestMapping("/student/remark")
public class RemarkController extends BaseController
{
    @Autowired
    private IRemarkService remarkService;

    // 1. 注入 TaskService (查任务用)
    @Autowired
    private TaskService taskService;

    // 2. 注入 UserService (查人名用)
    @Autowired
    private UserService userService;

    @GetMapping("/list")
    public TableDataInfo list(Remark remark)
    {
        startPage();
        List<Remark> list = remarkService.selectRemarkList(remark);

        // 遍历每一个评价
        for (Remark r : list) {
            if (r.getTaskId() != null) {
                Task task = taskService.getById(r.getTaskId());

                if (task != null) {
                    // 1. 查发布者/求助者 (Publisher) -> 用于“我收到的评价”页面
                    Long publishId = task.getPublishId();
                    if (publishId != null) {
                        User publisher = userService.getById(publishId);
                        task.setPublish(publisher); // 确保 Task.java 有 private User publish;
                    }

                    // 2. 查接受者/互助者 (Acceptor) -> 用于“我的评价记录”页面
                    Long acceptId = task.getAcceptId();
                    if (acceptId != null) {
                        User acceptor = userService.getById(acceptId);
                        task.setAccept(acceptor);   // 确保 Task.java 有 private User accept;
                    }

                    // 将信息完整的 task 放回 remark
                    r.setTask(task);
                }
            }
        }
        return getDataTable(list);
    }
    /**
     * 获取remark详细信息
     */
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return AjaxResult.success(remarkService.selectRemarkById(id));
    }

    /**
     * 新增remark
     */
    @PostMapping
    public AjaxResult add(@RequestBody Remark remark)
    {
        return toAjax(remarkService.insertRemark(remark));
    }

    /**
     * 修改remark
     */
    @PutMapping
    public AjaxResult edit(@RequestBody Remark remark)
    {
        return toAjax(remarkService.updateRemark(remark));
    }

    /**
     * 删除remark
     */
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(remarkService.deleteRemarkByIds(ids));
    }
}
