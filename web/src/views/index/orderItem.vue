<template>
  <div>
    <a-form layout="inline">
      <!-- 部门,工单简介,工单内容,是否加急:创建时需要传入 -->
      <a-form-item>
        <!-- 工单简介,创建时间,是否加急 -->
        <span>
          标题简介：
          <a-input
            style="display: inline; width: 10.8rem"
            placeholder="请输入工单简介..."
            v-model="formData.intro"
          />
        </span>
        <br />
        <!-- 创建时间回显来自data -->
        <span style="margin-right: 0.5rem">
          创建时间：
          <span>{{ this.formData.ctime }}</span>
        </span>

        <a-radio-group
          name="radioGroup"
          placeholder="是否加急"
          v-model="formData.urgent"
        >
          是否加急：
          <a-radio :value="1"> 加急 </a-radio>
          <a-radio :value="0"> 非加急 </a-radio>
        </a-radio-group>

        <!-- 部门ID需要渲染出来所有部门 -->
        <a-select
          v-model="formData.did"
          :key="key"
          style="width: 2rem; margin-bottom: 15px"
          @change="(value) => (formData.did = value)"
          placeholder="请选择部门.."
        >
          <!-- 权限 0 admin  1 user  2 manager  3 employee  -1 账号冻结 -->
          <a-select-option
            v-for="item in departmentList"
            :key="item.id"
            :value="item.id"
            :disabled="!(formData.id == 0)"
            >{{ item.departmentname }}
          </a-select-option>
        </a-select>
      </a-form-item>
      <br />
      <!-- 工单内容,暂时使用textarea,后续使用富文本 -->
      <a-form-item>
        工单内容：
        <a-textarea
          v-model="formData.content"
          rows="10"
          style="width: 10.8rem"
        />
      </a-form-item>
      <br />
      <!-- 工单备注 -->
      <a-form-item>
        工单备注：
        <a-textarea
          v-model="formData.remarks"
          rows="3"
          style="width: 10.8rem"
        />
      </a-form-item>
      <br />
      <a-form-item>
        <!-- 工单联系方式 -->
        <!-- 对应部门 对应员工 -->
        <div v-if="this.formData.wstatus >= 2">
          <!-- 当分配到员工时显示  2 -->
          <span>{{ this.formData.dname }}>{{ this.formData.ename }}：</span>
          <span>
            <!-- 员工电话邮箱 用户电话邮箱 -->
            <a-tag color="cyan"> 邮箱地址：{{ this.formData.email }} </a-tag>
            <a-tag color="cyan"> 电话号码：{{ this.formData.ephone }} </a-tag>
          </span>
        </div>
        <div>
          <!-- 默认user端从this.baseData带入,其实只是给user看后期从请求中获取 -->
          <span>联系用户名：</span>
          <span v-if="baseData.jurisdiction == 1 && formData.wstatus == 0">
            <!-- 员工电话邮箱 用户电话邮箱 -->
            <a-tag color="cyan"> 邮箱地址：{{ this.baseData.email }} </a-tag>
            <a-tag color="cyan"> 电话号码：{{ this.baseData.phone }}</a-tag>
          </span>
          <span v-else>
            <!-- 员工电话邮箱 用户电话邮箱 -->
            <a-tag color="cyan"> 邮箱地址：{{ this.formData.umail }} </a-tag>
            <a-tag color="cyan"> 电话号码：{{ this.formData.uphone }} </a-tag>
          </span>
        </div>
      </a-form-item>
      <br />
      <a-form-item>
        <!-- 签核列表和评价列表 -->
        <!-- 两个表格仅显示一个,根据表单顺序来 如果说显示评论表格后给予显示签核表的按钮 -->
        <!-- 签核人名,签核内容,签核时间0000000 -->
        <div v-if="this.formData.wstatus >= 1" class="ideaList">
          <!-- 用户发布 -->
          <div v-if="this.formData.wstatus >= 1">
            <span> 用户发布：{{ this.formData.ctime }}</span>
            <br />
            <span>{{ this.formData.uidea }}</span>
          </div>
          <!-- 主管签核 -->
          <div v-if="this.formData.wstatus >= 2">
            <span> 主管签核：{{ this.formData.mideatime }} </span>
            <br />
            <span>{{ this.formData.midea }}</span>
          </div>
          <!-- 员工签核 -->
          <div v-if="this.formData.wstatus >= 3">
            <span>员工签核：{{ this.formData.eideatime }}</span>
            <span>{{ this.formData.eidea }} </span>
          </div>
        </div>
        <!-- 评价人,评价内容,评价等级,评价时间 -->
        <div v-if="this.formData.wstatus >= 4">
          <div v-if="this.formData.wstatus >= 4">
            <span>用户评价：{{ this.formData.ustarttime }}</span>
            <br />
            <a-rate :default-value="formData.ustart" disabled />
            <br />
            <span>{{ this.formData.ucontent }} </span>
          </div>
          <div v-if="this.formData.wstatus == 5">
            <span>主管评价：{{ this.formData.mstarttime }}</span>
            <br />
            <a-rate :default-value="formData.ustart" disabled />
            <br />
            <span>{{ this.formData.mcontent }} </span>
          </div>
          <div v-if="this.formData.wstatus == 5">
            <span>平均评价：{{ this.formData.mstarttime }}</span>
            <br />
            <a-rate :default-value="formData.averagestart" disabled />
          </div>
        </div>
      </a-form-item>
      <br />
      <!-- 结案状态没有按钮 -->
      <a-form-item v-if="!(this.formData.wstatus == 5)">
        <!-- 按钮列表   根据进度和权限显示或者隐藏按钮 -->
        <!-- 当前工单状态, 0 用户端保存,1 待经理审核分配,2 分配到员工,3 员工提交,4 用户评价工单,5 主管评价工单,6 结案 -->
        <!-- 发布工单仅限this.frome中的id为空时判定为发布 -->
        <a-button
          class="buttomList"
          v-if="this.formData.wstatus == 0"
          type="primary"
          @click="visible.addWorkOrder = true"
        >
          发布工单
        </a-button>
        <!-- 当工单为1时显示 主管具有分配权限的签核 -->
        <a-button
          class="buttomList"
          v-if="this.formData.wstatus == 1 && this.baseData.jurisdiction == 2"
          type="primary"
          @click="visible.distribution = true"
        >
          签核工单
        </a-button>
        <!-- 当工单为2时显示 员工签核-->
        <a-button
          class="buttomList"
          v-if="this.formData.wstatus == 2 && this.baseData.jurisdiction == 3"
          type="primary"
          @click="visible.checkWorkOrder = true"
        >
          签核工单
        </a-button>
        <!-- 当工单为1,3时显示 -->
        <a-button
          class="buttomList"
          v-if="
            (this.baseData.jurisdiction == 1 && this.formData.wstatus == 3) ||
            (this.formData.wstatus == 1 && this.baseData.jurisdiction == 2)
          "
          type="danger"
        >
          退回工单
        </a-button>
        <!-- 当工单为3,4时显示 -->
        <a-button
          class="buttomList"
          v-if="
            (this.formData.wstatus == 3 && this.baseData.jurisdiction == 1) ||
            (this.baseData.jurisdiction == 2 && this.formData.wstatus == 4)
          "
          @click="visible.start = true"
          type="primary"
        >
          评价工单
        </a-button>
        <!-- 当用户权限为0且状态为3的时候显示 -->
        <a-button
          class="buttomList"
          v-if="this.formData.wstatus == 3 && this.baseData.jurisdiction == 0"
          type="primary"
        >
          强制结案
        </a-button>
      </a-form-item>
    </a-form>
    <!-- 发布工单 -->
    <a-modal v-model="visible.addWorkOrder" title="发布工单">
      <a-textarea
        rows="2"
        style="margin-bottom: 15px"
        placeholder="请输入发布想法..."
        v-model="formData.idea"
      />
      <template slot="footer">
        <a-button key="back" @click="visible.addWorkOrder = false"
          >取消</a-button
        >
        <a-button
          key="confirm"
          @click="
            addWorkItem();
            visible.addWorkOrder = false;
          "
          >确认发布</a-button
        >
      </template>
    </a-modal>

    <!-- 分配工单 在原有基础上添加一个Uid-->
    <a-modal v-model="visible.distribution" title="分配工单">
      <a-select
        :default-value="null"
        style="width: 120px; margin-bottom: 20px"
        @change="(value) => (formData.eid = value)"
      >
        <!-- 权限 0 admin  1 user  2 manager  3 employee  -1 账号冻结 -->
        <a-select-option
          :value="item.id"
          v-for="item in userList"
          :key="item.id"
        >
          {{ item.name }}
        </a-select-option>
      </a-select>

      <a-textarea
        rows="2"
        style="margin-bottom: 15px"
        placeholder="请输入发布想法..."
        v-model="formData.idea"
      />
      <template slot="footer">
        <a-button key="back" @click="visible.distribution = false"
          >取消</a-button
        >
        <a-button
          key="confirm"
          @click="
            distribution();
            visible.distribution = false;
          "
          >确认发布</a-button
        >
      </template>
    </a-modal>

    <!-- 签核工单 -->
    <a-modal v-model="visible.checkWorkOrder" title="签核工单">
      <a-textarea
        rows="2"
        style="margin-bottom: 15px"
        placeholder="请输入签核想法..."
        v-model="formData.idea"
      />
      <template slot="footer">
        <a-button key="back" @click="visible.checkWorkOrder = false"
          >取消</a-button
        >
        <a-button
          key="confirm"
          @click="
            checkWorkOrderItem();
            visible.checkWorkOrder = false;
          "
          >确认发布</a-button
        >
      </template>
    </a-modal>

    <!-- 评价工单工单 -->
    <a-modal v-model="visible.start" title="评价工单">
      <a-rate v-model="formData.start" allow-half style="margin-bottom: 15px" />

      <a-textarea
        rows="2"
        style="margin-bottom: 15px"
        placeholder="请输入评价内容..."
        v-model="formData.idea"
      />
      <template slot="footer">
        <a-button key="back" @click="visible.start = false">取消</a-button>
        <a-button
          key="confirm"
          @click="
            startWorkOrderItem();
            visible.start = false;
          "
          >确认发布</a-button
        >
      </template>
    </a-modal>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
export default {
  data() {
    return {
      key: 0,
      userList: [],
      visible: {
        // 新增触发弹出控制
        addWorkOrder: false,
        // 分配
        distribution: false,
        // 签核
        checkWorkOrder: false,
        //评分
        start: false,
      },
      departmentList: [{ id: 1, departmentname: "test" }],
      formData: {
        id: 0,
        intro: "",
        // 时间截取前十,满足数据库
        did: 1,
        ctime: "",
        // 是否加急
        urgent: 0,
        // 工单内容
        content: "",
        // 工单备注
        remarks: "",
        // 用户和员工联系方式
        umail: "",
        uphone: "",
        email: "",
        ephone: "",
        // 部门名称
        dname: "",
        // 工单状态
        wstatus: 0,
        // 主管员工签核内容和时间
        midea: "",
        mideatime: "",
        eidea: "",
        eideatime: "",
        uidea: "",
        // 评价内容和时间
        ustart: null,
        ucontent: "",
        ustarttime: "",
        mstart: null,
        mcontent: "",
        mstarttime: "",
        averagestart: null,
        // 表单提交过渡使用
        idea: "",
        // 分配员工时过渡使用
        eid: 0,
        start: 2.5,
      },
    };
  },
  created() {
    this.formData.ctime = new Date().toISOString();
    // this.getDepartmentList();

    // 检测是否为跳页如果是请求工单数据
    let workId = localStorage.getItem("workId");
    if (!isNaN(workId)) {
      this.getWorkItem(workId);
    } else {
      workId = 0;
    }
  },
  mounted() {
    this.getDepartmentList();
  },
  methods: {
    ...mapActions(["updateIsClose"]),
    getWorkItem(id) {
      this.$api.comprehensiveAuthority
        .getWorkOrderItem(id)
        .then((res) => {
          this.formData = res.data;
          // 请求用户列表
          if (this.baseData.jurisdiction == 2) {
            this.getUserList();
          }
        })
        .catch((err) => console.log(err));
    },
    //发布工单
    addWorkItem() {
      this.$api.generalAuthority
        .createWorkOrderItem({
          did: this.formData.did,
          intro: this.formData.intro,
          content: this.formData.content,
          urgent: this.formData.urgent,
          remarks: this.formData.remarks,
          uidea: this.formData.uidea,
        })
        .then((res) => {
          if (res.status == 1) {
            this.visible.addWorkOrder = false;
            this.updateIsClose(false);
            this.$notification["success"]({
              message: `${res.msg}`,
            });
          } else {
            this.$notification["error"]({
              message: `${res.msg}`,
            });
          }
        })
        .catch((err) => {
          this.$notification["error"]({
            message: `异常错误:${err}`,
          });
        });
    },
    // 获取部门列表并刷新       a
    getDepartmentList() {
      this.$api.comprehensiveAuthority
        .getDepartmentList()
        .then((res) => {
          this.departmentList = res.data;
          this.key++;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    //获取主管对应的用户列表
    getUserList() {
      let data = {
        query: "%",
        page: 1,
        limit: 9999,
      };
      this.$api.advancedPermission
        .getUserList(data)
        .then((res) => {
          this.userList = res.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    //签核工单
    checkWorkOrderItem() {
      // 签核工单仅为员工提供
      this.$api.generalAuthority
        .subWorkOrderItem(this.formData.id, this.formData.idea)
        .then((res) => {
          if (res.status == 1) {
            this.visible.checkWorkOrder = false;
            this.updateIsClose(false);
            this.$notification["success"]({
              message: `${res.msg}`,
            });
          } else {
            this.$notification["error"]({
              message: `${res.msg}`,
            });
          }
        })
        .catch((err) => {
          this.$notification["error"]({
            message: `异常错误:${err}`,
          });
        });
    },
    // 分配到用户
    distribution() {
      this.$api.advancedPermission
        .checkWorkOrderItem({
          id: this.formData.id,
          eid: this.formData.eid,
          idea: this.formData.idea,
        })
        .then((res) => {
          if (res.status == 1) {
            this.visible.distribution = false;
            this.updateIsClose(false);
            this.$notification["success"]({
              message: `${res.msg}`,
            });
          } else {
            this.$notification["error"]({
              message: `${res.msg}`,
            });
          }
        })
        .catch((err) => {
          this.$notification["error"]({
            message: `异常错误:${err}`,
          });
        });
    },
    //评论工单
    startWorkOrderItem() {
      // alert(this.formData.start);
      // 评分系统触发,根据formdata中的wstatus判定为谁评论然后提交评论

      this.$api.comprehensiveAuthority
        .scoreWorkOrderItem({
          id: this.formData.id,
          start: this.formData.start,
          content: this.formData.content,
        })
        .then((res) => {
          if (res.status == 1) {
            this.visible.start = false;
            this.updateIsClose(false);
            this.$notification["success"]({
              message: `${res.msg}`,
            });
          } else {
            this.$notification["error"]({
              message: `${res.msg}`,
            });
          }
        })
        .catch((err) => {
          this.$notification["error"]({
            message: `异常错误:${err}`,
          });
        });
    },
  },
  computed: { ...mapGetters(["baseData", "isClose"]) },
};
</script>

<style lang="less" scoped>
.buttomList {
  margin-right: 0.2rem;
}
.ideaList {
  div {
    width: 12rem;
  }
}
</style>