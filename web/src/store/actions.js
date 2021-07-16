/**
 * 注册事件处理函数,将状态提交给mutations
 * export function modifyBName({commit}, name) {// commit提交 name为附带参数 一般name为变量或obj
    return commit ('modifyBName', name)
}
 */
/**
 * 
 * @param {*} param0 
 * @param {*} obj 
 * @returns 设置用户基础数据
 */
export function updateUserBaseData({ commit }, obj) {
    return commit('updateUserBaseData', obj)
}

export function updateIsLogin({ commit }, obj) {
    return commit('updateIsLogin', obj)
}
export function updateIsClose({ commit }, obj) {
    return commit('updateIsClose', obj)
}