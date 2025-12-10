package com.yqn.service;

import com.yqn.pojo.Remark;
import java.util.List;

/**
 * remarkService接口
 *
 * @author Leivmox
 * @date 2025-12-16
 */
public interface IRemarkService
{
    /**
     * 查询remark
     *
     * @param id remark主键
     * @return remark
     */
    public Remark selectRemarkById(Long id);

    /**
     * 查询remark列表
     *
     * @param remark remark
     * @return remark集合
     */
    public List<Remark> selectRemarkList(Remark remark);

    /**
     * 新增remark
     *
     * @param remark remark
     * @return 结果
     */
    public int insertRemark(Remark remark);

    /**
     * 修改remark
     *
     * @param remark remark
     * @return 结果
     */
    public int updateRemark(Remark remark);

    /**
     * 批量删除remark
     *
     * @param ids 需要删除的remark主键集合
     * @return 结果
     */
    public int deleteRemarkByIds(Long[] ids);

    /**
     * 删除remark信息
     *
     * @param id remark主键
     * @return 结果
     */
    public int deleteRemarkById(Long id);
}
