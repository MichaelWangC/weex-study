package com.softbi.core.webcore;

import android.content.Context;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.util.List;
import java.util.Map;

/**
 * Created by michael on 2017/12/19.
 */

public class FileRequest {
    private final URLConnection mURLConn;
    private DownloadListener mListener;
    private String mFilepath;

    public FileRequest(Context context, String url) throws IOException {
        this.mURLConn = new URL(url).openConnection();
        if (this.mURLConn instanceof HttpURLConnection) {
            ((HttpURLConnection)mURLConn).setRequestMethod("GET");
        }
//		mURLConn.setDoOutput(true);
//        mURLConn.setRequestProperty("Cookie", HybridCookieManager.getCookie(context, url));
        mURLConn.setConnectTimeout(15000);
    }

    public FileRequest setListener(DownloadListener listener){
        this.mListener = listener;
        return this;
    }

    public FileRequest setFilePath(String filepath){
        this.mFilepath = filepath;
        return this;
    }

    public void connect() throws IOException{
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    mURLConn.connect();

                    Response response = new Response();

                    InputStream in = new BufferedInputStream(mURLConn.getInputStream());
                    response.contentLength = mURLConn.getContentLength();
                    response.contentEncoding = mURLConn.getContentEncoding();
                    response.contentType = mURLConn.getContentType();
                    response.headers = mURLConn.getHeaderFields();
                    response.url = mURLConn.getURL();
                    if (mURLConn instanceof HttpURLConnection) {
                        response.statusCode = ((HttpURLConnection) mURLConn).getResponseCode();
                    }
                    OutputStream os = null;
                    try {
                        if (mFilepath != null) {
                            os = new FileOutputStream(mFilepath);
                        } else {
                            if (mURLConn.getContentLength() != -1) {
                                os = new ByteArrayOutputStream(mURLConn.getContentLength());
                            } else {
                                os = new ByteArrayOutputStream();
                            }
                        }

                        byte[] buffer = new byte[1024];
                        int len = 0, t = 0;
                        long loaded = 0, contentLength = mURLConn.getContentLength();
                        DownloadListener listener = mListener;
                        while ((len = in.read(buffer)) != -1) {
                            os.write(buffer, 0, len);
                            t++;
                            loaded += len;
                            if (t == 20) {
                                t = 0;
                                if (listener != null) {
                                    listener.onProgress(loaded, contentLength);
                                }
                            }
                        }

                        if (listener != null) {
                            if (os instanceof ByteArrayOutputStream) {
                                ByteArrayOutputStream bos = (ByteArrayOutputStream) os;
                                listener.onComplete(response, bos.toByteArray(), null);
                            } else {
                                listener.onComplete(response, null, mFilepath);
                            }
                        }
                    } catch (Exception e) {
                        if (mListener != null) {
                            mListener.onError(e);
                        }
                    } finally {
                        try {
                            os.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }catch (IOException e){
                    e.printStackTrace();
                }
            }
        }).start();
    }

    public static String getHeader(Map<String,List<String>> headers, String key){
        if(headers==null)return null;

        List<String> list = headers.get(key);
        if (list==null||list.size()==0)return null;
        return list.get(0);

    }

    public interface DownloadListener{
        void onProgress(long progress, long size);

        /**
         *
         * @param response
         * @param data if filepath!=null data==null
         * @param filepath
         */
        void onComplete(Response response, byte[] data, String filepath);
        void onError(Exception e);
    }

    public static class Response{
        Map<String,List<String>> headers;
        String contentType;
        Object contentLength;
        String contentEncoding;
        int statusCode = 0;
        URL url;

        public int getStatusCode() {
            return statusCode;
        }

        public Map<String, List<String>> getHeaders() {
            return headers;
        }

        public Object getContentLength() {
            return contentLength;
        }

        public String getContentEncoding() {
            if(contentEncoding==null){
                return Charset.defaultCharset().name();
            }
            return contentEncoding;
        }

        public String getContentType() {
            return contentType;
        }

        public URL getURL() {
            return url;
        }
    }
}
