package com.softbi.extend.module;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.widget.Toast;

import com.softbi.R;
import com.softbi.core.BaseApplication;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.common.WXModule;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.modelmsg.WXWebpageObject;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

/**
 * Created by michael on 2018/2/7.
 */

public class WXWeChatModule extends WXModule implements IWXAPIEventHandler{

    private static final String APP_ID = "wxc8aadb60378ad495";

    private IWXAPI api;

    @JSMethod(uiThread = true)
    public void sendLinkContent(String title, String description, String url) {
        if (api == null) {
            api = WXAPIFactory.createWXAPI(mWXSDKInstance.getContext(), APP_ID, true);
            api.registerApp(APP_ID);
        }

        WXWebpageObject webpage = new WXWebpageObject();
        webpage.webpageUrl = url;

        WXMediaMessage msg = new WXMediaMessage(webpage);
        msg.title = title;
        msg.description = description;
        Bitmap thumb = BitmapFactory.decodeResource(BaseApplication.getContext().getResources(), R.drawable.icon_message_red);
        msg.setThumbImage(thumb);


        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.message = msg;
        req.scene = SendMessageToWX.Req.WXSceneSession;

        api.sendReq(req);
    }

    @Override
    public void onReq(BaseReq baseReq) {

    }

    @Override
    public void onResp(BaseResp baseResp) {
        String result = "";

        Toast.makeText(mWXSDKInstance.getContext(), "baseresp.getType = " + baseResp.getType(), Toast.LENGTH_SHORT).show();

        switch (baseResp.errCode) {
            case BaseResp.ErrCode.ERR_OK:
                result = "success";
                break;
            case BaseResp.ErrCode.ERR_USER_CANCEL:
                result = "cancel";
                break;
            case BaseResp.ErrCode.ERR_AUTH_DENIED:
                result = "deny";
                break;
            case BaseResp.ErrCode.ERR_UNSUPPORT:
                result = "unsupported";
                break;
            default:
                result = "unknown";
                break;
        }

        Toast.makeText(mWXSDKInstance.getContext(), result, Toast.LENGTH_LONG).show();
    }
}
