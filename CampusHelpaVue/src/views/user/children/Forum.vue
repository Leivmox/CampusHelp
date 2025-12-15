<template>
  <div class="forum">
    <el-card class="forum-header">
      <el-input placeholder="发帖标题" v-model="newPost.title"></el-input>
      <el-input type="textarea" placeholder="发帖内容" v-model="newPost.content"></el-input>
      <el-button type="primary" @click="submitPost">发布</el-button>
    </el-card>

    <el-card class="forum-list" v-for="post in posts" :key="post.id" style="margin-top: 20px">
      <div class="post-header">
        <span>{{post.title}}</span>
        <span style="float:right">{{post.user.username}} | {{post.createTime | formatDate}}</span>
      </div>
      <div class="post-content">{{post.content}}</div>

      <div class="post-actions">
        <el-button type="text" @click="likePost(post.id)">👍 {{post.likeCount}}</el-button>
        <el-button type="text" @click="toggleComments(post.id)">
          评论 {{post.comments.length}}
        </el-button>
      </div>

      <div v-show="post.showComments" class="comments">
        <div v-for="comment in post.comments" :key="comment.id">
          <span>{{comment.user.username}}:</span> {{comment.content}}
        </div>
        <el-input placeholder="回复..." v-model="post.newComment" size="small"></el-input>
        <el-button type="text" size="small" @click="submitComment(post.id, post.newComment)">回复</el-button>
      </div>
    </el-card>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { formatDate } from "@/util/date";

export default {
  data() {
    return {
      posts: [],
      newPost: {
        title: '',
        content: ''
      }
    };
  },
  computed: {
    ...mapState('user', ['user'])
  },
  created() {
    this.fetchPosts();
  },
  methods: {
    fetchPosts() {
      this.$get('/forum').then(res => {
        this.posts = res.data.posts.map(p => ({...p, showComments: false, newComment: ''}));
      });
    },
    submitPost() {
      if(!this.newPost.title || !this.newPost.content){
        this.$msg('请输入标题和内容', 'error');
        return;
      }
      this.$post('/forum', {...this.newPost, userId: this.user.id}).then(() => {
        this.$msg('发布成功', 'success');
        this.newPost.title = '';
        this.newPost.content = '';
        this.fetchPosts();
      });
    },
    toggleComments(postId) {
      const post = this.posts.find(p => p.id === postId);
      post.showComments = !post.showComments;
    },
    submitComment(postId, content) {
      if(!content) return;
      this.$post(`/forum/comment`, {postId, userId: this.user.id, content}).then(() => {
        this.fetchPosts();
      });
    },
    likePost(postId) {
      this.$put(`/forum/like/${postId}`, {userId: this.user.id}).then(() => {
        this.fetchPosts();
      });
    }
  },
  filters: {
    formatDate(time) {
      return formatDate(new Date(time), 'yyyy-MM-dd hh:mm');
    }
  }
};
</script>

<style scoped>
.forum-header { margin-bottom: 20px; padding: 10px; }
.post-header { font-weight: bold; display: flex; justify-content: space-between; }
.post-actions { margin-top: 10px; }
.comments { margin-top: 10px; border-top: 1px solid #ebeef5; padding-top: 10px; }
</style>
