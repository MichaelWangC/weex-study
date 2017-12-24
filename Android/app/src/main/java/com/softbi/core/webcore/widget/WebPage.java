package com.softbi.core.webcore.widget;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.support.annotation.NonNull;
import android.util.AttributeSet;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;

import com.softbi.core.BaseActivity;
import com.softbi.core.BaseNavigtionActivity;
import com.softbi.core.webcore.kit.MyWebChromeClient;
import com.softbi.core.webcore.kit.WebViewJavascriptBridge;

import java.net.URL;

/**
 * Created by michael on 2017/12/19.
 */

public class WebPage extends HybridPage {

    private WebView webView;
    private URL mBaseUrl;
    private ProgressDialog pdialog;

    public WebPage(@NonNull Context context) {
        this(context, null, 0);
    }

    public WebPage(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        this.init();
    }

    @Override
    public void handleActivityResult(int requestCode, int resultCode, Intent data) {

    }

    private BaseActivity getActivity() {
        Context context = getContext();
        while (!(context instanceof Activity) && context instanceof ContextWrapper) {
            context = ((ContextWrapper) context).getBaseContext();
        }

        if (context instanceof BaseActivity) {
            return (BaseActivity) context;
        }

        return new BaseActivity();
    }

    private void init () {
        webView = new WebView(getContext());
        // 取消滚动条
        webView.setScrollBarStyle(WebView.SCROLLBARS_OUTSIDE_OVERLAY);

        FrameLayout.LayoutParams flp = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.MATCH_PARENT);
        addView(webView, flp);

        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setCacheMode(WebSettings.LOAD_NO_CACHE);
        settings.setAllowFileAccess(true);
        settings.setDomStorageEnabled(true);

        final BaseActivity superAc = getActivity();
        webView.setWebChromeClient(new MyWebChromeClient());
        webView.setWebViewClient(new WebViewClient() {
            private boolean hybridInited = false;

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
                if (hybridInited) return;
                hybridInited = true;

//                evaluateJS(getResources().getString(R.string.hybrid));

                // 加载页面 loading 框
                Handler handler = new Handler(Looper.getMainLooper());
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        if (pdialog != null && pdialog.isShowing()) {
                            pdialog.dismiss();
                        }
                        pdialog = new ProgressDialog(superAc);
                        pdialog.setMessage("加载中");
                        pdialog.setIndeterminate(true);
                        pdialog.setCancelable(true);// 禁止用户取消 防止出现如下错误
                        pdialog.show();
                    }
                });
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);

                //
                Handler handler = new Handler(Looper.getMainLooper());
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        if (null == pdialog)
                            return;
                        if (pdialog != null && pdialog.isShowing()) {
                            pdialog.dismiss();
                            pdialog = null;
                        }
                    }
                });
            }
        });

        WebViewJavascriptBridge webViewJavascriptBridge = new WebViewJavascriptBridge(WebPage.this.getContext(), this, superAc);
        webView.addJavascriptInterface(webViewJavascriptBridge, "hybrid");

    }

    private void evaluateJS(String javascript){
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            webView.evaluateJavascript(javascript, null);
        } else {
            webView.loadUrl(javascript);
        }
    }

    public void loadDataWithBaseURL(URL baseUrl, String data,
                                    String mimeType, String encoding, String historyUrl) {
        this.mBaseUrl = baseUrl;
        webView.loadDataWithBaseURL(baseUrl.toString(), data, mimeType, encoding, historyUrl);
    }

    /**
     * getter WebView
     * @return
     */
    public WebView getWebView() {
        return webView;
    }
}
