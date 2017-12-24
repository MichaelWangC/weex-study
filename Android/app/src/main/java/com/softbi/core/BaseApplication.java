package com.softbi.core;

import android.app.Application;

import com.softbi.extend.module.WXDeviceModule;
import com.softbi.extend.module.WXEventModule;
import com.taobao.weex.InitConfig;
import com.taobao.weex.WXSDKEngine;

import com.softbi.extend.adapter.ImageAdapter;

/**
 * Created by michael on 2017/10/13.
 */

public class BaseApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        InitConfig initConfig = new InitConfig.Builder().setImgAdapter(new ImageAdapter()).build();
        try {

            // weex 注册
            WXSDKEngine.initialize(this, initConfig);
            WXSDKEngine.registerModule("event", WXEventModule.class);
            WXSDKEngine.registerModule("device", WXDeviceModule.class);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
