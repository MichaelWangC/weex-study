<template>
  <div>
    <navpage dataRole="none" 
      :title="title" 
      :leftItemSrc="hasLeftItem?leftItemSrc:''"
      backgroundColor="#3399ff" 
      titleColor="white" 
      @naviBarLeftItemClick="naviBarLeftItemClick">
      <div class="app">
        <image class="img" :src="src"></image>
        <hello></hello>
      </div>
    </navpage>
  </div>
</template>

<script>
import hello from './components/Hello.vue'
import navpage from './components/navpage.vue'

export default {
  name: 'app',
  created: function () {
    const storage = weex.requireModule('storage')
    var _this = this
    storage.getItem("hasLeftItem", function (e) {
      if (e.data === "true") {
        _this.hasLeftItem = true
      }
      storage.removeItem("hasLeftItem")
    })
  },
  data() {
    return {
      title: '消息',
      leftItemSrc: require('./modules/home/images/icon_home_message.png'),
      src: "https://img.alicdn.com/tfs/TB1OOl1SVXXXXc_XVXXXXXXXXXX-340-340.png"
    }
  },
  components: {
    hello,
    navpage
  },
  props: {
    hasLeftItem: { default: false }
  },
  methods: {
    naviBarLeftItemClick: function (e) {
      var event = weex.requireModule('event')
      event.popPage()

      // 测试是否 本地存储是否删除
      const storage = weex.requireModule('storage')
      storage.getItem("hasLeftItem", function (e) {
        var modal = weex.requireModule('modal')
        modal.alert({
            message: e.data,
            duration: 0.3
        }, function (value) {
            console.log('alert callback', value)
        })
      })
    }
  }
}
</script>

<style scoped>
.app {
  align-items: center;
  padding-top: 200px;
}

.img {
  width: 340px;
  height: 340px;
}
</style>
