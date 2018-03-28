/**
 * 缺省页面
 * by wangc
 */
<template>
    <div class="no-data">
        <image class="no-data-icon" :src="imgSrc"></image>
        <text class="no-data-text">{{text}}</text>
    </div>
</template>

<script>
export default {
    props: {
        text: {default: "没有内容了~"},
        imgSrc: {default: require('@/images/home/banner.png')}
    }
}
</script>

<style lang="less" scoped>
@import "~styles/variable.less";

.no-data {
    flex: 1;
    margin-top: 100px;
    width: 750px;
    justify-content: center;
    align-items: center;
}

.no-data-icon {
    width: 462px;
    height: 392px;
}

.no-data-text {
    margin-top: 20px;
    font-size: @text-font-size-small;
    color: @text-default-color;
}

</style>
