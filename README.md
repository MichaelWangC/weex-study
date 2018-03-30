# 说明
1.由于目前框架，Android和iOS的tabbar和导航栏均使用原生开发。而且目前接触到的业务需求无需支持web端的显示，所以目前框架不支持web端，只支持iOS和Android端开发。

# ios集成使用
## 使用
需要安装cocoapods，命令行运行pod install，下载依赖项

## Charts 配置设置
项目使用了第三方组件Charts，使用的是swift编写。
需将Pods -> Charts -> Build Settings 中的 Always Embed Swift Standard Libraries 改为 yes，Swift Language Version 改为 4.0

# android集成使用
使用 Android Studio 打开工程，gradle下载相关依赖包后，运行项目即可

# 配置项
## 运行环境配置
iOS配置文件路径：ios/config/env.plist
Android配置文件路径： Android/app/env.properties

设置当前的运行环境，目前可区分三种运行模式：开发、测试和生产
iOS中对应填写：DEV、DEBUG、PUBLISH
Android中对应填写：DEV、DEBUG、PUBLISH

## API等访问路径配置
iOS配置文件路径：ios/config/ConfigInfo.m
Android配置文件路径：Android/app/src/main/java/com/softbi/config/ConfigInfo

设置每个运行环境中访问api服务器、weex文件的路径地址
weex路径配置为""，则访问本地的weex文件

# 拓展模块
# component
weex拓展组件
## animal
用于展示AE制作的动画
## pieChart
用于展示饼图

## 目前iOS有，Android还未添加的组件
## lineChart
用于展示折线图
## web
用于展示web页面

## module
weex与原生交互方法
## event
基本的事件方法
包含页面跳转、页面返回、展示loading框等 基本的方法
## device
获取设备信息
可获取当前设备为 iPhone、iPhone X或Android
## http
用于网络请求、获取api服务器访问路径等
## navbar
可用于控制导航栏颜色，添加右上角按钮名称或图片
## wechat
用于微信分享
## imagePicker
目前用于获取和设置用户头像
后续可进行拓展成图片选择的控件
## userInfo
获取用户登录信息（用户名、手机号、手势密码等信息）

# 页面间传值
## 参数传入
1.使用 url传参
通过 url-util.js 中的 getQueryString 获取
2.中文处理
中文传参需要使用encodeUrl
## 数据返回
可以通过BroadcastChannel对象

# 网络框架
## http
添加http的module方法
可通过一下代码获取数据
let http = weex.requireModule('http')
http.request({
    url: ""
}, data => {

})

# 样式支持
## less
集成less，通用样式可调用styles/variable.less中定义的样式

# 部署
控制台进入weex目录
运行npm run build生成weex的js文件
将文件拷贝到iOS和Android中的assets目录
