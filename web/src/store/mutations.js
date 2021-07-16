/**
 * 提交 mutations是更改Vuex状态的唯一合法方法
export const modifyAName = (state, name) => { // name为附带参数由actions传入
    state.resturantName = name // 把方法传递过来的参数，赋值给state中的resturantName
}
 */

export const updateUserBaseData = (state, obj) => {
    state.baseData = obj
}
export const updateIsLogin = (state, obj) => {
    state.isLogin = obj
}
export const updateIsClose = (state, obj) => {
    state.isClose = obj
}