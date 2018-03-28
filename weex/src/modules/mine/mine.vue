<template>
    <div class="main_container">
        <image class="ming_bg" src="local:///icon_mine_bg"></image>
        <div class="scroller">
            <!-- <div v-if="headIcon === ''" class="head_circle" @click="mineSetting">
                <text class="customer_head_name">{{headName}}</text>
            </div> -->
            <image class="head_circle" @click="mineSetting" :src="headIcon" resize="cover"></image>
            <text class="customer_name">{{userName}}</text>
            <div class="customer_data_view">
                <div class="customer_data_text_view">
                    <text class="data_title">本月累计交易额</text>
                    <text class="data_value">{{balancemonthsum}}</text>
                </div>
                <div class="customer_data_text_view">
                    <text class="data_title">本月新增客户数</text>
                    <text class="data_value">{{custmonthsum}}</text>
                </div>
            </div>
            
            <!-- 事件按钮 -->
            <div class="event_view">
                <div class="event-item">
                    <text class="event-title">tab1</text>
                    <div class="badge-num" v-if="proposalNum != '0'">
                        <text class="badge-num-text">{{proposalNum}}</text>
                    </div>
                    
                </div>
                <div class="line-v"></div>
                <div class="event-item">
                    <text class="event-title">tab2</text>
                    <div class="badge-num" v-if="eventNum != '0'">
                        <text class="badge-num-text">{{eventNum}}</text>
                    </div>
                </div>
                <div class="line-v"></div>
                <div class="event-item" @click="showInteraction">
                    <text class="event-title">tab3</text>
                </div>
            </div>

            <scroller class="scroller1" show-scrollbar="false">
                <!-- 小工具 -->
                <div class="tool-view">
                    <div class="mine-cell">
                        <image class="cell-image" :src="require('@/images/mine/icon_tools.png')"></image>
                        <text class="cell-title">小工具</text>
                    </div>
                    <div class="cell-separator-line"></div>
                    <!-- tools -->
                    <div class="mine-tools">
                        <div class="mine-tool-item" @click="showCompanyIntro">
                            <image class="mine-tool-image" :src="require('@/images/mine/icon_tools_1.png')"></image>
                            <text class="mine-tool-text">彩蛋</text>
                        </div>
                        <div class="mine-tool-item">
                            <image class="mine-tool-image" :src="require('@/images/mine/icon_tools_2.png')"></image>
                            <text class="mine-tool-text">计算器</text>
                        </div>
                        <div class="mine-tool-item">
                            <image class="mine-tool-image" :src="require('@/images/mine/icon_tools_3.png')"></image>
                            <text class="mine-tool-text">收益试算</text>
                        </div>
                    </div>
                </div>

                <div class="mine-cell" style="margin-top:20px;" @click="message">
                    <image class="cell-image" :src="require('@/images/mine/icon_mine_message.png')"></image>
                    <text class="cell-title">消息</text>
                    <image class="img-list" :src="require('@/images/icon_list.png')"></image>
                </div>
                <div class="cell-separator-line"></div>
                <div class="mine-cell">
                    <image class="cell-image" :src="require('@/images/mine/icon_mine_feedback.png')"></image>
                    <text class="cell-title">反馈</text>
                    <image class="img-list" :src="require('@/images/icon_list.png')"></image>
                </div>
                <div class="cell-separator-line"></div>
                <div class="mine-cell" @click="setting">
                    <image class="cell-image" :src="require('@/images/mine/icon_setting.png')"></image>
                    <text class="cell-title">设置</text>
                    <image class="img-list" :src="require('@/images/icon_list.png')"></image>
                </div>
                <div style="margin-top:20px;"></div>
            </scroller>
        </div>
    </div>
</template>

<script>

import numberUtil from '@/utils/number-util.js'

export default {
  data () {
    return {
        headIcon: require('@/images/mine/icon_header.png'),
        userName: "李世民",
        proposalNum: "1,200",
        eventNum: "2",
        balancemonthsum: "11",
        custmonthsum: "2",
        mineBadge: 0
    };
  },
  computed: {
    headName: function() {
        let iconName = "?"
        if(this.userName && this.userName.length > 0) {
            iconName = this.userName.substring(0, 1)
        }
        return iconName
    }
  },
  watch: {
      mineBadge: function(val, oldval) {
        let tabbar = weex.requireModule("tabbar")
        tabbar.setMineTabbarbadge(val.toString())
      }
  },
  methods: {
    mineSetting() {
        var event = weex.requireModule('event')
        event.openURL("@/modules/mine/setting/mineMsg.js?title=个人信息")
    },
    message() {
        var event = weex.requireModule('event')
        event.openURL("@/modules/mine/message/msgList.js?title=消息")
    },
    setting() {
        var event = weex.requireModule('event')
        event.openURL("@/modules/mine/setting/settings.js?title=设置")
    }
  },
  mounted () {
    let _this = this
    // 头像
    let changeHeaderIcon = new BroadcastChannel('changeHeaderIcon')
    changeHeaderIcon.onmessage = function (event) {
        _this.headIcon = event.data.image
    }
    let imagePicker = weex.requireModule('imagePicker')
    let head = imagePicker.getHeaderIcon()
    if (typeof(head) !== 'undefined' && head != "") {
        _this.headIcon = head
    }
  }
};
</script>

<style scoped lang="less">
@import '~styles/variable.less';

.ming_bg {
    width: @weex-screen-width;
    height: 530;
}

.main_container {
    background-color: @common-background-color;
}

.scroller {
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    flex-direction: column;
    align-items: center;
}

.scroller1 {
    margin-top: 20px;
    position: relative;
    width: 750;
    top: 0;
    bottom: 0;
    flex-direction: column;
    align-items: center;
}

.head_circle {
    margin-top: 120px;
    height: 120px;
    width: 120px;
    border-radius: 60px;
    background-color: white;
    align-items: center;
    justify-content: center;
    border-style: solid;
    border-width: 4px;
    border-color: white;
}

.image_circle {
    height: 120px;
    width: 120px;
}

.customer_head_name {
    color: white;
    font-size: @text-font-size-small;
}

.customer_name {
    color: white;
    font-size: @text-font-size-large;
    margin-top: 20px;
}

.img-list {
    width: 40px;
    height: 40px;
    right: 10px;
}

// 相关交易销售数据
@margin: 20px;
.customer_data_view {
    width: @weex-screen-width - 2*@margin;
    height: 140px;
    margin-top: 2 * @margin;
    flex-direction: row;
    margin-left: @margin;
}

.customer_data_text_view {
    flex: 1;
}

.data_title {
    margin-left: 40px;
    font-size: @text-font-size-small;
    color: white;
}

.data_value {
    margin-left: 40px;
    margin-top: 10px;
    font-size: @text-font-size-superoutsize;
    color: white;
}

// 
.badge-num {
    position: absolute;
    right: (@weex-screen-width - 2*@margin)/3*0.1;
    top: 30px;
    width: 60px;
    height: 40px;
    border-radius: 20px;
    background-color: @common-default-red;
    color: white;
    text-align: center;
    align-items: center;
    justify-content: center;
}

.badge-num-text {
    max-width: 60px;
    color: white;
    margin-left: 10px;
    margin-right: 10px;
}

// 事件
.event_view {
    margin-top: @margin/2;
    width: @weex-screen-width - 2*@margin;
    height: 140px;
    background-color: white;
    border-radius: 5px;
    flex-direction: row;
    box-shadow: 0 3px 9px 0 rgba(0,0,0,0.04);
}

.event-item {
    flex: 1;
    align-items: center;
    justify-content: center;
    flex-direction: row;
}

.line-v {
    width: 1px;
    background-color: @separate-line-color;
}

.event-image {
    width: 50px;
    height: 50px;
}

.event-title {
    // margin-left: @margin;
    font-size: @text-font-size-normal;
    color: @text-default-color;
    font-weight: 600;
}

.tool-view {
    width: @weex-screen-width;
    min-height: 300px;
    background-color: white;
    // margin-top: @margin*2;
}

.mine-cell {
    flex-direction: row;
    height: 100px;
    width: @weex-screen-width;
    background-color: white;
    align-items: center;
}

.cell-image {
    width: 40px;
    height: 40px;
    margin-left: 20px;
}

.cell-title {
    font-size: @text-font-size-normal;
    margin-left: 20px;
    flex: 1;
    color: @text-color-seg-gray;
}

.cell-separator-line {
    background-color: @separate-line-color;
    width: @weex-screen-width - @margin;
    height: 1px;
    margin-left: @margin;
}

.mine-tools {
    flex-direction: row;
    height: 200px;
}

.mine-tool-item {
    flex: 1;
    align-items: center;
    justify-content: center;
}

.mine-tool-image {
    height: 100px;
    width: 100px;
}

.mine-tool-text {
    margin-top: 10px;
    color: @text-color-seg-gray;
    font-size: @text-font-size-small;
}

</style>