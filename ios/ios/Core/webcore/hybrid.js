;(function() {
  'use strict';
  if(typeof(window.Hybrid)==='undefined'){
	window.Hybrid = function (params) {
        var hybrid = this;
        var callbackid = 1;
        var callbackMethods = {};
        var sendMessage = function(msg){
            var iframe = document.createElement('iframe');
            iframe.style.display = 'none';
        	iframe.src = msg;
            document.documentElement.appendChild(iframe);
        };
        /***************Navtive 回调************/
        hybrid.handle=function(callbackIndex,params,error){
        	callbackMethods[callbackIndex](params,error);
        	callbackMethods[callbackIndex] = undefined;
        };
        /***************页面跳转****************/
        hybrid.openPage=function(data){
			if (data.url.indexOf('http') !=0) {
				if(data.url.indexOf('/') == 0){
					var port = window.location.port;
                    data.url = window.location.protocol+'//'+window.location.hostname+((''===port)?'':':')+port+'/#'+data.url;
				}else{
					var baseUrl = window.location.href.replace(/\?.*/,'');
					var index = baseUrl.lastIndexOf('/');
					if(index!=-1){
					   baseUrl = baseUrl.substring(0, index+1);
					}
					data.url = baseUrl+data.url;
				}
			};

			sendMessage('hsmbp://open?data='+encodeURIComponent(JSON.stringify(data)));
		};
		hybrid.onResult=function(requestcode,resultcode,data){
		};
		hybrid.close=function(tag){
            if(typeof(tag)==='undefined'){
                sendMessage('hsmbp://close');
            }else{
                sendMessage('hsmbp://close?tag='+tag);
            }
		};
		hybrid.setResult=function(resultcode,data){
			sendMessage('hsmbp://result?resultcode='+resultcode+'&data='+JSON.stringify(data));
		};
        /***************右上角按钮************/
        hybrid.setNavRightButtons=function(titles){
            sendMessage('hsmbp://nav_right_btn?titles='+JSON.stringify(titles));
        };
        hybrid.onNavRightButtonClicked=function(title){};
        /***************SearchBar************/
        hybrid.showSearchBar=function(placeholder){
            sendMessage('hsmbp://showSearchBar?placeholder='+placeholder);
        };
        hybrid.onSearchClicked=function(){};
		/***************下拉刷新****************/
		hybrid.initHeaderRefresh=function(callback){
			if(typeof(callback)==='undefined'){
				sendMessage('hsmbp://headerrefresh?action=init');
			}else{
				var cbId = callbackid++;
				callbackMethods[cbId] = callback;
				sendMessage('hsmbp://headerrefresh?action=init&callback='+cbId);
			};
		};
		hybrid.onHeaderBeginRefresh=function(){
		};
		hybrid.headerBeginRefreshing=function(){
			sendMessage('hsmbp://headerrefresh?action=start');
		};
		hybrid.headerEndRefreshing=function(){
			sendMessage('hsmbp://headerrefresh?action=stop');
		};
		/****************选择*******************/
		hybrid.showSelectUI=function(params,callback){
			if(typeof(callback)==='undefined'){
				sendMessage('hsmbp://showSelectUI?params='+JSON.stringify(params));
			}else{
				var cbId = callbackid++;
				callbackMethods[cbId] = callback;
				sendMessage('hsmbp://showSelectUI?params='+JSON.stringify(params)+'&callback='+cbId);
			};
		};
		/****************扩展服务调用************/
		hybrid.service=function(serviceName,params,callback){
			if(typeof(callback)==='undefined'){
				sendMessage('hsmbp://service?name='+serviceName+'&params='+JSON.stringify(params));
			}else{
				var cbId = callbackid++;
				callbackMethods[cbId] = callback;
				sendMessage('hsmbp://service?name='+serviceName+'&params='+JSON.stringify(params)+'&callback='+cbId);
			};
		};
        /***************Request*************/
        hybrid.request=function(settings,callback){
          var request = {};
          request.url = settings.url;
          if(settings.method !== undefined) {
            request.type = settings.method;
          }
          if(settings.data !== undefined) {
            request.data = settings.data;
          }
          if(typeof(callback)==='undefined'){
            sendMessage('hsmbp://request?request='+encodeURIComponent(JSON.stringify(request)));
          }else{
            var cbId = callbackid++;
            callbackMethods[cbId] = callback;
            sendMessage('hsmbp://request?request='+encodeURIComponent(JSON.stringify(request))+'&callback='+cbId);
          };
        };
        /***************导航栏参数设置************/
        hybrid.setNavBarsAppearance=function(params){
          sendMessage('hsmbp://nav_bar_appear?params='+JSON.stringify(params));
        };
        /***************打开原生界面************/
        hybrid.openNaviPage=function(params){
          sendMessage('hsmbp://openNaviPage?params='+JSON.stringify(params));
        };
        /***************保存用户信息************/
        hybrid.commitUserData=function(key,value){
          sendMessage('hsmbp://commitUserData?key='+key+'&value='+value);
        };
        /***************获取用户信息************/
        hybrid.getUserData=function(key, callback){
          if(typeof(callback)==='undefined'){
            sendMessage('hsmbp://getUserData?key='+key);
          }else{
              var cbId = callbackid++;
              callbackMethods[cbId] = callback;
              sendMessage('hsmbp://getUserData?key='+key+'&callback='+cbId);
          };
        };
        /***************跳转到用户信息页面************/
        hybrid.showMine=function(){
            sendMessage('hsmbp://showMine');
        };
        /***************展示商智宣传pdf************/
        hybrid.showSzPdf=function(){
            sendMessage('hsmbp://showSzPdf');
        };
        /***************广播通知************/
        hybrid.postNotification=function(name){
            sendMessage('hsmbp://postNotification?name='+name);
        }
        /***************注销************/
        hybrid.loginOut=function(){
            sendMessage('hsmbp://loginOut');
        }
        hybrid.onAPPLoginOut=function(){};
        hybrid.onAPPLogin=function(){};
		return hybrid;
	};
    window.hybrid = new Hybrid();
  }
})();
