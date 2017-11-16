---
title: 创建maven的scala项目
tags: scala,spark,maven
grammar_cjkRuby: true
---


1. 找模板(百度搜索 scala maven archetype 关键词)
scala maven 骨架连接 [http://docs.scala-lang.org/tutorials/scala-with-maven.html][1]

![][2]

2.intellj中new--》project--》maven
- 勾选create from archetype
- 点击 add archetype按钮
- 模板下载完之后选择我们添加的模板：net.alchim31.maven:scala-archetype-simple
- next


3.填写自己项目的GAV
4.next---next---finish
5.import changens

6.pom中修改

``` xml
<scala.tools.version>2.11</scala.tools.version>
<scala.version>2.11.11</scala.version>// 改成自己的版本
```


  [1]: http://docs.scala-lang.org/tutorials/scala-with-maven.html
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510846163013.jpg