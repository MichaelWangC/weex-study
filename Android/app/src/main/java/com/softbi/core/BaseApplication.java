package com.softbi.core;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.Application;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.softbi.config.UMConfigManage;
import com.softbi.config.WeexSDKManager;
import com.softbi.source.front.SplashActivity;
import com.softbi.utils.HttpUtil;
import com.softbi.utils.PreferencesManager;
import com.softbi.utils.UserUtil;

import java.lang.ref.WeakReference;
import java.util.List;

/**
 * Created by michael on 2017/10/13.
 */

public class BaseApplication extends Application implements Application.ActivityLifecycleCallbacks {

    private static Context context;

    @Override
    public void onCreate() {
        super.onCreate();

        context = getApplicationContext();
        registerActivityLifecycleCallbacks(this);

        // weex注册
        WeexSDKManager.setup(this);

        // 友盟注册
        UMConfigManage.setup(this);
    }

    public static Context getContext() {
        return context;
    }

    /**
     * 登出
     */
    public void doLoginOut () {
        UserUtil.getInstance().clear();
        HttpUtil.getInstance().clearCookies();
        PreferencesManager.putBoolean(this, PreferencesManager.BOOLEAN_USE_GERSURE_LOCK, false);
        // 跳转登录页面
        Intent intent = SplashActivity.getLoginIntent(this);
        Activity activity = getTopActivity();
        activity.startActivity(intent);
    }

    /**************** 应用退出 *******************/

    private WeakReference<Activity> topActivityRef;
    private void setTopActivity(Activity activity){
        topActivityRef = activity==null?null:new WeakReference<Activity>(activity);
    }

    public Activity getTopActivity(){
        if(topActivityRef == null)return null;
        Activity activity = topActivityRef.get();
        if(activity == null)return null;
        return isTopActivity(activity)?activity:null;
    }

    private static boolean isTopActivity(Activity activity) {
        ActivityManager am = (ActivityManager) activity.getApplication().getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningTaskInfo> tasks = am.getRunningTasks(1);
        if (!tasks.isEmpty()) {
            ComponentName topActivity = tasks.get(0).topActivity;
            Log.i("Top Activity","top:"+topActivity.getPackageName()+" "+topActivity.getClassName());
            Log.i("Top Activity", "top1:"+activity.getPackageName()+" "+activity.getClass().getName());
            if (topActivity.getPackageName().equals(activity.getPackageName())
                    && topActivity.getClassName().equals(activity.getClass().getName())) {
                return true;
            }
        }
        return false;
    }

    /******************** ActivityLifecycleCallbacks **************/
    @Override
    public void onActivityCreated(Activity activity, Bundle bundle) {

    }

    @Override
    public void onActivityStarted(Activity activity) {

    }

    @Override
    public void onActivityResumed(Activity activity) {
        setTopActivity(activity);
    }

    @Override
    public void onActivityPaused(Activity activity) {

    }

    @Override
    public void onActivityStopped(Activity activity) {

    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle bundle) {

    }

    @Override
    public void onActivityDestroyed(Activity activity) {

    }
}
