---
title: Spring Boot
tags: Spring boot,java
author: XieSen
time: 2018-5-14 
grammar_cjkRuby: true
---

# spring boot quickstart

``` java
@Controller
public class HelloController {

    @RequestMapping(value = "/hello",method = RequestMethod.GET)
    @ResponseBody
    public String sayHello() {
        return "Hello，Spring Boot！";
    }
```

**restful 风格**

``` java
@RestController
public class HelloBookController {

    @RequestMapping(value = "/book/hello",method = RequestMethod.GET)
    public String sayHello() {
        return "Hello，《Spring Boot 2.x 核心技术实战 - 上 基础篇》！";
    }
}
```

# spring boot 配置
读取properties文件

``` java
demo.book.name=[Spring Boot 2.x Core Action]
demo.book.writer=BYSocket
demo.book.description=${demo.book.writer}'s book ${demo.book.name}

@Component
public class BookProperties {

    @Value("${demo.book.name}")
    private String name;
    @Value("${demo.book.writer}")
    private String writer;

    @Value("${demo.book.description}")
    private String desc;
	
	getter/setter...
```
产生随机数

``` java
# 随机字符串
top.xiesen.value=${random.value}
# 随机int
top.xiesen.number=${random.int}
# 随机long
top.xiesen.bignumber=${random.long}
# 10以内的随机数
top.xiesen.test1=${random.int(10)}
# 10-20的随机数
top.xiesen.test2=${random.int[10,20]}

@Component
public class RandomProperties {
    @Value("${top.xiesen.value}")
    private String value;

    @Value("${top.xiesen.number}")
    private int number;

    @Value("${top.xiesen.bignumber}")
    private long bignumber;

    @Value("${top.xiesen.test1}")
    private int test1;

    @Value("${top.xiesen.test2}")
    private int test2;
	getter/setter...
}


```


