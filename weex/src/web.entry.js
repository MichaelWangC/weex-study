import Vue from 'vue'
import weex from 'weex-vue-render'
weex.init(Vue)

import App from './index.vue'
new Vue({
    el: '#root',
    render: h => h(App)
})
