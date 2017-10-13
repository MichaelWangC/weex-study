package com.study.core;

import android.app.Application;

import com.study.extend.module.WXEventModule;
import com.taobao.weex.InitConfig;
import com.taobao.weex.WXSDKEngine;

import com.study.extend.module.ImageAdapter;

/**
 * Created by michael on 2017/10/13.
 */

public class BaseApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        InitConfig initConfig = new InitConfig.Builder().setImgAdapter(new ImageAdapter()).build();
        try {
            WXSDKEngine.initialize(this, initConfig);
            WXSDKEngine.registerModule("event", WXEventModule.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
