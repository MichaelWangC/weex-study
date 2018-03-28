/*
 * 登录界面
 * by wangc
 */
<template>
  <div>
    <!-- 使用slider 为了保持Android图片在cover状态下 不过分放大 -->
    <slider class="login_bg" infinite="false">
      <div class="login_bg">
        <image class="login_bg" src="local:///login_bg" resize="cover"></image>
      </div>
    </slider>
    <div class="scroller" show-scrollbar="false">
      <div class="login_text_logo">
        <text class="text_logo">您的智能理财，</text>
        <text class="text_logo">从“建议书”开始！</text>
        <text class="text_eng_logo" style="margin-top:20px;">From one financial plan to a rich and</text>
        <text class="text_eng_logo">wonderful life</text>
      </div>

      <div class="login_input_view">
        <div class="login_input_cell">
          <image class="login_input_img" :src="require('@/images/login/icon_login_phone.png')"></image>
          <input class="login_input" type="number" placeholder="请输入手机号" @input="onMobilePhone"></input>
        </div>
        <div class="separator-line"></div>
        <div class="login_input_cell" style="margin-top:20px;">
          <image class="login_input_img" :src="require('@/images/login/icon_login_msg.png')"></image>
          <input class="login_input" type="number" @input="onPassword"></input>
          <text class="identify_code" @click="getCode">{{secondText}}</text>
        </div>
        <div class="separator-line"></div>
        <text class="login_btn" @click="login">登录</text>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      mobilePhone: "",
      password: "",
      secondText: "获取验证码",
      isReceieve: false
    }
  },
  methods: {
    getCode: function () {
      if (!this.mobilePhone || this.mobilePhone === "") {
        let modal = weex.requireModule('modal')
        modal.alert({
            message: '请输入手机号码'
        })
        return
      }
      if (this.isReceieve) return
      this.isReceieve = true
      let _this = this
      let leftSeconds = 60
      this.secondText = leftSeconds + "s" + "后重新获取"
      let inter = setInterval(function () {
        leftSeconds--
        _this.secondText = leftSeconds + "s" + "后重新获取"
        if (leftSeconds === 0) {
          _this.secondText = "获取验证码"
          _this.isReceieve = false
          clearInterval(inter)
        }
      }, 1000)
      // 请求短信
      // var http = weex.requireModule('http')
      // http.request({
      //   url: "",
      //   data: {
      //     phone: this.mobilePhone
      //   }
      // }, function(data) {
      //   console.log("smsSend", data)
      //   let retData = JSON.parse(data)
      //   if (retData.status != 200) {
      //     _this.secondText = "获取验证码"
      //     _this.isReceieve = false
      //     clearInterval(inter)
      //   }
      // })
    },
    onMobilePhone: function (event) {
      this.mobilePhone = event.value
    },
    onPassword: function (event) {
      this.password = event.value
    },
    login: function() {
      // 手机号码 校验
      // if (!this.mobilePhone || this.mobilePhone === "") {
      //   let modal = weex.requireModule('modal')
      //   modal.alert({
      //       message: '请输入手机号码'
      //   })
      //   return
      // }
      // // 验证码 校验
      // if (!this.password || this.password === "") {
      //   let modal = weex.requireModule('modal')
      //   modal.alert({
      //       message: '请输入验证码'
      //   })
      //   return
      // }
      let event = weex.requireModule("event")
      event.gotoMainTabbar()
    }
  },
  created() {
  }
}
</script>

<style style lang="less" scoped>
@import "~styles/variable.less";

.login_bg {
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
}

.scroller {
  align-items: center;
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
}

.login_text_logo {
  width: 650;
  margin-top: @weex-screen-width/4;
  align-items: center;
}

.text_logo {
  text-align: center;
  color: white;
  font-size: @text-font-size-superoutsize;
}

.text_eng_logo {
  text-align: center;
  color: white;
  font-size: @text-font-size-normal;
}

// 登录输入页
.login_input_view {
  min-height: 200px;
  width: 600px;
  position: absolute;
  bottom: 40;
  left: (750-600)/2;
}

.login_input_cell {
  flex-direction: row;
}

.login_input_img {
  width: 60px;
  height: 60px;
}

.login_input {
  flex: 1;
  height: 60px;
  margin-left: 30px;
  placeholder-color: white;
  color: white;
  font-size: @text-font-size-large;
}

.separator-line {
  flex: 1;
  height: 3px;
  background-color: white;
  margin-top: 20px;
  margin-bottom: 40px;
}

.identify_code {
  color: white;
  font-size: @text-font-size-large;
}

.login_btn {
  background-color: @common-default-blue;
  color: white;
  height: 100px;
  font-size: @text-font-size-large;
  text-align: center;
  line-height: 100px;
  border-radius: 50px;
  margin-top: 20px;
}

</style>