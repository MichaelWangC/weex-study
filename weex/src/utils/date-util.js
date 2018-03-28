let dateutil = {
    // 对Date的扩展，将 Date 转化为指定格式的String
    // 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
    // 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
    // 例子： 
    // format(new Date(), "yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
    // format(new Date(), "yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
    format: function (date, fmt) { //author: meizz 
        var o = {
            "M+": date.getMonth() + 1, //月份 
            "d+": date.getDate(), //日 
            "h+": date.getHours(), //小时 
            "m+": date.getMinutes(), //分 
            "s+": date.getSeconds(), //秒 
            "q+": Math.floor((date.getMonth() + 3) / 3), //季度 
            "S": date.getMilliseconds() //毫秒 
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    },
    //时区转换成GMT当前时区
    //传入日期字符串，返回日期字符串
    dateGMTExchange:function(UTCDate) {
        if(!UTCDate){
            return '-';
          }
          function formatFunc(str) {    //格式化显示
            return str > 9 ? str : '0' + str
          }
          var date2 = UTCDate;     //这步是关键
          var year = date2.getFullYear();
          var mon = formatFunc(date2.getMonth() + 1);
          var day = formatFunc(date2.getDate());
          var hour = date2.getHours();
        //   var noon = hour >= 12 ? 'PM' : 'AM';
        //   hour = hour>=12?hour-12:hour;
          hour = formatFunc(hour);
          var min = formatFunc(date2.getMinutes());
        //   var dateStr = year+'-'+mon+'-'+day+' '+noon +' '+hour+':'+min;
          var dateStr = year+'-'+mon+'-'+day+' '+hour+':'+min+':00';
          return dateStr;
    }
}

export default dateutil;