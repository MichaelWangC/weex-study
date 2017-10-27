package com.study.config;

import com.study.BuildConfig;

/**
 * Created by michael on 2017/10/21.
 */

public class ConfigInfo {
    private static String RELEASE_TYPE = BuildConfig.releaseType;

    public  enum ReleaseType {
        TEST,        //测试
        PUBLISH,     //生产
        DEVELOPER    //开发环境
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

    public String getBaseUrl() {
        switch (releaseType) {
            case TEST:
                this.baseUrl = testUrl();
                break;
            case PUBLISH:
                this.baseUrl = publishUrl();
                break;
            case DEVELOPER:
                this.baseUrl = devUrl();
                break;
            default:
                this.baseUrl = devUrl();
                break;
        }
        return this.baseUrl;
    }

    /**
     * weex首页连接
     * @return
     */
    public String getHomeUrl() {
        return this.getBaseUrl() + "dist/weex/index.js";
    }

    /**
     * 获取根路径 url
     * @return
     */
    public String getRootUrl() {
        return this.getBaseUrl() + "dist/weex/";
    }

    /**
     * 开发环境
     * @return
     */
    private String devUrl() {
//        return "http://192.168.2.135:8081/";
        return "http://10.0.2.2:8081/";
    }

    /**
     * 测试环境
     * @return
     */
    private String testUrl() {
        return "";
    }
   /**
     * 生成环境
     * @return
     */
    private String publishUrl() {
        return "";
    }


}
