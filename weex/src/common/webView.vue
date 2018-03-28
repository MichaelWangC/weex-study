
/**
* webView
* by sunny
*/

<template>
    <div>
        <web :src="webUrl" class="webview" @pagestart="start" @pagefinish="finish" @error="error"></web>
        <!-- 分享模板 -->
        <div class="share-view" v-if="showShare" @click="hideShareView">
            <div class="share-items">
                <div class="share-item" @click="shareWeChat">
                    <image class="share-icon" :src="require('@/images/icon_share_friend.png')"></image>
                    <text class="share-text">微信好友</text>
                </div>
            </div>
        </div>
        <div ref="progress" v-if="isShowProgress" class="progress"></div>
    </div>
</template>

<script>
import urlUtil from "@/utils/url-util.js"
import stringUrl from "@/utils/string-util.js"

const animation = weex.requireModule('animation')

  export default {
    data () {
      return {
        value: '',
        webUrl : '',
        showShare: false,
        couldShare: true,
        isShowLoading: false,
        isSendContent: false,
        sendType: "2",
        contentCode: "",
        isShowProgress: false,
        shareTitle: "",
        shareDescription: ""
      }
    },
    methods: {
      start (e) {
        // if (!this.isShowLoading) {
        //   this.isShowLoading = true
        //   let event = weex.requireModule('event')
        //   event.showLoadingStatus()
        // }
        // console.log("=========start==========", e)
        this.isShowProgress = true
        let progress = this.$refs.progress
        animation.transition(progress, {
          styles: {
            width: '200px',
          },
          duration: 800, //ms
          timingFunction: 'ease',
          needLayout:false,
          delay: 0 //ms
        }, function () {
          animation.transition(progress, {
            styles: {
              width: '600px',
            },
            duration: 2000, //ms
            timingFunction: 'ease',
            needLayout:false,
            delay: 0 //ms
          })
        })
      },
      finish (e) {
        let event = weex.requireModule('event')
        event.hideLoadingStatus()
        this.isShowLoading = false
        console.log("=========finish==========", e)

        let _this = this
        let progress = this.$refs.progress
        animation.transition(progress, {
          styles: {
            width: '750px',
          },
          duration: 800, //ms
          timingFunction: 'ease',
          needLayout:false,
          delay: 0 //ms
        }, function() {
          _this.isShowProgress = false
        })        
      },
      error (e) {
        let event = weex.requireModule('event')
        event.hideLoadingStatus()
        this.isShowLoading = false
        this.isShowProgress = false
        console.log("=========error==========", e)
      },
      // share
      hideShareView: function() {
        this.showShare = false;
      },
      shareWeChat: function() {
        let _this = this
        _this.showShare = false;
        
        if (this.isSendContent) {
          let event = weex.requireModule('event')
          event.showLoadingStatus()
          let http = weex.requireModule('http')
          http.request({
              url: "app/gaas/share/sendContent",
              data: {
                  contentCode: _this.contentCode,
                  contentType: _this.sendType
              }
          }, function(data) {
              console.log(data)
              event.hideLoadingStatus()
              let retData = JSON.parse(data)
              if (retData.status === 200) {
                  _this.sendToWeChart(retData.data)
              }
          })
        } else {
          _this.sendToWeChart()
        }
      },
      sendToWeChart: function(shareCode) {
        let title = urlUtil.getQueryString("title")
        title = decodeURI(title)

        this.shareTitle = urlUtil.getQueryString("shareTitle")
        this.shareTitle = decodeURI(this.shareTitle)
        if (stringUrl.isNull(this.shareTitle)) this.shareTitle = title

        this.shareDescription = urlUtil.getQueryString("shareDescription")
        this.shareDescription = decodeURI(this.shareDescription)
        if (stringUrl.isNull(this.shareDescription)) this.shareDescription = this.shareTitle

        let wechat = weex.requireModule('wechat')
        let shareUrl = this.webUrl
        if (typeof(shareCode) != "undefined" && shareCode != "") {
          if (shareUrl.indexOf("?") != -1) {
            shareUrl = this.webUrl + "&shareCode=" + shareCode
          } else {
            shareUrl = this.webUrl + "?shareCode=" + shareCode
          }
        }
        wechat.sendLinkContent(this.shareTitle, this.shareDescription, shareUrl)
      }
    },
    mounted() {
      let url = urlUtil.getQueryString("urlstr")

      let _this = this
      const storage = weex.requireModule('storage')
      let webUrl = ""
      let storageUrl = storage.getItem('urlstr', function(event) {
        if (event.data && event.data != "undefined" && event.data != "") {
          webUrl= event.data
          storage.removeItem("urlstr")
        } else {
          webUrl = decodeURI(url)
        }
        // 
        if (typeof(_this.contentCode) != "undefined" && _this.contentCode != "") {
          if (webUrl.indexOf("?") != -1) {
            webUrl = webUrl + "&infoCode=" + _this.contentCode
          } else {
            webUrl = webUrl + "?infoCode=" + _this.contentCode
          }
        }
        _this.webUrl = webUrl
        console.log(">>>>>>webUrl<<<<<<<<", webUrl)
      })

      let couldShare = urlUtil.getQueryString("couldShare")
      if (couldShare == "false") this.couldShare = false

      if (this.couldShare) {
        let _this = this
        const navbar = weex.requireModule('navbar')
        navbar.setNavRightButtonsWithImages(["icon_share"], function () {
          _this.showShare = !_this.showShare
        })
      }

      // 是否需要记录分享
      let isSendContent = urlUtil.getQueryString("isSendContent")
      if (isSendContent == "true") this.isSendContent = true
      if (this.isSendContent) {
        this.sendType = urlUtil.getQueryString("sendType")
        this.contentCode = urlUtil.getQueryString("contentCode")
      }
    }
  }
</script>

<style lang="less" scoped>
@import "~styles/variable.less";

.webview {
  flex:1;
}

/// 分享栏目
.share-view {
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    background-color: fade(#000000, 50%)
}

.share-items {
    position: absolute;
    bottom: 0;
    right: 0;
    left: 0;
    height: 250;
    background-color: white;
    justify-content: center;
}

@shareWidth: 750/4;
.share-item {
    height: @shareWidth;
    width: @shareWidth;
    margin-top: 40px;
    align-items: center;
    justify-content: center;
}

.share-icon {
    height: 120px;
    width: 120px;
}

.share-text {
    margin: 10px;
    font-size: @text-font-size-small;
    color: @text-default-color;
}

.progress {
  position: fixed;
  top: 0;
  left: 0;
  height: 2px;
  width: 0px;
  background-color: @common-default-blue;
}
    
</style>