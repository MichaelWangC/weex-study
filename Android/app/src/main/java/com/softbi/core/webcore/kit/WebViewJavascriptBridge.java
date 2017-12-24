package com.softbi.core.webcore.kit;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.webkit.JavascriptInterface;

import com.softbi.core.BaseActivity;
import com.softbi.core.BaseNavigtionActivity;
import com.softbi.core.webcore.HybridNavigtionActivity;
import com.softbi.core.webcore.widget.WebPage;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.ref.WeakReference;

/**
 * Created by michael on 2017/12/19.
 */

public class WebViewJavascriptBridge {
    final WeakReference<Context> contextRef;
    final WebPage webPage;
    final BaseActivity superActivity;
    boolean hasSetNavBar = false;

    public WebViewJavascriptBridge(Context context, WebPage webPage, BaseActivity superActivity) {
        this.contextRef = new WeakReference<Context>(context);
        this.webPage = webPage;
        this.superActivity = superActivity;
    }

    @JavascriptInterface
    public void OSAndroid(){
    }

    @JavascriptInterface
    public void setNavBarsAppearanceInner(String str) {
        final Context context = contextRef.get();
        final WebPage webViewRef = webPage;
        try {
            final JSONObject obj = new JSONObject(str);
            final String isHiddenNavBar = obj.getString("isHiddenNavBar");
            ((Activity) context).runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (superActivity instanceof BaseNavigtionActivity) {
                        if (isHiddenNavBar.equals("true")) {
                            ((BaseNavigtionActivity)superActivity).setNavigationHidden(true);
                        } else {
                            ((BaseNavigtionActivity)superActivity).setNavigationHidden(false);
                        }

                        if (!hasSetNavBar) {
                            hasSetNavBar = true;
                            webViewRef.getWebView().reload();
                        }
                    }

                }
            });
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @JavascriptInterface
    public void openPageInner( String str) {
        try {
            final JSONObject obj = new JSONObject(str);
            final Context context = contextRef.get();
            if (context == null) {
                return;
            }
            ((Activity) context).runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    String url = obj.optString("url");
                    int requestcode = obj.optInt("requestcode", -1);
                    String title = obj.optString("title", "");
                    Intent intent = new Intent(context, HybridNavigtionActivity.class);
                    intent.putExtra("url", url);
                    intent.putExtra("title", title);
                    if (requestcode == -1) {
                        ((Activity) context).startActivity(intent);
                    } else {
                        ((Activity) context).startActivityForResult(intent, requestcode);
                    }
                }
            });
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}
