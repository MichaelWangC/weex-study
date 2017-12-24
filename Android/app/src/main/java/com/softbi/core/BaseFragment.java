package com.softbi.core;

import android.app.Activity;
import android.support.v4.app.Fragment;
import android.view.View;

/**
 * Created by michael on 2017/12/19.
 */

public class BaseFragment extends Fragment {
    /**
     * 贴附的activity
     */
    public Activity mActivity;
    /**
     * 根view
     */
    public View mRootView;
}
