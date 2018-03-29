／**
*
**/
<template>

	<div class="container">

    <div class="section"></div>
		<div class="cell1" @click="imagePicker">
      <text class="cell-title">头像</text>
      <div class="item-align">
        <image class="img-head" :src="imgSrc"></image>
        <image class="img-list" :src="require('@/images/icon_list.png')"></image>
      </div>
    </div>
    <div class="section-white"><div class="line"></div></div>
    <div class="cell">
      <text class="cell-title">姓名</text>
      <div class="item-align">
        <text class="cell-right">{{userName}}</text>
        <image class="img-list" :src="require('@/images/icon_list.png')"></image>
      </div>
    </div>

    <div class="section"></div>
    <div class="cell">
      <text class="cell-title">个人简介</text>
      <div class="item-align">
        <text class="owner-sign">{{memo}}</text>
        <image class="img-list" :src="require('@/images/icon_list.png')"></image>
      </div>
    </div>
    <div class="section-white"><div class="line"></div></div>
    <div class="cell">
      <text class="cell-title">手写签名</text>
      <div class="item-align">
        <text class="text-sign">{{userName}}</text>
        <image class="img-list" :src="require('@/images/icon_list.png')"></image>
      </div>
    </div>
    <div class="section-white"><div class="line"></div></div>
    <div class="cell1">
      <text class="cell-title">微信二维码</text>
      <div class="item-align">
        <image class="img" :src="require('@/images/mine/setting/code.png')"></image>
        <image class="img-list" :src="require('@/images/icon_list.png')"></image>
      </div>
    </div>
    
    <div class="section"></div>
    <div class="cell">
      <text class="cell-title">手机号</text>
      <div style="flex-direction: row;">
        <text class="cell-right">{{mPhone}}</text>
        <image class="img-list" :src="require('@/images/icon_list.png')"></image>
      </div>
    </div>

	</div>

</template>

<script>

	export default {
      data () {
      	return {
          imgSrc: require('@/images/mine/icon_header.png'),
          userName: "",
          mPhone: "",
          memo:""
        }
      },
      components: {

      },
      methods: {
        imagePicker: function () {
          let imagePicker = weex.requireModule('imagePicker')
          let _this = this
          imagePicker.pushHeaderImagePickerController(function(image) {
            // console.log('>>>>>>>>><<<<<<<<<<<<'+image)
            _this.imgSrc = image
            let changeHeaderIcon = new BroadcastChannel('changeHeaderIcon')
            changeHeaderIcon.postMessage({
              image: image
            })
          })
        }
      },
      mounted() {
        // 获取用户信息
        let userInfo = weex.requireModule('userInfo')
        this.userName = userInfo.getUserName()
        this.mPhone = userInfo.getMobilePhone()
        this.memo = userInfo.getUserMemo()
        // 头像
        let imagePicker = weex.requireModule('imagePicker')
        let head = imagePicker.getHeaderIcon()
        console.log("imgSrc",head)
        if (typeof(head) !== 'undefined' && head != "") {
          this.imgSrc = head
        }
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

.cell1 {
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 20px 30px;
  background-color: white;
}

.cell-title {
  font-size: @text-font-size-small;
  color: @text-color-seg-gray;
}

.img-head {
  width: 80px;
  height: 80px;
}

.line {
  height: 2px;
  background-color:@separate-line-color1;
  margin-left: 30px;
}

.cell-right {
  font-size: @text-font-size-small;
  color: @text-color-seg-gray;
}

.owner-sign {
  font-size: @text-font-size-normal;
  font-family: STXingkaiSC-Bold;
  color: @text-color-seg-gray;
  width: @weex-screen-width - 60px - 200px;
  lines:1;
  text-align: right;
}

.text-sign {
  font-size: @text-font-size-normal;
  font-family: STXingkaiSC-Bold;
  font-weight: bold;
  color: @text-color-seg-gray;
}

.item-align{
  flex-direction: row;
  align-items: center;
}

.img {
  width: 60px;
  height: 60px;
}

.img-list {
  width: 35px;
  height: 35px;
}


</style>