---
title: Day_08_Arvo
tags: bigdata,Arvo,Java,hadoop
grammar_cjkRuby: true
---

# Avro

> Avro是序列化和反序列化工具和RPC库组成，用于改进MapReduce中的数据交换频率、互操作性和版本控制。Avro使用压缩二进制数据格式（可以通过配置选项设置压缩，压缩可以快速提高序列化时间）。Avro可以直接在MR中该处理，可以使用通用的数据模型处理schema数据。

Avro 提供的基本服务

1. 提供更加丰富的数据类型
2. 提供快速压缩的二进制数据格式
3. Avro是一个文件容器，可以解决小文件的问题
4. RPC(remote procedure call) 远程过程调用
5. 支持代码自动生成策略，并且能够和动态语言进行结合

> 在大数据中，大数据的业务主要分成三个部分，数据采集、数据分析、数据展现
> 数据采集可以通过爬虫等手段获取，但是在实际生活中，大部分数据都是有数据产商提供的，所以获取数据源并不是我们的重点，我们的重点是进行数据分析，提到数据分析，就会牵扯到io的读写操作。在大数据产业链中，数据源大部分都是文本类型，但是文本类型的数据读取比较消耗资源，因为数据资源是数据产商提供的，我们不能改变，但是我们可以在我们分析的阶段将数据之间的传输格式定义为其他的方式。例如：avro，sequenceFile等等，在数据展现时一般是将数据存入到关系型数据库(rdbms)中.

![大数据逻辑分工示意图][1]

SequenceFile：二进制文件格式,能够保存数据类型，是hadoop自带的数据类型
Avro是hadoop的创始人开发出的，avro能够将每个字段的数据类型进行存储
Arvo：序列化反序列化，序列化过程中提供复杂的数据结构(多个字段，多个字段类型)，类似数据库中的表，也就是模式
Avro使用json的形式定义schema，json在数据交互时，扮演的角色是数据存储格式，在webservice和rpc一般希望使用json来作为数据的传输格式

# Avro的代码实现
Arvo在大数据中扮演两个角色，一是读写文件效果比较好，二是arvo是一个容器，能够将小文件合并成大文件，起到优化程序的角色

## 读写操作
> arvo读取文件时，有两种不同的方式，一是通过模式读取，一个不需要模式的读取，下面一一进行阐述

### 模式读取

#### 写操作

1. 编写schema

> 定义schema，文件名必须是以.avsc结尾的，并且目录位置设置需要与maven项目中pom文件的`<sourceDirectory>${project.basedir}/src/main/avro/</sourceDirectory>`对应，json中表示的具体参数类型 ，请参考 [http://avro.apache.org/docs/1.8.2/gettingstartedjava.html][2]中defining schema部分

``` json
{
"type":"record",
"name":"UserActionLog",
"namespace":"top.xiesen.avro.schema",
"fields":[
	{"name":"userName","type":"string"},
	{"name":"actionType","type":"string"},
	{"name":"ipAddress","type":"string"},
	{"name":"gender","type":"int"},
	{"name":"provience","type":"string"}
]
}
```


2. 编写操作类

``` java
import java.io.File;
import org.apache.avro.file.DataFileWriter;
import org.apache.avro.io.DatumWriter;
import org.apache.avro.specific.SpecificDatumWriter;
import top.xiesen.avro.schema.UserActionLog;

/**
* 项目名称：avrotest
* 类名称：WriterAsAvro
* 类描述：使用arvo模式创建对象，写操作
* 创建人：Allen
* @version
*/
public class WriterAsAvro {

	public static void main(String[] args) throws Exception {
		UserActionLog userActionLog = new UserActionLog();
		userActionLog.setActionType("login");
		userActionLog.setGender(1);
		userActionLog.setIpAddress("192.168.1.1");
		userActionLog.setProvience("henan");
		userActionLog.setUserName("lisi");
		
		UserActionLog userActionLog2 = UserActionLog.newBuilder().setActionType("logout")
				.setGender(0).setIpAddress("192.168.6.110").setProvience("hunan").setUserName("allen").build();
		// 把两条记录写入到文件(序列化)
		DatumWriter<UserActionLog> writer = new SpecificDatumWriter<UserActionLog>();
		DataFileWriter<UserActionLog> fileWriter = new DataFileWriter<UserActionLog>(writer);
		
		// 创建序列化
		fileWriter.create(UserActionLog.getClassSchema(), new File("userlogaction.avro"));
		// 写入内容
		fileWriter.append(userActionLog);
		fileWriter.append(userActionLog2);
		
		fileWriter.flush();
		fileWriter.close();
	}
}
```
#### 读操作


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508325985802.jpg
  [2]: http://avro.apache.org/docs/1.8.2/gettingstartedjava.html