package com.yqn.service.impl;

import com.yqn.mapper.RemarkMapper;
import com.yqn.pojo.Remark;
import com.yqn.service.IRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * remarkService业务层处理
 *
 * @author Leivmox
 * @date 2025-12-16
 */
@Service
public class RemarkServiceImpl implements IRemarkService
{
    @Autowired
    private RemarkMapper remarkMapper;

    /**
     * 查询remark
     *
     * @param id remark主键
     * @return remark
     */
    @Override
    public Remark selectRemarkById(Long id)
    {
        return remarkMapper.selectRemarkById(id);
    }

    /**
     * 查询remark列表
     *
     * @param remark remark
     * @return remark
     */
    @Override
    public List<Remark> selectRemarkList(Remark remark)
    {
        return remarkMapper.selectRemarkList(remark);
    }

    /**
     * 新增remark
     *
     * @param remark remark
     * @return 结果
     */
    @Override
    public int insertRemark(Remark remark)
    {
        return remarkMapper.insertRemark(remark);
    }

    /**
     * 修改remark
     *
     * @param remark remark
     * @return 结果
     */
    @Override
    public int updateRemark(Remark remark)
    {
        return remarkMapper.updateRemark(remark);
    }

    /**
     * 批量删除remark
     *
     * @param ids 需要删除的remark主键
     * @return 结果
     */
    @Override
    public int deleteRemarkByIds(Long[] ids)
    {
        return remarkMapper.deleteRemarkByIds(ids);
    }

    /**
     * 删除remark信息
     *
     * @param id remark主键
     * @return 结果
     */
    @Override
    public int deleteRemarkById(Long id)
    {
        return remarkMapper.deleteRemarkById(id);
    }
}
