package com.softbi.extend.module;

import android.Manifest;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.text.TextUtils;

import com.softbi.config.ConfigInfo;
import com.softbi.core.weex.WeexBaseActivity;
import com.softbi.core.util.OnServiceCallBack;
import com.softbi.core.util.ServiceCallBack;
import com.softbi.source.front.SplashActivity;
import com.softbi.source.front.MainTabbarNavigtionActivity;
import com.softbi.utils.Keys;
import com.softbi.utils.PreferencesManager;
import com.softbi.utils.UserUtil;
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
    public void openTelprompt(String telephone) {
        Intent intent = new Intent(Intent.ACTION_DIAL);
        Uri data = Uri.parse("tel:" + telephone);
        intent.setData(data);
        if (ActivityCompat.checkSelfPermission(mWXSDKInstance.getContext(), Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return;
        }
        mWXSDKInstance.getContext().startActivity(intent);
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
            String rootUrl = ConfigInfo.getInstance().getWeexRootUrl();
            url = url.substring(2);// 去掉 @和/ 符号
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
        Intent intent = new Intent(mWXSDKInstance.getContext(), WeexBaseActivity.class);
        intent.setAction(WEEX_ACTION);
        intent.setData(uri);
        intent.addCategory(WEEX_CATEGORY);

        // 获取url参数
        Bundle bundle = new Bundle();
        String title = uri.getQueryParameter("title");
        if (title != null && !"".equals(title)) {
            intent.putExtra("title", title);
        }
        String navBarIsClear = uri.getQueryParameter("navBarIsClear");
        if (navBarIsClear != null && !"".equals(navBarIsClear)) {
            if (navBarIsClear.equals("true")) {
                intent.putExtra("navBarIsClear", true);
            } else {
                intent.putExtra("navBarIsClear", false);
            }
        }

        String isHiddenNavBar = uri.getQueryParameter("isHiddenNavBar");
        if (isHiddenNavBar != null && !"".equals(isHiddenNavBar)) {
            if (isHiddenNavBar.equals("true")) {
                intent.putExtra("isHiddenNavBar", true);
            } else {
                intent.putExtra("isHiddenNavBar", false);
            }
        }

        String backButtonType = uri.getQueryParameter("backButtonType");
        if (backButtonType != null) {
            intent.putExtra("backButtonType", backButtonType);
        }

        if (callback != null) {
            // 查看是否存在回调函数
            intent.putExtra(Keys.IS_CALLBACK_WEEX_RENDER_STATUS, true);

            final ServiceCallBack serviceCallBack = new ServiceCallBack();
            OnServiceCallBack onServiceCallBack = new OnServiceCallBack() {
                @Override
                public void onServiceCallBack(String info) {
                    callback.invoke(info);
                    mWXSDKInstance.getContext().unregisterReceiver(serviceCallBack);
                }
            };
            serviceCallBack.setOnServiceCallBack(onServiceCallBack);

            // 动态注册广播 在weex加载成功后 返回相应信息
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction(ServiceCallBack.CALLBCAK_ACTION);
            mWXSDKInstance.getContext().registerReceiver(serviceCallBack, intentFilter);
        }
        mWXSDKInstance.getContext().startActivity(intent);
    }

    @JSMethod(uiThread = true)
    public void popPage() {
        Activity currentActivity = (Activity)mWXSDKInstance.getContext();
        currentActivity.finish();
    }

    @JSMethod(uiThread = true)
    public void gotoMainTabbar() {
        Activity currentActivity = (Activity)mWXSDKInstance.getContext();

        Intent intent = new Intent(mWXSDKInstance.getContext(), MainTabbarNavigtionActivity.class);
        mWXSDKInstance.getContext().startActivity(intent);

        currentActivity.finish();
    }

    @JSMethod(uiThread = true)
    public void showGestureLock(String type) {
        String loginUrl = ConfigInfo.getInstance().getWeexRootUrl() + "modules/front/gestureLock.js?type="+type;
        Intent intent = new Intent(mWXSDKInstance.getContext(), WeexBaseActivity.class);

        Uri uri = Uri.parse(loginUrl.toString());
        intent.setData(uri);
        intent.putExtra("navBarIsClear", true);
        intent.putExtra("showBackBtn", false);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK
                | Intent.FLAG_ACTIVITY_NEW_TASK);

        mWXSDKInstance.getContext().startActivity(intent);

        Activity currentActivity = (Activity)mWXSDKInstance.getContext();
        currentActivity.finish();
    }

    @JSMethod(uiThread = true)
    public void navigationNext() {
        String token = UserUtil.getInstance().getToken();
        if (token != null && !token.equals("")) {
            if (PreferencesManager.getBoolean(mWXSDKInstance.getContext(), PreferencesManager.BOOLEAN_USE_GERSURE_LOCK, false)) {
                this.showGestureLock("lock");
                return;
            }
            this.gotoMainTabbar();
        } else {
            Intent intent = SplashActivity.getLoginIntent(mWXSDKInstance.getContext());
            mWXSDKInstance.getContext().startActivity(intent);
        }
        Activity currentActivity = (Activity)mWXSDKInstance.getContext();
        currentActivity.finish();
    }

    private ProgressDialog progressDialog;
    @JSMethod(uiThread = true)
    public void showLoadingStatus() {
        if (progressDialog == null) {
            progressDialog = new ProgressDialog(mWXSDKInstance.getContext());
            progressDialog.setCancelable(false);
        }
        progressDialog.show();
    }

    @JSMethod(uiThread = true)
    public void hideLoadingStatus() {
        if (progressDialog != null) {
            progressDialog.hide();
        }
    }
}
