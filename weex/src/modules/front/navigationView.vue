/**
 * 引导页
 * by wangc
 */
<template>
  <div>
      <slider class="slider" infinite="false">
          <div class="slider" v-for="(item, i) in imgList">
              <image class="slider" :src="item.imgUrl" resize="cover"></image>
              <div class="goto-btn" v-if="i == 2" @click="showNext">
                  <text class="goto-text">启航</text>
              </div>
              <text class="display-text" v-if="i == 2">开始你的表演</text>
          </div>
          <indicator class="indicator"></indicator>
      </slider>
  </div>
</template>

<script>
export default {
    data() {
        return {
            imgList: [
                {imgUrl: "local:///navigation_bg_1"},
                {imgUrl: "local:///navigation_bg_2"},
                {imgUrl: "local:///navigation_bg_3"}
            ]
        }
    },
    methods: {
        showNext: function () {
            let event = weex.requireModule("event")
            event.navigationNext()
        }
    }
}
</script>

<style lang="less" scoped>
@import '~styles/variable.less';

.slider {
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
}

.indicator {
    position: absolute;
    bottom: 40;
    width: 750;
    height: 20;
    item-color: #999999;
    item-selected-color: #ffffff;
    item-size: 15px;
}

.goto-btn {
    position: absolute;
    bottom: 200;
    height: 120;
    width: 500;
    left: (750-500)/2;
    border-width: 2px;
    border-style: solid;
    border-color: white;
    align-items: center;
    justify-content: center;
    border-radius: 60;
}

.goto-text {
    color: white;
    font-size: @text-font-size-outsize;
    text-align: center;
}

.display-text {
    color: white;
    font-size: @text-font-size-outsize;
    width: 750;
    text-align: center;
    position: absolute;
    bottom: 100;
}

</style>
