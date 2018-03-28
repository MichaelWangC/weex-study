
/**
* 首页
* by sunny
*/

<template>
    <div>
        <list show-scrollbar="false">
            <refresh-header  @refresh="onrefresh" :display="refreshing ? 'show' : 'hide'">
            </refresh-header>
            <cell>
                <slider style="width: 750px;height: 408px;" infinite="true" interval="3000" auto-play="true">
                    <div v-for="(item, i) in bannerList">
                        <image style="width: 750px;height: 408px;" 
                        resize="cover"
                        :src="item.imgUrl"  @click="bannerClick(i)"
                        :placeholder="require('@/images/icon_no_image.png')">
                        </image>
                    </div>
                    <indicator class="indicator"></indicator>
                </slider>
                <div class="div-title">
                    <text class="text-title1">财经百事通</text>
                    <text class="text-title2">最新 / 市场行情早知道</text>
                </div>
                <div class="seperator-line"></div>
            </cell>
            <cell class="cell" v-for="(msg, i) in msgList" @click="clickDetails(i)">
                <div class="cell-div-img">
                    <div class="cell-img">
                        <text class="text-title" lines="2">{{msg.title}}</text>
                        <div class="div-other-msg">
                            <image class="top-image" :src="require('@/images/home/icon_information_fire.png')"></image>
                            <text class="text-source">{{msg.infoRef}}</text>
                            <text class="text-date">{{msg.releaseTime}}</text>  
                        </div>
                    </div>
                    <image class="img" :src="msg.imgUrl" resize="cover" :placeholder="require('@/images/icon_no_image.png')"></image>              
                </div>
                <div class="line-view"></div>
            </cell>
        </list>
  </div>
</template>


<script>

import urlUtil from '@/utils/url-util.js'
import refreshHeader from '@/common/refreshHeader.vue'

export default {
    data() {
        return {
            refreshing: false,
            loadinging: false,
            msgList: [{
                title: "资讯标题",
                infoRef: "网易新闻",
                releaseTime: "一小时前",
                imgUrl: "local:///home_banner"
            },{
                title: "资讯标题",
                infoRef: "网易新闻",
                releaseTime: "一小时前",
                imgUrl: require('@/images/home/banner.png')
            },{
                title: "资讯标题",
                infoRef: "网易新闻",
                releaseTime: "一小时前",
                imgUrl: "local:///home_banner"
            }],
            bannerList: [{
                imgUrl: "local:///home_banner"
            },{
                imgUrl: require('@/images/home/banner.png')
            }]
        }
    },
    components: {
        refreshHeader
    },
    methods: {
        onrefresh (event) {
            this.pageNumber = 1
            this.refreshing = true
            let _this = this
            setTimeout(() => {
                _this.refreshing = false
            }, 3000);
        },
        onloading () {
            this.pageNumber ++
            this.loadinging = true
            setTimeout(() => {
                _this.loadinging = false
            }, 1500);
        },
        bannerClick(index) {
            let modal = weex.requireModule('modal')
            modal.alert({
                message: 'click banner index:'+index
            }, function (value) {
                console.log('alert callback', value)
            })
        },
        clickDetails(index) {
            let modal = weex.requireModule('modal')
            modal.alert({
                message: 'click list index:'+index
            }, function (value) {
                console.log('alert callback', value)
            })
        }
    },
    created: function() {

    }
}
</script>

<style lang="less" scoped>
@import "~styles/variable.less";

    .indicator {
        width: 750px;
        height: 408px;
        item-color: @separate-line-color;
        item-selected-color: white;
        item-size: 10px;
        position: absolute;
        top: 168px;
    }

    .div-title {
        flex: 1;
        flex-direction: row;
        height: 80px;
        align-items: flex-end;
        margin-bottom: 30px;
    } 
    
    .text-title1 {
        margin-left: 30px;
        color: @text-default-color;
        font-size: @text-font-size-superlarge; 
        font-weight: 700;
    }

    .text-title2 {
        flex: 1;
        margin-left: 30px;
        color: @text-color-gray;
        font-size: @text-font-size-small;
        text-align: left;
    }

    .seperator-line {
        background-color: @separate-line-color;
        height: 1px;
        width: 750px;
    }
    
    .text-more {
        color: @text-default-color;
        font-size: @text-font-size-small;
        text-align: right;
        margin-right: 20px;
    }

    .item-div {
        margin: 0px 15px;
        background-color: yellow;
    }

  .cell {
    height: 210px;
    // min-height: 180px;
    // border-bottom-style: solid;
    // border-bottom-width: 1;
    // border-bottom-color: @separate-line-color;
  }

  .cell-div {
    flex: 1;
    margin: 20px;
    justify-content: center;
  }

 .cell-img {
     flex: 1;
    justify-content: center;
    height: 140px;
 }

  .text-title {
    position: absolute;
    left: 10px;
    top: 0px;
    right: 20px;
    // margin-bottom: 20px;
    color: @text-default-color;
    font-size: @text-font-size-normal; 
  }

  .text-title-noimg {
    position: absolute;
    left: 10px;
    // right: 10px;
    top: 15px;
    // margin-bottom: 20px;
    width: @weex-screen-width - 40px;
    color: @text-default-color;
    font-size: @text-font-size-normal; 
  }

  .div-other-msg {
    position: absolute;
    left: 10px;
    right: 10px;
    bottom: 0px;
    // margin-left: 10px;
    flex-direction: row;
    // margin-top: 20px;
    // margin-bottom: 30px;
    align-items: center;
  }

  .div-other-msg-noimg {
    position: absolute;
    left: 10px;
    right: 10px;
    bottom: 15px;
    flex-direction: row;
    align-items: center;
  }

  .text-source {
    color: @text-color-gray;
    font-size: @text-font-size-supersmall;
    margin-right: 20px;
    margin-bottom: 2px;
  }
  
  .text-date {
    left: 20px;
    color: @text-color-gray;
    font-size: @text-font-size-supersmall;
    bottom: 2px;
  }

  .loading-text {
    margin-top: 20px;
    width: 750px;
    text-align: center;
  }

  .cell-div-img {
    flex: 1;
    // margin: 30px;
    margin-left: 20px;
    margin-top: 30px;
    margin-right: 30px;
    margin-bottom: 30px;
    flex-direction: row; 
    align-items: center;
  }
  
  .img {
    width: 200px;
    height: 140px;
    border-radius: 5px;
  }

  .line-view {
      height: 1px;
      background-color: @separate-line-color;
      margin-left: 30px;
  }

  .top-image {
      width: 20px;
      height: 20px;
      margin-right: 10px;
  }

</style>