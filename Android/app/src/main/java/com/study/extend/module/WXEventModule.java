package com.study.extend.module;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.text.TextUtils;

import com.study.config.ConfigInfo;
import com.study.core.WeexBaseActivity;
import com.study.core.util.OnServiceCallBack;
import com.study.core.util.ServiceCallBack;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;

import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by michael on 2017/10/13.
 */

public class WXEventModule extends WXModule {
    private static final String WEEX_CATEGORY = "com.taobao.android.intent.category.WEEX";
    private static final String WEEX_ACTION = "com.taobao.android.intent.action.WEEX";

    @JSMethod(uiThread = true)
    public void openURL(String url) {
        openURL(url, null);
    }

    @JSMethod(uiThread = true)
    public void openURL(String url, final JSCallback callback) {
        if (TextUtils.isEmpty(url)) {
            return;
        }
        String scheme = Uri.parse(url).getScheme();
        StringBuilder builder = new StringBuilder();
        if (TextUtils.equals("http", scheme) || TextUtils.equals("https", scheme) || TextUtils.equals("file", scheme)) {
            builder.append(url);
        } else if ( url.startsWith("@")) {
            String rootUrl = ConfigInfo.getInstance().getRootUrl();
            url = url.substring(1);
            builder.append(rootUrl).append(url);
        } else {
            try {
                URL absolutUrl = new URL(mWXSDKInstance.getBundleUrl());
                URL relariveUrl = new URL(absolutUrl, url);
                builder.append(relariveUrl.toString());
            } catch (MalformedURLException e) {
                e.printStackTrace();
            }
        }

        Uri uri = Uri.parse(builder.toString());
        Intent intent = new Intent(mWXSDKInstance.getContext(),WeexBaseActivity.class);
        intent.setAction(WEEX_ACTION);
        intent.setData(uri);
        intent.addCategory(WEEX_CATEGORY);

        if (callback != null) {

            intent.putExtra("sendRenderStatus", true);

            final ServiceCallBack serviceCallBack = new ServiceCallBack();
            OnServiceCallBack onServiceCallBack = new OnServiceCallBack() {
                @Override
                public void onServiceCallBack(String info) {
                    callback.invoke(info);
                    mWXSDKInstance.getContext().unregisterReceiver(serviceCallBack);
                }
            };
            serviceCallBack.setOnServiceCallBack(onServiceCallBack);

            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction("com.study.core.util.ServiceCallBack");
            mWXSDKInstance.getContext().registerReceiver(serviceCallBack, intentFilter);
        }
        mWXSDKInstance.getContext().startActivity(intent);
    }

    @JSMethod(uiThread = true)
    public void popPage() {
        Activity currentActivity = (Activity)mWXSDKInstance.getContext();
        currentActivity.finish();
    }
}
