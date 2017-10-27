<template>
    <navpage dataRole="none" title="产品" titleColor="white">

        <list class="list">
            <refresh class="refresh" @refresh="onrefresh" @pullingdown="onpullingdown" :display="refreshing?'show':'hide'">
                <text class="indicator">Refreshing ...</text>
                <loading-indicator class="indicator"></loading-indicator>
            </refresh>
            <cell class="cell" v-for="num in lists" :key="num">
                <div class="panel" v-on:click="tapCell(num)">
                    <text class="text">{{num}}</text>
                </div>
            </cell>
            <loading class="loading" @loading="fetch" :display="isloading ? 'show' : 'hide'">
                <text class="indicator">Loading ...</text>
            </loading>
        </list>
    </navpage>
</template>

<script>
import navpage from '@/components/navpage.vue'

let modal = weex.requireModule('modal')
let event = weex.requireModule('event')
const LOADMORE_COUNT = 4

export default {
    data() {
        return {
            refreshing: false,
            isloading: false,
            lists: [1, 2, 3, 4, 5]
        }
    },
    components: {
        navpage
    },
    methods: {
        fetch(event) {
            modal.toast({ message: 'loadmore', duration: 1 })

            this.isloading = true
            setTimeout(() => {
                const length = this.lists.length
                for (let i = length; i < length + LOADMORE_COUNT; ++i) {
                    this.lists.push(i + 1)
                }
                this.isloading = false
            }, 800)
        },
        tapCell: function(num) {
            modal.toast({ message: 'click' + num, duration: 1 })
            event.openURL("@/App.js?hasLeftItem=true")
        },
        onrefresh(event) {
            console.log('is refreshing')
            modal.toast({ message: 'refresh', duration: 1 })
            this.refreshing = true
            setTimeout(() => {
                this.refreshing = false
            }, 2000)
        },
        onpullingdown(event) {
            console.log('is onpulling down')
        }
    }
}
</script>

<style scoped>
.header {
    padding: 25;
    background-color: #efefef;
    border-bottom-color: #eeeeee;
    border-bottom-width: 2;
    border-bottom-style: solid;
}

.panel {
    width: 600px;
    height: 250px;
    margin-left: 75px;
    margin-top: 35px;
    margin-bottom: 35px;
    flex-direction: column;
    justify-content: center;
    border-width: 2px;
    border-style: solid;
    border-color: rgb(162, 217, 192);
    background-color: rgba(162, 217, 192, 0.2);
}

.text {
    font-size: 50px;
    text-align: center;
    color: #41B883;
}

.loading,
.refresh {
    height: 128px;
    width: 750px;
    flex-direction: row;
    align-items: center;
    justify-content: center;
}
</style>