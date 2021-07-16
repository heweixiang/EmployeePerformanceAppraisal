import http from '../utils/http'

export default {

    /**
     * 
     * @param {string} username 用户名
     * @param {string} password 密码
     * @param {string} code 验证码
     * @param {string} token 请求验证码时发配的token
     * @returns 用户登陆
     */
    login(user) {
        return http.post(`/login/login`, {
            username: user.username,
            password: user.password,
            code: user.code,
            codeToken: user.codeToken
        })
    },
    /**
     * 
     * @param {string} username 用户名/登陆名
     * @param {string} name 姓名
     * @param {string} password 密码
     * @param {string} sex 密码
     * @param {string} code 验证码
     * @param {string} token 验证码token
     * @returns 用户注册
     */
    registerUser(user) {
        return http.post(`/login/registerUser`, {
            username: user.username,
            name: user.name,
            password: user.password,
            sex: user.sex,
            code: user.code,
            codeToken: user.codeToken,
        })
    },

    /**
     * 
     * @returns 获取验证码
     */
    getVerificationCode() {
        return http.post(`/login/getVerificationCode`)
    },

}