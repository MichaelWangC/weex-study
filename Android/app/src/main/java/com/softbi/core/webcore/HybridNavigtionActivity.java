package com.softbi.core.webcore;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.widget.FrameLayout;

import com.softbi.core.BaseNavigtionActivity;
import com.softbi.core.webcore.widget.HybridPage;
import com.softbi.core.webcore.widget.WebPage;

import java.io.UnsupportedEncodingException;

/**
 * Created by michael on 2017/12/19.
 */

public class HybridNavigtionActivity extends BaseNavigtionActivity {
    public static final String KEY_URL = "url";
    public static final String KEY_TITLE = "title";

    private HybridPage mPageView;
    public FrameLayout mContainerView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (pageLayoutId()==-1) {
            mContainerView = new FrameLayout(this);
            setContentView(mContainerView);
        } else {
            throw new IllegalStateException("Undefied page container");
        }
//        setTitle(getIntent().getStringExtra(KEY_TITLE));
        String url = getIntent().getStringExtra(KEY_URL);
        if(url != null && !("".equals(url))){
            loadPage(url);
        }
    }

    protected int pageLayoutId(){
        return -1;
    }

    protected void loadPage(String url){
        if (url!=null) {
            if (HybridManager.instance().getUrlSigner()!=null){
                url = HybridManager.instance().getUrlSigner().sign(url,null).urlWithSign(url);
            }
            try {
                new FileRequest(getApplicationContext(), url).setListener(new FileRequest.DownloadListener() {
                    @Override
                    public void onProgress(long progress, long size) {

                    }

                    @Override
                    public void onComplete(final FileRequest.Response response, final byte[] data, String filepath) {
                        String xHsType = FileRequest.getHeader(response.getHeaders(),"X-Hs-Type");
                        if ("react".equalsIgnoreCase(xHsType)){
                            //ReactPage
                        } else {
                            //WebPage
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    try {
                                        loadDataWithWebPage(response, new String(data, response.getContentEncoding()));
                                    }catch (UnsupportedEncodingException e){
                                        e.printStackTrace();
                                    }
                                }
                            });
                        }
                    }

                    @Override
                    public void onError(Exception e) {
                        e.printStackTrace();
                    }

                }).connect();
            }catch (Exception e){
                e.printStackTrace();
            }
        }
    }

    private void loadDataWithWebPage(FileRequest.Response response, String data){
        WebPage webPage = new WebPage(this);
        mContainerView.addView(webPage, FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT);
        webPage.loadDataWithBaseURL(response.getURL(), data, null, response.getContentEncoding(), null);
        mPageView = webPage;
    }
}
