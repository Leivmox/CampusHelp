import axios from "axios"
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'

var instance = axios.create({
    baseURL: 'http://localhost:8080',
    headers: {
        'Content-Type': 'application/json;charset=utf-8'
    },
    timeout: 20000
});

instance.interceptors.request.use(function (config) {
    if (!config.silent) {
        NProgress.start();
    }
    return config;
}, function (error) {
    NProgress.done();
    return Promise.reject(error);
});

instance.interceptors.response.use(function (response) {
    NProgress.done();
    return response;
}, function (error) {
    NProgress.done();
    return Promise.reject(error);
});

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
    if (!config.silent) {
        NProgress.start();
    }
    return config;
}, function (error) {
    NProgress.done();
    return Promise.reject(error);
});

let get = function (url, params, silent = false) {
    return instance.get(url, { params, silent });
}

let post = function (url, params, silent = false) {
    return instance.post(url, params, { silent });
}

let put = function (url, params, silent = false) {
    return instance.put(url, params, { silent });
}

let del = function (url, params, silent = false) {
    return instance.delete(url, { params, silent });
}

export {
    get, put, del, post
}

export default service
