/**
 */
<template>
  <div class="container">
      <text class="pop-btn-text">{{paramData}}</text>
      <div class="pop-btn" @click="popView">
          <text class="pop-btn-text">{{callbackWithParam?"回传参数":"返回上一页"}}</text>
      </div>
  </div>
</template>

<script>
import urlUtil from "@/utils/url-util.js"
import strUtil from "@/utils/string-util.js"

export default {
    data() {
        return {
            paramData: "默认参数",
            callbackWithParam: false
        }
    },
    methods: {
        popView() {
            let event = weex.requireModule("event")
            event.popPage()
            if (this.callbackWithParam) {
                let callback = new BroadcastChannel('callback')
                callback.postMessage({
                    info: "你好，我是回传的参数"
                })
            }
        }
    },
    mounted() {
        let paramData = urlUtil.getQueryString("paramData")
        console.log("paramData", paramData)
        if (!strUtil.isNull(paramData)) {
            this.paramData = decodeURI(paramData)
        }

        let callbackWithParam = urlUtil.getQueryString("callbackWithParam")
        if (callbackWithParam == "true") {
            this.callbackWithParam = true
        }
    }
}
</script>

<style lang="less" scoped>
@import "~styles/variable.less";

.container {
    justify-content: center;
    align-items: center;
    background-color: @common-default-yellow;
}

.pop-btn {
    width: 200px;
    height: 100px;
    background-color: @common-default-blue;
    margin-top: 20px;
    justify-content: center;
    align-items: center;
}

.pop-btn-text {
    font-size: @text-font-size-normal;
    color: white;
}

</style>
