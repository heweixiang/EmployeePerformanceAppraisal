<template>
  <div>
    <router-view v-if="this.isLogin"></router-view>
    <a-layout
      id="components-layout-demo-side"
      style="min-height: 100vh"
      v-if="!this.isLogin"
    >
      <Nav v-if="isShowSelect"></Nav>
      <slot></slot>
      <a-layout>
        <a-layout-header style="background: #fff; padding: 0">
          <!-- 检测到手机端显示该按钮,点击显示侧边栏 -->
          <a-row>
            <a-col :span="12"
              ><a-icon
                style="margin-left: 20px"
                :type="isShowSelect ? 'menu-unfold' : 'menu-fold'"
                @click="() => (isShowSelect = !isShowSelect)"
            /></a-col>
            <a-col :span="12">
              <span style="float: right; margin-right: 1rem; color: blue">
                {{ this.name }}
              </span>
              <span style="float: right; margin-right: 1rem"
                ><a-dropdown>
                  <a class="ant-dropdown-link">
                    更多功能 <a-icon type="down" />
                  </a>
                  <a-menu slot="overlay">
                    <a-menu-item>
                      <a @click="modifyInformation">修改资料</a>
                    </a-menu-item>
                    <a-menu-item>
                      <a
                        @click="
                          visible.modifyPassword = true;
                          getcode();
                        "
                        >修改密码</a
                      >
                    </a-menu-item>
                    <a-menu-item>
                      <a @click="loginOut">退出登录</a>
                    </a-menu-item>
                    <!-- <a-menu-item>
                      <a @click="bindEmail">绑定邮箱</a>
                    </a-menu-item>
                    <a-menu-item>
                      <a @click="bindPhone">绑定电话</a>
                    </a-menu-item> -->
                  </a-menu>
                </a-dropdown></span
              >
            </a-col>
          </a-row>

          <!-- 标题内容一般放入头像退出登录等按钮 打算直接在本页面开发基础功能-->
        </a-layout-header>
        <a-layout-content style="margin: 0 16px">
          <a-breadcrumb style="margin: 16px 0">
            <!-- 面包屑,功能保留 该功能实现方式是同步vueX中的面包屑数据 
            
            权限 0 admin  1 user  2 manager  3 employee  -1 账号冻结-->
            <a-breadcrumb-item v-if="this.jurisdiction == 0"
              >Admin</a-breadcrumb-item
            >
            <a-breadcrumb-item v-if="this.jurisdiction == 1"
              >User</a-breadcrumb-item
            >
            <a-breadcrumb-item v-if="this.jurisdiction == 2"
              >Manager</a-breadcrumb-item
            >
            <a-breadcrumb-item v-if="this.jurisdiction == 3"
              >Employee</a-breadcrumb-item
            >

            <a-breadcrumb-item>
              {{ this.$router.app._route.fullPath.substr(1) }}
            </a-breadcrumb-item>
          </a-breadcrumb>
          <div
            :style="{
              padding: '24px',
              background: '#fff',
              minHeight: '360px',
            }"
          >
            <!-- 此处放入页面  直接导入页面即可 -->
            <router-view></router-view>
          </div>
        </a-layout-content>
        <a-layout-footer style="text-align: center">
          <!-- 底部内容几乎无意义 -->
          绩效考核 @&nbsp;0.1.0.0.041721_bate
        </a-layout-footer>
      </a-layout>
    </a-layout>
    <!-- 修改密码弹窗 -->
    <a-modal v-model="visible.modifyPassword" title="修改密码">
      <!-- <a-input
        style="margin-bottom: 15px"
        placeholder="用户名"
        v-model="username"
        disabled
      /> -->
      <a-input placeholder="请输入旧密码" v-model="password" />
      <a-input placeholder="请输入新密码" v-model="newPassword" />
      <a-input placeholder="确认新密码" v-model="reNewPassword" />
      <a-row :gutter="8">
        <a-col :span="12">
          <a-input v-model="code" placeholder="captcha" />
        </a-col>
        <!-- 验证码图片渲染 将svg图片直接渲染-->
        <a-col
          :span="12"
          v-html="codeSvg"
          @click="getcode()"
          id="codeBox"
        ></a-col>
      </a-row>
      <template slot="footer">
        <a-button
          key="back"
          @click="
            visible.modifyPassword = false;
            codeSvg = '';
          "
          >取消</a-button
        >
        <a-button
          key="confirm"
          @click="
            modifyPassword();
            visible.modifyPassword = false;
          "
          >确认修改</a-button
        >
      </template>
    </a-modal>
  </div>
</template>

<script>
import Nav from "./components/Nav";
import { mapActions, mapGetters } from "vuex";

export default {
  components: {
    Nav,
  }, // 计算属性导入store
  computed: { ...mapGetters(["baseData", "isLogin"]) },
  data() {
    return {
      name: "",
      isShowSelect: true,
      visible: { modifyPassword: false },
      username: "",
      password: "",
      codeSvg: "",
      code: "",
      codeToken: "",
      newPassword: "",
      reNewPassword: "",
      jurisdiction: -1,
    };
  },
  created() {
    document.body.clientWidth < 690
      ? (this.isShowSelect = false)
      : (this.isShowSelect = true);
    this.name = this.baseData.name;
    this.jurisdiction = this.baseData.jurisdiction;
    this.username = this.baseData.username;
    this.updateUserBaseData(JSON.parse(localStorage.getItem("state")));
    this.updateIsLogin(JSON.parse(localStorage.getItem("isLogin")));
    // console.log(this.baseData);
  },
  mounted() {
    window.addEventListener("unload", this.saveState);
  },
  methods: {
    ...mapActions(["updateUserBaseData", "updateIsLogin"]),
    saveState() {
      localStorage.setItem("state", JSON.stringify(this.baseData));
      localStorage.setItem("isLogin", JSON.stringify(this.isLogin));
    },
    //获取验证码对接
    getcode() {
      this.$api.login
        .getVerificationCode()
        .then((res) => {
          this.codeSvg = res.data.svg;
          this.codeToken = res.data.Key;
        })
        .catch((err) => {
          this.$message.error(`验证码获取失败:${err}`);
        });
    },
    selectRightButton(a) {
      console.log(a);
    },
    modifyInformation() {
      console.log("修改资料");
    },
    modifyPassword() {
      console.log("修改密码");
      this.visible.modifyPassword = false;
      // 修改密码
      this.$api.comprehensiveAuthority
        .modificationPassword({
          password: this.password,
          newPassword: this.newPassword,
          code: this.code,
          codeToken: this.codeToken,
        })
        .then((res) => {
          if (res.status == 1) {
            this.$message.success("修改成功!");
            this.$router.push("/login");
          } else {
            this.$message.error(`${res.msg}`);
          }
        })
        .catch((err) => {
          this.$message.error(`error:${err}`);
        });
    },
    bindEmail() {
      console.log("绑定邮箱");
    },
    bindPhone() {
      console.log("绑定电话");
    },
    loginOut() {
      localStorage.removeItem("token");
      this.$router.push("/login");
      this.$message.success("退出登录成功!");
    },
  },
};
</script>

<style lang="less" scoped>
#components-layout-demo-side .logo {
  height: 32px;
  background: rgba(255, 255, 255, 0.2);
  margin: 16px;
}
input {
  margin-bottom: 15px;
}
</style>