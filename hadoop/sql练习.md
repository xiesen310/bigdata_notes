---
title: sql练习 
tags: mysql,sql
grammar_cjkRuby: true
---

--1.学生表
Student(S,Sname,Sage,Ssex) --S 学生编号,Sname 学生姓名,Sage 出生年月,Ssex 学生性别
--2.课程表 
Course(C,Cname,T) --C --课程编号,Cname 课程名称,T 教师编号
--3.教师表 
Teacher(T,Tname) --T 教师编号,Tname 教师姓名
--4.成绩表 
SC(S,C,score) --S 学生编号,C 课程编号,score 分数

``` sql
--创建测试数据
create table Student(S varchar(10),Sname varchar(10),Sage datetime,Ssex nvarchar(10))
insert into Student values('01' , '赵雷' , '1990-01-01' , '男')
insert into Student values('02' , '钱电' , '1990-12-21' , '男')
insert into Student values('03' , '孙风' , '1990-05-20' , '男')
insert into Student values('04' , '李云' , '1990-08-06' , '男')
insert into Student values('05' , '周梅' , '1991-12-01' , '女')
insert into Student values('06' , '吴兰' , '1992-03-01' , '女')
insert into Student values('07' , '郑竹' , '1989-07-01' , '女')
insert into Student values('08' , '王菊' , '1990-01-20' , '女')
create table Course(C varchar(10),Cname,varchar(10),T varchar(10))
insert into Course values('01' , '语文' , '02')
insert into Course values('02' , '数学' , '01')
insert into Course values('03' , '英语' , '03')
create table Teacher(T varchar(10),Tname,varchar(10))
insert into Teacher values('01' , '张三')
insert into Teacher values('02' , '李四')
insert into Teacher values('03' , '王五')
create table SC(S varchar(10),C varchar(10),score decimal(18,1))
insert into SC values('01' , '01' , 80)
insert into SC values('01' , '02' , 90)
insert into SC values('01' , '03' , 99)
insert into SC values('02' , '01' , 70)
insert into SC values('02' , '02' , 60)
insert into SC values('02' , '03' , 80)
insert into SC values('03' , '01' , 80)
insert into SC values('03' , '02' , 80)
insert into SC values('03' , '03' , 80)
insert into SC values('04' , '01' , 50)
insert into SC values('04' , '02' , 30)
insert into SC values('04' , '03' , 20)
insert into SC values('05' , '01' , 76)
insert into SC values('05' , '02' , 87)
insert into SC values('06' , '01' , 31)
insert into SC values('06' , '03' , 34)
insert into SC values('07' , '02' , 89)
insert into SC values('07' , '03' , 98)
```

--  1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数

``` sql
SELECT a.*,b.score AS '01分数',c.score AS '02分数'
FROM student a
JOIN sc b
ON a.s=b.s AND b.c='01'
JOIN sc c
ON a.s=c.s AND c.c='02'
WHERE b.score>c.score
```


--  2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数

``` sql
SELECT a.*,b.score AS '01分数',c.score AS '02分数'
FROM Student a
INNER JOIN sc b
ON a.s=b.s AND b.c='01'
INNER JOIN sc c
ON a.s=c.s AND c.c='02'
WHERE b.score<c.score
```


--  3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩

``` sql
SELECT a.S,a.Sname,AVG(b.score) AS 'avgscore'
FROM Student a
JOIN sc b
ON a.S = b.s 
GROUP BY a.S
HAVING AVG(b.score) >= 60
```


--  4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩

``` sql
SELECT a.S,a.Sname,AVG(b.score) AS 'avgscore'
FROM Student a
JOIN sc b
ON a.S = b.s 
GROUP BY a.S
HAVING AVG(b.score) < 60
```


--  5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩

``` sql
SELECT a.S AS '学生编号',a.Sname AS '学生姓名',COUNT(b.c) AS '选课总数',SUM(b.score) AS '总成绩'
FROM Student a LEFT JOIN sc b
ON a.S = b.s
GROUP BY 1,2
```


--  6、查询"李"姓老师的数量 

``` sql
SELECT COUNT(*) 
FROM teacher 
WHERE Tname LIKE '%李%'
```


--  7、查询学过"张三"老师授课的同学的信息 

``` sql
SELECT * FROM Student 
WHERE S IN (
	SELECT S FROM sc 
	WHERE C = (
		SELECT C FROM course 
		WHERE T = (
		SELECT T FROM teacher 
		WHERE Tname = '张三')));
```


--  8、查询没学过"张三"老师授课的同学的信息

``` sql
SELECT a.*
FROM student a
LEFT JOIN sc b
ON a.s=b.s
WHERE NOT EXISTS(
	SELECT * 
	FROM course cc
	JOIN teacher b
	ON cc.t=b.t
	JOIN sc c
	ON cc.c=c.c
	WHERE b.tname='张三'
	AND c.s=a.s
)
GROUP BY 1,2,3,4
```


--  9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息

``` sql
SELECT a.*
FROM Student a
JOIN sc b 
ON a.S = b.s AND b.c = '01'
JOIN sc c
ON a.S = c.s AND c.c = '02'
```


--  10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息

``` sql
SELECT a.*
FROM Student a
LEFT JOIN sc b 
ON a.S = b.s AND b.c = '01'
LEFT JOIN sc c
ON a.S = c.s AND c.c = '02'
WHERE b.c = '01' AND c.c IS NULL
```


-- 　11、查询没有学全所有课程的同学的信息 

``` sql
SELECT a.*
FROM Student a
LEFT JOIN sc b
ON a.S = b.s
GROUP BY 1,2,3,4
HAVING (COUNT(b.c) < (SELECT COUNT(*) FROM course))
```


--  12、查询至少有一门课与学号为"01"的同学所学相同 的同学的信息 

``` sql
SELECT a.* 
FROM Student a
JOIN sc b
ON a.S = b.s
WHERE EXISTS(
	SELECT s FROM sc WHERE s = '01' AND c = b.c 
)
GROUP BY 1,2,3,4
```


--  13、查询和"01"号的同学学习的课程完全相同的其他同学的信息

``` sql
SELECT a.* FROM student a
JOIN( 
	SELECT a.*
	FROM (
		SELECT *,COUNT(b.C) num
		FROM (
			SELECT a.s,a.c 
			FROM sc a 
			GROUP BY 1,2
	) b
	GROUP BY 1) a

	JOIN
	(SELECT	a.s,a.num FROM(
		SELECT *,COUNT(b.C) num
		FROM 
		(SELECT a.s,a.c 
		FROM sc a 
		GROUP BY 1,2
		) b
	GROUP BY 1
	) a
	WHERE a.s ='01') b
	WHERE a.num = b.num AND a.s <> '01'
) b
WHERE a.s = b.s
```


--  14、查询没学过"张三"老师讲授的任一门课程的学生姓名 

``` sql
SELECT	* FROM student a
LEFT JOIN 

(SELECT a.s FROM student a
	LEFT JOIN sc b
	ON a.s = b.s
	WHERE b.c = (
		SELECT b.c FROM teacher a
		JOIN course b 
		ON a.t = b.t
		WHERE a.tname = '张三'
	)
) b
ON a.s = b.S
WHERE b.s IS  NULL
```


--  15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩 

``` stylus
SELECT a.s
       ,a.sname
       ,AVG(b.score) AS '平均成绩'
FROM student a
JOIN sc b
ON a.s=b.s
GROUP BY 1,2
HAVING SUM(CASE WHEN b.score >= 60 THEN 0 ELSE 1 END)>=2
```


--  16、检索"01"课程分数小于60，按分数降序排列的学生信息

``` sql
SELECT a.*,b.score
FROM Student a
LEFT JOIN sc b 
ON a.S = b.s
WHERE b.c = '01' AND b.score < 60
ORDER BY b.score DESC
```


--  17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩

``` sql
SELECT
  a.*,
  SUM(CASE WHEN b.c = '01' THEN b.score ELSE 0 END) AS s01,
  SUM(CASE WHEN b.c = '02' THEN b.score ELSE 0 END) AS s02,
  SUM(CASE WHEN b.c = '03' THEN b.score ELSE 0 END) AS s03,
  AVG(CASE WHEN b.score IS NULL THEN 0 ELSE b.score END)    avgscore
FROM student a
  LEFT JOIN sc b
    ON a.s = b.s
GROUP BY 1,2,3,4
ORDER BY avgscore DESC
```


--  18、查询各科成绩最高分、最低分和平均分：
--  以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90

``` sql
SELECT a.c AS '课程ID'
	,a.Cname AS '课程name'
	,MAX(b.score) AS '最高分'
	,MIN(b.score) AS '最低分'
	,AVG(b.score) AS '平均分'
	,SUM(CASE WHEN b.score >= 60 THEN 1 ELSE 0 END)/COUNT(*) AS '及格率'
	,SUM(CASE WHEN b.score >= 70 AND b.score < 80 THEN 1 ELSE 0 END)/COUNT(*) AS '中等率'
	,SUM(CASE WHEN b.score >= 80 AND b.score < 90 THEN 1 ELSE 0 END)/COUNT(*) AS '优良率'
	,SUM(CASE WHEN b.score >= 90 THEN 1 ELSE 0 END)/COUNT(*) AS '优秀率'
FROM course a
JOIN sc b
ON a.c = b.c
GROUP BY 1,2
```

--  19、按各科成绩进行排序，并显示排名

``` sql
SELECT * 
	,(SELECT COUNT(1) FROM sc WHERE c = a.c AND score > a.score) + 1 pm	
FROM sc a
ORDER BY a.c,pm
```

--  20、查询学生的总成绩并进行排名

``` sql
SELECT a.*,b.sums FROM student a
JOIN (
	SELECT *,SUM(a.score) sums
	FROM sc a
	GROUP BY a.s
) b
ON a.s = b.S
ORDER BY b.sums DESC
```


--  21、查询不同老师所教不同课程平均分从高到低显示 

``` sql
SELECT a.*
       ,b.cname
       ,AVG(c.score) AS '平均分'
FROM teacher a
JOIN course b
ON a.t=b.t
JOIN sc c
ON b.c=c.c
GROUP BY 1,2,3
ORDER BY '平均分' DESC
```


-- 　22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩

``` sql
SELECT a.*
	,b.*
	,(SELECT COUNT(DISTINCT score) FROM sc WHERE C = a.C AND score < a.score)+1 px
FROM sc a
JOIN student b
ON a.S = b.S
WHERE (SELECT COUNT(DISTINCT score) FROM sc WHERE C = a.C AND score < a.score)+1 BETWEEN 2 AND 3
ORDER BY a.C,a.score
```


--  23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],(85-70],(70-60],[0-60)及所占百分比 

``` sql
SELECT a.c AS '课程编号'
	,a.cName AS '课程名称'
	,SUM(CASE WHEN b.score >=85 THEN 1 ELSE 0 END)/COUNT(*) AS '[100-85]'
	,SUM(CASE WHEN b.score >= 70 AND b.score < 85 THEN 1 ELSE 0 END)/COUNT(*) AS '(85-70]'
	,SUM(CASE WHEN b.score >= 60 AND b.score < 70 THEN 1 ELSE 0 END)/COUNT(*) AS '(70-60]'
	,SUM(CASE WHEN b.score >= 0 AND b.score < 60 THEN 1 ELSE 0 END)/COUNT(*) AS '[0,60)'
FROM course a
JOIN sc b
ON a.c = b.c
GROUP BY 1,2
```
--  24、查询学生平均成绩及其名次

``` sql
SET @rank=0;
SELECT b.s
	,avg_score
	,@rank := @rank+1 AS rank
FROM(
		SELECT a.s
		,AVG(a.score) avg_score
	FROM sc a
	GROUP BY a.S
	ORDER BY avg_score DESC
) b
```


--  25、查询各科成绩前三名的记录

``` sql
SELECT a.* FROM sc a
LEFT JOIN sc b ON a.c = b.c AND a.score < b.score
GROUP BY 1,2,3
HAVING COUNT(b.s) < 2
ORDER BY a.c,a.score DESC
```


--  26、查询每门课程被选修的学生数 

``` sql
SELECT a.*
       ,COUNT(b.s)
FROM course a
LEFT JOIN sc b
ON a.c=b.c
GROUP BY 1,2,3
```


--  27、查询出只有两门课程的全部学生的学号和姓名  

``` sql
SELECT a.*
       ,COUNT(b.c)
FROM student a
LEFT JOIN sc b
ON a.s=b.s
GROUP BY 1,2,3,4
HAVING COUNT(b.c)=2
```


--  28、查询男生、女生人数 

``` sql
SELECT a.ssex
	,COUNT(a.Ssex)
FROM student a
GROUP BY Ssex
```


--  29、查询名字中含有"风"字的学生信息

``` sql
SELECT * 
FROM student 
WHERE Sname LIKE '%风%'
```
--  30、查询同名同性学生名单，并统计同名人数

``` sql
SELECT  a.Sname
	,COUNT(a.Sname)
FROM student a
GROUP BY a.Sname
HAVING COUNT(a.Sname) > 1
```
--  31、查询1990年出生的学生名单(注：Student表中Sage列的类型是datetime) 

``` sql
SELECT * 
FROM student 
WHERE YEAR(Sage) = 1990
```


--  32、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号

``` sql
SELECT a.*
	,AVG(b.score) AS ac
FROM course a
LEFT JOIN sc b
ON a.c = b.c
GROUP BY 1,2,3
ORDER BY ac DESC,a.c
```


--  33、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩

``` sql
SELECT a.*
	,AVG(b.score) ac
FROM student a
LEFT JOIN sc b
ON a.s = b.S
GROUP BY 1,2,3,4
HAVING ac >= 85
```


--  34、查询课程名称为"数学"，且分数低于60的学生姓名和分数 

``` sql
SELECT c.*
FROM course a
LEFT JOIN sc b
ON a.c = b.C
LEFT JOIN student c
ON c.s = b.S
WHERE a.cname ='数学' 
AND b.score < 60
```
--  35、查询所有学生的课程及分数情况； 

``` sql
SELECT *
FROM sc a
INNER JOIN student b
ON a.s=b.s
INNER JOIN course c
ON a.c=c.c
```


--  36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数

``` sql
SELECT b.sname , c.cname,a.score
FROM sc a
JOIN student b
ON a.s=b.s
JOIN course c
ON a.c=c.c
WHERE a.score > 70
```


--  37、查询不及格的课程

``` sql
SELECT b.sname , c.cname,a.score
FROM sc a
JOIN student b
ON a.s=b.s
JOIN course c
ON a.c=c.c
WHERE a.score < 60
```


--  38、查询课程编号为01且课程成绩在80分以上的学生的学号和姓名； 

``` sql
SELECT a.S,a.Sname
FROM student a
JOIN sc b
ON a.S = b.s
WHERE b.c = '01' AND b.score > 80
```


--  39、求每门课程的学生人数 

``` sql
SELECT a.* ,COUNT(a.cname)
FROM course a
LEFT JOIN sc b
ON a.c = b.c
LEFT JOIN student c
ON b.s = c.s
GROUP BY 1,2,3
```


--  40、查询选修"张三"老师所授课程的学生中，成绩最高的学生信息及其成绩

``` sql
SELECT a.* ,b.maxscore
FROM student a
JOIN 
	(
	SELECT *,MAX(a.score) maxscore
	FROM sc a
	WHERE c = 
	(
	SELECT a.c
	FROM course a
	JOIN teacher b
	ON a.T = b.T
	WHERE b.Tname = '张三')
)b
ON a.s = b.s
```


--  41、查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩 

``` sql
SELECT a.s
       ,a.c
       ,a.score
FROM sc a
JOIN (
	SELECT a.score
	       ,b.s
	       ,COUNT(1)
	FROM sc a
	JOIN student b
	ON a.s=b.s
	GROUP BY a.score,b.s
	HAVING COUNT(1)>1
)b
ON a.s=b.s AND a.score=b.score
```
--  42、查询每门功成绩最好的前两名

``` sql
SELECT a.* FROM sc a 
LEFT JOIN sc b ON a.c = b.c AND a.score > b.score
GROUP BY 1,2,3
HAVING COUNT(b.S)<2
ORDER BY a.c,a.score DESC
```




--  43、统计每门课程的学生选修人数（超过5人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列  

``` sql
SELECT a.c
       ,COUNT(1) AS pnum
FROM sc a
GROUP BY 1
HAVING pnum>5
ORDER BY pnum DESC,a.c
```


--  44、检索至少选修两门课程的学生学号

``` sql
SELECT a.S
	,COUNT(a.c) pnum
FROM sc a
GROUP BY 1
HAVING pnum>=2
```
--  45、查询选修了全部课程的学生信息

``` sql
SELECT a.*
FROM student a
JOIN (
SELECT a.S
	,COUNT(a.c) pnum
FROM sc a
GROUP BY 1
HAVING pnum>=(SELECT COUNT(1) FROM course)
) b
ON a.s = b.s
```
--  46、查询各学生的年龄

``` sql
SELECT a.s
	,a.Sname
	,a.Ssex
	,YEAR(NOW())-YEAR(a.Sage) AS 'age'
FROM student a
```


--  47、查询本周过生日的学生

``` sql
SELECT b.*
FROM(
	SELECT *
		,DATE_SUB(CURDATE(),INTERVAL WEEKDAY(CURDATE()) DAY) starttime 
		,DATE_SUB(CURDATE(),INTERVAL WEEKDAY(CURDATE())-6 DAY) endtime 
		
	FROM student a
) b
WHERE DATE_FORMAT(b.Sage,'%Y-%m-%d') >= starttime AND DATE_FORMAT(b.Sage,'%Y-%m-%d') <= endtime

SELECT DATE_FORMAT(NOW(), '%Y-%m-%d');
```


--  48、查询下周过生日的学生

``` sql
SELECT b.*
FROM(
	SELECT *
	,DATE_ADD(DATE_SUB(CURDATE(),INTERVAL WEEKDAY(CURDATE()) DAY), INTERVAL 7 DAY) nwt
	,DATE_ADD(DATE_SUB(CURDATE(),INTERVAL WEEKDAY(CURDATE())-6 DAY), INTERVAL 7 DAY) ewt			
	FROM student a
) b
WHERE DATE_FORMAT(b.Sage,'%Y-%m-%d') >= nwt AND DATE_FORMAT(b.Sage,'%Y-%m-%d') <= ewt
```


--  计算当前周的起始时间，结束时间

``` sql
SELECT DATE_SUB(CURDATE(),INTERVAL WEEKDAY(CURDATE()) DAY) starttime ,DATE_SUB(CURDATE(),INTERVAL WEEKDAY(CURDATE())-6 DAY) endtime;
--  计算下周的起始时间，结束时间
SELECT  DATE_ADD(DATE_SUB(CURDATE(),INTERVAL WEEKDAY(CURDATE()) DAY), INTERVAL 7 DAY) nwt,DATE_ADD(DATE_SUB(CURDATE(),INTERVAL WEEKDAY(CURDATE())-6 DAY), INTERVAL 7 DAY) ewt
```


--  49、查询本月过生日的学生

``` sql
SELECT * 
FROM student a
WHERE MONTH(a.sage)=MONTH(CURDATE())
```


-- 50、查询下月过生日的学生

``` sql
SELECT * 
FROM student a
WHERE MONTH(a.sage)=MONTH(CURDATE())+1 
```












