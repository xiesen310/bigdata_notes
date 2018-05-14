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


