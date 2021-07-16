import http from '../utils/http'

export default {

    /**
     * 
     * @param {int} did 部门ID
     * @param {string} intro  工单简介
     * @param {string} content 工单内容
     * @param {string} remarks 工单备注
     * @param {string} urgent 是否加急
     * @param {string} uidea 用户建议
     * @returns 用户发布工单
     */
    createWorkOrderItem(user) {
        return http.post(`/generalAuthority/createWorkOrderItem`, {
            did: user.did,
            intro: user.intro,
            content: user.content,
            remarks: user.remarks,
            urgent: user.urgent,
            uidea: user.uidea
        })
    },

    /**
     * @param {int} id 工单id
     * @param {string} idea 内容
     * 提交工单
     */
    subWorkOrderItem(id, idea) {
        return http.post(`/generalAuthority/subWorkOrderItem`, {
            id,
            idea
        })
    }

}