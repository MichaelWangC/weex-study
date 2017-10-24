package com.study.core;

import android.content.Intent;
import android.os.Bundle;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.study.R;
import com.study.config.ConfigInfo;
import com.taobao.weex.WXSDKInstance;

public class WeexBaseActivity extends WeexAbsActivity {

    private ProgressBar mProgressBar;
    private TextView mTipView;
    private boolean sendRenderStatus;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mContainer = (ViewGroup) findViewById(R.id.container);
        mProgressBar = (ProgressBar) findViewById(R.id.progress);
        mTipView = (TextView) findViewById(R.id.index_tip);

        Intent intent = this.getIntent();
        mUri = intent.getData();

        sendRenderStatus = this.getIntent().getBooleanExtra("sendRenderStatus", false);

        if (mUri == null) {
            String homeUrl = ConfigInfo.getInstance().getHomeUrl();
            renderPageByURL(homeUrl);
        } else {
            renderPageByURL(mUri.toString());
        }
    }

    @Override
    public void onRenderSuccess(WXSDKInstance instance, int width, int height) {
        super.onRenderSuccess(instance, width, height);
        if (sendRenderStatus){
            Intent intent = new Intent();
            intent.setAction("com.study.core.util.ServiceCallBack");
            intent.putExtra("sendRenderStatus", "success");
            intent.addFlags(Intent.FLAG_INCLUDE_STOPPED_PACKAGES);

            WeexBaseActivity.this.sendBroadcast(intent);
        }
    }
}
