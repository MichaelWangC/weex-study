package com.study.core;

import android.content.Intent;
import android.os.Bundle;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.study.R;
import com.study.config.ConfigInfo;

public class WeexBaseActivity extends WeexAbsActivity {

    private ProgressBar mProgressBar;
    private TextView mTipView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mContainer = (ViewGroup) findViewById(R.id.container);
        mProgressBar = (ProgressBar) findViewById(R.id.progress);
        mTipView = (TextView) findViewById(R.id.index_tip);

        Intent intent = this.getIntent();
        mUri = intent.getData();

        if (mUri == null) {
            String homeUrl = ConfigInfo.getInstance().getHomeUrl();
            renderPageByURL(homeUrl);
        } else {
            renderPageByURL(mUri.toString());
        }
    }
}
