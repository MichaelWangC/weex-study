package com.softbi.config;

import android.content.Context;

import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;

/**
 * Created by michael on 2018/3/15.
 */

public class UMConfigManage {
    public static void setup(Context context) {
        UMConfigure.init(context, UMConfigManage.getAppKey(), "softbi Android", UMConfigure.DEVICE_TYPE_PHONE, "");

        MobclickAgent.setScenarioType(context, MobclickAgent.EScenarioType.E_DUM_NORMAL);
        MobclickAgent.openActivityDurationTrack(false);
    }

    private static String getAppKey() {
        if (ConfigInfo.getInstance().getReleaseType() == ConfigInfo.ReleaseType.PUBLISH) {
            return "";
        } else {
            return "5a56cf68f43e485644000117";
        }
    }
}
