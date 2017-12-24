package com.softbi.core.webcore;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.softbi.core.BaseFragment;
import com.softbi.core.webcore.widget.HybridPage;
import com.softbi.core.webcore.widget.WebPage;

import java.io.UnsupportedEncodingException;

/**
 * Created by michael on 2017/12/19.
 */

public class HybridFragment extends BaseFragment {
    public static final String KEY_URL = "url";
    public static final String KEY_TITLE = "title";

    protected HybridPage mPageView;
    public FrameLayout mContainerView;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        mContainerView = new FrameLayout(getActivity());
        Bundle bundle = getArguments();
        String url = bundle.getString(KEY_URL);
        if(url != null && !("".equals(url))){
            loadPage(url);
        }
        return mContainerView;
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
                new FileRequest(getActivity().getApplicationContext(), url).setListener(new FileRequest.DownloadListener() {
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
                            getActivity().runOnUiThread(new Runnable() {
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

    protected void loadDataWithWebPage(FileRequest.Response response, String data){
        WebPage webPage = new WebPage(getActivity());
        mContainerView.addView(webPage, FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT);
        webPage.loadDataWithBaseURL(response.getURL(), data, null, response.getContentEncoding(), null);
        mPageView = webPage;
    }
}
