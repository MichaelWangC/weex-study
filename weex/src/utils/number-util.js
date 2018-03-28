let numberUtil = {
    /**
    * 将数值四舍五入后格式化.
    *
    * @param num 数值(Number或者String)
    * @param cent 要保留的小数位(Number)
    * @param isThousand 是否需要千分位 0:不需要,1:需要(数值类型);
    * @return 格式的字符串,如'1,234,567.45'
    * @type String
    */
    formatNumber: function(num, cent, isThousand) {
        num = num.toString().replace(/\$|\,/g,'');
        // 检查传入数值为数值类型
        if(isNaN(num)) num = "0";
    
        // 获取符号(正/负数)
        let sign = (num == (num = Math.abs(num)));
    
        num = Math.floor(num*Math.pow(10,cent)+0.50000000001); // 把指定的小数位先转换成整数.多余的小数位四舍五入
        let cents = num%Math.pow(10,cent);       // 求出小数位数值
        num = Math.floor(num/Math.pow(10,cent)).toString();  // 求出整数位数值
        cents = cents.toString();        // 把小数位转换成字符串,以便求小数位长度
    
        // 补足小数位到指定的位数
        while(cents.length<cent)
        cents = "0" + cents;
    
        if(isThousand) {
        // 对整数部分进行千分位格式化.
        for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
            num = num.substring(0,num.length-(4*i+3))+','+ num.substring(num.length-(4*i+3));
        }
    
        if (cent > 0)
            return (((sign)?'':'-') + num + '.' + cents);
        else
            return (((sign)?'':'-') + num);
    },
    changeMoneyToChinese(money){  
        var cnNums = new Array("零","壹","贰","叁","肆","伍","陆","柒","捌","玖"); //汉字的数字  
        var cnIntRadice = new Array("","拾","佰","仟"); //基本单位  
       var cnIntUnits = new Array("","万","亿","兆"); //对应整数部分扩展单位  
        var cnDecUnits = new Array("角","分","毫","厘"); //对应小数部分单位  
    //    var cnInteger = "整"; //整数金额时后面跟的字符  
       var cnIntLast = "元"; //整型完以后的单位  
       var maxNum = 100000000000; //最大处理的数字  
          
       var IntegerNum; //金额整数部分  
       var DecimalNum; //金额小数部分  
       var ChineseStr=""; //输出的中文金额字符串  
       var parts; //分离金额后用的数组，预定义  
        if( money == "" ){  
           return "";  
       }  
       money = parseFloat(money);  
       if( money >= maxNum ){  
           $.alert('超出最大处理数字');  
            return "";  
       }  
        if( money == 0 ){  
            //ChineseStr = cnNums[0]+cnIntLast+cnInteger;  
            ChineseStr = cnNums[0]+cnIntLast  
            //document.getElementById("show").value=ChineseStr;  
            return ChineseStr;  
        }  
        money = money.toString(); //转换为字符串  
        if( money.indexOf(".") == -1 ){  
            IntegerNum = money;  
            DecimalNum = '';  
        }else{  
            parts = money.split(".");  
            IntegerNum = parts[0];  
            DecimalNum = parts[1].substr(0,4);  
        }  
        if( parseInt(IntegerNum,10) > 0 ){//获取整型部分转换  
            var zeroCount = 0;  
            var IntLen = IntegerNum.length;  
            for(var i=0;i<IntLen;i++ ){  
                var n = IntegerNum.substr(i,1);  
                var p = IntLen - i - 1;  
                var q = p / 4;  
                var m = p % 4;  
                if( n == "0" ){  
                     zeroCount++;  
                }else{  
                    if( zeroCount > 0 ){  
                        ChineseStr += cnNums[0];  
                    }  
                    zeroCount = 0; //归零  
                    ChineseStr += cnNums[parseInt(n)]+cnIntRadice[m];  
                }  
                if( m==0 && zeroCount<4 ){  
                    ChineseStr += cnIntUnits[q];  
                }  
            }  
            ChineseStr += cnIntLast;  
            //整型部分处理完毕  
        }  
        return ChineseStr;  
    }
};
export default numberUtil;