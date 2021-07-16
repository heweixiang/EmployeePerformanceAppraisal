import http from '../utils/http'

export default {

    /**
     * @param {string} query 模糊查询,默认为空
     * @param {int} page 
     * @param {int} limit 
     * @returns 获取用户列表
     */
    getUserList(data) {
        return http.post(`/advancedPermissions/getUserList`, {
            query: data.query,
            page: data.page,
            limit: data.limit
        })
    },
    /**
     * @param {int} id 用户ID
     * @param {string} name 用户姓名
     * @param {string} email 用户邮箱
     * @param {string} phone 用户电话
     * @param {int} sex 性别
     * @param {int} did 部门ID
     * @param {int} jurisdiction 权限
     * @returns 设置用户数据
     */
    setUserItem(user) {
        console.log(user);
        return http.post(`/advancedPermissions/setUserItem`, {
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            sex: user.sex,
            did: user.did,
            jurisdiction: user.jurisdiction
        })
    },
    /**
     * @param {string} username 用户名
     * @param {string} name 姓名
     * @param {int} sex 性别
     * @param {int} did 部门ID    admin可传
     * @param {int} jurisdiction 权限     admin可传9
     * @returns 新增用户
     */
    addUserItem(user) {
        return http.post(`/advancedPermissions/addUserItem`, {
            username: user.username,
            name: user.name,
            sex: user.sex,
            did: user.did,
            jurisdiction: user.jurisdiction
        })
    },
    /**
     * @param {int} id 用户ID
     * @returns 删除用户
     */
    delUserItem(id) {
        return http.post(`/advancedPermissions/delUserItem`, {
            id
        })
    },
    /**
     * @param {int} id 用户ID
     * @returns 冻结用户
     */
    freezeUser(id) {
        return http.post(`/advancedPermissions/freezeUser`, {
            id: id,
        })
    },
    /**
     * @param {int} id 用户ID
     * @returns 解除冻结
     */
    relieveFreeze(id) {
        return http.post(`/advancedPermissions/relieveFreeze`, {
            id: id,
        })
    },
    /**
     * @param {int} id 用户ID
     * @returns 重置用户密码
     */
    REUserPassword(id) {
        return http.post(`/advancedPermissions/REUserPassword`, {
            id: id,
        })
    },
    /**
     * @param {int} id 表单id
     * @param {int} eid 员工id
     * @param {string} idea 分配备注
     * @returns 分配工单给员工
     */
    checkWorkOrderItem(work) {
        return http.post(`/advancedPermissions/checkWorkOrderItem`, {
            id: work.id,
            eid: work.eid,
            idea: work.idea
        })
    },
    /**
     * @returns 获取表格数据
     */
    getChartData() {
        return http.post(`/advancedPermissions/getChartData`)
    },
    /**
     * @returns 获取Excel表格
     */
    getExcel() {
        return http.post(`/advancedPermissions/getExcel`)
    },
    /**
     * @param {string} name 部门名称
     * @returns 新增部门
     */
    addDepartment(name) {
        return http.post(`/advancedPermissions/addDepartment`, {
            name
        })
    },
    /**
     * @param {int} id 部门ID
     * @param {string} name 部门名称
     * @returns 修改部门名称
     */
    modifyDepartment(id, name) {
        return http.post(`/advancedPermissions/modifyDepartment`, {
            id,
            name
        })
    },
    /**
     * @param {int} id 部门ID
     * @returns 删除部门
     */
    delDepartment(id) {
        return http.post(`/advancedPermissions/delDepartment`, {
            id
        })
    },
}