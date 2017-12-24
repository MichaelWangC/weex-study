package com.softbi.core.webcore;

import java.util.Map;

/**
 * Created by michael on 2017/12/19.
 */

public class HybridManager {
    private static HybridManager instance;
    public static HybridManager instance(){
        if (instance!=null){
            return instance;
        }
        synchronized (HybridManager.class){
            if (instance!=null){
                return instance;
            }
            instance = new HybridManager();
            return instance;
        }
    }

    private URLSigner urlSigner = null;
    private HybridManager(){}

    public URLSigner getUrlSigner() {
        return urlSigner;
    }

    public void setUrlSigner(URLSigner urlSigner) {
        this.urlSigner = urlSigner;
    }

    public interface URLSigner{
        public SignedData sign(String url, Map<String, String> params);
    }

    public static class SignedData{
        public Map<String,String> signParams;
        public String urlWithSign(String url){
            if (signParams==null||signParams.size()==0)
                return url;
            StringBuilder urlBuilder = new StringBuilder();
            for (String key : signParams.keySet()){
                urlBuilder.append("&").append(key).append("=").append(signParams.get(key));
            }
            if (urlBuilder.length()<=0){
                return url;
            }
            if (url.indexOf("?")==-1){
                return url+"?"+urlBuilder.toString().substring(1);
            }else{
                return url+urlBuilder.toString();
            }
        }
    }
}
