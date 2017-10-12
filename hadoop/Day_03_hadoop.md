---
title: Day_03_hadoop
tags: bigdata,Java,hadoop
grammar_cjkRuby: true
---

hadoop开发之前需要对Eclipse进行基础的设置，否则会出现各种各样的麻烦

# Eclipse基本设置

1. 设置编码格式

![enter description here][1]

2. 设置eclipse中jdk

![enter description here][2]


3. eclipse添加额外的maven设置

![enter description here][3]

# 阅读文档的基本步骤

1. read class description
2. read Constructor
3. read static method or Builder and factory
4. read base method，to understand the method of use

# 创建maven项目注意事项
1. 创建项目

![enter description here][4]

2. 修改jdk的版本

![enter description here][5]

3. 添加依赖，添加依赖的网址 [https://mvnrepository.com][6]

![enter description here][7]

# Java代码操作hdfs

## 编写hdfsUtils

``` java
public class HdfsUtils {
	public static final Configuration CONF = new Configuration();
	public static FileSystem hdfs;
	static {
		try {
			hdfs = FileSystem.get(CONF);
		} catch (IOException e) {
			System.out.println("无法连接hdfs,请检查配置...");
			e.printStackTrace();
		}
	}
}
```

## 在hdfs上创建文件，并写入数据

``` java
// 创建一个新的文件，将数据写入到hdfs文件中
	public static void createFile(String fileName, String content) throws Exception {
		Path path = new Path(fileName);
		if (hdfs.exists(path)) {
			System.out.println("文件 " + fileName + " 已存在");
		} else {
			FSDataOutputStream outputStream = hdfs.create(path);
			outputStream.writeUTF(content); // 会添加一些特殊的字符
			// outputStream.write(content.getBytes()); //可以解决特殊的字符
			outputStream.close();
			outputStream.flush();
		}
	}
```
## 读取hdfs上已有的文件

``` java
public static void readFile(String fileName) throws Exception {
		Path path = new Path(fileName);
		if (!hdfs.exists(path) || hdfs.isDirectory(path)) {
			System.out.println("给定路径 " + fileName + "不存在,或者不是一个");
		} else {
			FSDataInputStream inputStream = hdfs.open(path);
			String content = inputStream.readUTF();
			System.out.println(content);
		}
	}
```

## 删除hdfs上已经有的文件或文件夹

``` java
public static void deleteFile(String fileName) throws Exception {
		Path path = new Path(fileName);
		if (!hdfs.exists(path)) {
			System.out.println("文件不存在");
		} else {
			hdfs.delete(path, true);
			System.out.println("删除成功");
		}
	}
```

## 上传文件

``` xml
public static void upload(Path src,Path dst) throws Exception{
		if(hdfs.exists(dst)){
			System.out.println("文件已经存在");
		}else {
			hdfs.copyFromLocalFile(false,src, dst);
		}
	}
```

## 下载文件

``` java
public static void download() throws Exception{
		// 方式一
		/*InputStream in = hdfs.open(new Path("/aa/a.txt"));
		FileOutputStream out = new FileOutputStream("d:/a.txt");
		IOUtils.copyBytes(in, out, 4096,true);*/
		// 方式二
		Path src = new Path("/aa/a.txt");
		Path dst = new Path("d:/aa.txt");
		hdfs.copyToLocalFile(src, dst);
}
```
## 迭代文件

``` java
public static void getAllFileStatus(Path path) throws Exception {
		FileStatus[] fileStatus = hdfs.listStatus(path);
		if(hdfs.isDirectory(path)){
			for (FileStatus fs : fileStatus) {
				 path = fs.getPath();
				 getAllFileStatus(path);
				 System.out.println(fs);
			}
		}
	}

```



  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507808911254.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507808921928.jpg
  [3]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507808931985.jpg
  [4]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507809837047.jpg
  [5]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507809848174.jpg
  [6]: https://mvnrepository.com
  [7]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507809858528.jpg