package com.softbi.source.modules.mine.fragment;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.softbi.R;
import com.softbi.core.BaseFragment;

/**
 * Created by michael on 2017/12/20.
 */

public class MineFragment extends BaseFragment {

    private View rootView;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        rootView = inflater.inflate(R.layout.text_demo, null);

//        android.support.v7.widget.Toolbar toolbar = rootView.findViewById(R.id.base_toolbar);
//        ((AppCompatActivity)getActivity()).setSupportActionBar(toolbar);

        return rootView;
    }
}
