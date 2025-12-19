import Vue from "vue";
import VueRouter from "vue-router";

Vue.use(VueRouter);

const routes = [
  {
    path: "*",
    component: () => import("@v/Error.vue"),
  },

  //用户登录
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
      // {
      //     path: "forum",
      //     meta: { title: "校园圈子" },
      //     component: () => import('@v/user/children/Forum.vue')
      // },
      // --- 修改：校园圈子 (整合了论坛和我的评论) ---
      {
        path: "forum",
        // 指向刚才新建的容器组件
        component: () => import("@v/user/children/ForumCenter.vue"),
        meta: { title: "校园圈子" },
        redirect: "/home/forum/list", // 默认显示论坛列表
        children: [
          {
            path: "list", // 注意：这里改名叫 list，避免和父路由冲突
            name: "ForumList",
            meta: { title: "校园论坛" },
            component: () => import("@v/user/children/Forum.vue"), // 原来的 Forum.vue
          },
          {
            path: "mycomment",
            name: "MyComment",
            meta: { title: "我的评论" },
            component: () => import("@v/user/children/MyComment.vue"), // 原来的 MyComment.vue
          },
        ],
      },

      // --- 新增：求助中心 (嵌套路由) ---
      {
        path: "help",
        // 这是一个容器组件(HelpCenter.vue)，包含顶部的红框导航按钮和 <router-view>
        // 请确保你已经创建了这个文件，路径要对应
        component: () => import("@v/user/children/HelpCenter.vue"),
        meta: { title: "求助中心" },
        redirect: "/home/help/task", // 默认打开“发布求助”
        children: [
          {
            path: "task",
            name: "PublishTask",
            meta: { title: "发布求助" },
            component: () => import("@v/user/children/Task.vue"),
          },
          {
            path: "accept",
            name: "AcceptTask",
            meta: { title: "接受求助" },
            component: () => import("@v/user/children/Accept.vue"),
          },
          {
            path: "published",
            name: "MyPublished",
            meta: { title: "已发布求助" },
            component: () => import("@v/user/children/Published.vue"),
          },
          {
            path: "accepted",
            name: "MyAccepted",
            meta: { title: "已接收求助" },
            component: () => import("@v/user/children/Accepted.vue"),
          },
        ],
      },

      // --- 新增：评价中心 (嵌套路由) ---
      {
        path: "remark",
        // 这是一个容器组件(RemarkCenter.vue)，类似 HelpCenter
        component: () => import("@v/user/children/RemarkCenter.vue"),
        meta: { title: "评价中心" },
        redirect: "/home/remark/myremark", // 默认打开“我的评价”
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

      // 其他保持不变
      {
        path: "noticeu",
        meta: { title: "查看公告" },
        component: () => import("@v/notice/adviseuser.vue"),
      },
    //   {
    //     path: "mycomment",
    //     name: "mycomment",
    //     meta: { title: "我的评论" },
    //     component: () => import("@v/user/children/MyComment.vue"),
    //   },
      {
        path: "myProfile",
        meta: { title: "个人信息" },
        component: () => import("@v/user/children/MyProfile.vue"),
      },
    ],
  },

  //管理员
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
