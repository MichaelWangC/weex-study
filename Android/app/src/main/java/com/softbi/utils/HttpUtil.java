package com.softbi.utils;

import com.alibaba.fastjson.JSON;
import com.softbi.config.ConfigInfo;
import com.softbi.core.BaseApplication;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Cookie;
import okhttp3.CookieJar;
import okhttp3.FormBody;
import okhttp3.HttpUrl;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

/**
 * Created by michael on 2017/12/21.
 */

public class HttpUtil {
    public static final long DEFAULT_READ_TIMEOUT_MILLIS = 50 * 1000;
    public static final long DEFAULT_WRITE_TIMEOUT_MILLIS = 20 * 1000;
    public static final long DEFAULT_CONNECT_TIMEOUT_MILLIS = 20 * 1000;

    private static volatile HttpUtil sInstance;
    private OkHttpClient okHttpClient;
    private CookiesManager cookiesManager;
    private HttpUtil () {

        cookiesManager = new CookiesManager();
        okHttpClient = new OkHttpClient.Builder()
                .connectTimeout(DEFAULT_CONNECT_TIMEOUT_MILLIS, TimeUnit.MILLISECONDS)
                .readTimeout(DEFAULT_READ_TIMEOUT_MILLIS, TimeUnit.MILLISECONDS)
                .writeTimeout(DEFAULT_WRITE_TIMEOUT_MILLIS, TimeUnit.MILLISECONDS)
                .cookieJar(cookiesManager)
                .build();
    }

    /**
     * 自动管理Cookies
     */
    private class CookiesManager implements CookieJar {
        private HashMap<String, List<Cookie>> cookieStore = new HashMap<>();

        @Override
        public void saveFromResponse(HttpUrl url, List<Cookie> cookies) {
            if (cookies != null && cookies.size() > 0) {
                cookieStore.put(url.host(), cookies);
            }
        }

        @Override
        public List<Cookie> loadForRequest(HttpUrl url) {
            List<Cookie> cookies = cookieStore.get(url.host());
            return cookies != null ? cookies : new ArrayList<Cookie>();
        }

        public void clearCookies() {
            cookieStore = new HashMap<>();
        }
    }

    public void clearCookies() {
        cookiesManager.clearCookies();
    }

    public static HttpUtil getInstance() {
        if (sInstance == null) {
            synchronized (HttpUtil.class) {
                if (sInstance == null) {
                    sInstance = new HttpUtil();
                }
            }
        }
        return sInstance;
    }

    public interface HttpCallback<T>{
        public void done(T data);
        public void fail(Exception e);
    }

    public void post(String url, Map<String, Object> params, final HttpCallback<JSONObject> callback) {
        this.post(url, params, false, callback);
    }

    public void post(String url, Map<String, Object> params, boolean isJsonType, final HttpCallback<JSONObject> callback) {

        String token = UserUtil.getInstance().getToken();
        if (token == null || token.equals("")) {
            token = "";
        }

        Request request;
        if (isJsonType) {
            String paramsJson = JSON.toJSONString(params);
            MediaType JSON = MediaType.parse("application/json; charset=utf-8");
            RequestBody requestBody = RequestBody.create(JSON, paramsJson);
            request = new Request.Builder()
                    .url(url)
                    .post(requestBody)
                    .addHeader("Accept","application/json, text/plain, */*")
                    .addHeader("Content-Type", "application/json; charset=utf-8")
                    .addHeader("token", token)
                    .addHeader("REQUEST-TYPE", "AJAX")
                    .build();
        } else {
            FormBody.Builder build = new FormBody.Builder();
            if (params != null) {
                //增强for循环遍历
                for (Map.Entry<String, Object> entry : params.entrySet()) {
                    build.add(entry.getKey(), entry.getValue().toString());
                }
            }
            FormBody formBody = build.build();
            request = new Request.Builder()
                    .url(url)
                    .post(formBody)
                    .addHeader("Accept","application/json, text/plain, */*")
                    .addHeader("token", token)
                    .addHeader("REQUEST-TYPE", "AJAX")
                    .build();
        }

        okHttpClient.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                callback.fail(e);
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                String bodyStr = response.body().string();
                try {
                    JSONObject jsonObject = new JSONObject(bodyStr);
                    // 数据校验
                    String code = jsonObject.getString("status");
                    if (code.equals("100")) {
                        Exception e = new Exception("登录验证过期或未登录，请重新登录");
                        callback.fail(e);
                        // 登出操作，返回登录页面 清空用户信息
                        ((BaseApplication)BaseApplication.getContext()).doLoginOut();
                    } else if(code.equals("500")) {
                        String statuMsg = jsonObject.getString("statuMsg");
                        Exception e = new Exception(statuMsg);
                        // 登出操作，返回登录页面 清空用户信息
                        callback.fail(e);
                    } else {
                        callback.done(jsonObject);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    callback.fail(e);
                }
            }
        });
    }

    public void login(final String phone, String password, final HttpCallback<JSONObject> callback) {
        String loginUrl = ConfigInfo.getInstance().getAPILoginUrl();
        Map<String, Object> params = new HashMap<>();
        params.put("phone", phone);
        params.put("code", password);
        this.post(loginUrl, params, new HttpCallback<JSONObject>() {
            @Override
            public void done(JSONObject data) {
                try {
                    // 数据校验
                    String code = data.getString("status");
                    if (code.equals("100")) {
                        Exception e = new Exception("登录验证过期或未登录，请重新登录");
                        callback.fail(e);
                    } else {
                        // 保存登录成功返回de信息
                        UserUtil userUtil = UserUtil.getInstance();
                        JSONObject map = data.getJSONObject("data");
                        String token = (String)map.get("token");
                        userUtil.setToken(token);

                        JSONObject userInfo = map.getJSONObject("user");
                        String userCode = userInfo.optString("userCode");
                        userUtil.setUserCode(userCode);
                        String loginCode = userInfo.optString("loginCode");
                        userUtil.setLoginCode(loginCode);
                        String mPhone = userInfo.optString("mphone");
                        userUtil.setMphone(mPhone);
                        String userName = userInfo.optString("userName");
                        userUtil.setUserName(userName);
                        String memo = userInfo.optString("memo");
                        userUtil.setMemo(memo);

                        userUtil.save();

                        callback.done(data);
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                    callback.fail(e);
                }
            }

            @Override
            public void fail(Exception e) {
                callback.fail(e);
            }
        });
    }
}
