package com.softbi.core.weex;

import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.softbi.R;
import com.softbi.core.BaseFragment;
import com.taobao.weex.IWXRenderListener;
import com.taobao.weex.WXSDKInstance;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXRenderStrategy;
import com.umeng.analytics.MobclickAgent;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by michael on 2018/1/3.
 */

public class WeexBaseFragment extends BaseFragment implements IWXRenderListener {

    private FrameLayout mContainerView;
    private LinearLayout rootView;
    private View mToolbar;
    private View baseToolBar;
    protected WXSDKInstance mInstance;

    private String mUrl;
    private String mTitle;
    private String pageName;
    private boolean isHiddenNavBar;
    private boolean navBarIsClear;
    private boolean showBackBtn = true;

    public void setUrl(String mUrl) {
        this.mUrl = mUrl;
        // 获取当前页面 js名称
        int jsIndex = mUrl.indexOf(".js");
        if (jsIndex != -1) {
            this.pageName = mUrl.substring(0, jsIndex+3);
            String[] pageNames = this.pageName.split("/");
            String lastStr = "";
            if (pageNames.length > 0) {
                lastStr = pageNames[pageNames.length - 1];
            }
            this.pageName = lastStr;
        }
    }

    public void setHiddenNavBar(boolean hiddenNavBar) {
        isHiddenNavBar = hiddenNavBar;
    }

    public void setNavBarIsClear(boolean navBarIsClear) {
        this.navBarIsClear = navBarIsClear;
    }

    public void setTitle(String mTitle) {
        this.mTitle = mTitle;
    }

    public void setShowBackBtn(boolean showBackBtn) {
        this.showBackBtn = showBackBtn;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        mInstance = new WXSDKInstance(getActivity());
        mInstance.registerRenderListener(this);
        Map<String, Object> options = new HashMap<>();
        options.put(WXSDKInstance.BUNDLE_URL, mUrl);

        mInstance.renderByUrl(
                "WeexBaseFragment",
                mUrl,
                options,
                null,
                WXRenderStrategy.APPEND_ASYNC);

        View retView = null;
        mToolbar = inflater.inflate(R.layout.base_toolbar, null);
        baseToolBar = mToolbar.findViewById(R.id.base_toolbar);
        ImageButton backBtn = mToolbar.findViewById(R.id.back_btn);
        TextView tv_title = mToolbar.findViewById(R.id.title_tv);
        if (mTitle != null && !"".equals(mTitle)) {
            tv_title.setText(mTitle);
        } else {
            tv_title.setText("");
        }
        if (showBackBtn) {
            backBtn.setVisibility(View.VISIBLE);
            backBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    getActivity().finish();
                }
            });
        } else {
            backBtn.setVisibility(View.GONE);
        }

        // toolbar 隐藏显示设置t
        if (isHiddenNavBar) {
            mContainerView = new FrameLayout(getActivity());
            retView = mContainerView;
        } else if (navBarIsClear) {
            mContainerView = new FrameLayout(getActivity());
            retView = mContainerView;
            baseToolBar.setBackgroundColor(getResources().getColor(R.color.clear_color));
        } else {
            rootView = new LinearLayout(getActivity());
            rootView.setOrientation(LinearLayout.VERTICAL);
//            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.WRAP_CONTENT);
            rootView.addView(mToolbar, LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);

            retView = rootView;
        }
        return retView;

    }

    @Override
    public void onResume() {
        super.onResume();
        MobclickAgent.onPageStart(this.pageName);
    }

    @Override
    public void onPause() {
        super.onPause();
        MobclickAgent.onPageEnd(this.pageName);
    }

    @Override
    public void onViewCreated(WXSDKInstance instance, final View view) {
        if (isHiddenNavBar) {
            mContainerView.addView(view);
        } else if (navBarIsClear) {
            mContainerView.addView(view);

            mContainerView.addView(mToolbar, FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.WRAP_CONTENT);
        } else {
            rootView.addView(view);
        }
    }

    @Override
    public void onRenderSuccess(WXSDKInstance instance, int width, int height) {
        Log.i("onRenderSuccess", "onRenderSuccess");
    }

    @Override
    public void onRefreshSuccess(WXSDKInstance instance, int width, int height) {

    }

    @Override
    public void onException(WXSDKInstance instance, String errCode, String msg) {
        Log.e("onRenderException", msg);
    }

    /**
     * 设置导航栏按钮
     */
    public void setNavRightButtonsWithTitles(List<String> titles, final JSCallback callback) {
        LinearLayout barView = (LinearLayout)mToolbar.findViewById(R.id.right_btn_view);

        final float scale = this.getResources().getDisplayMetrics().density;
        float btnWidthDp = getResources().getDimension(R.dimen.nav_btn_width);
        float btnHeightDp = getResources().getDimension(R.dimen.nav_btn_height);
        int btnWidthPx= (int) (btnWidthDp);
        int btnHeightPx= (int) (btnHeightDp);

        int index = titles.size() - 1;
        for (; index >= 0; index--) {
            final String title = titles.get(index);
//            Button button = new Button(getActivity());
            TextView button = new TextView(getActivity());
            button.setText(title);
            button.setTextColor(getResources().getColor(R.color.color_text_default));
            button.setVisibility(View.VISIBLE);
            button.setTextSize(17);
            button.setGravity(Gravity.CENTER);
            button.setBackgroundColor(getResources().getColor(R.color.clear_color));
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.MATCH_PARENT);
            lp.setMargins(0, 0, 20, 0);
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
        LinearLayout barView = (LinearLayout)mToolbar.findViewById(R.id.right_btn_view);

        final float scale = this.getResources().getDisplayMetrics().density;
        float btnWidthDp = getResources().getDimension(R.dimen.nav_icon_width);
        float btnHeightDp = getResources().getDimension(R.dimen.nav_icon_height);
        int btnWidthPx= (int) (btnWidthDp);
        int btnHeightPx= (int) (btnHeightDp);

        int index = images.size() - 1;
        for (; index >= 0; index--) {
            final String image = images.get(index);
            ImageView imageView = new ImageView(getActivity());
            int id = getResources().getIdentifier(image, "drawable", getActivity().getPackageName());
            imageView.setImageDrawable(getResources().getDrawable(id));

            imageView.setVisibility(View.VISIBLE);
            imageView.setLayoutParams(new LinearLayout.LayoutParams(btnWidthPx, btnHeightPx));
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
