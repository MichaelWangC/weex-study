/**
* 
*/
<template>
  <div>
    <list class="list">
      <cell class="separator-line"></cell>
      <cell v-for="(item, i) in dataList" @click="clickShow(item.eventID)">
        <div class="list-cell">
          <text>{{item.title}}</text>
        </div>
        <div class="separator-line"></div>
      </cell>
    </list>
  </div>
</template>
<script>
  

  export default {
    data () {
      return {
        dataList: [{
          title: "页面跳转",
          eventID: "1"
        },{
          title: "传参到下一页",
          eventID: "2"
        },{
          title: "参数回传",
          eventID: "3"
        },{
          title: "导航栏透明",
          eventID: "4"
        },{
          title: "导航栏隐藏",
          eventID: "5"
        }]
      }
    },
    methods: {
      clickShow(eventID) {
        let event = weex.requireModule("event")
        
        if (eventID == 1) {
          // 页面跳转
          event.openURL("@/modules/financial/showDetail.js?title=页面跳转")
        } else if (eventID == 2) {
          // 传参到下一页
          event.openURL("@/modules/financial/showDetail.js?title=页面跳转&paramData=我是上一页的参数")
        } else if (eventID == 3) {
          // 参数回传
          event.openURL("@/modules/financial/showDetail.js?title=页面跳转&paramData=我是上一页的参数&callbackWithParam=true")

          let callback = new BroadcastChannel("callback")
          callback.onmessage = event => {
            if (event.data != null) {
              let modal = weex.requireModule('modal')
              modal.alert({
                  message: event.data.info
              }, function (value) {
                  console.log('alert callback', value)
              })
            }
            callback.close()
          }

        } else if (eventID == 4) {
          // 导航栏透明
          event.openURL("@/modules/financial/showDetail.js?title=页面跳转&paramData=导航栏透明&navBarIsClear=true")
        } else if (eventID == 5) {
          // 导航栏隐藏
          event.openURL("@/modules/financial/showDetail.js?title=页面跳转&paramData=导航栏隐藏&isHiddenNavBar=true")
        }

      }
    },
    mounted() {
    }
  }

</script>

<style lang="less" scoped>
@import "~styles/variable.less";

.list {
  background-color: @common-background-color;
}

.list-cell {
  background-color: wheat;
  height: 200px;
  width: 750px;
  justify-content: center;
  align-items: center;
}

.separator-line {
  height: 20px;
  background-color: @common-background-color;
  width: 750px;
}

</style>