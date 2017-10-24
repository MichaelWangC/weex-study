package com.study.core.util;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Parcel;

/**
 * Created by michael on 2017/10/24.
 */

public class ServiceCallBack extends BroadcastReceiver {

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
        String info = intent.getExtras().getString("info");
        onServiceCallBack.onServiceCallBack(info);
    }
}
