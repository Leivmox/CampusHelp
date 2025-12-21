// 注意这里：改成了 '@/util/request' (单数)
import request from '@/util/request'

// 修改用户头像
export function updateUserAvatar(data) {
  return request({
    url: '/user/updateAvatar',
    method: 'post',
    data: data
  })
}