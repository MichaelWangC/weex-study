package com.study.core;

import android.content.Intent;
import android.os.Bundle;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.study.R;

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
            renderPageByURL("http://10.0.2.2:8081/dist/weex/index.js");
        } else {
            renderPageByURL(mUri.toString());
        }
    }
}
