package com.softbi.source.widget;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.MotionEvent;

/**
 * Created by michael on 2017/12/19.
 */

public class NoScrollViewPager extends ViewPager {
    public NoScrollViewPager(Context context) {
        super(context);
    }

    public NoScrollViewPager(Context context, AttributeSet attrs) {
        super(context, attrs);
    }
    /**
     * 重写ViewPager的onTouchEvent，禁止ViewPager滑动
     */
    @Override
    public boolean onTouchEvent(MotionEvent ev) {
        return false;
    }
    /**
     * 表示事件是否拦截，返回false表示不拦截
     */
    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        return false;
    }
}
