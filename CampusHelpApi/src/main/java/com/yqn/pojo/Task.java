package com.yqn.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
// 去掉了 import lombok.Data; 避免依赖插件
import java.util.Date;

/**
 * @author Leivmox
 */
@TableName(resultMap = "taskResultMap")
public class Task {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @TableField(value = "publish_user_id")
    private Long publishId;

    @TableField(value = "accept_user_id")
    private Long acceptId;

    @TableField(value = "user_school_id")
    private Long schoolId;

    private Double reward;
    private Date createTime;
    private Date orderTime;
    private Date endTime;
    private String taskTitle;
    private String taskContext;
    private Integer state;

    // ==========================================
    // 关键字段：用来存 Controller 查出来的用户对象
    // ==========================================
    @TableField(exist = false)
    private User publish;

    @TableField(exist = false)
    private User accept;

    @TableField(exist = false)
    private School school;

    // ==========================================
    // 手动添加 Getter 和 Setter 方法
    // (这保证了 task.setPublish() 绝对可用)
    // ==========================================

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getPublishId() {
        return publishId;
    }

    public void setPublishId(Long publishId) {
        this.publishId = publishId;
    }

    public Long getAcceptId() {
        return acceptId;
    }

    public void setAcceptId(Long acceptId) {
        this.acceptId = acceptId;
    }

    public Long getSchoolId() {
        return schoolId;
    }

    public void setSchoolId(Long schoolId) {
        this.schoolId = schoolId;
    }

    public Double getReward() {
        return reward;
    }

    public void setReward(Double reward) {
        this.reward = reward;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getOrderTime() {
        return orderTime;
    }

    public void setOrderTime(Date orderTime) {
        this.orderTime = orderTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public String getTaskTitle() {
        return taskTitle;
    }

    public void setTaskTitle(String taskTitle) {
        this.taskTitle = taskTitle;
    }

    public String getTaskContext() {
        return taskContext;
    }

    public void setTaskContext(String taskContext) {
        this.taskContext = taskContext;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    // === 重点：User 对象的 Getter/Setter ===
    public User getPublish() {
        return publish;
    }

    public void setPublish(User publish) {
        this.publish = publish;
    }

    public User getAccept() {
        return accept;
    }

    public void setAccept(User accept) {
        this.accept = accept;
    }

    public School getSchool() {
        return school;
    }

    public void setSchool(School school) {
        this.school = school;
    }

    @Override
    public String toString() {
        return "Task{" +
                "id=" + id +
                ", publishId=" + publishId +
                ", taskTitle='" + taskTitle + '\'' +
                ", publish=" + publish +
                '}';
    }
}
