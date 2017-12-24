package com.softbi.utils;

import android.widget.TextView;

/**
 * Created by michael on 2017/12/19.
 */

public class StringUtils {
    /**
     * 用于textview的settext非空处理
     *
     * @param result
     * @return
     */
    public static void setText(TextView textView, String result) {
        if(textView != null ){
            if (result == null) textView.setText("");
            textView.setText(result);
        }
    }
}
