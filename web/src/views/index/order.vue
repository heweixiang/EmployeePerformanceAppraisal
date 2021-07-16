<template>
  <div>
    <!-- 头部按钮 -->
    <div style="margin-bottom: 5px">
      <!-- 仅对user开放 权限 0 admin  1 user  2 manager  3 employee  -1 账号冻结 -->
      <a-button
        type="primary"
        style="margin-right: 5px"
        v-if="this.baseData.jurisdiction == 1"
        @click="addWorkOrder"
        >创建工单</a-button
      >
      <a-input
        v-model="query"
        style="width: 5rem; margin-right: 5px"
        placeholder="请输入关键字..."
      />
      <!--  搜索实现思路   每次都带入搜索关键词,默认为*全部当关键词刷新重新调用获取函数 -->
      <a-button icon="query" @click="confirmQuery"> query </a-button>
      <a-button
        style="margin-left: 1rem"
        icon="arrow-down"
        v-if="
          this.baseData.jurisdiction == 0 || this.baseData.jurisdiction == 2
        "
        @click="getExcel()"
      >
        获取详细数据表
      </a-button>
    </div>
    <a-table
      :columns="columns"
      :rowKey="
        (record, index) => {
          return index;
        }
      "
      :data-source="workOrderList"
      :pagination="pagination"
    >
      <template slot="wstatus" slot-scope="wstatus" style="color: yellow">
        <span v-if="wstatus == 0">本地保存</span>
        <span v-if="wstatus == 1">待经理分配</span>
        <span v-if="wstatus == 2">员工处理中</span>
        <span v-if="wstatus == 3">待用户评价</span>
        <span v-if="wstatus == 4">待经理评价</span>
        <span v-if="wstatus == 5" style="color: green">结案</span>
      </template>
      <template slot="ename" slot-scope="ename, record">
        <span @click="getEmployeeCard(record.eid)">{{ ename }}</span>
      </template>
      <template slot="urgent" slot-scope="urgent">
        <span v-if="urgent == 1" style="color: red">加急</span>
        <span v-else style="color: blue">普通</span>
      </template>
      <template slot="operation" slot-scope="wstatus, record">
        <a-button
          type="danger"
          style="margin-right: 5px"
          v-if="record.wstatus == 0 && baseData.jurisdiction == 1"
          @click="
            fromData = record;
            confirmDel();
          "
          >删除工单</a-button
        >
        <!-- 权限操作放到工单页面 -->
        <a-button
          type="primary"
          style="margin-right: 5px"
          @click="
            fromData = record;
            confirmModify();
          "
          >查看/签核工单</a-button
        >
      </template>
    </a-table>

    <!-- 显示弹窗-->
    <a-modal
      v-model="visible.item"
      v-if="visible.item"
      @cancel="closeBox"
      width="20rem"
      footer=""
      title="工单详情"
    >
      <order-item></order-item>
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
import { mapActions, mapGetters } from "vuex";
import orderItem from "./orderItem";
import userCard from "../../components/userCard";

export default {
  components: {
    orderItem,
    userCard,
  },
  data() {
    return {
      // 用户表数据
      workOrderList: null,
      //   表头
      columns: null,
      //   搜索字段
      query: "",
      //   部门列表
      departmentList: [{ id: "1", departmentname: "初始化数据..." }],
      //   弹窗控制
      visible: { del: false, item: false, card: false },
      //  表单数据 用于过渡,防止变量被污染
      fromData: {
        id: null,
        username: null,
        name: null,
        sex: 1,
        departmentid: 1,
        jurisdiction: null,
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
    //   获取工单列表
    this.getWorkOrderList();
  },
  watch: {
    isClose(val) {
      this.visible.item = val;
      if (val == false) {
        this.closeBox();
      }
    },
    pagination: {
      deep: true,
      handler() {
        // 跳页数据发生变化重新请求
        this.getWorkOrderList();
      },
    },
  },
  methods: {
    ...mapActions(["updateIsClose"]),
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
    //   创建表格,请求完列表数据后创建表格
    createData() {
      /**
       * 对接:
       *      对接数据,做好搜索跳转,item页面控制好权限,没权限不给显示
       */
      this.columns = [
        {
          title: "工单ID",
          dataIndex: "id",
          key: "id",
        },
        {
          title: "工单简介",
          dataIndex: "intro",
          key: "intro",
        },
        {
          title: "工单状态",
          dataIndex: "wstatus",
          key: "wstatus",
          scopedSlots: { customRender: "wstatus" },
        },
        {
          title: "所属用户",
          dataIndex: "uname",
          key: "uname",
        },
        {
          title: "所属员工",
          dataIndex: "ename",
          key: "ename",
          scopedSlots: { customRender: "ename" },
        },
        {
          title: "所属部门",
          dataIndex: "dname",
          key: "dname",
        },
        {
          title: "发布时间",
          dataIndex: "ctime",
          key: "ctime",
        },
        {
          title: "是否加急",
          dataIndex: "urgent",
          key: "urgent",
          scopedSlots: { customRender: "urgent" },
        },
        {
          title: "操作",
          dataIndex: "operation",
          key: "operation",
          scopedSlots: { customRender: "operation" },
        },
      ];
    },
    // 获取工单列表
    getWorkOrderList() {
      let query = this.query;
      let page = this.pagination.pageNo;
      let limit = this.pagination.pageSize;
      this.$api.comprehensiveAuthority
        .getWorkOrderList({ query, page, limit })
        .then((res) => {
          this.workOrderList = res.data;
          this.pagination.total = res.data[0].count;
          this.createData();
        })
        .catch((err) => console.log(err));
    },
    // 工单暂时不给删除功能
    confirmDel() {
      // 此处弹出确认框,确认是否删除
    },
    closeBox() {
      this.getWorkOrderList();
    },
    // 添加工单跳转
    addWorkOrder() {
      localStorage.setItem("workId", null);
      this.visible.item = true;
      this.updateIsClose(true);
    },
    //修改工单跳转,给个id
    confirmModify() {
      this.updateIsClose(true);
      localStorage.setItem("workId", this.fromData.id);
      this.visible.item = true;
    },
    // 搜索
    confirmQuery() {
      this.pagination.pageNo = 1;
      this.getWorkOrderList();
    },
    // 获取表格
    getExcel() {
      let token = localStorage.getItem("token");
      window.open(
        `http://127.0.0.1:1587/advancedPermissions/getExcel?token=${token}`
      );
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
  },
  computed: { ...mapGetters(["baseData", "isClose"]) },
};
</script>

<style lang="less" scoped>
</style>