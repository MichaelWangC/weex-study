<template>
    <div>
        <navpage dataRole="none" title="" titleColor="white" rightItemTitle="个人信息" rightItemColor="white">
            <div class="mine-asset-bg">
                我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的我的
                
            </div>
        </navpage>
    </div>
</template>

<script>
import navpage from '@/components/navpage.vue'

export default {
    data() {
        return {

        }
    },
    components: {
        navpage
    }
}
</script>

<style scoped>
.mine-asset-bg {
    width: 750;
    min-height: 200;
    background-color: #3399ff;
}

</style>