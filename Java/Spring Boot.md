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


