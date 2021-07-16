// 防抖
export default {

    debounce(func, time) {
        if (this.timeout) clearTimeout(this.timeout);
        this.timeout = setTimeout(() => {
            func();
        }, time);
    },
    // 节流
    throttle(fn, interval = 200) {
        var last;
        var timer;
        // var interval = interval || 200;
        return function() {
            var th = this;
            var args = arguments;
            var now = +new Date();
            if (last && now - last < interval) {
                clearTimeout(timer);
                timer = setTimeout(function() {
                    last = now;
                    fn.apply(th, args);
                }, interval);
            } else {
                last = now;
                fn.apply(th, args);
            }
        }
    }
}