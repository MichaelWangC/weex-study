/*
 * 通过相对路径 获取绝对路径
 */
let stringUrl = {
    isNull: function(value) {
        if (typeof(value) == "undefined" || value == "undefined" || value == "null" || value == null || value == "") {
            return true
        }
        return false
    }
}

export default stringUrl