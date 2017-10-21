<template>
    <div>
        <navpage dataRole="none" 
            :title="title" 
            :rightItemSrc="rightItemSrc" 
            titleColor="white"
            @naviBarRightItemClick="naviBarRightItemClick">
            <!-- 内容 -->
            <scroller class="scroller" show-scrollbar="false">
                <slider class="slider" interval="3000" auto-play="true">
                    <div class="frame" v-for="(img,i) in imageList" v-bind:key="i">
                        <image class="image" resize="cover" :src="img.src"></image>
                    </div>
                    <indicator class="indicator"></indicator>
                </slider>

                <!-- 快捷按钮 start -->
                <div class="quick-btn-view">
                    <div v-for="(items,i) in quickBtns" v-bind:key="i" class="quickBg">
                        <quickbtn v-for="item in items" 
                            :key="item.index" 
                            :index="item.index" 
                            :icon="item.icon" 
                            :title="item.title" 
                            :titleColor="item.titleColor">
                        </quickbtn>
                    </div>
                </div>
                <!-- 快捷按钮 end -->
                <div class="quick-btn-view" style="background-color: red">
                </div>

                <div class="quick-btn-view" style="background-color: green">
                </div>

                <div class="quick-btn-view" style="background-color: blue">
                </div>

            </scroller>
        </navpage>
    </div>
</template>

<script>
import quickbtn from '../../components/quickButton.vue'
import navpage from '../../components/navpage.vue'

export default {
    data() {
        return {
            title: "首页",
            rightItemSrc: require('./images/icon_home_message.png'),
            imageList: [
                {
                    src: 'http://seopic.699pic.com/photo/50035/8104.jpg_wh1200.jpg'
                },
                {
                    src: 'http://seopic.699pic.com/photo/50032/5463.jpg_wh1200.jpg'
                },
                {
                    src: 'http://seopic.699pic.com/photo/50036/9518.jpg_wh1200.jpg'
                }
            ],
            quickBtns: [
                [{
                    index: 1,
                    icon: require('./images/icon_quick_private.png'),
                    title: '私募',
                    titleColor: '#000000'
                }, {
                    index: 1,
                    icon: require('./images/icon_quick_public.png'),
                    title: '公募',
                    titleColor: '#000000'
                }, {
                    index: 1,
                    icon: require('./images/icon_quick_insurance.png'),
                    title: '保险',
                    titleColor: '#000000'
                }, {
                    index: 1,
                    icon: require('./images/icon_quick_private.png'),
                    title: '公募',
                    titleColor: '#000000'
                }], [{
                    index: 1,
                    icon: require('./images/icon_quick_public.png'),
                    title: '公募',
                    titleColor: '#000000'
                }, {
                    index: 1,
                    icon: require('./images/icon_quick_private.png'),
                    title: '公募',
                    titleColor: '#000000'
                }, {
                    index: 1,
                    icon: require('./images/icon_quick_public.png'),
                    title: '公募',
                    titleColor: '#000000'
                }, {
                    index: 1,
                    icon: require('./images/icon_quick_private.png'),
                    title: '公募',
                    titleColor: '#000000'
                }]]
        }
    },
    components: {
        quickbtn,
        navpage
    },
    methods: {
        naviBarRightItemClick: function (params) {
            var event = weex.requireModule('event')
            event.openURL("../../App.js?hasLeftItem=true")
            const storage = weex.requireModule('storage')
            storage.setItem("hasLeftItem", "true")
        }
    }
}
</script>

<style scoped>
.scroller {
    background-color: #f4f5fa;
}

.quick-btn-view {
    margin-top: 10px;
    left: 0;
    right: 0;
    height: 300px;
}

.quickBg {
    flex-direction: row;
    height: 150;
}

.image {
    width: 750px;
    height: 375px;
}

.slider {
    width: 750px;
    height: 375px;
}

.frame {
    width: 100%;
    height: 100%;
    position: relative;
}

.indicator {
    width: 750px;
    height: 80px;
    item-color: #f4f5fa;
    item-selected-color: #3399ff;
    item-size: 20px;
    position: absolute;
    bottom: 0px;
}
</style>