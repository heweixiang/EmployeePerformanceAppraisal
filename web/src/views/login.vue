<template>
  <div id="loginFromBox">
    <!-- 响应式布局 登陆页面 -->
    <a-row type="flex" justify="space-around" class="mbbl" align="middle">
      <!-- 兼容手机端 -->
      <a-col :xs="24" :sm="22" :md="20" :lg="18" :xl="18" :xxl="18" :offset="1">
        <a-form ref="form" label-width="80px" :inline="false" size="normal">
          <!-- 用户名模块 -->
          <a-form-item>
            <a-input v-model="username" placeholder="Username">
              <a-icon
                slot="prefix"
                type="user"
                style="color: rgba(0, 0, 0, 0.25)"
              />
            </a-input>
          </a-form-item>
          <!-- 密码模块 -->
          <a-form-item>
            <a-input v-model="password" type="password" placeholder="Password">
              <a-icon
                slot="prefix"
                type="lock"
                style="color: rgba(0, 0, 0, 0.25)"
              />
            </a-input>
          </a-form-item>
          <!-- 验证码框 -->
          <a-form-item>
            <a-row :gutter="8">
              <a-col :span="12">
                <a-input v-model="code" placeholder="captcha" />
              </a-col>
              <!-- 验证码图片渲染 将svg图片直接渲染-->
              <a-col
                :span="12"
                v-html="codeSvg"
                @click="getVerificationCode"
                id="codeBox"
              ></a-col>
            </a-row>
          </a-form-item>
          <!-- 忘记密码和注册账号 -->
          <a-form-item>
            <a-row>
              <a-col :span="8"><a @click="forgotPassword">忘记密码</a></a-col>
              <a-col :span="8" :offset="8"
                ><a @click="register = true">注册账号</a></a-col
              >
            </a-row>
          </a-form-item>
          <!-- 登陆按钮 -->
          <a-form-item size="normal" :span="24">
            <a-row :span="24">
              <a-col :span="24">
                <a-button type="button" style="width: 100%" @click="subLogin"
                  >登入系统
                </a-button>
              </a-col>
            </a-row>
          </a-form-item>
        </a-form>
      </a-col>
      <!-- 注册用户弹窗 -->
      <a-modal v-model="register" title="注册账号">
        <a-input placeholder="用户名" v-model="username" />
        <a-input placeholder="密码" v-model="password" />
        <a-input placeholder="确认密码" v-model="reNewPassword" />
        <a-input placeholder="姓名" v-model="name" />
        <a-select
          default-value="1"
          style="width: 120px; margin-bottom: 0.2rem"
          @change="(value) => (sex = value)"
        >
          <!-- 权限 0 admin  1 user  2 manager  3 employee  -1 账号冻结 -->
          <a-select-option value="1"> 男 </a-select-option>
          <a-select-option value="0"> 女 </a-select-option>
        </a-select>
        <a-row :gutter="8">
          <a-col :span="12">
            <a-input v-model="code" placeholder="captcha" />
          </a-col>
          <!-- 验证码图片渲染 将svg图片直接渲染-->
          <a-col
            :span="12"
            v-html="codeSvg"
            @click="getVerificationCode()"
            id="codeBox"
          ></a-col>
        </a-row>
        <template slot="footer">
          <a-button
            key="back"
            @click="
              register = false;
              codeSvg = '';
            "
            >取消</a-button
          >
          <a-button
            key="confirm"
            @click="
              registerUser();
              register = false;
            "
            >确认删除</a-button
          >
        </template>
      </a-modal>
    </a-row>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
export default {
  data() {
    //用户数据
    return {
      register: false,
      // 用户名/密码
      username: "root",
      password: "A123456!",
      reNewPassword: "",
      name: "",
      sex: 1,
      // 验证码
      code: "",
      // 验证码token
      codeToken: "",
      // 验证码SVG
      codeSvg: "",
    };
  },
  created() {
    // 获取验证码
    this.getVerificationCode();
  },
  watch: {
    // 监听username改变,验证数据,并判定是否提供登入系统功能
    username(newVal, oldVal) {
      let usernameAgent = /^[A-Za-z0-9-_]{1,15}$/;
      //   username改变时进行基本验证 非法字符禁止输入
      if (newVal == "") {
        return;
      }
      if (!usernameAgent.test(newVal)) {
        this.showSb = true;
        this.username = oldVal;
        this.$notification["error"]({
          message: "请输入正确格式的用户名!",
          description: "规则：字母|数字|下划线,4-15位~",
        });
      }
    },
  },
  // 计算属性导入store
  computed: { ...mapGetters(["baseData"]) },
  methods: {
    // 导入actions用于更新store
    ...mapActions(["updateUserBaseData", "updateIsLogin"]),
    // 验证数据功能   判断是否可以提交登陆   暂时关闭
    verifyData() {
      let usernameAgent = /^[A-Za-z0-9-_]{4,15}$/;
      let passwordAgent = /^(?=.*\d).{6,32}$/;
      let VerificationCodeAgent = /^[a-zA-Z0-9]{4}$/;
      if (
        usernameAgent.test(this.username) &&
        passwordAgent.test(this.password) &&
        VerificationCodeAgent.test(this.code)
      ) {
        return true;
      } else {
        return true;
      }
    },
    //登陆功能
    subLogin() {
      if (this.verifyData()) {
        //验证通过 执行登陆操作
        let user = {
          username: this.username,
          password: this.password,
          code: this.code,
          codeToken: this.codeToken,
        };
        this.$api.login
          .login(user)
          .then((res) => {
            if (res.status == 1) {
              //登陆成功
              localStorage.setItem("token", res.data.token);
              this.$notification["success"]({
                message: `${res.msg}`,
              });
              this.updateUserBaseData(res.data);
              this.updateIsLogin(false);
              // 此处还要更新loca数据
              localStorage.setItem("state", JSON.stringify(res.data));
              this.$router.push("/order");
            } else {
              this.getVerificationCode();

              //登陆异常
              this.$notification["error"]({
                message: `${res.msg}`,
              });
              // this.password = "";
            }
          })
          .catch((err) => {
            //登陆接口异常
            this.getVerificationCode();
            console.log(err);
          });
      } else {
        this.$notification["error"]({
          //数据验证异常
          message: "数据验证不通过!请检查输入的数据!",
        });
        this.getVerificationCode();
      }
    },
    //获取验证码  bate
    getVerificationCode() {
      this.$api.login
        .getVerificationCode()
        .then((res) => {
          this.codeSvg = res.data.svg;
          this.codeToken = res.data.Key;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    //忘记密码功能
    forgotPassword() {
      this.$notification["warning"]({
        message: "忘记密码修改方式尚未开通,请联系管理员!",
      });
    },
    //注册功能
    registerUser() {
      if (!this.verifyData()) return;
      let user = {
        username: this.username,
        name: this.name,
        password: this.password,
        sex: this.sex,
        code: this.code,
        codeToken: this.codeToken,
      };
      this.$api.login
        .registerUser(user)
        .then((res) => {
          if (res.status == 1) {
            this.$message.success("注册成功!");
            this.code = "";
            this.getVerificationCode();
          } else {
            this.getVerificationCode();

            this.$message.error(`${res.msg}`);
          }
        })
        .catch((err) => {
          this.getVerificationCode();

          this.$message.error(`${err}`);
        });
    },
  },
};
</script>

<style lang="less" scoped>
.mbbl {
  width: 10rem;
  margin-left: 11rem;
  padding: 1rem 0;
  border-radius: 5%;
  background: rgba(rgb(0, 0, 0), 0.3);
}

a {
  color: rgb(255, 255, 255);
}

#codeBox {
  height: 37px;
}

#loginFromBox {
  height: 15.2rem;
  // background: rgba(88, 216, 248, 0.308);
  background-image: url("../../public/img/bg.jpg");
  padding: 3rem 0rem;
  //   border: 1px solid red;
}

input {
  margin-bottom: 0.2rem;
  border-radius: 5%;
}
</style>