／**
* 消息详情
* by longlw
**/
<template>
  <div>
    <image class="bg-view" src="local:///msg_detail_bg"></image>
    <div class="div-title">
          <text class="title">{{msgTitle}}</text>
          <text class="date">{{date}}</text>
    </div>
    <scroller class="content-scroller" show-scrollbar="false">
          <text class="content">{{content}}</text>
    </scroller>
  </div>
  
</template>

<script>
import urlUtil from "@/utils/url-util.js";

export default {
    data() {
    return {};
  },
  props: {
    msgTitle: { default: "" },
    date: { default: "" },
    content: { default: "" }
  },
  mounted() {
    let msgTitle = urlUtil.getQueryString("msgTitle");
    let msgDate = urlUtil.getQueryString("msgDate");
    let msgContent = urlUtil.getQueryString("msgContent");

    this.msgTitle = decodeURI(msgTitle);
    this.date = decodeURI(msgDate);
    this.content = decodeURI(msgContent);
  }
}
</script>

<style style lang="less" scoped>
@import "~styles/variable.less";

.bg-view {
    width: 750;
    height: 750*2.38;
}

.div-title {
    position: absolute;
    top: 54px;
    left: 27px;
    // line-height: 32px;
    width: @weex-screen-width - 230px;
    // bottom: 80px;
}

.title {
    font-weight: bold;
    color: white;
    lines:2;
    font-size: @text-font-size-outsize;
}

.date {
    margin-top: 8px;
    // margin-left: 27px;
    margin-right: 200px;
    color: white;
    font-size: @text-font-size-supersmall;
}

.content-scroller {
    position: absolute;
    top: 268px;
    // margin-top: 144px;
    left: 88px;
    bottom: 60px;
    width: @weex-screen-width - 80px * 2;
}

.content {
    // margin-top: 144px;
    // margin-left: 88px;
    // margin-bottom: 60px;
    // width: @weex-screen-width - 88px * 2;
    color:@text-color-seg-gray;
    font-size: @text-font-size-normal;
}

</style>
