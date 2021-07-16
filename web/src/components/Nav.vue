<template>
  <div class="left_bg_color">
    <a-layout-sider v-model="collapsed" collapsible>
      <div class="logo">绩效考核系统</div>
      <a-menu
        theme="dark"
        :defaultSelectedKeys="[`${selectRouter}`]"
        :open-keys.sync="openKeys"
        mode="inline"
      >
        <a-menu-item key="order" @click="selectNav">
          <a-icon type="table" />
          <span>工单列表</span>
        </a-menu-item>
        <!-- <a-menu-item key="orderItem" @click="selectNav">
          <a-icon type="form" />
          <span>查看/修改工单</span>
        </a-menu-item> -->
        <!-- 用户管理需要判断一下vuex中状态是否为主管或者admin -->
        <a-menu-item
          key="userList"
          @click="selectNav"
          v-if="
            this.baseData.jurisdiction == 0 || this.baseData.jurisdiction == 2
          "
        >
          <a-icon type="team" />
          <!-- 用户内容内容管理使用弹窗 -->
          <span>用户管理</span>
        </a-menu-item>
        <a-menu-item
          key="department"
          @click="selectNav"
          v-if="this.baseData.jurisdiction == 0"
        >
          <a-icon type="team" />
          <!-- 用户内容内容管理使用弹窗 -->
          <span>部门管理</span>
        </a-menu-item>
        <a-menu-item
          key="chart"
          @click="selectNav"
          v-if="
            this.baseData.jurisdiction == 0 || this.baseData.jurisdiction == 2
          "
        >
          <a-icon type="bar-chart" />
          <span>图表页</span>
        </a-menu-item>
      </a-menu>
    </a-layout-sider>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";

export default {
  data() {
    return {
      // 调整侧边栏数据
      collapsed: false,
      collapsible: true,
      isHiddenSelect: "hidden",
      // 当前选中的路由名称
      selectRouter: "order",
      openKeys: ["order"],
    };
  },
  computed: { ...mapGetters(["baseData"]) },
  created() {
    // 导航中暂时解决不了的暂时放这里写死首次检查
    // 设置selectRouter根据路由来跳转
    this.selectRouter = this.$route.name;
    if (this.selectRouter == null) {
      // 为了解决routename刷新后为空问题
      this.selectRouter = localStorage.getItem("router");
      if (this.selectRouter == null) {
        this.selectRouter = "order";
      }
    }
  },
  watch: {
    $route: {
      handler: function (val, oldVal) {
        console.log(oldVal);
        // val变动前   oldVal变动后
        if (val.name == "login") {
          //路由跳转到login
          this.updateIsLogin(true);
        } else {
          //  路由不在login
          this.updateIsLogin(false);
        }
      },
      // 深度观察监听
      deep: true,
    },
  },
  methods: {
    ...mapActions(["updateIsLogin"]),
    selectNav(obj) {
      //路由跳页处理
      if (obj.key != this.selectRouter) {
        // 可以跳页
        this.selectRouter = obj.key;
        localStorage.setItem("router", obj.key);
        this.$router.push(`${this.selectRouter}`);
      } else {
        console.log("重复点击");
      }
    },
  },
};
</script>

<style lang="less" scoped>
// 背景
.left_bg_color {
  background: #001529;
}
// 内容
#components-layout-demo-side .logo {
  height: 32px;
  color: #fff;
  text-align: center;
  line-height: 32px;
  font-size: 16px;
  background: rgba(255, 255, 255, 0.2);
  margin: 16px;
}
</style>