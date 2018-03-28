package com.softbi.extend.component;

import android.content.Context;
import android.support.annotation.NonNull;
import android.view.View;

import com.airbnb.lottie.LottieAnimationView;
import com.taobao.weex.WXSDKInstance;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.dom.WXDomObject;
import com.taobao.weex.ui.component.WXComponent;
import com.taobao.weex.ui.component.WXComponentProp;
import com.taobao.weex.ui.component.WXVContainer;

/**
 * Created by michael on 2018/3/13.
 */

public class WXLOTAnimationView extends WXComponent {
    public WXLOTAnimationView(WXSDKInstance instance, WXDomObject dom, WXVContainer parent) {
        super(instance, dom, parent);
    }

    private LottieAnimationView lottieAnimationView;
    @Override
    protected View initComponentHostView(@NonNull Context context) {
        lottieAnimationView = new LottieAnimationView(context);
        lottieAnimationView.setImageAssetsFolder("images");
        return lottieAnimationView;
    }

    @WXComponentProp(name = "src")
    public void setSrc(String src) {
        lottieAnimationView.setAnimation(src);
    }

    @WXComponentProp(name = "loop")
    public void setLoop(String loop) {
        if (loop.equals("false")) {
            lottieAnimationView.loop(false);
        } else  {
            lottieAnimationView.loop(true);
        }
    }

    @JSMethod
    public void play() {
        lottieAnimationView.playAnimation();
    }

    @JSMethod
    public void stop() {
        lottieAnimationView.pauseAnimation();
    }

}
