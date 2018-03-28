package com.softbi.source.front;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;

import com.softbi.R;
import com.softbi.config.ConfigInfo;
import com.softbi.core.BaseActivity;
import com.softbi.core.weex.WeexBaseActivity;
import com.softbi.utils.PreferencesManager;
import com.softbi.utils.UserUtil;

/**
 * Created by michael on 2018/1/25.
 */

public class SplashActivity extends BaseActivity {

    private boolean isFirstOpenApp = false;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash_activity);

        String localVersion = "0";
        try {
            // 当前版本号获取
            PackageInfo packageInfo = this.getApplicationContext().getPackageManager().getPackageInfo(this.getPackageName(), 0);
            localVersion = packageInfo.versionName;
            // 本地保存版本号
            String saveVersion = PreferencesManager.getString(SplashActivity.this, PreferencesManager.APP_VERSION_INFO);
            if (saveVersion.equals(localVersion)) {
                isFirstOpenApp = false;
            } else {
                isFirstOpenApp = true;
            }
            isFirstOpenApp = true;
            PreferencesManager.putString(SplashActivity.this, PreferencesManager.APP_VERSION_INFO, localVersion);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        toNextActivity();
    }

    private void toNextActivity() {
        if (isFirstOpenApp) {
            Intent intent = getNavigationInten(SplashActivity.this);
            startActivity(intent);
            this.finish();
            return;
        }
        String token = UserUtil.getInstance().getToken();
        if (token != null && !token.equals("")) {
            Intent intent = new Intent(SplashActivity.this, MainTabbarNavigtionActivity.class);
            if (PreferencesManager.getBoolean(SplashActivity.this, PreferencesManager.BOOLEAN_USE_GERSURE_LOCK, false)) {
                intent = getGestureIntent(SplashActivity.this);
            }
            startActivity(intent);
        } else {
            Intent intent = getLoginIntent(SplashActivity.this);
            startActivity(intent);
        }
        this.finish();
    }

    /**
     * 登录页面
     * @param context
     * @return
     */
    public static Intent getLoginIntent(Context context) {
        String loginUrl = ConfigInfo.getInstance().getWeexRootUrl() + "modules/front/login.js";
        Intent intent = new Intent(context, WeexBaseActivity.class);

        Uri uri = Uri.parse(loginUrl.toString());
        intent.setData(uri);
        intent.putExtra("navBarIsClear", true);
        intent.putExtra("showBackBtn", false);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK
                | Intent.FLAG_ACTIVITY_NEW_TASK);
        return intent;
    }

    /**
     * 手势密码
     * @param context
     * @return
     */
    public static Intent getGestureIntent(Context context) {
        String loginUrl = ConfigInfo.getInstance().getWeexRootUrl() + "modules/front/gestureLock.js?type=lock";
        Intent intent = new Intent(context, WeexBaseActivity.class);

        Uri uri = Uri.parse(loginUrl.toString());
        intent.setData(uri);
        intent.putExtra("navBarIsClear", true);
        intent.putExtra("showBackBtn", false);
        intent.putExtra("backButtonType", "BackButtonTypeWhite");
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK
                | Intent.FLAG_ACTIVITY_NEW_TASK);
        return intent;
    }

    public static  Intent getNavigationInten(Context context) {
        String loginUrl = ConfigInfo.getInstance().getWeexRootUrl() + "modules/front/navigationView.js";
        Intent intent = new Intent(context, WeexBaseActivity.class);

        Uri uri = Uri.parse(loginUrl.toString());
        intent.setData(uri);
        intent.putExtra("navBarIsClear", true);
        intent.putExtra("showBackBtn", false);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK
                | Intent.FLAG_ACTIVITY_NEW_TASK);
        return intent;
    }

}
