package com.softbi.core.webcore.widget;

import android.content.Context;
import android.content.Intent;
import android.support.annotation.NonNull;
import android.util.AttributeSet;
import android.widget.FrameLayout;

/**
 * Created by michael on 2017/12/19.
 */

public abstract class HybridPage extends FrameLayout {

    public HybridPage(@NonNull Context context) {
        super(context);
    }

    public HybridPage(Context context, AttributeSet attrs, int defStyleAttr){
        super(context, attrs, defStyleAttr);
    }

    public abstract void handleActivityResult(final int requestCode, final int resultCode, Intent data);
}
