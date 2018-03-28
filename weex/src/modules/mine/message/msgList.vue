／**
* 消息模块
* by longlw
**/
<template>

  <div class="container">

    <list show-scrollbar="false">
      <refresh-header  @refresh="onrefresh" :display="refreshing ? 'show' : 'hide'">
      </refresh-header>

      <cell v-for="(item,index) in messageList">
          <div class="section"></div>
          <message-cell :content="item.content" :title="item.title" :date="item.releaseTime">
          </message-cell>
      </cell>

      <cell v-if="isNoData">
        <no-data-view>
        </no-data-view>
      </cell>
    </list>

  </div>

</template>

<script>
import MessageCell from "./messageCell.vue"
import refreshHeader from '@/common/refreshHeader.vue'
import refreshFooter from '@/common/refreshFooter.vue'
import noDataView from "@/common/noDataView.vue"

const event = weex.requireModule('event')

export default {
  data() {
    return {
      messageList: [],
      pageNumber:1,
      pageSize:5,
      refreshing: false,
      loadinging: false,
      showFooter: true,
      isNoData:false
    };
  },
  props: {},
  components: {
    MessageCell,
    refreshHeader,
    refreshFooter,
    noDataView
  },
  mounted() {
    this.getMessageList(this.pageNumber);
    event.showLoadingStatus()
    setTimeout(() => {
      event.hideLoadingStatus()
    }, 2000);
  },
  methods: {
    getMessageList(pageSum) {
      this.messageList = [{
        releaseTime: "2018-02-09 12:08:33",
        content: "contentcontentcontentcontentcontentcontent",
        title: "titletitletitle"
      },{
        releaseTime: "2018-02-09 12:08:33",
        content: "contentcontentcontentcontentcontentcontent",
        title: "titletitletitle"
      },{
        releaseTime: "2018-02-09 12:08:33",
        content: "contentcontentcontentcontentcontentcontent",
        title: "titletitletitle"
      }]
    },
    onrefresh (event) {
      this.refreshing = true
      this.pageNumber = 1
      let _this = this
      setTimeout(() => {
        _this.refreshing = false
      }, 4000);
    },
    onloading () {
      this.loadinging = true
      this.pageNumber ++ 
    }
  }
};
</script>

<style lang="less" scoped>
@import "~styles/variable.less";

.container {
  background-color: @common-background-color;
}

.section {
  background-color: @common-background-color;
  height: 20px;
}
</style>
