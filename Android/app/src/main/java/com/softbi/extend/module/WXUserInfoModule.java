package com.softbi.extend.module;

import com.softbi.utils.PreferencesManager;
import com.softbi.utils.UserUtil;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.common.WXModule;

/**
 * Created by michael on 2018/3/1.
 */

public class WXUserInfoModule extends WXModule {
    @JSMethod(uiThread = false)
    public String getUserName(){
        return UserUtil.getInstance().getUserName();
    }

    @JSMethod(uiThread = false)
    public String getMobilePhone(){
        return UserUtil.getInstance().getMphone();
    }

    @JSMethod(uiThread = false)
    public String getUserMemo(){
        return UserUtil.getInstance().getMemo();
    }

    //String memo
    @JSMethod(uiThread = false)
    public void saveUserMemo(String memo){
        UserUtil userUtil = UserUtil.getInstance();
        userUtil.setMemo(memo);
        userUtil.save();
    }

    @JSMethod(uiThread = false)
    public void setGestureLockBoolean(String isopen) {
        if (isopen.equals("true")) {
            PreferencesManager.putBoolean(mWXSDKInstance.getContext(), PreferencesManager.BOOLEAN_USE_GERSURE_LOCK, true);
        } else {
            PreferencesManager.putBoolean(mWXSDKInstance.getContext(), PreferencesManager.BOOLEAN_USE_GERSURE_LOCK, false);
        }
    }

    @JSMethod(uiThread = false)
    public boolean getGestureLockBoolean() {
        return PreferencesManager.getBoolean(mWXSDKInstance.getContext(), PreferencesManager.BOOLEAN_USE_GERSURE_LOCK, false);
    }

    @JSMethod(uiThread = false)
    public void setGestureLockPassword(String password) {
        UserUtil userUtil = UserUtil.getInstance();
        userUtil.setGestruePassword(password);
        userUtil.save();
    }

    @JSMethod(uiThread = false)
    public String getGestureLockPassword() {
        UserUtil userUtil = UserUtil.getInstance();
        return userUtil.getGestruePassword();
    }
}
