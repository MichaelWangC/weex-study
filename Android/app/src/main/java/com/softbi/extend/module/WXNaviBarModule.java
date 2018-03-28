package com.softbi.extend.module;

import com.softbi.core.weex.WeexBaseActivity;
import com.softbi.core.weex.WeexBaseFragment;
import com.softbi.source.front.MainTabbarNavigtionActivity;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;

import java.util.List;

/**
 * Created by michael on 2018/1/9.
 */

public class WXNaviBarModule extends WXModule {

    @JSMethod(uiThread = true)
    public void setNavRightButtonsWithTitles(List<String> titles, final JSCallback callback) {
        Class mclass = mWXSDKInstance.getContext().getClass();
        if (mclass == WeexBaseActivity.class) {
            ((WeexBaseActivity)mWXSDKInstance.getContext()).setNavRightButtonsWithTitles(titles, callback);
        } else if (mclass == MainTabbarNavigtionActivity.class) {
            String bundleUrl = mWXSDKInstance.getBundleUrl();
            // 首页 fragment需 自己判断 控制
            if (bundleUrl.contains("mine")) {
                WeexBaseFragment mineFragment = (WeexBaseFragment)((MainTabbarNavigtionActivity)mWXSDKInstance.getContext()).getPagelist().get(3);
                mineFragment.setNavRightButtonsWithTitles(titles, callback);
            }
        }
    }

    @JSMethod(uiThread = true)
    public void setNavRightButtonsWithImages(List<String> images, final JSCallback callback) {
        Class mclass = mWXSDKInstance.getContext().getClass();
        if (mclass == WeexBaseActivity.class) {
            ((WeexBaseActivity)mWXSDKInstance.getContext()).setNavRightButtonsWithImages(images, callback);
        } else if (mclass == MainTabbarNavigtionActivity.class) {
            String bundleUrl = mWXSDKInstance.getBundleUrl();
            // 首页 fragment需 自己判断 控制
            if (bundleUrl.contains("mine")) {
                WeexBaseFragment mineFragment = (WeexBaseFragment)((MainTabbarNavigtionActivity)mWXSDKInstance.getContext()).getPagelist().get(3);
                mineFragment.setNavRightButtonsWithImages(images, callback);
            } else if (bundleUrl.contains("home")) {
                WeexBaseFragment homeFragment = (WeexBaseFragment)((MainTabbarNavigtionActivity)mWXSDKInstance.getContext()).getPagelist().get(0);
                homeFragment.setNavRightButtonsWithImages(images, callback);
            }
        }
    }

    @JSMethod(uiThread = true)
    public void setNavBarColor(String color, float opacity, JSCallback callback) {
        Class mclass = mWXSDKInstance.getContext().getClass();
        if (mclass == WeexBaseActivity.class) {
            ((WeexBaseActivity)mWXSDKInstance.getContext()).setNavBarColor(color, opacity, callback);
        } else if (mclass == MainTabbarNavigtionActivity.class) {
            String bundleUrl = mWXSDKInstance.getBundleUrl();
            // 首页 fragment需 自己判断 控制
            if (bundleUrl.contains("home")) {
                WeexBaseFragment homeFragment = (WeexBaseFragment)((MainTabbarNavigtionActivity)mWXSDKInstance.getContext()).getPagelist().get(0);
                homeFragment.setNavBarColor(color, opacity, callback);
            }
        }
    }

}
