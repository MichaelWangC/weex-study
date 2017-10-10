<template>
  <div>
      <!-- <h1>hello!</h1>
      <hello></hello> -->
    <navpage 
      dataRole="none" 
      :title="title" 
      backgroundColor="#3399ff" 
      titleColor="white">
      <mytabbar :tabItems="tabItems" selectedColor="#3399ff" @tabBarOnClick="tabBarOnClick"></mytabbar>
    </navpage>
  </div>
</template>

<script>
import mytabbar from './components/tabbar.vue'
import navpage from './components/navpage.vue'
import hello from './components/Hello.vue'

var getBaseURL = require('./utils/base-url.js').getBaseURL

module.exports = {
  data: function() {
    return {
      title: "首页",
      tabItems: [
        {
          index: 0,
          title: '首页',
          titleColor: '#000000',
          icon: '',
          image: require('./assets/images/home/icon_home_unselected.png'),
          selectedImage: require('./assets/images/home/icon_home_selected.png'),
          src: 'modules/home/home.js',
          visibility: 'visible',
        },
        {
          index: 1,
          title: '产品',
          titleColor: '#000000',
          icon: '',
          image: require('./assets/images/home/icon_product_unselected.png'),
          selectedImage: require('./assets/images/home/icon_product_selected.png'),
          src: 'App.js',
          visibility: 'hidden',
        },
        {
          index: 2,
          title: '我的',
          titleColor: '#000000',
          icon: '',
          image: require('./assets/images/home/icon_mine_unselected.png'),
          selectedImage: require('./assets/images/home/icon_mine_selected.png'),
          src: 'App.js',
          visibility: 'hidden',
        }
      ],
    }
  },
  components: {
    mytabbar,
    navpage,
    hello
  },
  created: function() {
    for (var i = 0; i < this.tabItems.length; i++) {
      var tabItem = this.tabItems[i]
      var baseURL = getBaseURL(tabItem.src)
      tabItem.src = baseURL
    }
  },
  methods: {
    tabBarOnClick: function(e) {
      console.log('tabBarOnClick', e.index)
      // 更改标题
      if (e.index === 0) {
        this.title = "首页"
      } else if (e.index === 1) {
        this.title = "产品"
      } else if (e.index === 2) {
        this.title = "我的"
      }
    }
  }
}
</script>