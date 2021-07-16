import Vue from "vue";
import Vuex from "vuex";
import * as getters from './getters';
import * as actions from './actions'
import * as mutations from './mutations';


Vue.use(Vuex);


const state = {
    baseData: {},
    isLogin: true,
    // 表单弹窗是否关闭,默认为关闭,弹窗为false如果需要关闭回调再为true,监听isClose即可
    isClose: true,
}

export default new Vuex.Store({
    state, //存放公共数据全局数据
    mutations,
    // mutations: {
    //使用功能函数操作state中的内容
    // this.$store.commit('increment')
    // increment(state,payload) {//此处可以提交第二参数  this.$store.commit('increment',obj)  荷载参数可以是变量或者obj
    //     state.count++
    // }
    // },
    actions, //数据的异步操作
    modules: {},
    getters,
    //和计算属性一样   store.getters.属性名称  调用
    // getters可以使用其它getters

    /**
     * getTodoById: (state) => (id) => {
     * return state.todos.find(todo => todo.id === id)
     * }
     * 
     * store.getters.getTodoById(2)  可以传参
     */

});


/**使用语法糖
 *  methods:{
      ...mapActions( // 语法糖
          ['modifyAName'] // 相当于this.$store.dispatch('modifyName'),提交这个方法
      ),
      trunToB () {
          this.$router.push({path: '/componentsB'}) // 路由跳转到B
      }
  },
  computed: {
      ...mapGetters(['resturantName']) // 动态计算属性，相当于this.$store.getters.resturantName
  }
 */