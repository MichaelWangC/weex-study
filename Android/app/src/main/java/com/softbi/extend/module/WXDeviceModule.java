package com.softbi.extend.module;

import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.common.WXModule;

/**
 * Created by michael on 2017/10/26.
 */

public class WXDeviceModule extends WXModule {

    @JSMethod(uiThread = false)
    public String getDeviceName(){
        return "Android";
    }

//    @JSMethod(uiThread = false)
//    public String getViewHeight() {
//        return "200";
//    }

}
