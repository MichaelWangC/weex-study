package com.softbi.extend.module;

import android.content.Intent;
import android.util.Base64;

import com.jph.takephoto.app.TakePhoto;
import com.jph.takephoto.app.TakePhotoImpl;
import com.jph.takephoto.model.CropOptions;
import com.jph.takephoto.model.InvokeParam;
import com.jph.takephoto.model.TContextWrap;
import com.jph.takephoto.model.TImage;
import com.jph.takephoto.model.TResult;
import com.jph.takephoto.permission.InvokeListener;
import com.jph.takephoto.permission.PermissionManager;
import com.jph.takephoto.permission.TakePhotoInvocationHandler;
import com.softbi.core.weex.WeexBaseActivity;
import com.softbi.utils.PreferencesManager;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;

/**
 * Created by michael on 2018/2/23.
 */

public class WXImagePickerModule extends WXModule implements TakePhoto.TakeResultListener,InvokeListener{

    private TakePhoto takePhoto;
    private InvokeParam invokeParam;
    private JSCallback imageCallback;

    @JSMethod(uiThread = true)
    public void pushHeaderImagePickerController(JSCallback callback) {
        CropOptions cropOptions = new CropOptions.Builder().setAspectX(800).setAspectY(800).create();
        getTakePhoto().onPickMultipleWithCrop(1, cropOptions);
        imageCallback = callback;
    }

    @JSMethod(uiThread = false)
    public String getHeaderIcon() {
        String base64 = PreferencesManager.getString(mWXSDKInstance.getContext(), PreferencesManager.APP_HEADER_ICON_DATA);
        return base64;
    }

    /**
     *  获取TakePhoto实例
     * @return
     */
    public TakePhoto getTakePhoto() {
        if (takePhoto == null) {
            takePhoto = (TakePhoto) TakePhotoInvocationHandler.of(this).bind(new TakePhotoImpl(((WeexBaseActivity)mWXSDKInstance.getContext()), this));
        }
        return takePhoto;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        getTakePhoto().onActivityResult(requestCode, resultCode, data);
        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        PermissionManager.TPermissionType type = PermissionManager.onRequestPermissionsResult(requestCode, permissions, grantResults);
        PermissionManager.handlePermissionsResult(((WeexBaseActivity)mWXSDKInstance.getContext()), type, invokeParam, this);
    }

    @Override
    public void takeSuccess(TResult result) {
        ArrayList<TImage> images = result.getImages();

        TImage image = images.get(0);
        InputStream is = null;
        byte[] data = null;
        String base64 = null;
        try{
            is = new FileInputStream(image.getOriginalPath());
            //创建一个字符流大小的数组。
            data = new byte[is.available()];
            //写入数组
            is.read(data);
            //用默认的编码格式进行编码
            base64 = Base64.encodeToString(data,Base64.DEFAULT);
        }catch (IOException e){
            e.printStackTrace();
        }finally {
            if(null !=is){
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }
        base64 = "data:image/jpeg;base64," + base64;
        imageCallback.invoke(base64);

        PreferencesManager.putString(mWXSDKInstance.getContext(), PreferencesManager.APP_HEADER_ICON_DATA, base64);
    }

    @Override
    public void takeFail(TResult result, String msg) {

    }

    @Override
    public void takeCancel() {

    }

    @Override
    public PermissionManager.TPermissionType invoke(InvokeParam invokeParam) {
        PermissionManager.TPermissionType type=PermissionManager.checkPermission(TContextWrap.of(((WeexBaseActivity)mWXSDKInstance.getContext())),invokeParam.getMethod());
        if(PermissionManager.TPermissionType.WAIT.equals(type)){
            this.invokeParam=invokeParam;
        }
        return type;
    }
}
