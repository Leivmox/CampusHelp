package com.yqn.mapper;

import com.yqn.pojo.Remark;
import java.util.List;

/**
 * remarkMapper接口
 *
 * @author Leivmox
 * @date 2025-12-16
 */
public interface RemarkMapper
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
     * 删除remark
     *
     * @param id remark主键
     * @return 结果
     */
    public int deleteRemarkById(Long id);

    /**
     * 批量删除remark
     *
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteRemarkByIds(Long[] ids);
}
