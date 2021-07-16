<template>
  <div>
    <!-- 头部按钮 -->
    <div style="margin-bottom: 5px">
      <!-- <a-button
        type="danger"
        style="margin-right: 5px"
        @click="visible.del = true"
      >
        删除用户
      </a-button> -->
      <a-button
        type="primary"
        style="margin-right: 5px"
        @click="visible.add = true"
        >添加用户</a-button
      >
      <!-- <a-button
        type="primary"
        style="margin-right: 5px"
        @click="visible.frozen = true"
        >冻结用户</a-button
      >
      <a-button
        type="primary"
        style="margin-right: 5px"
        @click="visible.REfrozen = true"
        >解除冻结</a-button
      >
      <a-button
        type="primary"
        style="margin-right: 5px"
        @click="visible.REup = true"
        >重置密码</a-button
      > -->
      <a-input
        v-model="query"
        style="width: 5rem; margin-right: 5px"
        placeholder="请输入关键字..."
      />
      <!--  搜索实现思路   每次都带入搜索关键词,默认为*全部当关键词刷新重新调用获取函数 -->
      <a-button icon="query" @click="confirmQuery"> query </a-button>
    </div>
    <a-table
      :columns="columns"
      :rowKey="
        (record, index) => {
          return index;
        }
      "
      :data-source="userList"
      :pagination="pagination"
    >
      <template slot="jurisdiction" slot-scope="jurisdiction">
        <span v-if="jurisdiction == 0">admin</span>
        <span v-if="jurisdiction == 1">用户</span>
        <span v-if="jurisdiction == 2">主管</span>
        <span v-if="jurisdiction == 3">员工</span>
      </template>
      <template slot="username" slot-scope="username, record">
        <span
          v-if="record.jurisdiction == 3"
          @click="getEmployeeCard(record.id)"
          >{{ username }}</span
        >
        <span v-else>{{ username }}</span>
      </template>
      <template slot="operation" slot-scope="jurisdiction, record">
        <a-button
          type="danger"
          style="margin-right: 5px"
          @click="
            fromData = record;
            visible.del = true;
          "
          >删除用户</a-button
        >
        <a-button
          type="primary"
          style="margin-right: 5px"
          @click="
            fromData = record;
            visible.mod = true;
          "
          >修改用户</a-button
        >
        <a-button
          type="primary"
          style="margin-right: 5px"
          @click="
            fromData = record;
            visible.REup = true;
          "
        >
          重置</a-button
        >
        <a-button
          type="primary"
          v-if="record.jurisdiction < 5"
          style="margin-right: 5px"
          @click="
            fromData = record;
            visible.frozen = true;
          "
        >
          冻结用户
        </a-button>

        <a-button
          type="primary"
          v-else
          @click="
            fromData = record;
            visible.REfrozen = true;
          "
        >
          解除冻结</a-button
        >
      </template>
    </a-table>
    <!-- 弹窗删除 -->
    <a-modal v-model="visible.del" title="删除用户">
      <a-input
        style="margin-bottom: 15px"
        placeholder="请输入用户ID(用户名和ID输入一个即可)"
        v-model="fromData.id"
      />
      <a-input placeholder="请输入用户名" v-model="fromData.username" />
      <template slot="footer">
        <a-button key="back" @click="visible.del = false">取消</a-button>
        <a-button
          key="confirm"
          @click="
            confirmDel();
            visible.del = false;
          "
          >确认删除</a-button
        >
      </template>
    </a-modal>
    <!-- 弹窗添加 -->
    <a-modal v-model="visible.add" title="添加用户">
      <!-- 用户名 姓名 部门ID   权限 -->
      <a-input
        style="margin-bottom: 15px"
        placeholder="请输入用户名"
        v-model="fromData.username"
      />
      <a-input
        style="margin-bottom: 15px"
        placeholder="请输入用户真实姓名"
        v-model="fromData.name"
      />
      <!-- 单选框 -->
      <a-radio-group v-model="fromData.sex" style="margin-bottom: 15px">
        <a-radio :value="1"> 男 </a-radio>
        <a-radio :value="0"> 女 </a-radio>
      </a-radio-group>
      <br />

      <!-- 部门ID需要渲染出来所有部门 -->
      <a-select
        :default-value="fromData.departmentid ? fromData.departmentid : 1"
        style="width: 120px; margin-bottom: 15px"
        v-if="this.baseData.jurisdiction == 0"
        @change="(value) => (fromData.departmentid = value)"
      >
        <!-- 权限 0 admin  1 user  2 manager  3 employee  -1 账号冻结 -->
        <a-select-option
          v-for="item in departmentList"
          :key="item.id"
          :value="item.id"
          >{{ item.departmentname }}
        </a-select-option> </a-select
      ><span
        style="color: #1a94bc; margin-left: 5px"
        v-if="this.baseData.jurisdiction == 0"
      >
        请选择对应部门user(也有部门归属)
      </span>
      <br />
      <a-select
        :default-value="
          fromData.jurisdiction != null ? fromData.jurisdiction : 1
        "
        v-if="this.baseData.jurisdiction == 0"
        style="width: 120px"
        @change="(value) => (fromData.jurisdiction = value)"
      >
        <!-- 权限 0 admin  1 user  2 manager  3 employee  -1 账号冻结 -->
        <a-select-option :value="-1"> 冻结 </a-select-option>
        <a-select-option :value="1"> 用户 </a-select-option>
        <a-select-option :value="2"> 主管 </a-select-option>
        <a-select-option :value="3"> 员工 </a-select-option> </a-select
      ><span
        style="color: #1a94bc; margin-left: 5px"
        v-if="this.baseData.jurisdiction == 0"
      >
        这个用户的权限是?
      </span>
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
    <!-- 弹窗修改 -->
    <a-modal v-model="visible.mod" title="修改用户">
      <!-- 用户名 姓名 部门ID   权限 -->
      <!-- <a-input
        style="margin-bottom: 15px"
        placeholder="请输入用户名"
        v-model="fromData.username"
      /> -->
      <a-input
        style="margin-bottom: 15px"
        placeholder="请输入用户真实姓名"
        v-model="fromData.name"
      />
      <!-- 单选框 -->
      <a-radio-group style="margin-bottom: 15px">
        <input type="radio" checked v-model="fromData.sex" value="1" id="nan" />
        <label for="nan" style="margin-right: 10px">男</label>
        <input type="radio" v-model="fromData.sex" value="0" id="nv" />
        <label for="nv">女</label>
      </a-radio-group>
      <br />

      <!-- 部门ID需要渲染出来所有部门 -->
      <a-select
        style="width: 120px; margin-bottom: 15px"
        @change="(value) => (fromData.departmentid = value)"
        v-if="this.baseData.jurisdiction == 0"
      >
        <!-- 权限 0 admin  1 user  2 manager  3 employee  -1 账号冻结 -->
        <a-select-option
          v-for="item in departmentList"
          :key="item.id"
          :value="item.id"
          >{{ item.departmentname }}
        </a-select-option> </a-select
      ><span
        style="color: #1a94bc; margin-left: 5px"
        v-if="this.baseData.jurisdiction == 0"
      >
        请选择对应部门user(也有部门归属)
      </span>
      <br />
      <a-select
        style="width: 120px"
        @change="(value) => (fromData.jurisdiction = value)"
        v-if="this.baseData.jurisdiction == 0"
      >
        <!-- 权限 0 admin  1 user  2 manager  3 employee  -1 账号冻结 -->
        <a-select-option :value="1"> 用户 </a-select-option>
        <a-select-option :value="2"> 主管 </a-select-option>
        <a-select-option :value="3"> 员工 </a-select-option> </a-select
      ><span
        style="color: #1a94bc; margin-left: 5px"
        v-if="this.baseData.jurisdiction == 0"
      >
        这个用户的权限是?
      </span>
      <template slot="footer">
        <a-button key="back" @click="visible.mod = false">取消</a-button>
        <a-button
          key="confirm"
          @click="
            confirmAdd();
            visible.mod = false;
          "
          >确认修改</a-button
        >
      </template>
    </a-modal>
    <!-- 弹窗冻结 -->
    <a-modal v-model="visible.frozen" title="冻结用户">
      <label>您确认冻结用户吗?</label>

      <template slot="footer">
        <a-button key="back" @click="visible.frozen = false">取消</a-button>
        <a-button
          key="confirm"
          @click="
            confirmFrozen();
            visible.frozen = false;
          "
          >确认冻结</a-button
        >
      </template>
    </a-modal>
    <!-- 弹窗解除冻结 -->
    <a-modal v-model="visible.REfrozen" title="解除冻结">
      <label>您确认解除冻结用户吗?</label>

      <template slot="footer">
        <a-button key="back" @click="visible.REfrozen = false">取消</a-button>
        <a-button
          key="confirm"
          @click="
            confirmREfrozen();
            visible.REfrozen = false;
          "
          >确认解除</a-button
        >
      </template>
    </a-modal>

    <!-- 弹窗重置 -->
    <a-modal v-model="visible.REup" title="重置用户">
      <label>您确认重置该用户密码吗?</label>
      <template slot="footer">
        <a-button key="back" @click="visible.REup = false">取消</a-button>
        <a-button key="confirm" @click="REup()">确认重置</a-button>
      </template>
    </a-modal>
    <!-- 用户卡片-->
    <a-modal
      v-model="visible.card"
      v-if="visible.card"
      width="20rem"
      footer=""
      title="用户详情"
    >
      <user-card></user-card>
    </a-modal>
  </div>
</template>

<script>
// 导入API和全局变量
import { mapGetters } from "vuex";
import userCard from "../../components/userCard";

export default {
  components: {
    userCard,
  },
  data() {
    return {
      // 用户表数据
      userList: null,
      //   表头
      columns: null,
      //   搜索字段
      query: "",
      //   分页
      page: 1,
      limit: 10,
      //   部门列表
      departmentList: [{ id: "1", departmentname: "初始化数据..." }],
      //   弹窗控制
      visible: {
        del: false,
        add: false,
        mod: false,
        frozen: false,
        REfrozen: false,
        REup: false,
        card: false,
      },
      jurisdiction: -1,
      //  表单数据 用于过渡,防止变量被污染
      fromData: {
        id: null,
        username: null,
        name: null,
        sex: "1",
        departmentid: 1,
        jurisdiction: 1,
      },
      pagination: {
        pageNo: 1,
        pageSize: 10, // 默认每页显示数量
        showSizeChanger: true, // 显示可改变每页数量
        pageSizeOptions: ["10", "20", "50", "100"], // 每页数量选项
        showTotal: (total) => `共${total}条`, // 显示总数
        onShowSizeChange: (current, pageSize) => {
          // 此处逻辑问题,如果说当页码乘以每页数量大于上次总数则将页码归一
          if (this.pagination.pageNo * pageSize >= this.pagination.total) {
            this.pagination.pageNo = 1;
            this.pagination.pageSize = pageSize;
          }
        }, // 改变每页数量时更新显示
        onChange: this.onPageChange.bind(this), //点击页码事件
        total: 0, //总条数
        current: 0,
        buildOptionText: (pageSizeOptions) => `${pageSizeOptions.value}条/页`,
        // size: "small",
      },
    };
  },
  created() {
    //   获取用户列表和部门列表
    this.getUserList();
    this.getDepartmentList();
  },
  watch: {
    //   监听弹窗的隐藏清空表单回显数据,300毫秒后清空,给请求留点时间,但是用户点不到
    visible: {
      // 监听回显保证回显数据不被污染            a
      handler() {
        // 此函数变量名不能乱命名
        if (this.visible.add == true) {
          this.fromData = {
            id: null,
            username: null,
            name: null,
            sex: 1,
            departmentid: 1,
            jurisdiction: 1,
          };
        }
        // if (
        //   val.REfrozen == false &&
        //   val.add == false &&
        //   val.del == false &&
        //   val.frozen == false &&
        //   val.REup == false &&
        //   val.card == false
        // ) {
        //   setTimeout(() => {
        //     this.fromData = {
        //       id: null,
        //       username: null,
        //       name: null,
        //       sex: 1,
        //       departmentid: 1,
        //       jurisdiction: 1,
        //     };
        //   }, 300);
        // }
      },
      deep: true,
    },
    pagination: {
      deep: true,
      handler() {
        this.getUserList();
      },
    },
  },
  methods: {
    //   分页处理
    onPageChange(page) {
      this.pagination.pageNo = page;
      this.pagination.current = page;
      // this.getWorkOrderList();
    },
    rePageSize(val) {
      // 重设pagesize
      this.pagination.pageSize = val;
    },
    //   创建表格,请求完列表数据后创建表格          a
    createData() {
      if (this.baseData.jurisdiction == 0) {
        this.columns = [
          {
            title: "用户ID",
            dataIndex: "id",
            key: "id",
          },
          {
            title: "姓名",
            dataIndex: "name",
            key: "name",
          },
          {
            title: "用户名",
            dataIndex: "username",
            key: "username",
            scopedSlots: { customRender: "username" },
          },
          {
            title: "所属部门",
            dataIndex: "departmentname",
            key: "departmentname",
          },
          {
            title: "权限",
            dataIndex: "jurisdiction",
            key: "jurisdiction",
            scopedSlots: { customRender: "jurisdiction" },
          },
          {
            title: "上次登陆时间",
            dataIndex: "lastlogintime",
            key: "lastlogintime",
          },
          {
            title: "操作",
            dataIndex: "operation",
            key: "operation",
            scopedSlots: { customRender: "operation" },
          },
        ];
      } else {
        this.columns = [
          {
            title: "用户ID",
            dataIndex: "id",
            key: "id",
          },
          {
            title: "姓名",
            dataIndex: "name",
            key: "name",
          },
          {
            title: "用户名",
            dataIndex: "username",
            key: "username",
            scopedSlots: { customRender: "username" },
          },
          {
            title: "所属部门",
            dataIndex: "departmentname",
            key: "departmentname",
          },
          {
            title: "权限",
            dataIndex: "jurisdiction",
            key: "jurisdiction",
            scopedSlots: { customRender: "jurisdiction" },
          },
          {
            title: "上次登陆时间",
            dataIndex: "lastlogintime",
            key: "lastlogintime",
          },
          {
            title: "操作",
            dataIndex: "operation",
            key: "operation",
            scopedSlots: { customRender: "operation" },
          },
        ];
      }
      this.jurisdiction = this.baseData.jurisdiction;
    },
    // 获取用户列表             a
    getUserList() {
      this.$api.advancedPermission
        .getUserList({
          query: this.query,
          page: this.pagination.pageNo,
          limit: this.pagination.pageSize,
        })
        .then((res) => {
          this.userList = res.data;
          this.pagination.total = res.data[0].count;
          this.createData();
        })
        .catch((err) => console.log(err));
    },
    // 获取部门列表并刷新       a
    getDepartmentList() {
      this.$api.comprehensiveAuthority
        .getDepartmentList()
        .then((res) => {
          this.departmentList = res.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    // 删除用户                 a
    confirmDel() {
      this.$api.advancedPermission
        .delUserItem(this.fromData.id)
        .then((res) => {
          if (res.status == 1) {
            this.$message.success(`${res.msg}`);
            this.getUserList();
          } else {
            this.$message.error(`${res.msg}`);
          }
        })
        .catch((err) => this.$message.error(`error:${err}`));
    },
    // 添加用户                 a
    confirmAdd() {
      // 检测到用户id跳转到修改
      if (this.fromData.id != null) {
        this.confirmModify();
        return;
      }
      this.$api.advancedPermission
        .addUserItem({
          username: this.fromData.username,
          name: this.fromData.name,
          sex: this.fromData.sex,
          did: this.fromData.departmentid,
          jurisdiction: this.fromData.jurisdiction,
        })
        .then((res) => {
          if (res.status == 1) {
            this.$message.success(`${res.msg}`);
            this.getUserList();
          } else {
            this.$message.error(`${res.msg}`);
          }
        })
        .catch((err) => this.$message.error(`error:${err}`));
    },
    // 冻结用户
    confirmFrozen() {
      this.$api.advancedPermission
        .freezeUser(this.fromData.id)
        .then((res) => {
          if (res.status == 1) {
            this.$message.success(`${res.msg}`);
            this.getUserList();
          } else {
            this.$message.error(`${res.msg}`);
          }
        })
        .catch((err) => this.$message.error(`error:${err}`));
    },
    // 解除冻结
    confirmREfrozen() {
      this.$api.advancedPermission
        .relieveFreeze(this.fromData.id)
        .then((res) => {
          if (res.status == 1) {
            this.$message.success(`${res.msg}`);
            this.getUserList();
          } else {
            this.$message.error(`${res.msg}`);
          }
        })
        .catch((err) => this.$message.error(`error:${err}`));
    },
    //修改用户
    confirmModify() {
      let data = {
        id: this.fromData.id,
        username: this.fromData.username,
        name: this.fromData.name,
        did: this.fromData.departmentid,
        sex: this.fromData.sex,
        jurisdiction: this.fromData.jurisdiction,
      };
      console.log(data);
      this.$api.advancedPermission
        .setUserItem(data)
        .then((res) => {
          if (res.status == 1) {
            this.$message.success(`${res.msg}`);
            this.getUserList();
          } else {
            this.$message.error(`${res.msg}`);
          }
        })
        .catch((err) => this.$message.error(`error:${err}`));
    },
    // 重置密码
    REup() {
      this.$api.advancedPermission
        .REUserPassword(this.fromData.id)
        .then((res) => {
          if (res.status == 1) {
            this.$message.success(`${res.msg}`);
            this.visible.REup = false;
            this.getUserList();
          } else {
            this.$message.error(`${res.msg}`);
          }
        })
        .catch((err) => {
          this.$message.error(`error:${err}`);
        });
    },
    getEmployeeCard(id) {
      this.$api.comprehensiveAuthority
        .getEmployeeCard(id)
        .then((res) => {
          if (res.status == 1) {
            this.$message.success(`${res.msg}`);
            localStorage.setItem("usercard", JSON.stringify(res.data));
            this.visible.card = true;
          } else {
            this.$message.error(`${res.msg}`);
          }
        })
        .catch((err) => {
          this.$message.error(`ERROR:${err}`);
        });
    },
    // 搜索
    confirmQuery() {
      this.pagination.pageNo = 1;
      this.getUserList();
    },
  },
  computed: { ...mapGetters(["baseData"]) },
};
</script>

<style lang="less" scoped>
</style>