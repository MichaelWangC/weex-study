package com.softbi.source.modules.mine.fragment;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;

import com.softbi.R;
import com.softbi.core.webcore.FileRequest;
import com.softbi.core.webcore.HybridFragment;
import com.softbi.core.webcore.widget.WebPage;

/**
 * Created by michael on 2017/12/20.
 */

public class MineFragment extends HybridFragment {

    private LinearLayout rootView;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        rootView = new LinearLayout(getActivity());
        rootView.setOrientation(LinearLayout.VERTICAL);

        View navView = inflater.inflate(R.layout.base_toolbar, null);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.WRAP_CONTENT);
        rootView.addView(navView, lp);

        Bundle bundle = getArguments();
        String url = bundle.getString(KEY_URL);
        if(url != null && !("".equals(url))){
            loadPage(url);
        }

        return rootView;
    }

    @Override
    protected void loadDataWithWebPage(FileRequest.Response response, String data) {
        WebPage webPage = new WebPage(getActivity());
        rootView.addView(webPage, FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT);
        webPage.loadDataWithBaseURL(response.getURL(), data, null, response.getContentEncoding(), null);
        mPageView = webPage;
    }
}
