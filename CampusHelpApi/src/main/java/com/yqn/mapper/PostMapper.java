package com.yqn.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yqn.pojo.Post;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface PostMapper extends BaseMapper<Post> {

    /**
     * 自定义查询：获取帖子列表，同时关联查询当前用户的点赞状态
     * 对应 PostMapper.xml 中的 <select id="selectPostListWithLike">
     * * @param schoolId 学校ID
     * @param userId   当前查看的用户ID
     * @return 帖子列表
     */
    List<Post> selectPostListWithLike(@Param("schoolId") Long schoolId, @Param("userId") Long userId);

}
