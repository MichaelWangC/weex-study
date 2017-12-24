package com.softbi.core.webcore.kit;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.util.Log;
import android.webkit.ConsoleMessage;
import android.webkit.JsResult;
import android.webkit.WebChromeClient;
import android.webkit.WebView;

/**
 * Created by michael on 2017/12/19.
 */

public class MyWebChromeClient extends WebChromeClient {
    @Override
    public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
        Log.i("Hybrid", "Log::" + consoleMessage);
        return super.onConsoleMessage(consoleMessage);
    }

    @Override
    public boolean onJsAlert(final WebView view, final String url, final String message, final JsResult result) {
        view.post(new Runnable() {
            @Override
            public void run() {
                new AlertDialog.Builder(view.getContext())
                        .setTitle("")
                        .setMessage(message)
                        .setPositiveButton("好的",
                                new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        result.confirm();
                                    }
                                })
                        .setCancelable(false)
                        .create()
                        .show();
            }
        });

        return true;
    }
}
