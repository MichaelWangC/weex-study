／**
* 消息单元格
**/
<template>
    <div class="cell" @click="readmore">
      <div style="head-cell">
          <div style="flex:1; flex-direction:row;">
              <text class="cell-title">{{title}}</text>
              <text class="date">{{date}}</text>
          </div>
          
          <div class="cell-separator-line"></div>
          <div style="flex:1; flex-direction:row;">
              <text class="cell-content">{{delHtmlContent}}</text>
              
          </div>
          <div style="flex-direction:row;">
              <text class="extend">...</text>
              <text class="read-more">查看全文></text>
          </div>
          <div style="margin-bottom:30px;"></div>
      </div>

    </div>
    
</template>

<script>
export default {
  data() {
    return {};
  },
  props: {
    title: { default: "" },
    date: { default: "" },
    content: { default: "" }
  },
  computed: {
    editDate: function() {
      // let time = this.date;
      // if (time.length > 10) {
      //   time = time.substring(0, 10);
      //   this.date = time;
      // }
      // return time;
    },
    delHtmlContent:function() {
        let string = this.content.replace(/<[^>]+>/g,"");
        this.content = string;
        return this.content;
    }
  },
  methods: {
    readmore() {
      var event = weex.requireModule("event");
      event.openURL("@/modules/mine/message/messageDetails.js?title=消息详情&msgTitle=" + encodeURI(this.title) + 
                                                                        "&msgDate=" + encodeURI(this.date) +
                                                                        "&msgContent=" + encodeURI(this.content));
    }
  }
};
</script>

<style lang="less" scoped>
@import "~styles/variable.less";

.head-cell {
  flex-direction: row;
}

// .scroller {
//     position: absolute;
//     top: 0;
//     bottom: 0;
//     left: 0;
//     right: 0;
//     flex-direction: column;
//     align-items: center;
// }

.cell-title {
  flex: 1;
  margin-left: 20px;
  margin-top: 30px;
  // width: @weex-screen-width - 160px - 120px;
  lines:1;
  // height: 50px;
  font-size: @text-font-size-normal;
}

.date {
  margin-top: 35px;
  margin-right: 30px;
  // width: 160px + 120px - 30px;
  text-align: right;
  color: @text-color-seg-gray;
  font-size: @text-font-size-supersmall;
}

@margin: 20px;
.cell-separator-line {
  margin-top: 30px;
  background-color: @separate-line-color;
  width: @weex-screen-width - @margin;
  height: 1px;
  margin-left: @margin;
}

.cell-content {
  margin-left: 20px;
  margin-top: 30px;
  line-height: 42px;
  width: @weex-screen-width - 40px;
  font-size: @text-font-size-small;
  color: @text-color-seg-gray;
  lines: 3;
  font-weight: lighter;
}

.extend {
  // margin-right: 120px;
  // margin-top: 125px;
  margin-left: 20px;
  width: @weex-screen-width - 40px - 150px;
  color: @text-color-seg-gray;
}

.read-more {
  margin-top: 15px;
  width: 150px;
  color: @common-theme-color;
  font-size: @text-font-size-supersmall;
}

.cell {
  flex-direction: row;
  //   align-items: center;
  //   justify-content: space-between;
  //   padding: px;
  background-color: white;
}
</style>



