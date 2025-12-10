package com.yqn.controller;

import com.yqn.common.core.controller.BaseController;
import com.yqn.common.core.domain.AjaxResult;
import com.yqn.common.core.page.TableDataInfo;
import com.yqn.pojo.Remark;
import com.yqn.service.IRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * remarkController
 *
 * @author Leivmox
 * @date 2025-12-16
 */
@RestController
@RequestMapping("/student/remark")
public class RemarkController extends BaseController
{
    @Autowired
    private IRemarkService remarkService;

    /**
     * 查询remark列表
     */
    @GetMapping("/list")
    public TableDataInfo list(Remark remark)
    {
        startPage();
        List<Remark> list = remarkService.selectRemarkList(remark);
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
