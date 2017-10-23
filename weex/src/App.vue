<template>
  <div>
    <navpage dataRole="none" 
      :title="title" 
      :showBackItem="showBackItem"
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
    let _this = this

    console.log('============created============')
    const bus = new BroadcastChannel("hasLeftItem")
    bus.onmessage = function (event) {
      if (event.data === "true") {
        _this.showBackItem = true
      }
      bus.close()
    }
  },
  data() {
    return {
      title: '消息',
      showBackItem: false,
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
