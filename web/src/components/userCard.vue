<template>
  <div>
    <a-row>
      <a-col class="bb1" :span="12">姓名：{{ this.userdata.name }}</a-col>
      <a-col class="bb1" :span="12">
        性别：{{ this.userdata.sex == 1 ? "男" : "女" }}
      </a-col>
      <a-col class="bb1" :span="12">部门名称：{{ this.userdata.dname }}</a-col>
      <a-col class="bb1" :span="12">用户名：{{ this.userdata.username }}</a-col>
      <a-col class="bb1" :span="12">
        上次上线时间：{{ this.userdata.lastlogintime }}
      </a-col>
      <a-col class="bb1" :span="12">邮箱：{{ this.userdata.email }}</a-col>
      <a-col class="bb1" :span="12">电话：{{ this.userdata.phone }}</a-col>
      <a-col class="bb1" :span="12">总评：{{ this.userdata.avgstart }}</a-col>
    </a-row>
  </div>
</template>

<script>
export default {
  data() {
    return {
      userdata: {},
    };
  },
  mounted() {
    this.userdata = JSON.parse(localStorage.getItem("usercard"));
    console.log(this.userdata.username);
  },
};
</script>

<style lang="less" scoped>
.bb1 {
  margin-bottom: 0.5rem;
  font-size: 0.4rem;
}
</style>