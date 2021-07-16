 //和计算属性一样   store.getters.属性名称  调用
 // getters可以使用其它getters

 /**
  * getTodoById: (state) => (id) => {
  * return state.todos.find(todo => todo.id === id)
  * }
  * 
  * store.getters.getTodoById(2)  可以传参
  */
 export const baseData = state => state.baseData
 export const isLogin = state => state.isLogin
 export const isClose = state => state.isClose