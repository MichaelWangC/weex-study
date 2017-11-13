<template>
    <div>
        <navpage dataRole="none" title="" titleColor="white" rightItemTitle="个人信息" rightItemColor="white">
            <scroller>
                <div class="mine-asset-bg">
                    我的 wode
                </div>
                <animal class="mine-asset-bg" src="Watermelon" loop="true"></animal>
                <div class="mine-asset-bg">
                    test
                </div>
            </scroller>
        </navpage>
    </div>
</template>

<script>
import navpage from "@/components/navpage.vue";

export default {
  data() {
    return {};
  },
  components: {
    navpage
  }
};
</script>

<style scoped>
.mine-asset-bg {
    width: 750;
    min-height: 200;
    background-color: #3399ff;
}
</style>