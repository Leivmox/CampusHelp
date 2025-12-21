// 工具包
import axios from "axios"
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'

// ❌ 移除或不再主要使用 Qs，因为我们要发 JSON
// const Qs = require("querystring"); 

/**
 * instance封装axios
 */
var instance = axios.create({
    // 本地測試
    baseURL: 'http://localhost:8080',
    // 🟢 新增：默认头信息，明确告诉后端我们要发JSON
    headers: {
        'Content-Type': 'application/json;charset=utf-8'
    },
    // 超时时间
    timeout: 20000
});

// 添加请求拦截器
instance.interceptors.request.use(function (config) {
    NProgress.start(); //开启
    // 在发送请求之前做些什么
    return config;
}, function (error) {
    NProgress.done(); //关闭
    // 对请求错误做些什么
    return Promise.reject(error);
});

// 添加响应拦截器
instance.interceptors.response.use(function (response) {
    NProgress.done(); //关闭
    // 对响应数据做点什么
    return response;
}, function (error) {
    NProgress.done(); //关闭
    // 对响应错误做点什么
    return Promise.reject(error);
});

/**
 * service封装axios (这一块你原来代码里保留了，我也保留，虽然看起来和instance重复了)
 */
var service = axios.create({
    baseURL: 'http://localhost:8080',
    timeout: 20000
});

service.interceptors.response.use(function (response) {
    NProgress.done();
    return response;
}, function (error) {
    NProgress.done();
    return Promise.reject(error);
});

service.interceptors.request.use(function (config) {
    NProgress.start();
    return config;
}, function (error) {
    NProgress.done();
    return Promise.reject(error);
});


// ==========================================
// 🟢 核心修改区域：GET, POST, PUT, DELETE
// ==========================================

let get = function (url, params) {
    return instance.get(url, { params });
}

let post = function (url, params) {
    // 🟢 修改：直接传 params 对象，Axios 会自动将其序列化为 JSON
    // 不要用 Qs.stringify(params)，那是转 Form 表单用的
    return instance.post(url, params);
}

let put = function (url, params) {
    // 🟢 修改：同上，PUT 请求也改为发送 JSON
    return instance.put(url, params);
}

let del = function (url, params) {
    return instance.delete(url, { params });
}

// 导出get和post方法
export {
    get, put, del, post
}

export default service