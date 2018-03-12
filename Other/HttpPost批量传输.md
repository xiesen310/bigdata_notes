---
title: HttpPost批量传输 
tags: Http，post
grammar_cjkRuby: true
---

- 连接池管理

``` java
import org.apache.http.client.config.RequestConfig;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;

public class PoolManager {
    private static PoolingHttpClientConnectionManager clientConnectionManager = null;
    private static int defaultMaxTotal = 200;
    private static int defaultMaxPerRoute = 25;

    public static CloseableHttpClient getHttpClient() {
        CloseableHttpClient httpclient;
        RequestConfig requestConfig = RequestConfig.custom().setConnectTimeout(30000).setSocketTimeout(30000).build();
        if (clientConnectionManager == null) {
            clientConnectionManager = new PoolingHttpClientConnectionManager();
            clientConnectionManager.setMaxTotal(defaultMaxTotal);
            clientConnectionManager.setDefaultMaxPerRoute(defaultMaxPerRoute);
        }
        httpclient = HttpClients.custom().setConnectionManager(clientConnectionManager)
                .setDefaultRequestConfig(requestConfig).build();
        return httpclient;
    }
}

```
- httpclient管理

``` java
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.zork.imonitorDataTranspond.Entity.ConsumerEntry;
import com.zork.imonitorDataTranspond.Entity.OpenTsdbMetric;
import com.zork.imonitorDataTranspond.MetricHandle.MetricHandle2OpenTsdb;
import org.apache.http.HttpEntity;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class HttpClientMethod {

    @Autowired
    static ConsumerEntry consumerEntry;

    private static CloseableHttpResponse resp = null;
    private static HttpEntity he = null;

    private static Map<CloseableHttpResponse,HttpEntity> resheMap = new HashMap<CloseableHttpResponse, HttpEntity>();


    public static void httpPostData(StringEntity entity, HttpPost httpPost, CloseableHttpClient client){
        try {
            httpPost.setHeader("Content-Type", "application/json");
            httpPost.setEntity(entity);
            resp = client.execute(httpPost);
            if (resp.getStatusLine().getStatusCode() == 200) {
                he = resp.getEntity();
                if (!resheMap.containsKey(resp)){
                    resheMap.put(resp,he);
                }
                String respContent = EntityUtils.toString(he, "UTF-8");
            } else {
                //LOG.info("返回码" + resp.getStatusLine().getStatusCode());
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (ClientProtocolException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void close() {
        if (!resheMap.isEmpty()) {
            for (Map.Entry<CloseableHttpResponse, HttpEntity> reshe : resheMap.entrySet()) {
                try {
                    //LOG.info("读取结束");
                    if (reshe.getValue() != null) {
                        EntityUtils.consume(reshe.getValue());
                    }
                    if (reshe.getKey() != null) {
                        reshe.getKey().close();
                    }
                } catch (Exception e) {
                    //LOG.error("[zorkerror]http 失败", e);
                }
            }
        }
    }


    public static void main(String[] args) throws ParseException {
        String datJson = "{\"metricsetname\":\"cpu\",\"type\":\"metricsete\",\"tags\":[[0]\"beats_input_raw_event\"],\"measures\":{\"cpu_used_pct\":1.0},\"dimensions\":{\"workernodeid\":\"1.2231\",\"hostname\":\"DESKTOP_P64ALKE\",\"ip\":\"192.168.1.93\",\"appsystem\":\"JTY-1\"},\"timestamp\":\"2018-03-07T14:55:13.425Z\"}";
        HttpPost httpPost = new HttpPost("http://192.168.1.150:4242/api/put?summary");
        CloseableHttpClient client = PoolManager.getHttpClient();
        MetricHandle2OpenTsdb metricHandle2OpenTsdb = new MetricHandle2OpenTsdb("http://192.168.1.150:4242/api/put?summary");
        List<OpenTsdbMetric> jsonArray = metricHandle2OpenTsdb.metricHandle(datJson);
        String json = JSON.toJSONString(jsonArray, SerializerFeature.DisableCircularReferenceDetect);
        StringEntity entity = new StringEntity(json, "UTF-8");//解决中文乱码问题
        //HttpClientMethod httpClientMethod = new HttpClientMethod();
        //httpClientMethod.httpPostData(entity,httpPost,client);
        httpPostData(entity,httpPost,client);
    }
}
```

- 测试代码

``` java
 for (int i = 0, len = record.size(); i < len; i++){
                JSONObject obj = JSONObject.parseObject(record.get(i).toString());
                jsonArray.add(obj);
            }
            StringEntity entity = new StringEntity(jsonArray.toString(), ENCODING);//解决中文乱码问题
            jsonArray.clear();
            httpClientMethod.httpPostData(entity,httpPost,client);
```
