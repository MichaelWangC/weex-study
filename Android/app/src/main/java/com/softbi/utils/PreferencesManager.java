package com.softbi.utils;

/**
 * Created by michael on 2018/3/1.
 */

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

public class PreferencesManager {
    private final static String TAG_APP_FILE_CONFIG = "TAG_APP_FILE_CONFIG";
    public final static String APP_HEADER_ICON_DATA = "APP_HEADER_ICON_DATA";
    public final static String BOOLEAN_USE_GERSURE_LOCK = "BOOLEAN_USE_GERSURE_LOCK";
    public final static String APP_VERSION_INFO = "APP_VERSION_INFO";

    public static void putBoolean(Context context,String key,boolean value){
        Editor editor = context.getSharedPreferences(TAG_APP_FILE_CONFIG,
                Context.MODE_PRIVATE).edit();
        editor.putBoolean(key, value);
        editor.commit();
    }

    public static boolean getBoolean(Context context,String key,boolean defValue){
        return context.getSharedPreferences(TAG_APP_FILE_CONFIG,
                Context.MODE_PRIVATE).getBoolean(key, defValue);
    }

    public static void putString(Context context,String key,String value){
        Editor editor = context.getSharedPreferences(TAG_APP_FILE_CONFIG,
                Context.MODE_PRIVATE).edit();
        editor.putString(key, value);
        editor.commit();
    }

    public static String getString(Context context,String key){
        return context.getSharedPreferences(TAG_APP_FILE_CONFIG, Context.MODE_PRIVATE).getString(key, "");
    }

    public static SharedPreferences getPreferences(Context context){
        return context.getSharedPreferences(TAG_APP_FILE_CONFIG, Context.MODE_PRIVATE);
    }
}
