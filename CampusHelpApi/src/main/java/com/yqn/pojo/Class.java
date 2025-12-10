package com.yqn.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.ToString;

import java.util.List;

/**
 * @author Leivmox
 */
@ToString
@Data
@TableName("class")
public class Class {
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @TableField("name")
    private String name;

    // 修改为基本类型int
    @TableField("school_id")
    private int schoolId;  // 之前是Integer

    @TableField("dept_id")
    private int deptId;    // 之前是Integer
}
