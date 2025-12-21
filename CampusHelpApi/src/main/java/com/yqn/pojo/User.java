package com.yqn.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.ToString;
import java.util.Date;

@ToString
@Data
@TableName(resultMap = "userResultMap")
public class User {

    // 1. 头像字段只要普通的声明即可，不要加 @TableId
    /** 用户头像 */
    private String avatar;

    // 2. 主键注解必须紧贴着 id 字段！
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private String studentId;
    private String password;
    private String phone;
    private Long schoolId;
    private Long deptId;
    private Long classId;
    private Integer sex;
    private String username;
    private Date createTime;
    private Double balance;
    private Integer state;
    /** 个人简介 (新增) */
    private String signature;

    /** 电子邮箱 (新增) */
    private String email;

    @TableField(exist = false)
    private School school;
    @TableField(exist = false)
    private Dept dept;
    @TableField(exist = false)
    private Class aClass;
}
