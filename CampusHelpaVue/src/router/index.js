import Vue from "vue";
import VueRouter from "vue-router";

Vue.use(VueRouter);

const routes = [
  {
    path: "*",
    component: () => import("@v/Error.vue"),
  },

  // 用户登录
  {
    path: "/",
    redirect: "/login",
  },
  {
    path: "/login",
    component: () => import("@v/user/Login.vue"),
  },

  // 用户主页
  {
    path: "/home",
    component: () => import("@v/user/Home.vue"),
    children: [
      {
        path: "/",
        meta: { title: "首页" },
        component: () => import("@v/user/children/Index.vue"),
      },

      // --- 校园圈子 ---
      {
        path: "forum",
        component: () => import("@v/user/children/ForumCenter.vue"),
        meta: { title: "校园圈子" },
        redirect: "/home/forum/list",
        children: [
          {
            path: "list",
            name: "ForumList",
            meta: { title: "校园论坛" },
            component: () => import("@v/user/children/Forum.vue"),
          },
          {
            path: "mycomment",
            name: "MyComment",
            meta: { title: "我的评论" },
            component: () => import("@v/user/children/MyComment.vue"),
          },
        ],
      },

      // --- 求助中心 (HelpCenter) ---
      {
        path: "help",
        // 这里的 component 就是上面的 HelpCenter.vue
        component: () => import("@v/user/children/HelpCenter.vue"),
        meta: { title: "求助中心" },
        // 默认重定向到 '发布求助' 页面，防止进来是空白
        redirect: "/home/help/task",
        children: [
          {
            // 完整路径: /home/help/task
            path: "task",
            name: "PublishTask",
            meta: { title: "发布求助" },
            component: () => import("@v/user/children/Task.vue"),
          },
          {
            // 完整路径: /home/help/accept
            path: "accept",
            name: "AcceptTask",
            meta: { title: "接受求助" },
            component: () => import("@v/user/children/Accept.vue"),
          },
          {
            // 完整路径: /home/help/published
            path: "published",
            name: "MyPublished",
            meta: { title: "已发布求助" },
            component: () => import("@v/user/children/Published.vue"),
          },
          {
            // 完整路径: /home/help/accepted
            path: "accepted",
            name: "MyAccepted",
            meta: { title: "已接收求助" },
            component: () => import("@v/user/children/Accepted.vue"),
          },
        ],
      },
      {
        path: "ai", // 路径 /home/help/ai
        name: "AiHelp",
        meta: { title: "智能助手" },
        component: () => import("@v/user/children/AiHelp.vue"),
      },
      // --- 评价中心 ---
      {
        path: "remark",
        component: () => import("@v/user/children/RemarkCenter.vue"),
        meta: { title: "评价中心" },
        redirect: "/home/remark/myremark",
        children: [
          {
            path: "myremark",
            name: "myremark",
            meta: { title: "我的评价" },
            component: () => import("@v/remark/myremark.vue"),
          },
          {
            path: "userremark",
            name: "userremark",
            meta: { title: "评价我的" },
            component: () => import("@v/remark/userremark.vue"),
          },
        ],
      },

      // 其他路由
      {
        path: "noticeu",
        meta: { title: "查看公告" },
        component: () => import("@v/notice/adviseuser.vue"),
      },
      {
        path: "myProfile",
        meta: { title: "个人信息" },
        component: () => import("@v/user/children/MyProfile.vue"),
      },
    ],
  },

  // 管理员
  {
    path: "/admin",
    component: () => import("@v/admin/Login.vue"),
  },
  {
    path: "/admin/home",
    component: () => import("@v/admin/Home.vue"),
    children: [
      {
        path: "/",
        meta: { title: "首页" },
        component: () => import("@v/admin/children/Index.vue"),
      },
      {
        name: "adminSchool",
        path: "school",
        meta: { title: "学校信息" },
        component: () => import("@v/admin/children/School.vue"),
      },
      {
        name: "adminStudent",
        path: "student",
        meta: { title: "用户信息" },
        component: () => import("@v/admin/children/Student.vue"),
      },
      {
        name: "adminPost",
        path: "Post",
        meta: { title: "论坛管理" },
        component: () => import("@v/admin/children/Post.vue"),
      },
      {
        name: "task",
        path: "task",
        meta: { title: "求助信息" },
        component: () => import("@v/admin/children/Task.vue"),
      },
      {
        name: "notice",
        path: "notice",
        meta: { title: "公告管理" },
        component: () => import("@v/notice/advise.vue"),
      },
      {
        name: "remark",
        path: "remark",
        meta: { title: "评价信息" },
        component: () => import("@v/remark/remark.vue"),
      },
    ],
  },
];

const router = new VueRouter({
  routes,
});

export default router;
