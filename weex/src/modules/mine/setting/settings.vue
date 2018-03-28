／**
*
* by sunny
**/
<template>

  <div class="container">

    <div class="section"></div>
    <div class="cell">
      <div class="item-align">
        <image class="img" :src="require('@/images/mine/setting/secret.png')"></image>
        <text class="cell-title">使用手势密码</text>
      </div>
      <div class="item-align">
        <switch :checked="useGestureLock" @change="gestureLockChange"></switch>
        <!-- <image class="img-list" :src="require('@/images/icon_list.png')"></image> -->
      </div>
    </div>
    <div class="section-white"><div class="line"></div></div>
    <div class="cell" @click="setGesturePassword" v-if="useGestureLock">
      <div class="item-align">
        <image class="img" :src="require('@/images/mine/setting/gesture.png')"></image>
        <text class="cell-title">修改手势密码</text>
      </div>
      <div class="item-align">
        <image class="img-list" :src="require('@/images/icon_list.png')"></image>
      </div>
    </div>

    <div class="section"></div>
    <div class="cell">
      <div class="item-align">
        <image class="img" :src="require('@/images/mine/setting/customer_service.png')"></image>
        <text class="cell-title">联系客服</text>
      </div>
      <div class="item-align">
        <text class="num-phone">hello-rich</text>
        <image class="img-list" :src="require('@/images/icon_list.png')"></image>
      </div>
    </div>
    <div class="section-white"><div class="line"></div></div>
    <div class="cell">
      <div class="item-align">
        <image class="img" :src="require('@/images/mine/setting/hope.png')"></image>
        <text class="cell-title">许愿池</text>
      </div>
      <div class="item-align">
        <image class="img-list" :src="require('@/images/icon_list.png')"></image>
      </div>
    </div>

    <div class="section"></div>
    <div class="cell">
      <div class="item-align">
        <image class="img" :src="require('@/images/mine/setting/customer_service.png')"></image>
        <text class="cell-title">新手攻略</text>
      </div>
      <div class="item-align">
        <image class="img-list" :src="require('@/images/icon_list.png')"></image>
      </div>
    </div>
    <div class="section-white"><div class="line"></div></div>
    <div class="cell">
      <div class="item-align">
        <image class="img" :src="require('@/images/mine/setting/hope.png')"></image>
        <text class="cell-title">公司简介</text>
      </div>
      <div class="item-align">
        <image class="img-list" :src="require('@/images/icon_list.png')"></image>
      </div>
    </div>
    <div class="section-white"><div class="line"></div></div>
    <div class="cell">
      <div class="item-align">
        <image class="img" :src="require('@/images/mine/setting/hope.png')"></image>
        <text class="cell-title">微信</text>
      </div>
      <div class="item-align">
        <image class="img" :src="require('@/images/mine/setting/code.png')"></image>
        <image class="img-list" :src="require('@/images/icon_list.png')"></image>
      </div>
    </div>
    
    <div class="section"></div>
    <div class="cell">
      <div class="item-align">
        <image class="img" :src="require('@/images/mine/setting/about.png')"></image>
        <text class="cell-title">版本</text>
      </div>
      <div class="item-align">
        <image class="img-list" :src="require('@/images/icon_list.png')"></image>
      </div>
    </div>

    <text class="leave" @click="loginOut">退出登陆</text>

  </div>
  

</template>

<script>

  export default {
      data () {
        return {
          useGestureLock: false
        }
      },
      methods: {
        loginOut: function() {
          let modal = weex.requireModule('modal')
          modal.confirm({
              message: '确定退出当前账号吗?',
              okTitle: "退出",
              cancelTitle: "取消"
          }, function (value) {
              if (value === "退出") {
                let http = weex.requireModule("http")
                http.doLogout()
              }
          })
        },
        setGesturePassword: function() {
          let event = weex.requireModule('event')
          // type: new 新增、modify 修改、lock 解锁、loginNew 登录成功设置密码
          event.openURL("@/modules/front/gestureLock.js?navBarIsClear=true&backButtonType=BackButtonTypeWhite&type=modify")
        },
        // 使用手势密码
        gestureLockChange(event) {
          let _this = this
          let userInfo = weex.requireModule('userInfo')
          if (event.value) {
            // 广播监听手势密码设置
            let gestureLockChange = new BroadcastChannel('gestureLockChange')
            gestureLockChange.onmessage = function (event) {
                _this.useGestureLock = true
            }
            _this.useGestureLock = false
            // 设置手势密码
            let push = weex.requireModule('event')
            // type: new 新增、modify 修改、lock 解锁、loginNew 登录成功设置密码
            push.openURL("@/modules/front/gestureLock.js?navBarIsClear=true&backButtonType=BackButtonTypeWhite&type=new")
          } else {
            // 清除手势密码
            this.useGestureLock = false
            userInfo.setGestureLockBoolean("false")
          }
        }
      },
      created() {
        let userInfo = weex.requireModule('userInfo')
        this.useGestureLock = userInfo.getGestureLockBoolean()
      }
    }
  
</script>

<style lang="less" scoped>
@import "~styles/variable.less";

.container {
  background-color: @common-background-color;
}

.section-white {
  // height: 20px;
  height: 2px;
  background-color: white;
}

.section {
  background-color: @common-background-color;
  height: 20px;
}

.cell {
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 30px;
  background-color: white;
}

.cell-title {
  margin-left: 15px;
  font-size: @text-font-size-small;
  color: @text-color-seg-gray;
}

.line {
  height: 2px;
  background-color:@separate-line-color1;
  margin-left: 30px;
}

.item-align{
  flex-direction: row;
  align-items: center;
}

.img {
  width: 55px;
  height: 55px;
} 

.img-list {
  width: 35px;
  height: 35px;
}

.num-phone {
  color: @common-default-orange;
  font-size: @text-font-size-small;
  font-weight: bold;
  margin-right: 0px;
}

.num-cache {
  color: @text-default-color;
  font-size: @text-font-size-small;
  font-weight: bold;
  margin-right: 0px;
}

.leave {
  position: absolute;
  margin-left: 40px;
  width: 670px;
  height: 100px;
  bottom: 50;
  color: @common-theme-color;
  border-style: solid;
  border-color: @common-theme-color;
  border-width: 2px;
  border-radius: 50px;
  font-size: @text-font-size-normal;
  line-height: 96px;
  text-align: center;
}

.wechat-code {
  position: absolute;
  top: 0px;
  bottom: 0px;
  left: 0px;
  right: 0px;
  justify-content: center;
  align-items: center;
  // background-color: @common-background-color;
  background-color: rgba(102,102,102, 0.8);
}

.img-code {
  width: 450px;
  height: 450px;
}

</style>