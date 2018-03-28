/**
 * 下拉刷新 组件
 * by wangc
 */
<template>
    <refresh class="refresh" @refresh="onrefresh" @pullingdown="onpullingdown" :display="display">
        <!-- <loading-indicator class="loading-indicator"></loading-indicator>
        <text class="indicator-text">{{refreshingText}}</text> -->
        <animal ref="animal" class="animal" src="Watermelon.json" loop="true"></animal>
    </refresh>
</template>

<script>
export default {
    data() {
        return {
            refreshingText: "下拉可以刷新"
        }
    },
    props: {
        display: {default: "hide"}
    },
    methods: {
        onrefresh (event) {
            this.refreshingText = "正在加载"
            this.$emit("refresh", event)
            this.$refs.animal.play()
        },
        onpullingdown (event) {
            let pullingDistance = event.pullingDistance
            let viewHeight = event.viewHeight
            if (-pullingDistance > viewHeight & this.display != "show") {
                this.refreshingText = "松开立即刷新"
            } else {
                this.refreshingText = "下拉可以刷新"
            }
            this.$emit("pullingdown", event)
        }
    },
    watch: {
        display: function(val, oldval) {
            if (val == "hide") {
                this.$refs.animal.stop()
            }
        }
    }
}
</script>

<style lang="less" scoped>
@import "~styles/variable.less";

    .refresh {
        width: 750;
        flex-direction: row;
        -ms-flex-align: center;
        -webkit-align-items: center;
        -webkit-box-align: center;
        align-items: center;
        justify-content: center;
        height: 120px;
    }
    .indicator-text {
        color: #888888;
        font-size: @text-font-size-small;
        text-align: center;
        margin-left: 20px;
    }
    .loading-indicator {
        height: 40px;
        width: 40px;
        color: #888888;
    }
    .animal {
        width: 200;
        height: 200;
    }

</style>
