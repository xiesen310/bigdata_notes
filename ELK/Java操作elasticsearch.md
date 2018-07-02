---
title: Java操作elasticsearch 
tags: java,elasticsearch
author: XieSen
time: 2018-7-2 
grammar_cjkRuby: true
---

## 添加依赖

``` xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>top.xiesen.es</groupId>
    <artifactId>es-demo</artifactId>
    <version>1.0-SNAPSHOT</version>

    <name>es-demo</name>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8

        </maven.compiler.target>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.elasticsearch.client</groupId>
            <artifactId>transport</artifactId>
            <version>5.2.2</version>
        </dependency>
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-api</artifactId>
            <version>2.7</version>
        </dependency>
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-core</artifactId>
            <version>2.7</version>
        </dependency>
    </dependencies>

</project>

```

## log4j2.properties

``` javascript
appender.console.type = Console
appender.console.name = console
appender.console.layout.type = PatternLayout

rootLogger.level = info
rootLogger.appenderRef.console.ref = console
```

## 示例代码

``` java
package top.xiesen.es;

import org.elasticsearch.action.delete.DeleteResponse;
import org.elasticsearch.action.get.GetResponse;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.transport.client.PreBuiltTransportClient;

import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Date;

import static org.elasticsearch.common.xcontent.XContentFactory.jsonBuilder;

public class EsTestDemo {
    static String index = "test_index";
    static String type = "test_type";

    public static void main(String[] args) throws IOException {
        // 构建client
        Settings settings = Settings.builder().put("cluster.name", "xs-es").build();
        TransportClient client = new PreBuiltTransportClient(settings)
                .addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName("node-1"), 9300));

        // 创建document
        IndexResponse response = client.prepareIndex(index, type, "10")
                .setSource(jsonBuilder()
                        .startObject()
                        .field("user", "kimchy")
                        .field("postDate", new Date())
                        .field("message", "trying out Elasticsearch")
                        .endObject()
                ).get();

        // 查询
        GetResponse result = client.prepareGet(index, type, "10").get();
        // 更新document
        client.prepareUpdate(index, type, "10")
                .setDoc(jsonBuilder()
                        .startObject()
                        .field("gender", "male")
                        .endObject())
                .get();

        // 删除document
        DeleteResponse deleteResponse = client.prepareDelete(index, type, "10").get();
        
        GetResponse resultUpdate = client.prepareGet(index, type, "10").get();
        System.out.println(result.getSourceAsString());
        System.out.println(resultUpdate.getSourceAsString());
        client.close();
    }
}

```


