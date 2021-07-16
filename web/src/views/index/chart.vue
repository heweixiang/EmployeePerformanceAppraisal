<template>
  <!-- 人数比例图   前十列表 -->
  <!-- 男女比例图   start列表 -->
  <div>
    <a-row>
      <a-col :xs="24" :sm="24" :md="24" :lg="12" :xl="12" :xxl="12">
        <div id="chart" style="width: 100%; height: 10rem"></div>
      </a-col>
      <a-col :xs="24" :sm="24" :md="24" :lg="12" :xl="12" :xxl="12">
        <a-table
          :columns="columns"
          :rowKey="
            (record, index) => {
              return index;
            }
          "
          :data-source="tableData"
        >
          <span slot="sex" slot-scope="sex">
            {{ sex == 0 ? "女" : "男" }}
          </span>
        </a-table>
      </a-col>
    </a-row>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
let echarts = require("echarts");

export default {
  setup() {
    return {};
  },
  data() {
    return {
      tableData: null,
      columns: null,
    };
  },
  created() {
    //   获取基础图表数据
    this.getChartData();
  },
  methods: {
    createdTable(data) {
      // 取前十条
      if (data.length > 10) {
        data = data.splice(10);
      }
      if (this.baseData.jurisdiction == 0) {
        this.columns = [
          {
            title: "部门ID",
            dataIndex: "did",
            key: "did",
          },
          {
            title: "部门名称",
            dataIndex: "departmentname",
            key: "departmentname",
          },
          {
            title: "员工数量",
            dataIndex: "counte",
            key: "counte",
          },
          {
            title: "总start",
            dataIndex: "countstart",
            key: "countstart",
          },
        ];
      } else {
        this.columns = [
          {
            title: "员工ID",
            dataIndex: "id",
            key: "id",
          },
          {
            title: "员工姓名",
            dataIndex: "name",
            key: "name",
          },
          {
            title: "员工性别",
            dataIndex: "sex",
            key: "sex",
            scopedSlots: { customRender: "sex" },
          },
          {
            title: "总start",
            dataIndex: "estart",
            key: "estart",
          },
        ];
      }
      this.tableData = data;
    },
    //   获取图表数据
    getChartData() {
      /** 权限 0 admin  1 user  2 manager  3 employee  -1 账号冻结-->
       *  */

      this.$api.advancedPermission
        .getChartData()
        .then((res) => {
          this.createChart(res.data);
          this.createdTable(res.data);
        })
        .catch((err) => {
          console.log(err);
        });
    }, // 创建图表
    createChart(res) {
      let _this = this;
      let data = [];
      // 遍历将res封装成data中需要的格式
      for (const item of res) {
        if (this.baseData.jurisdiction == 0) {
          data.push({
            value: [item.countstart, item.counte],
            name: item.departmentname,
          });
        } else {
          data.push({
            value: [item.estart, item.sex == 0 ? "女" : "男"],
            name: item.name,
          });
        }
      }

      let myChart = echarts.init(document.getElementById("chart"));
      myChart.setOption({
        title: {
          text: "各部门数据统计",
          subtext: "start",
          left: "center",
        },
        tooltip: {
          trigger: "item",
          formatter: function (data) {
            data = data.data;
            if (_this.baseData.jurisdiction == 0) {
              return `部门名称：${data.name}<br/>总评分：${data.value[0]}<br/>总人数：${data.value[1]}`;
            } else {
              return `姓名：${data.name}<br/>总评分：${data.value[0]}<br/>性别：${data.value[1]}`;
            }
          },
          axisPointer: {
            type: "shadow",
          },
        },
        legend: {
          orient: "vertical",
          left: "left",
        },
        series: [
          {
            name: "name",
            type: "pie",
            radius: ["40%", "70%"],
            data,
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: "rgba(0, 0, 0, 0.5)",
              },
            },
          },
        ],
      });
    },
  },
  computed: { ...mapGetters(["baseData"]) },
};
</script>

<style lang="scss" scoped>
</style>