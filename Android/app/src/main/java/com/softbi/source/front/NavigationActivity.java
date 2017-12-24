package com.softbi.source.front;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;

import com.softbi.R;
import com.softbi.core.BaseActivity;

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
