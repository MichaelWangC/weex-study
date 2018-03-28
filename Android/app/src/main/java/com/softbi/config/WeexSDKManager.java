package com.softbi.config;

import android.app.Application;
import android.content.Context;

import com.softbi.extend.adapter.ImageAdapter;
import com.softbi.extend.component.WXLOTAnimationView;
import com.softbi.extend.component.WXPieChartView;
import com.softbi.extend.module.WXDeviceModule;
import com.softbi.extend.module.WXEventModule;
import com.softbi.extend.module.WXHttpModule;
import com.softbi.extend.module.WXImagePickerModule;
import com.softbi.extend.module.WXNaviBarModule;
import com.softbi.extend.module.WXUserInfoModule;
import com.softbi.extend.module.WXWeChatModule;
import com.taobao.weex.InitConfig;
import com.taobao.weex.WXSDKEngine;

/**
 * Created by michael on 2018/3/15.
 */

public class WeexSDKManager {
    public static void setup(Application application) {
        InitConfig initConfig = new InitConfig.Builder().setImgAdapter(new ImageAdapter()).build();
        try {

            // weex 注册
            WXSDKEngine.initialize(application, initConfig);
            WXSDKEngine.registerModule("event", WXEventModule.class);
            WXSDKEngine.registerModule("device", WXDeviceModule.class);
            WXSDKEngine.registerModule("http", WXHttpModule.class);
            WXSDKEngine.registerModule("navbar", WXNaviBarModule.class);
            WXSDKEngine.registerModule("wechat", WXWeChatModule.class);
            WXSDKEngine.registerModule("imagePicker", WXImagePickerModule.class);
            WXSDKEngine.registerModule("userInfo", WXUserInfoModule.class);

            WXSDKEngine.registerComponent("pieChart", WXPieChartView.class);
            WXSDKEngine.registerComponent("animal", WXLOTAnimationView.class);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
