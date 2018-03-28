/*
 * 通过相对路径 获取绝对路径
 */
let urlUtil = {
    getBaseURL: function (relativePath) {
        // 相对路径设置
        var absolutePath = weex.config.bundleUrl

        var reg = new RegExp("\\.\\./", "g")
        var uplayCount = 0 // 相对路径中返回上层的次数。  
        var m = relativePath.match(reg)
        if (m) uplayCount = m.length

        var lastIndex = absolutePath.length - 1
        var subString = absolutePath.substr(0, lastIndex + 1)
        for (var i = 0; i <= uplayCount; i++) {
            lastIndex = subString.lastIndexOf("/", lastIndex)
            subString = subString.substr(0, lastIndex)
        }
        return subString + "/" + relativePath.replace(reg, "")
    },
    getQueryString: function (name) {
        // 获取url参数
        let reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)")

        let absolutePath = weex.config.bundleUrl
        let urls = absolutePath.split("?")
        let url
        if (urls.length > 1) {
            url = urls[1]
        } else {
            return null
        }

        // 特殊字符替换 
        url = url.replace("&nbsp", " ")
        // 
        let r = url.match(reg)
        if (r != null) return r[2]//unescape(r[2])
        return null;
    }
}

export default urlUtil;