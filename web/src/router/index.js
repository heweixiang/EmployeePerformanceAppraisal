import Vue from "vue";
import VueRouter from "vue-router";

Vue.use(VueRouter);
// 默认主页重定向为order因为chart不是每个人都有
const routes = [{
        path: "/",
        name: "index",
        redirect: '/order'
    },
    {
        path: '/index',
        name: 'index',
        redirect: '/order'
    },
    {
        path: "/nav",
        name: "nav",
        component: () =>
            import ( /* webpackChunkName: "nav" */ "../components/Nav.vue"),
    }, {
        path: "/login",
        name: "login",
        component: () =>
            import ( /* webpackChunkName: "login" */ "../views/login.vue"),
    }, {
        path: "/chart",
        name: "chart",
        component: () =>
            import ( /* webpackChunkName: "chart" */ "../views/index/chart.vue"),
    }, {
        path: "/order",
        name: "order",
        component: () =>
            import ( /* webpackChunkName: "order" */ "../views/index/order.vue"),
    }, {
        path: "/userList",
        name: "userList",
        component: () =>
            import ( /* webpackChunkName: "userList" */ "../views/index/userList.vue"),
    }, {
        path: "/department",
        name: "department",
        component: () =>
            import ( /* webpackChunkName: "department" */ "../views/index/department.vue"),
    },
];

const router = new VueRouter({
    // mode: "history",
    base: process.env.BASE_URL,
    routes,
});

export default router;

// , {
//     path: "/orderItem",
//     name: "orderItem",
//     component: () =>
//         import ("../views/index/orderItem.vue"),
// }