---
title: Day19
tags: hadoop,hbase,phoenix
grammar_cjkRuby: true
---


## view

view 应用场景：限制数据查看权限，保存复杂的sql


create view ad_limit as 
select * from ad where user_id < 50

`select * from ad_limit` 等同于`select * from (select * from ad where user_id < 50)`


view 不保存数据，保存的是sql

## phoenix sql语句操作HBase

``` sql
select * from system.catalog where table_schem='SYSTEM'and table_name='STATS'and column_name='PHYSICAL_NAME';
-- 创建表必须添加主键
create table phoenix_user(
	user_id integer not null primary key 
	,username varchar(20)
	,age integer
	,birthday varchar(20)
)

-- 查询数据
select * from phoenix_user

-- 插入数据
upsert into phoenix_user (user_id,username,age,birthday) values(1,'张三',12,'2012-01-02');
upsert into phoenix_user (user_id,username,age,birthday) values(2,'李四',12,'2012-04-02');
upsert into phoenix_user (user_id,username,age,birthday) values(3,'王五',12,'2012-07-02');

-- 修改数据,只能根据主键进行修改
upsert into phoenix_user(user_id,age) values(1,25);
upsert inrto phoenix_user(user_id,age) values()

-- 删除数据 年龄大于20的删除1
delete from phoenix_user where age > 20

```


## java API操作phoenix

``` java
package top.xiesen.phoenix;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Random;


/**
* 项目名称：phoenixTest
* 类名称：PhoenixJdbcTest
* 类描述：phoenix jdbc 操作 
* @author Allen
*/
public class PhoenixJdbcTest {

	public static final String URL = "jdbc:phoenix:master,slaver1,slaver2:2181";
	public static final String DRIVER_CLASS = "org.apache.phoenix.jdbc.PhoenixDriver";
	public static final String USER_NAME = "root";
	public static final String PASSWORD = "";

	private Connection connection;

	public PhoenixJdbcTest() {
		try {
			Class.forName(DRIVER_CLASS);
			this.connection = DriverManager.getConnection(URL, USER_NAME, PASSWORD);
		} catch (Exception e) {
			System.out.println("connection exception ......");
			e.printStackTrace();
		}
	}

	/**
	* findData 查找数据
	* @param @throws Exception 参数
	* @return void 返回类型
	* @Exception 异常对象
	* @author Allen
	*/
	public void findData() throws Exception {
		Statement statement = connection.createStatement();
		String sql = "select * from phoenix_user";
		ResultSet resultSet = statement.executeQuery(sql);
		while (resultSet.next()) {
			System.out.println("user_id:" + resultSet.getInt("user_id") + "\tusername:" + resultSet.getString(2)
					+ "\tage:" + resultSet.getInt(3) + "\tbirthday:" + resultSet.getString(4));
		}
	}

	
	/**
	* insertData 通过sql查询数据到hbase上
	* @param @throws Exception 参数
	* @return void 返回类型
	* @Exception 异常对象
	* @author Allen
	*/
	public void insertData() throws Exception {
		String sql = "upsert into phoenix_user (user_id,username,age,birthday) values(?,?,?,?)";
		PreparedStatement prepareStatement = connection.prepareStatement(sql);
		Random random = new Random();
		for (int i = 0; i < 10; i++) {
			prepareStatement.setInt(1, 14 + i);
			prepareStatement.setString(2, "user" + i);
			prepareStatement.setInt(3, random.nextInt(10) + 1);
			prepareStatement.setString(4, "2014-0" + random.nextInt(10) + "-" + random.nextInt(30) + 1);
			prepareStatement.addBatch();
		}
		prepareStatement.executeBatch();
		// phoenix 的 connection自动提交默认是关闭的，这点与其他数据库是不一样的
		prepareStatement.getConnection().commit();
	}

	
	/**
	* cleanUp 关闭资源
	* @param  参数
	* @return void 返回类型
	* @Exception 异常对象
	* @author Allen
	*/
	public void cleanUp() {
		if (connection != null) {
			try {
				connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public static void main(String[] args) throws Exception {
		PhoenixJdbcTest pTest = new PhoenixJdbcTest();
		pTest.findData();
//		pTest.insertData();
		pTest.cleanUp();
	}
}

```

 ## HBase协处理器
 
 
