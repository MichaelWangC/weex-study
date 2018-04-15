package com.softbi.core.weex;

import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.softbi.R;
import com.softbi.config.ConfigInfo;
import com.softbi.core.util.ServiceCallBack;
import com.softbi.utils.Keys;
import com.taobao.weex.WXSDKInstance;
import com.taobao.weex.bridge.JSCallback;
import com.umeng.analytics.MobclickAgent;

import java.util.List;

public class WeexBaseActivity extends WeexAbsActivity {

    private boolean sendRenderStatus;
    private String mTitle;
    private String pageName;
    private View toolbar;
    private View baseToolBar;
    private String backButtonType;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.weex_activity_main);

        Intent intent = this.getIntent();
        mUri = intent.getData();
        LinearLayout weexLinear = (LinearLayout) findViewById(R.id.weex_linear_layout);
        FrameLayout weexFrame = (FrameLayout) findViewById(R.id.weex_frame_layout);
        // 导航栏参数
        boolean isHiddenNavBar = intent.getBooleanExtra("isHiddenNavBar", false);
        boolean navBarIsClear = intent.getBooleanExtra("navBarIsClear", false);
        boolean showBackBtn = intent.getBooleanExtra("showBackBtn", true);
        backButtonType = intent.getStringExtra("backButtonType");

        ViewGroup frameContainer = (ViewGroup) findViewById(R.id.frame_container);
        ViewGroup lineContainer = (ViewGroup) findViewById(R.id.line_container);

        if (isHiddenNavBar) {
            // 导航栏隐藏
            mContainer = frameContainer;
            weexLinear.setVisibility(View.GONE);
            weexFrame.setVisibility(View.VISIBLE);
            toolbar = weexFrame.findViewById(R.id.frame_toolbar);
            toolbar.setVisibility(View.GONE);
        } else if (navBarIsClear) {
            // 导航栏透明
            mContainer = frameContainer;
            weexLinear.setVisibility(View.GONE);
            weexFrame.setVisibility(View.VISIBLE);
            toolbar = weexFrame.findViewById(R.id.frame_toolbar);
            baseToolBar = toolbar.findViewById(R.id.base_toolbar);
            baseToolBar.setBackgroundColor(getResources().getColor(R.color.clear_color));
        } else {
            // 导航栏显示
            mContainer = lineContainer;
            weexLinear.setVisibility(View.VISIBLE);
            weexFrame.setVisibility(View.GONE);
            toolbar = weexLinear.findViewById(R.id.line_toolbar);
        }
        baseToolBar = toolbar.findViewById(R.id.base_toolbar);

        // 导航栏返回按钮图标类型
        if (backButtonType != null && backButtonType.equals("BackButtonTypeWhite")) {
            ImageButton backBtn = baseToolBar.findViewById(R.id.back_btn);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                backBtn.setBackground(getResources().getDrawable(R.drawable.icon_back_white));
            } else {
                backBtn.setBackgroundDrawable(getResources().getDrawable(R.drawable.icon_back_white));
            }

            TextView textView = baseToolBar.findViewById(R.id.title_tv);
            textView.setTextColor(getResources().getColor(R.color.white));
        }

        // 导航栏标题
        TextView textView = toolbar.findViewById(R.id.title_tv);
        String title = intent.getStringExtra("title");
        if (title != null && !"".equals(title)) {
            textView.setText(title);
        } else {
            textView.setText("");
        }
        // 返回按钮
        ImageButton backBtn = toolbar.findViewById(R.id.back_btn);
        if (showBackBtn) {
            backBtn.setVisibility(View.VISIBLE);
            backBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    finish();
                }
            });
        } else {
            backBtn.setVisibility(View.GONE);
        }

        // weex加载状态通知
        sendRenderStatus = this.getIntent().getBooleanExtra(Keys.IS_CALLBACK_WEEX_RENDER_STATUS, false);
        // weex页面加载
        if (mUri == null) {
            String homeUrl = ConfigInfo.getInstance().getWeexHomeUrl();
            renderPageByURL(homeUrl);
            this.pageName = homeUrl;
        } else {
            renderPageByURL(mUri.toString());
            this.pageName = mUri.toString();
        }

        // 获取当前页面 js名称
        int jsIndex = this.pageName.indexOf(".js");
        if (jsIndex != -1) {
            this.pageName = this.pageName.substring(0, jsIndex+3);
            String[] pageNames = this.pageName.split("/");
            String lastStr = "";
            if (pageNames.length > 0) {
                lastStr = pageNames[pageNames.length - 1];
            }
            this.pageName = lastStr;
        }

    }

    @Override
    protected void onResume() {
        super.onResume();
        MobclickAgent.onPageStart(this.pageName);
    }

    @Override
    public void onPause() {
        super.onPause();
        MobclickAgent.onPageEnd(this.pageName);
    }

    @Override
    public void onRenderSuccess(WXSDKInstance instance, int width, int height) {
        super.onRenderSuccess(instance, width, height);
        if (sendRenderStatus){
            Intent intent = new Intent();
            intent.setAction(ServiceCallBack.CALLBCAK_ACTION);
            intent.putExtra(Keys.WEEX_RENDER_STATUS, "success");
            intent.addFlags(Intent.FLAG_INCLUDE_STOPPED_PACKAGES);

            WeexBaseActivity.this.sendBroadcast(intent);
        }
    }

    /**
     * 设置导航栏按钮
     */
    public void setNavRightButtonsWithTitles(List<String> titles, final JSCallback callback) {
        LinearLayout barView = (LinearLayout)toolbar.findViewById(R.id.right_btn_view);

        final float scale = this.getResources().getDisplayMetrics().density;
        float btnWidthDp = getResources().getDimension(R.dimen.nav_btn_width);
        float btnHeightDp = getResources().getDimension(R.dimen.nav_btn_height);
        int btnWidthPx= (int) (btnWidthDp);
        int btnHeightPx= (int) (btnHeightDp);

        barView.removeAllViews();
        int index = titles.size() - 1;
        for (; index >= 0; index--) {
            final String title = titles.get(index);
            TextView button = new TextView(this);
            button.setText(title);
            if (backButtonType != null && backButtonType.equals("BackButtonTypeWhite")) {
                button.setTextColor(getResources().getColor(R.color.white));
            } else {
                button.setTextColor(getResources().getColor(R.color.color_text_default));
            }
            button.setVisibility(View.VISIBLE);
            button.setTextSize(17);
            button.setGravity(Gravity.CENTER);
            button.setBackgroundColor(getResources().getColor(R.color.clear_color));
            button.setMinWidth(0);
            button.setMinHeight(0);
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.MATCH_PARENT);
            button.setLayoutParams(lp);
            barView.addView(button);
            button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    callback.invokeAndKeepAlive(title);
                }
            });
        }
    }

    public void setNavRightButtonsWithImages(List<String> images, final JSCallback callback) {
        LinearLayout barView = (LinearLayout)toolbar.findViewById(R.id.right_btn_view);

        final float scale = this.getResources().getDisplayMetrics().density;
        float btnWidthDp = getResources().getDimension(R.dimen.nav_icon_width);
        float btnHeightDp = getResources().getDimension(R.dimen.nav_icon_height);
        int btnWidthPx= (int) (btnWidthDp);
        int btnHeightPx= (int) (btnHeightDp);

        barView.removeAllViews();
        int index = images.size() - 1;
        for (; index >= 0; index--) {
            final String image = images.get(index);
            ImageView imageView = new ImageView(this);
            int id = getResources().getIdentifier(image, "drawable", getBaseContext().getPackageName());
            imageView.setImageDrawable(getResources().getDrawable(id));

            imageView.setVisibility(View.VISIBLE);
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(btnWidthPx, btnHeightPx);
            lp.setMargins(40, 0, 0, 0);
            imageView.setLayoutParams(lp);
            barView.addView(imageView);
            imageView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    callback.invokeAndKeepAlive(image);
                }
            });
        }
    }

    /**
     * 设置导航栏颜色
     * @param color
     * @param opacity
     * @param callback
     */
    public void setNavBarColor(String color, float opacity, JSCallback callback) {
        baseToolBar.setBackgroundColor(Color.parseColor(color));
        baseToolBar.getBackground().setAlpha(Math.round(opacity*255));
    }

}
