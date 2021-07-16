<template>
  <div>
    <!-- 头部按钮 -->
    <div style="margin-bottom: 5px">
      <a-button
        type="primary"
        style="margin-right: 5px"
        @click="visible.add = true"
        >添加部门</a-button
      >
    </div>
    <a-table
      :columns="columns"
      :rowKey="
        (record, index) => {
          return index;
        }
      "
      :data-source="departmentList"
      :pagination="false"
    >
      <template slot="operation" slot-scope="departmentname, record">
        <a-button
          type="primary"
          style="margin-right: 5px"
          @click="
            fromData = record;
            visible.add = true;
          "
          >修改部门</a-button
        >
      </template>
    </a-table>
    <!-- 弹窗添加 -->
    <a-modal v-model="visible.add" title="添加/修改部门">
      <!-- 用户名 姓名 部门ID   权限 -->
      <a-input
        style="margin-bottom: 15px"
        placeholder="请输入部门名"
        v-model="fromData.departmentname"
      />
      <template slot="footer">
        <a-button key="back" @click="visible.add = false">取消</a-button>
        <a-button
          key="confirm"
          @click="
            confirmAdd();
            visible.add = false;
          "
          >添加/修改</a-button
        >
      </template>
    </a-modal>
  </div>
</template>

<script>
// 导入API和全局变量
import { mapGetters } from "vuex";

export default {
  data() {
    return {
      //   表头
      columns: null,

      //   部门列表
      departmentList: null,
      //   弹窗控制
      visible: { add: false },
      //  表单数据 用于过渡,防止变量被污染
      fromData: {
        id: null,
        departmentname: "",
      },
    };
  },
  created() {
    //   获取用户列表和部门列表
    this.getDepartmentList();
  },
  watch: {
    //   监听弹窗的隐藏清空表单回显数据,300毫秒后清空,给请求留点时间,但是用户点不到
    visible: {
      // 监听回显保证回显数据不被污染            a
      handler(val) {
        // 此函数变量名不能乱命名
        if (val.add == false) {
          setTimeout(() => {
            this.fromData = {
              id: null,

              departmentname: "",
            };
          }, 300);
        }
      },
      deep: true,
    },
  },
  methods: {
    //   创建表格,请求完列表数据后创建表格          a
    createData() {
      this.columns = [
        {
          title: "部门ID",
          dataIndex: "id",
          key: "id",
        },
        {
          title: "部门名称",
          dataIndex: "departmentname",
          key: "departmentname",
        },
        {
          title: "操作",
          dataIndex: "operation",
          key: "operation",
          scopedSlots: { customRender: "operation" },
        },
      ];
    },
    // 获取部门列表并刷新       a
    getDepartmentList() {
      this.$api.comprehensiveAuthority
        .getDepartmentList()
        .then((res) => {
          this.departmentList = res.data;
          this.createData();
        })
        .catch((err) => {
          console.log(err);
        });
    },
    // 添加部门                 a
    confirmAdd() {
      // 检测到id跳转到修改
      if (this.fromData.id != null) {
        this.confirmModify();
        return;
      }
      this.$api.advancedPermission
        .addDepartment(this.fromData.departmentname)
        .then((res) => {
          if (res.status == 1) {
            this.$message.success(`${res.msg}`);
            this.getDepartmentList();
          } else {
            this.$message.error(`${res.msg}`);
          }
        })
        .catch((err) => console.log(err));
    },
    //修改部门
    confirmModify() {
      this.$api.advancedPermission
        .modifyDepartment(this.fromData.id, this.fromData.departmentname)
        .then((res) => {
          if (res.status == 1) {
            this.$message.success(`${res.msg}`);
            this.getDepartmentList();
          } else {
            this.$message.error(`${res.msg}`);
          }
        })
        .catch((err) => console.log(err));
    },
  },
  computed: { ...mapGetters(["baseData"]) },
};
</script>

<style lang="less" scoped>
</style>