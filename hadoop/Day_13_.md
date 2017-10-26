---
title: Day_13_ 
tags: hadoop,hive
grammar_cjkRuby: true
---

# java代码操作hive

## 创建maven工程，导入依赖文件

``` xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.mycom.hive</groupId>
	<artifactId>hivetest</artifactId>
	<version>0.0.1-SNAPSHOT</version>

	<dependencies>
		<dependency>
			<groupId>org.apache.hive</groupId>
			<artifactId>hive-jdbc</artifactId>
			<version>2.3.0</version>
		</dependency>
		<dependency>
			<groupId>jdk.tools</groupId>
			<artifactId>jdk.tools</artifactId>
			<version>1.8</version>
			<scope>system</scope>
			<systemPath>${JAVA_HOME}/lib/tools.jar</systemPath>
		</dependency>

	</dependencies>

</project>

```

## 编写连接小工具

``` java
package top.xiesen.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class HiveJdbcUtils {

	public static final String DRIVER_CLASS = "org.apache.hive.jdbc.HiveDriver";
	public static final String URL = "jdbc:hive2://master:10000/db14";
	public static final String USERNAME = "root";
	public static final String PASSWORD = "";
	private static Connection connection;
	/**
	* getConnection 获取连接
	* @param @return 参数
	* @return Connection 返回类型
	* @Exception 异常对象
	*/
	public static Connection getConnection(){
		try {
			Class.forName(DRIVER_CLASS);
			connection = DriverManager.getConnection(URL,USERNAME,PASSWORD);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return connection;
	}
	
	/**
	* close 关闭连接
	* @param @param connection 参数
	* @return void 返回类型
	* @Exception 异常对象
	*/
	public static void close(Connection connection) {
		try {
			if (connection != null) {
				connection.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
```

## hive的基本操作

### 创建表

``` java
public static void createTable() throws SQLException {
		Connection connection = HiveJdbcUtils.getConnection();
		Statement statement = connection.createStatement();
		StringBuilder stringBuilder = new StringBuilder();
		stringBuilder.append("create table table_form_java(");
		stringBuilder.append("test1 string");
		stringBuilder.append(",test2 int");
		stringBuilder.append(",test3 string");
		stringBuilder.append(")stored as textfile");
		statement.execute(stringBuilder.toString());
		ResultSet result = statement.executeQuery("show tables");
		while(result.next()){
			System.out.println(result.getString(1));
		}
	}
```

# Hive 函数

hive 中内置了很多函数，具体使用用法详见官方文档[https://cwiki.apache.org/confluence/display/Hive/LanguageManual+UDF][1]

- 查看所有函数 `show functions`
- 查看函数的具体用法 `describe function last_day` 或者 `describe function extended last_day`
- 返回当前月的最后一天

``` sql
-- Returns the last day of the month  
select last_day(to_date('2017-10-01'))
select last_day('2017-10-01')
```

- 字符串拼接

``` sql
show tables;
select '姓名:' || emp_name || '\t薪水:'|| salary
from dw_employee

select concat(emp_name,':',salary)
from dw_employee

describe function extended concat
```

- hive支持正则表达式

``` sql
describe function extended regexp
select * from dw_employee
where status regexp '(.{4})'
```

- 复杂类型构造方法

``` sql
-- 复杂类型构造方法
select map(emp_name,status)
from dw_employee
```

## 数学函数
> 小数的数据类型 double float decimal numberic，一般我们使用decimal



## 日期类型函数

- 获取当前时间戳

``` sql
select unix_timestamp();
select unix_timestamp('2017-01-02 00:00:00');
```

- 把字符串时间转换成时间戳,指定格式 `select unix_timestamp('2017-01-02 00:00:00','yyyy-MM-dd HH:mm:ss')`
- 时间戳转换成时间 `select from_unixtime(unix_timestamp(),'yyyyMMdd');`
- 把字符串转换成日期格式 yyyy-MM-dd HH:mm:ss `select to_date('2017-03-20 11:30:01');`
- 抽取日期的天数 `select extract(day from '2017-8-10')`
- 计算两个日期相隔天数 `select abs(datediff('2017-08-03','2017-09-02'));`
- 在一个日期上加天数 求新日期 

## 条件函数

  [1]: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+UDF