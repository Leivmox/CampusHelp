import request from '@/util/request'

// 查询“我发布的”求助
export function listPublished(userId) {
  return request({
    url: '/task/published',
    method: 'get',
    params: { id: userId }
  })
}

// 查询“我解决的”求助
export function listAccepted(userId) {
  return request({
    url: '/task/accepted',
    method: 'get',
    params: { id: userId }
  })
}