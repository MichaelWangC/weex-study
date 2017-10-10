import Vue from 'vue'
import weex from 'weex-vue-render'
weex.init(Vue)

import App from './index.vue'
App.el = '#root'
new Vue(App)
