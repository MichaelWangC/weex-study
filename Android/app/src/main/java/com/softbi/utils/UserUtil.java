package com.softbi.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.support.v4.view.PagerAdapter;

import com.softbi.core.BaseApplication;

/**
 * Created by michael on 2017/12/21.
 * 用户信息管理
 */

public class UserUtil {

    private static UserUtil singleInstance = null;
    public static UserUtil getInstance(){
        if(singleInstance!=null){
            return singleInstance;
        }
        synchronized (UserUtil.class) {
            if(singleInstance!=null){
                return singleInstance;
            }
            singleInstance = new UserUtil();
            singleInstance.init();
        }
        return singleInstance;
    }

    private String userCode;
    private String password;
    private String userName;
    private String loginCode;
    private String mphone;
    private String token;
    private String gestruePassword;
    private String memo;

    private void init(){
        SharedPreferences preference = BaseApplication.getContext().getSharedPreferences("user_config", Context.MODE_PRIVATE);
        userCode = preference.getString("usercode", null);
        password = preference.getString("password", null);
        userName = preference.getString("UserName", null);
        token = preference.getString("token", null);
        loginCode = preference.getString("loginCode", null);
        mphone = preference.getString("mphone", null);
        gestruePassword = preference.getString("gestruePassword", null);
        memo = preference.getString("memo", null);
    }

    public boolean isLogin(){
        if(userCode == null || "".equalsIgnoreCase(userCode)){
            return false;
        }
        return true;
    }

    public void clear() {
        userCode = null;
        password = null;
        userName = null;
        token = null;
        loginCode = null;
        mphone = null;
        gestruePassword = null;
        memo = null;

        SharedPreferences preference = BaseApplication.getContext().getSharedPreferences("user_config", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preference.edit();
        editor.clear();
        editor.apply();
    }

    public void save(){
        SharedPreferences preference = BaseApplication.getContext().getSharedPreferences("user_config", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preference.edit();
        if (userCode != null && !userCode.equals("")) {
            editor.putString("usercode", userCode);
        }
        if (password != null && !password.equals("")) {
            editor.putString("password", password);
        }
        if (userName != null && !userName.equals("")) {
            editor.putString("UserName", userName);
        }
        if (token != null && !token.equals("")) {
            editor.putString("token", token);
        }
        if (loginCode != null && !loginCode.equals("")) {
            editor.putString("loginCode", loginCode);
        }
        if (mphone != null && !mphone.equals("")) {
            editor.putString("mphone", mphone);
        }
        if (gestruePassword != null && !gestruePassword.equals("")) {
            editor.putString("gestruePassword", gestruePassword);
        }
        if (memo != null && !memo.equals("")) {
            editor.putString("memo", memo);
        }
        editor.apply();
    }

    public String getUserCode() {
        return userCode;
    }

    public void setUserCode(String userCode) {
        this.userCode = userCode;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getLoginCode() {
        return loginCode;
    }

    public void setLoginCode(String loginCode) {
        this.loginCode = loginCode;
    }

    public String getMphone() {
        return mphone;
    }

    public void setMphone(String mphone) {
        this.mphone = mphone;
    }

    public String getGestruePassword() {
        return gestruePassword;
    }

    public void setGestruePassword(String gestruePassword) {
        this.gestruePassword = gestruePassword;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }
}
