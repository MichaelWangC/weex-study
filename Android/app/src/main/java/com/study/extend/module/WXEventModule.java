package com.study.extend.module;

import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;

import com.study.core.WeexBaseActivity;
import com.taobao.weex.annotation.JSMethod;
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
        if (TextUtils.isEmpty(url)) {
            return;
        }
        String scheme = Uri.parse(url).getScheme();
        StringBuilder builder = new StringBuilder();
        if (TextUtils.equals("http", scheme) || TextUtils.equals("https", scheme) || TextUtils.equals("file", scheme)) {
            builder.append(url);
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
        mWXSDKInstance.getContext().startActivity(intent);

//        if (mWXSDKInstance.checkModuleEventRegistered("event", this)) {
//            HashMap<String,Object> params=new HashMap<>();
//            params.put("param1","param1");
//            params.put("param2","param2");
//            params.put("param3","param3");
//            mWXSDKInstance.fireModuleEvent("event", this, params);
//        }
    }
}
