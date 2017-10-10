/*
 * 通过相对路径 获取绝对路径
 */
exports.getBaseURL = function (relativePath) {

    var absolutePath = weex.config.bundleUrl;

    var reg = new RegExp("\\.\\./", "g");
    var uplayCount = 0; // 相对路径中返回上层的次数。  
    var m = relativePath.match(reg);
    if (m) uplayCount = m.length;

    var lastIndex = absolutePath.length - 1;
    var subString = absolutePath.substr(0, lastIndex + 1)
    for (var i = 0; i <= uplayCount; i++) {
        lastIndex = subString.lastIndexOf("/", lastIndex);
        subString = subString.substr(0, lastIndex)
    }
    return subString + "/" + relativePath.replace(reg, "");
}