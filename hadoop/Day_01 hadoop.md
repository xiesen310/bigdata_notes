---
title: Day_01 hadoop
tags: hadoop,java,bigdata
grammar_cjkRuby: true
---


[toc]
# 概论
 1. 起源于nutch项目(是一个搜索引擎)
    基于nutch又研发了其他的搜索引擎和延伸到数据的处理
    搜索:Lucene  solr  elasticsearch
    数据处理:Hadoop  Avro

 2. **分布式的产生**:传统服务器对新型业务的处理达到了瓶颈,主要处理大数据和高并发的问题,数据进行分布在多台电脑上.
    **分布式的处理**:利用网络把多台机器连接起来,使用消息系统来保持通信,以一个整体对外提供统一的服务

 3. **集群**:可以实现分布式
    集群里面是一个一个的物理计算机,也就是节点

 4. **分布式通信**:
    序列化:把文件序列化为二进制,进行传输
    再经过IPC协议(通信调用协议),分为两种:LPC(本地过程调用),RPC(远程过程调用).

# 集群
   
## 克隆虚拟机
  

 1. 关闭虚拟机,选择右键管理,选择克隆

![enter description here][1]

![enter description here][2]

![enter description here][3]

![enter description here][4]

![enter description here][5]


 2. 更改ip

> vi /etc/sysconfig/network-scripts/ifcfg-eth0 编辑对应的配置文件，注意修改一下 ip地址以及网卡地址(网卡地址可以通过ifconfig命令查看)

![enter description here][6]

## 创建集群

 ### ssh
  (1)`ssh-keygen -t rsa` 生成ssh(公钥和私钥)(为了解决每次远程操作时都要访问密码)
     公钥:给其他的公钥,其他的就可以有权限来操作,远程操作的时候就可以不用密码了
     私钥:只有自己有
  (2) `cp id_rsa.pub authorized_keys`
    生成的公钥和私钥在root的.ssh中(.ssh是个隐藏文件夹),然后把公钥的内容复制到authorized_keys文件中(授权列表,相当于门,而把公钥配置到权限列表中就代表这个公钥可以打开门,如果拿公钥访问的话就会先去授权列表中查看是否有这个公钥,有就直接访问,没有就会要密码)
  (3)`scp ~/.ssh/id_rsa.pub root@master:~/.ssh/id_rsa_slaver1.pub`
     `scp ~/.ssh/id_rsa.pub root@master:~/.ssh/id_rsa_slaver2.pub`
     将两个子节点的公钥拷贝到主节点上，分别在两个子节点上执行,这步就是把子节点的公钥给了主节点
  (4)`cat id_rsa_slaver1.pub >> authorized_keys`
     `cat id_rsa_slaver2.pub >> authorized_keys`
     把公钥配置到授权列表中
  (5)`scp ~/.ssh/authorized_keys root@slave1:~/.ssh/id_rsa_slaver1.pub`
     `scp ~/.ssh/authorized_keys root@slave2:~/.ssh/id_rsa_slaver1.pub`
     在master中把权限列表(`authorized_keys`)复制到子节点中
  (6)在每个节点上都分别执行`ssh slaver1     ssh slaver2    ssh master` 可以正常跳转到两个节点中就成功了.

 ### hadoop
   

 1. 先把`hadoop`的压缩包放虚拟机中,然后解压,
 2. 配置环境变量:
   先配置`/etc/profile`文件中的环境变量,把`hadoop`配置到环境变量中

  ![enter description here][7]

   再`source /etc/profile`加载一下配置文件,可以输入`hadoop`的时候有提示,证明配置Hadoop成功
 3. `hadoop`的配置
    `hadoop-env.sh`:运行环境配置,`jdk`,`jvm`内存配置
    `yarn-env.sh`:yarn的环境配置
    `core-site.xml`:权限,文件系统,主节点
    `hdfs-site.xml:hdfs`相关
    `mapred-site.xml`:`mapreduce`的参数配置
    `yarn-site.xml`:`yarn`的参数配置
    `slaves`:子节点的配置,里面写入所有子节点的`hostname`
 4. 配置`Hadoop`的环境
    (1)在`hadoop-env.sh`中把`export JAVA_HOME`的值改为固定的`JDK`的值即`export JAVA_HOME=/opt/Software/Java/jdk1.8.0_141`这样就不会出现找不到程序的环境变量.

  ![enter description here][8]
   
   (2)在`yarn-evn.sh`中把`export JAVA_HOME`的值改为固定的`JDK`的值即`export JAVA_HOME=/opt/Software/Java/jdk1.8.0_141`
    
  ![enter description here][9]
 5. 在`core-site.xml`中配置

  ![enter description here][10]
  
 

 6. 在`hdfs-site.xml`中配置
  
  ![enter description here][11]
  
  在版本新的里面没有`mapred-site.xml`,只有
  
  ![enter description here][12]
  
  则复制改个名`mapred-site.xml`然后在`mapred-site.xml`中配置:
  
  ![enter description here][13]
 
 7. 在`yarn-site.xml`中配置

  ![enter description here][14]
  
 8. 在slaves中配置

![enter description here][15]

 9. 这样就配置了主机的`Hadoop`,则需要把这个`hadoop`文件拷贝到子节点,则在主节点上执行:
   `scp -r /opt/Software/Hadoop/hadoop-2.6.4 root@slaver1:/usr`
   `scp -r /opt/Software/Hadoop/hadoop-2.6.4 root@slaver2:/usr`

 10. 拷贝完`hadoop`后还要配置`hadoop`的环境,则可以直接把主节点的profile拷贝到子节点
   `scp /etc/profile root@slaver1:/etc/`
 然后执行`source /etc/profile`重新加载
 11. 然后进行格式化(初始化)主节点`namenode`

   运行`Hadoop`命令:`hadoop namenode -format`就可以初始化了,出现`successfully formatted`表示格式化成功

 12. 启动`hadoop`
   执行`start-all.sh`进行启动,再执行`jps`就会显示正在运行的JAVA程序
  主节点上`jps`进程有：
  `NameNode`
  `SecondaryNameNode`
  `ResourceManager`
  每个子节点上的`jps`进程有：
  `DataNode`
 ` NodeManager`
  如果这样表示`hadoop`集群配置成功
  
  13. 要想在浏览器中进行访问，必须开放端口，这里我们直接将防火墙进行关闭

``` xml
service iptables stop 关闭防火墙
chkconfig ipdatables off 开机不启动
```


 
 ## 异常信息
 
1. 如果出现  ==doesn't satisfy minimum== 异常信息，需要指定内存信息，在yarn-site.xml中配置如下配置文件
 
``` xml
<property>
<!--NodeManager总的可用物理内存。注意，该参数是不可修改的，一旦设置，整个运行过程中不 可动态修改。另外，该参数的默认值是8192MB，因此，这个值通过一 定要配置。不过，Apache已经正在尝试将该参数做成可动态修改的。-->
        <name>yarn.nodemanager.resource.memory-mb</name>
        <value>1024</value>
    </property>
    <property>
        <name>yarn.nodemanager.resource.cpu-vcores</name>
        <value>1</value>
 </property>
 nodemanager要求的内存较低1024MB
```

2. core-site.xml文件中配置的缓冲区大小详见官方文档[http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/ClusterSetup.html][16]

``` xml
<property>
	<name>io.file.buffer.size</name>
	<value>131072</value>
</property>
```

![enter description here][17]
 

 
 


   


  [1]: https://www.github.com/wxdsunny/images/raw/master/1507618366514.jpg "1507618366514.jpg"
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507646284206.jpg
  [3]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507646294761.jpg
  [4]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507646305359.jpg
  [5]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507646310534.jpg
  [6]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507646331256.jpg
  [7]: https://www.github.com/wxdsunny/images/raw/master/1507625175117.jpg "1507625175117.jpg"
  [8]: https://www.github.com/wxdsunny/images/raw/master/1507635013502.jpg "1507635013502.jpg"
  [9]: https://www.github.com/wxdsunny/images/raw/master/1507635270903.jpg "1507635270903.jpg"
  [10]: https://www.github.com/wxdsunny/images/raw/master/1507637048976.jpg "1507637048976.jpg"
  [11]: https://www.github.com/wxdsunny/images/raw/master/1507637915355.jpg "1507637915355.jpg"
  [12]: https://www.github.com/wxdsunny/images/raw/master/1507638120425.jpg "1507638120425.jpg"
  [13]: https://www.github.com/wxdsunny/images/raw/master/1507638522476.jpg "1507638522476.jpg"
  [14]: https://www.github.com/wxdsunny/images/raw/master/1507638835376.jpg "1507638835376.jpg"
  [15]: https://www.github.com/wxdsunny/images/raw/master/1507639140091.jpg "1507639140091.jpg"
  [16]: http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/ClusterSetup.html
  [17]: http://markdown.xiaoshujiang.com/img/spinner.gif "[[[1507648366954]]]"