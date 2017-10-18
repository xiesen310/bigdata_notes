---
title: Day_07_MR串联与关联
tags: bigdata,hadoop,Java,MapReduce
grammar_cjkRuby: true
---

# 分维度topN问题

![topN分维度示意图][1]




# Mr串联
hadoop的mr作业支持链式处理流程,就好比我们linux中的管道一样,将上次的输出作为下次的输入继续执行操作.
为了解决这类问题,提出了ChainMapper和ChainReduce,这个过程和我们一个map一个reducer的状态是一样的,,下面是具体的实现代码


![MR原理分析示意图][2]

``` java
package top.xiesen.chain;

import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.chain.ChainMapper;
import org.apache.hadoop.mapreduce.lib.chain.ChainReducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

/**
* 项目名称：mapreeduce
* 类名称：MRChain
* 类描述：
* 创建人：Allen
* @version
*/
public class MRChain {
	
	/**
	* 项目名称：mapreeduce
	* 类名称：MRChainMap1
	* 类描述：map过滤销售数量大于1亿的数据
	* 创建人：Allen
	* @version
	*/
	public static class MRChainMap1 extends Mapper<LongWritable, Text, Text, IntWritable>{
		private Text oKey = new Text();
		private IntWritable oValue = new IntWritable();
		private String[] infos;
		@Override
		protected void map(LongWritable key, Text value, Mapper<LongWritable, Text, Text, IntWritable>.Context context)
				throws IOException, InterruptedException {
			infos = value.toString().split("\\s");
			if(Integer.valueOf(infos[1]) <= 100000000){
				oKey.set(infos[0]);
				oValue.set(Integer.valueOf(infos[1]));
				System.out.println(oKey+"---" + oValue);
				context.write(oKey, oValue);
			}
		}
	}
	
	/**
	* 项目名称：mapreeduce
	* 类名称：MRChain2
	* 类描述：过滤掉100-10000之间的数据
	* 创建人：Allen
	* @version
	*/
	public static class MRChainMap2 extends Mapper<Text, IntWritable,Text, IntWritable>{

		@Override
		protected void map(Text key, IntWritable value, Mapper<Text, IntWritable, Text, IntWritable>.Context context)
				throws IOException, InterruptedException {
			if(value.get() <= 100 || value.get() >= 10000){
				context.write(key, value);
			}
		}
	}
	
	
	/**
	* 项目名称：mapreeduce
	* 类名称：MRChainReducer
	* 类描述：聚合商品总数量
	* 创建人：Allen
	* @version
	*/
	public static class MRChainReducer extends Reducer<Text, IntWritable, Text, IntWritable>{
		private IntWritable oValue = new IntWritable();
		private int sum;
		@Override
		protected void reduce(Text key, Iterable<IntWritable> values,
				Reducer<Text, IntWritable, Text, IntWritable>.Context context) throws IOException, InterruptedException {
			sum = 0;
			for (IntWritable value : values) {
				sum += value.get();
			}
			oValue.set(sum);
			context.write(key, oValue);
		}
	}
	
	/**
	* 项目名称：mapreeduce
	* 类名称：MRChainMap3
	* 类描述：商品名称大于3的过滤掉
	* 创建人：Allen
	* @version
	*/
	public static class MRChainMap3 extends Mapper<Text, IntWritable, Text, IntWritable>{
		
		@Override
		protected void map(Text key, IntWritable value, Mapper<Text, IntWritable, Text, IntWritable>.Context context)
				throws IOException, InterruptedException {
			if(key.toString().length() < 3){
				context.write(key, value);
			}
		}
	}
	
	
	public static void main(String[] args) throws Exception {
		Configuration configuration = new Configuration();
		Job job = Job.getInstance(configuration);
		job.setJarByClass(MRChain.class);
		job.setJobName("mapreduce串联");
		// 设置map端执行
		ChainMapper.addMapper(job, MRChainMap1.class, LongWritable.class, Text.class, Text.class, IntWritable.class, configuration);
		ChainMapper.addMapper(job, MRChainMap2.class, Text.class, IntWritable.class,Text.class, IntWritable.class, configuration);
		// 设置reduce端执行
		ChainReducer.setReducer(job, MRChainReducer.class, Text.class, IntWritable.class, Text.class, IntWritable.class, configuration);
		ChainReducer.addMapper(job, MRChainMap3.class, Text.class, IntWritable.class, Text.class, IntWritable.class, configuration);
		
		Path inputPath = new Path("/goods.txt");
		Path outputDir = new Path("/bd14/goods");
		outputDir.getFileSystem(configuration).delete(outputDir,true);
		FileInputFormat.addInputPath(job, inputPath);
		FileOutputFormat.setOutputPath(job, outputDir);
		
		System.exit(job.waitForCompletion(true) ? 0 : 1);
	}
}
```

# mr关联

> mr关联有三种形式: map端关联,reduce端关联,semijoin关联.map端关联时效率最高的,因为map端关联,关联在一起的数据小于或者等于没有关联的数据,减少了数据的传输过程和shuffle过程,shuffle过程是最消耗资源的.在reduce端进行关联是最消耗资源的,增大了shuffle过程,但是对于大文件我们只能在reduce端进行关联,另外一个是semijoin


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508329686314.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508328590698.jpg