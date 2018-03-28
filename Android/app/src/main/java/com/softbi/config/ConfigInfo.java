package com.softbi.config;

import com.softbi.BuildConfig;

/**
 * Created by michael on 2017/10/21.
 */

public class ConfigInfo {
    private static String RELEASE_TYPE = BuildConfig.releaseType;

    public  enum ReleaseType {
        DEBUG,        //测试
        PUBLISH,     //生产
        DEV   //开发环境
    }

    private static ConfigInfo singleInstance = null;
    private ReleaseType releaseType;
    private String baseUrl;

    private void init() {
        ReleaseType releaseType = ReleaseType.valueOf(RELEASE_TYPE);
        this.releaseType = releaseType;
    }

    public static ConfigInfo getInstance() {
        if (singleInstance != null) {
            return singleInstance;

        }
        synchronized (ConfigInfo.class) {
            if (singleInstance != null) {
                return singleInstance;
            }
            ConfigInfo instance = new ConfigInfo();
            instance.init();

            singleInstance = instance;
        }
        return singleInstance;
    }

    public ReleaseType getReleaseType() {
        return releaseType;
    }

    /**
     * api url
     * @return
     */
    public String getApiBaseUrl() {
        switch (releaseType) {
            case DEBUG:
                this.baseUrl = testApiUrl();
                break;
            case PUBLISH:
                this.baseUrl = publishApiUrl();
                break;
            case DEV:
                this.baseUrl = devApiUrl();
                break;
            default:
                this.baseUrl = devApiUrl();
                break;
        }
        return this.baseUrl;
    }
    public String getAPILoginUrl() {
        return this.getApiBaseUrl() + "app/gaas/login";
    }

    public String getLocalApiUrl () {
//        return "http://10.26.160.192:8031/front/";
        return "http://36.110.68.73:8082/gaas/";
    }
    /**
     * api 开发环境
     */
    private String devApiUrl() {
        return "http://im.one2rich.cn/gaas/";
//        return "http://10.26.160.192:8030/gaas/";
//        return "http://10.26.160.187:8082/gaas/";
//        return "http://10.26.160.193:8080/gaas/";
//        return "http://10.26.160.192:8030/front/";
    }
    /**
     * api 测试环境
     */
    private String testApiUrl() {
        return "http://im.one2rich.cn/gaas/";
//        return "http://10.26.160.192:8030/gaas/";
    }
    /**
     * api 生产环境
     */
    private String publishApiUrl() {
        return "http://im.one2rich.cn/gaas/";
        //return "http://47.96.146.178/gaas/";
    }

    /**
     * Weex url
     * @return
     */
    public String getWeexBaseUrl() {
        switch (releaseType) {
            case DEBUG:
                this.baseUrl = testWeexUrl();
                break;
            case PUBLISH:
                this.baseUrl = publishWeexUrl();
                break;
            case DEV:
                this.baseUrl = devWeexUrl();
                break;
            default:
                this.baseUrl = devWeexUrl();
                break;
        }
        return this.baseUrl;
    }
    /**
     * weex 首页连接
     */
    public String getWeexHomeUrl() {
        return this.getWeexBaseUrl() + "dist/weex/index.js";
    }
    /**
     * weex 获取根路径 url
     */
    public String getWeexRootUrl() {
        String baseUrl = this.getWeexBaseUrl();
        if ("".equals(baseUrl)) {
            return "file:///weex/";
        } else {
            return baseUrl + "dist/weex/";
        }
    }
    /**
     * weex 开发环境
     */
    private String devWeexUrl() {;
         return "http://192.168.2.3:8008/";
    }
    /**
     * weex 测试环境
     */
    private String testWeexUrl() {
        return "";
    }
    /**
     * weex 生产环境
     */
    private String publishWeexUrl() {
        return "";
    }

    /**
     * vue url
     * @return
     */
    public String getVueBaseUrl() {
        switch (releaseType) {
            case DEBUG:
                this.baseUrl = testVueUrl();
                break;
            case PUBLISH:
                this.baseUrl = publishVueUrl();
                break;
            case DEV:
                this.baseUrl = devVueUrl();
                break;
            default:
                this.baseUrl = devVueUrl();
                break;
        }
        return this.baseUrl;
    }
    /**
     * vue 开发环境
     */
    private String devVueUrl() {
        return "http://192.168.2.3:8081/";
    }
    /**
     * vue 测试环境
     */
    private String testVueUrl() {
        return "http://im.one2rich.cn:8083/";
//        return "http://192.168.2.3:8081/";
    }
    /**
     * vue 生产环境
     */
    private String publishVueUrl() {
//        return "http://192.168.2.3:8081/";
        return "http://im.one2rich.cn:8083/";
    }

}
