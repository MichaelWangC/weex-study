/** 
* 手势密码
*/
<template>
  <div v-on:panstart="panstart($event)" v-on:panmove="panmove($event)" v-on:panend="panend($event)">
      <image class="gesture_bg" src="local:///gesture_bg"></image>
      <div class="gesture_bg" ref="lockview">
          <image class="customer_logo" resize="contain"></image>
          <text class="text_tip">{{msgTip}}</text>
          <!-- 手势密码 滑动界面 -->
          <div class="gesture-lock-view">
              <div class="gesture-lock-row" v-for="rows in lockItems">
                  <div class="gesture-lock-item" v-for="item in rows">
                      <div class="gesture-lock-circle">
                          <div class="gesture-lock-selected-circle" v-if="item.isSelected">
                          </div>
                      </div>
                  </div>
              </div>
          </div>
      </div>
  </div>
</template>

<script>
import urlUtil from "@/utils/url-util.js"

const document = weex.document
export default {
    data() {
        return {
            lockItems: [
                [{index: 1, isSelected: false},{index: 2, isSelected: false},{index: 3, isSelected: false}],
                [{index: 4, isSelected: true},{index: 5, isSelected: false},{index: 6, isSelected: false}],
                [{index: 7, isSelected: false},{index: 8, isSelected: false},{index: 9, isSelected: false}]
            ],
            line: "",
            lockviewY: "",
            lockviewX: "",
            linestartX: "",
            linestartY: "",
            lines: [],
            lockPasswords: "",
            lockSetPasswords: "",
            type: "",
            msgTip: "设置手势密码",
            lockNum: 0
        }
    },
    methods: {
        panstart: function(event) {
            let screenY = event.changedTouches[0].screenY
            let screenX = event.changedTouches[0].screenX

            console.log(JSON.stringify(event.changedTouches))
            // console.log(">>>"+screenX+">>>"+screenY)
            // 数据初始化
            this.lines = []
            this.line = null
            this.lockPasswords = ""
            this.linestartX = ""
            this.linestartY = ""

            for (let i = 0; i < this.lockItems.length; i++) {
                let rowItems = this.lockItems[i]
                for (let j = 0; j < rowItems.length; j++) {
                    let item = rowItems[j]
                    // console.log(">>>"+item.minX+">>>"+screenX+">>>"+item.maxX+"+++"+item.minY+">>>"+screenY+">>>"+item.maxY)
                    if (screenX > item.minX && screenX < item.maxX && screenY > item.minY && screenY < item.maxY) {
                        item.isSelected = true;
                        this.linestartX = item.minX + (item.maxX - item.minX) / 2
                        this.linestartY = item.minY + (item.maxY - item.minY) / 2

                        let el = document.createElement('div')
                        el.setStyle('width', 8)
                        el.setStyle('position', 'absolute')
                        el.setStyle('left', this.linestartX-4)
                        el.setStyle('top', this.linestartY)
                        el.setStyle('backgroundColor', '#ffffff')
                        el.setStyle('transformOrigin', 'center top')
                        el.setStyle('transform', 'rotate(0deg)')
                        document.body.appendChild(el)

                        // console.log("item.index", item.index)
                        this.lockPasswords += item.index
                        this.line = el;
                    }
                }
            }
        },
        panmove: function(event) {
            // 判断是否有起点
            if (this.linestartX === "" || this.linestartY === "") {
                return
            }
            let screenY = event.changedTouches[0].screenY
            let screenX = event.changedTouches[0].screenX
            // 判断滑动过程中 是否有触摸 圆点
            let array = this.lockItems;
            let newLine = ""
            for (let i = 0; i < array.length; i++) {
                const elements = array[i];
                for (let j = 0; j < elements.length; j++) {
                    let item = elements[j];
                    if (!item.isSelected && screenX > item.minX && screenX < item.maxX && screenY > item.minY && screenY < item.maxY) {
                        item.isSelected = true;
                        let linestartX = item.minX + (item.maxX - item.minX) / 2
                        let linestartY = item.minY + (item.maxY - item.minY) / 2
                        // 结束上一条直线
                        let screenY = event.changedTouches[0].screenY
                        let screenX = event.changedTouches[0].screenX
                        let H = linestartY - this.linestartY
                        let W = linestartX - this.linestartX
                        let lineH = Math.sqrt(H*H + W*W)
                        this.line.setStyle('height', lineH)

                        let angle = Math.atan(H/W) * 180 / Math.PI
                        if ( (H >= 0 && W >= 0) || (H < 0 && W >= 0)) {
                            angle = angle - 90
                        } else if ((H >= 0 && W < 0) || (H < 0 && W < 0)) {
                            angle = angle + 90
                        }
                        this.line.setStyle('transform', 'rotate('+angle+'deg)')
                        // 开始下一条直线
                        this.linestartX = linestartX
                        this.linestartY = linestartY

                        let el = document.createElement('div')
                        el.setStyle('width', 8)
                        el.setStyle('position', 'absolute')
                        el.setStyle('left', this.linestartX-4)
                        el.setStyle('top', this.linestartY)
                        el.setStyle('backgroundColor', '#ffffff')
                        el.setStyle('transformOrigin', 'center top')
                        el.setStyle('transform', 'rotate(0deg)')
                        document.body.appendChild(el)

                        // 保存所有已结束滑动的直线
                        // console.log("item.index", item.index)
                        this.lockPasswords += item.index
                        this.lines.push(this.line)
                        this.line = el;
                    }
                }
            }

            let H = screenY - this.linestartY
            let W = screenX - this.linestartX
            let lineH = Math.sqrt(H*H + W*W)
            this.line.setStyle('height', lineH)

            let angle = Math.atan(H/W) * 180 / Math.PI
            if ( (H >= 0 && W >= 0) || (H < 0 && W >= 0)) {
                angle = angle - 90
            } else if ((H >= 0 && W < 0) || (H < 0 && W < 0)) {
                angle = angle + 90
            }
            this.line.setStyle('transform', 'rotate('+angle+'deg)')
        },
        panend: function(event) {
            
            this.lines.forEach(element => {
                document.body.removeChild(element)
            });

            if (this.line) {
                document.body.removeChild(this.line)
            }

            let array = this.lockItems;
            for (let i = 0; i < array.length; i++) {
                const elements = array[i];
                for (let j = 0; j < elements.length; j++) {
                    let item = elements[j];
                    item.isSelected = false;
                }
            }
            console.log(this.lockPasswords)
            let userInfo = weex.requireModule('userInfo')
            let oldPwd = userInfo.getGestureLockPassword()
            if (this.type === "new" || this.type === "loginNew") {
                if (this.lockNum === 0) {
                    this.msgTip = "再次设置手势密码"
                    this.lockNum++
                    this.lockSetPasswords = this.lockPasswords
                    return
                }
                // 判断
                if (this.lockSetPasswords != this.lockPasswords) {
                    this.msgTip = "与首次不一致，请重新绘制"
                    this.lockSetPasswords = ""
                    this.lockNum = 0
                } else {
                    // 保存手势密码
                    userInfo.setGestureLockPassword(this.lockPasswords)
                    userInfo.setGestureLockBoolean("true")
                    
                    let push = weex.requireModule('event')
                    if (this.type === "loginNew") {
                        // 登录页 跳转到首页
                        push.gotoMainTabbar()
                    } else {
                        // 返回
                        push.popPage()
                        let gestureLockChange = new BroadcastChannel('gestureLockChange')
                        gestureLockChange.postMessage()
                    }
                    
                }
            } else if (this.type === "modify") {
                // 输入原手势密码
                if (oldPwd !== this.lockPasswords) {
                    this.msgTip = "密码错误"
                    return
                }
                this.lockNum = 0
                this.type = "new"
                this.msgTip = "设置手势密码"
            } else {
                if (oldPwd !== this.lockPasswords) {
                    this.lockNum++
                    this.msgTip = "密码错误"+this.lockNum+"次"
                    return
                }
                let push = weex.requireModule('event')
                push.gotoMainTabbar()
            }
        }
    },
    mounted() {
        // 获取类型
        // type: new 新增、modify 修改、lock 解锁、loginNew 登录成功设置密码
        this.type = urlUtil.getQueryString("type")
        if (this.type === "new" || this.type === "loginNew") {
            this.msgTip = "设置手势密码"
        } else if (this.type === "modify") {
            this.msgTip = "请输入原手势密码"
        } else {
            this.msgTip = "输入手势密码解锁"
            // 添加 忘记密码
            let navbar = weex.requireModule('navbar')
            navbar.setNavRightButtonsWithTitles(["忘记密码"], function(title){
                let event = weex.requireModule('event')
                if (title === "忘记密码") {
                    let http = weex.requireModule("http")
                    http.doLogout()
                }
            })
        }
        // 获取每个circle的坐标
        let logoMarginTop = 750/4;
        let logoWH = 200;
        let textH = 40;
        let textMarginTop = 20;
        this.lockviewY = logoMarginTop+logoWH+textH+textMarginTop+40;
        this.lockviewX = (750-600)/2;

        let gestureLockW = 600;
        let gestureLockH = 700;
        let gestureItemWH = gestureLockW/3;
        let itemPadding = 20;
        let circleWH = gestureItemWH - 2 * itemPadding;
        let itemPaddingY = (gestureLockH/3 - circleWH)/2;

        // 从1开始
        let i = 1;
        this.lockItems = [];

        for (let row in [0,1,2]) {
            let rowItems = [];
            for (let column in [0,1,2]) {
                let itemMinX = this.lockviewX + itemPadding + itemPadding*2*column + circleWH*column;
                let itemMinY = this.lockviewY + itemPaddingY + itemPaddingY*2*row + circleWH*row;
                let itemMaxX = itemMinX + circleWH;
                let itemMaxY = itemMinY + circleWH;

                rowItems.push({
                    index: i,
                    minX: itemMinX,
                    minY: itemMinY,
                    maxX: itemMaxX,
                    maxY: itemMaxY,
                    isSelected: false
                })
                i++;
            }
            this.lockItems.push(rowItems)
        }
        // console.log(">>>>>>>>>>>", JSON.stringify(this.lockItems));
    }
}
</script>

<style style lang="less" scoped>
@import "~styles/variable.less";

.gesture_bg {
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    position: absolute;
    align-items: center;
}

.customer_logo {
    width: 200px;
    height: 200px;
    margin-top: @weex-screen-width/4;
}

.text_tip {
    font-size: @text-font-size-normal;
    color: white;
    height: 40px;
    margin-top: 20px;
}

@gestureLockW: 600px;
@gestureLockH: 700px;
.gesture-lock-view {
    margin-top: 40px;
    width: @gestureLockW;
    height: @gestureLockH;
}

.gesture-lock-row {
    width: @gestureLockW;
    height: @gestureLockH/3;
    flex-direction: row;
}

.gesture-lock-item {
    width: @gestureLockW/3;
    height: @gestureLockH/3;
    justify-content: center;
    align-items: center;
}

@circleWH: @gestureLockW/3 - 2 * 20;
.gesture-lock-circle {
    width: @circleWH;
    height: @circleWH;
    border-radius: @circleWH / 2;
    background-color: fade(white, 60%);
    border-style: solid;
    border-color: white;
    border-width: 3px;
    justify-content: center;
    align-items: center;
}

.gesture-lock-selected-circle {
    width: 40px;
    height: 40px;
    border-radius: 20px;
    background-color: white;
}

</style>
