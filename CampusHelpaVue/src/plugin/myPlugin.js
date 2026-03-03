import {del, get, post, put} from "../util/request";

export default {
    install: function (Vue) {
        Vue.mixin({
            methods: {
                $get(url, params, silent = false) {
                    return get(url, params, silent);
                },
                $post(url, params, silent = false) {
                    return post(url, params, silent);
                },
                $put(url, params, silent = false) {
                    return put(url, params, silent);
                },
                $del(url, params, silent = false) {
                    return del(url, params, silent);
                },
                $msg(message, type, duration = 2000) {
                    this.$message({
                        message: message,
                        type: type,
                        duration: duration,
                        showClose: true
                    });
                },
                $notifyMsg(title, message, type, duration = 2500) {
                    this.$notify({
                        title: title,
                        message: message,
                        type: type,
                        duration: duration
                    })
                }
            }
        })
    }
}
