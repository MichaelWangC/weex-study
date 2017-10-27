package com.study.core.util;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.study.utils.Keys;

/**
 * Created by michael on 2017/10/24.
 */

public class ServiceCallBack extends BroadcastReceiver {

    public static final String CALLBCAK_ACTION = "com.study.core.util.ServiceCallBack.action";

    private OnServiceCallBack onServiceCallBack;

    public ServiceCallBack() {

    }

    public ServiceCallBack(OnServiceCallBack onServiceCallBack) {
        this.onServiceCallBack = onServiceCallBack;
    }

    public void setOnServiceCallBack(OnServiceCallBack onServiceCallBack) {
        this.onServiceCallBack = onServiceCallBack;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        String info = intent.getExtras().getString(Keys.WEEX_RENDER_STATUS);
        onServiceCallBack.onServiceCallBack(info);
    }
}
