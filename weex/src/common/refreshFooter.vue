/**
 * 上拉加载 组件
 * by wangc
 */
<template>
    <loading class="loading" @loading="onloading" :display="display">
        <text class="indicator-text">{{refreshingText}}</text>
        <loading-indicator class="indicator"></loading-indicator>
    </loading>
</template>

<script>
export default {
    data() {
        return {
            refreshingText: "上拉加载更多..."
        }
    },
    props: {
        display: {default: "hide"}
    },
    methods: {
        onloading (event) {
            this.$emit("loading", event)
        }
    },
    watch: {
        display: function(val, oldval) {
            if (val == "hide") {
                this.refreshingText = "上拉加载更多..."
            } else {
                this.refreshingText = "正在加载"
            }
        }
    }
}
</script>

<style lang="less" scoped>
@import "~styles/variable.less";

.loading {
    width: 750;
    display: -ms-flex;
    display: -webkit-flex;
    display: flex;
    -ms-flex-align: center;
    -webkit-align-items: center;
    -webkit-box-align: center;
    align-items: center;
}

.indicator-text {
    color: #888888;
    font-size: @text-font-size-normal;
    text-align: center;
    margin-top: 20px;
}

.indicator {
    margin-top: 16px;
    height: 40px;
    width: 40px;
    color: #888888;
    margin-bottom: 20px;
}

</style>
