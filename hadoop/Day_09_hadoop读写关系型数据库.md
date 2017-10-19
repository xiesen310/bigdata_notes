---
title: Day_09_hadoop读写关系型数据库
tags: bigdata,Java,hadoop,数据库
grammar_cjkRuby: true
---

# 事实数据和维度数据

> 维度数据相对稳定的，不经常变化，而且数据量不大，描述事物本身的数据.例如行政区划，时间(年月日)等等

> 事实数据是每分每秒都在变化，并且数据量很大描述事情的数据，例如：业务数据，订单数据，存取款等等

![enter description here][1]

# Hadoop读写关系型数据库

## 读数据库

1. 连接数据库
2. 获取表信息
3. 设置inputFormat为 DBinputWritable
4. Map的输入类型key：longWritable，value：DBWritable

不管是读取还是写入都需要我们自定义数据类型的，下面定义一个实现类实现DBWritable接口来从rdbms中获取的数据进行对接

``` java
// 对应表word_count create table word_count(wc_word varchar(255),wc_count integer)
	public static class WordCountDBWritable implements DBWritable, Writable {
		private String word;
		private int count;
		public String getWord() {
			return word;
		}
		public void setWord(String word) {
			this.word = word;
		}
		public int getCount() {
			return count;
		}
		public void setCount(int count) {
			this.count = count;
		}
		
		@Override
		public String toString() {
			return "WordCountDBWritable [word=" + word + ", count=" + count + "]";
		}

		// 将数据写入到数据库
		// insert into word_count(wc_word,wc_count) values(?,?)
		@Override
		public void write(PreparedStatement statement) throws SQLException {
			statement.setString(1, this.word);
			statement.setInt(2, this.count);
		}

		// 从数据库中读数据
		@Override
		public void readFields(ResultSet resultSet) throws SQLException {
			this.word = resultSet.getString("wc_word");
			this.count = resultSet.getInt("wc_count");
		}
		@Override
		public void write(DataOutput out) throws IOException {
			out.writeUTF(this.word);
			out.writeInt(this.count);
		}
		@Override
		public void readFields(DataInput in) throws IOException {
			this.word = in.readUTF();
			this.count = in.readInt();
		}
	}

```
> 定义mapper

``` java
public static class WriteToDBMap extends Mapper<LongWritable, Text, Text, IntWritable> {
		private final IntWritable ONE = new IntWritable(1);
		private String[] infos;
		private Text outKey = new Text();

		@Override
		protected void map(LongWritable key, Text value, Mapper<LongWritable, Text, Text, IntWritable>.Context context)
				throws IOException, InterruptedException {
			infos = value.toString().split("\\s");
			for (String word : infos) {
				outKey.set(word);
				context.write(outKey, ONE);
			}
		}
	}
```

> 定义reducer 

``` java
public static class WriteToDBReducer extends Reducer<Text, IntWritable, WordCountDBWritable, NullWritable> {
		private WordCountDBWritable outKey = new WordCountDBWritable();
		private NullWritable outValue = NullWritable.get();
		private int sum;
		@Override
		protected void reduce(Text key, Iterable<IntWritable> valuess,
				Reducer<Text, IntWritable, WordCountDBWritable, NullWritable>.Context context)
				throws IOException, InterruptedException {
			sum = 0;
			for (IntWritable value : valuess) {
				sum += value.get();
			}
			// 设置输出数据到数据库
			outKey.setWord(key.toString());
			outKey.setCount(sum);
			context.write(outKey, outValue);
		}
	}
```


## 将数据写入到数据库

1.	DBoutputFormat设置为job的输出格式
2.	Reduce的key：DBWritable，value：随便写,不会写入数据库(一般使用NullWritable)
3.	DBOutputFormat.setOutPut(),设置把数据写入到数据库的那张表
4.	DBConfiguration.configureDB(),设置输出数据库的连接





  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508413515484.jpg