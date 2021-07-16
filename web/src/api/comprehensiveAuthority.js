import http from '../utils/http'

export default {

    /**
     * @param {string} password 旧密码
     * @param {string} newPassword 新密码
     * @param {string} code 验证码
     * @param {string} codeToken 验证码token
     * @returns 修改密码
     */
    modificationPassword(data) {
        return http.post(`/comprehensiveAuthority/modificationPassword`, {
            password: data.password,
            newPassword: data.newPassword,
            code: data.code,
            codeToken: data.codeToken
        })
    },
    /**
     * @param {int} id 用户id
     * @returns 根据id获取用户卡片
     */
    getEmployeeCard(id) {
        return http.post(`/comprehensiveAuthority/getEmployeeCard`, {
            id
        })
    },
    /**
     * @returns 获取部门列表
     */
    getDepartmentList() {
        return http.post(`/comprehensiveAuthority/getDepartmentList`)
    },
    /**
     * @returns 获取用户个人基础数据
     */
    getUserBaseData() {
        return http.post(`/comprehensiveAuthority/getUserBaseData`)
    },
    /**
     * @param {string} name 姓名
     * @param {string} email 邮箱
     * @param {string} phone 电话
     * @param {int} sex 性别
     * @returns 修改用户基础数据
     */
    setUserBaseData(data) {
        return http.post(`/comprehensiveAuthority/setUserBaseData`, {
            name: data.name,
            email: data.email,
            phone: data.phone,
            sex: data.sex
        })
    },
    /**
     * @param {int} page 页码
     * @param {int} limit 每页行数
     * @param {string} query 查询
     * @returns 获取工单列表
     */
    getWorkOrderList(data) {
        return http.post(`/comprehensiveAuthority/getWorkOrderList`, {
            page: data.page,
            limit: data.limit,
            query: data.query
        })
    },
    /**
     * @param {int} id 工单ID
     * @returns 获取工单内容
     */
    getWorkOrderItem(id) {
        return http.post(`/comprehensiveAuthority/getWorkOrderItem`, {
            id
        })
    },
    /**
     * @param {int} id 工单ID
     * @param {int} start 评分
     * @param {string} content 评价内容
     * @returns 工单评价接口
     */
    scoreWorkOrderItem(data) {
        return http.post(`/comprehensiveAuthority/scoreWorkOrderItem`, {
            id: data.id,
            start: data.start,
            content: data.content
        })
    },

}