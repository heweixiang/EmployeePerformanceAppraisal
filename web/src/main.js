import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import "ant-design-vue/dist/antd.css";
import Antd from "ant-design-vue/es"
import ChangeRem from "./utils/rem"
import login from './api/login'
import generalAuthority from './api/generalAuthority'
import advancedPermission from './api/advancedPermission';
import comprehensiveAuthority from './api/comprehensiveAuthority';

Vue.prototype.$api = { login, generalAuthority, advancedPermission, comprehensiveAuthority }

Vue.use(Antd)
Vue.config.ChangeRem = ChangeRem

Vue.config.productionTip = false;

new Vue({
    router,
    store,
    render: (h) => h(App),
}).$mount("#app");