package com.softbi.extend.module;

import android.app.Activity;
import android.util.Log;
import android.widget.Toast;

import com.softbi.config.ConfigInfo;
import com.softbi.core.BaseApplication;
import com.softbi.utils.HttpUtil;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;

import org.json.JSONObject;

import java.util.Map;

/**
 * Created by michael on 2018/1/8.
 */

public class WXHttpModule extends WXModule {

    @JSMethod(uiThread = true)
    public void request(Map<String, Object> data, final JSCallback callback) {
        String url = (String) data.get("url");
        Map<String, Object> dict = (Map<String, Object>) data.get("data");

        if (url.contains("app/local")) {
            url = ConfigInfo.getInstance().getLocalApiUrl() + url;
        } else {
            url = ConfigInfo.getInstance().getApiBaseUrl() + url;
        }

        String type = (String) data.get("type");
        boolean isJsonType = false;
        if (type != null && type.equals("JSON")) {
            isJsonType = true;
        }

        HttpUtil.getInstance().post(url, dict, isJsonType, new HttpUtil.HttpCallback<JSONObject>() {
            @Override
            public void done(JSONObject data) {
                Log.i("httpdone", data.toString());
                callback.invoke(data.toString());
            }

            @Override
            public void fail(final Exception e) {
                ((Activity)mWXSDKInstance.getContext()).runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        String msg = e.getLocalizedMessage();
                        if (msg == null) {
                            msg = e.toString();
                        }
                        Toast.makeText(mWXSDKInstance.getContext(), msg, Toast.LENGTH_LONG).show();
                    }
                });
                String errorCode = "500";
                String errMsg = "{\"status\":\""+errorCode+"\", \"errMsg\":\""+e.getLocalizedMessage()+"\"}";
                callback.invoke(errMsg.toString());
                if (e.getLocalizedMessage() != null) {
                    Log.i("httpfail", e.getLocalizedMessage());
                }
            }
        });
    }

    @JSMethod(uiThread = true)
    public void login(Map<String, Object> data, final JSCallback callback) {
        String usercode = (String)data.get("usercode");
        String password = (String)data.get("password");
        HttpUtil.getInstance().login(usercode, password, new HttpUtil.HttpCallback<JSONObject>() {
            @Override
            public void done(JSONObject data) {
                String dataS = data.toString();
                callback.invoke(dataS);
            }

            @Override
            public void fail(final Exception e) {
                ((Activity)mWXSDKInstance.getContext()).runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        String msg = e.getLocalizedMessage();
                        Toast.makeText(mWXSDKInstance.getContext(), msg, Toast.LENGTH_LONG).show();
                    }
                });
                Log.i("httpfail", e.getLocalizedMessage());
            }
        });
    }

    @JSMethod(uiThread = true)
    public void doLogout() {
        // 登出操作，返回登录页面 清空用户信息
        ((BaseApplication)BaseApplication.getContext()).doLoginOut();
    }

    @JSMethod(uiThread = false)
    public String getApiBaseUrl() {
        String baseUrl = ConfigInfo.getInstance().getApiBaseUrl();
        return baseUrl;
    }

    @JSMethod(uiThread = false)
    public String getVueBaseUrl() {
        String baseUrl = ConfigInfo.getInstance().getVueBaseUrl();
        return baseUrl;
    }
}
