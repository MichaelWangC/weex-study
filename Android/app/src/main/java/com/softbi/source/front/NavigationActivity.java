package com.softbi.source.front;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;

import com.softbi.R;
import com.softbi.config.ConfigInfo;
import com.softbi.core.BaseActivity;
import com.softbi.utils.HttpUtil;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by michael on 2017/12/18.
 */

public class NavigationActivity extends BaseActivity {
    @Bind(R.id.start_btn)
    android.support.v7.widget.AppCompatButton button;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.navi_page);
        ButterKnife.bind(this);

        this.login();
    }

    private void login () {
//        String url = ConfigInfo.getInstance().getApiBaseUrl() + "login";
//        Map<String, String> params = new HashMap<>();
//        params.put("username", "zhangwei");
//        params.put("password", "111111");
//        HttpUtil.getInstance().post(url, params, new HttpUtil.HttpCallback<JSONObject>() {
//            @Override
//            public void done(JSONObject data) {
//                Log.i("login data", data.toString());
//            }
//
//            @Override
//            public void fail(Exception e) {
//
//            }
//        });
    }

    @OnClick(R.id.start_btn)
    public void OnClick(View view) {
        switch (view.getId()) {
            case  R.id.start_btn:
                Intent intent = new Intent(this, MainTabbarNavigtionActivity.class);
                startActivity(intent);
                finish();
                break;
            default:
                break;
        }
    }

}
