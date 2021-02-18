--建表
--学生表
CREATE TABLE [schema].Student(
s_id VARCHAR(20),
s_name VARCHAR(20) NOT NULL DEFAULT '',
s_birth VARCHAR(20) NOT NULL DEFAULT '',
s_sex VARCHAR(10) NOT NULL DEFAULT '',
PRIMARY KEY(s_id)
);
--课程表
CREATE TABLE [schema].Course(
c_id VARCHAR(20),
c_name VARCHAR(20) NOT NULL DEFAULT '',
t_id VARCHAR(20) NOT NULL,
PRIMARY KEY(c_id)
);
--教师表
CREATE TABLE [schema].Teacher(
t_id VARCHAR(20),
t_name VARCHAR(20) NOT NULL DEFAULT '',
PRIMARY KEY(t_id)
);

--成绩表
CREATE TABLE [schema].Score(
s_id VARCHAR(20),
c_id VARCHAR(20),
s_Score INT,
PRIMARY KEY(s_id,c_id)
);
--插入学生表测试数据
insert into [schema].Student values('01' , '赵雷' , '1990-01-01' , '男');
insert into [schema].Student values('02' , '钱电' , '1990-12-21' , '男');
insert into [schema].Student values('03' , '孙风' , '1990-05-20' , '男');
insert into [schema].Student values('04' , '李云' , '1990-08-06' , '男');
insert into [schema].Student values('05' , '周梅' , '1991-12-01' , '女');
insert into [schema].Student values('06' , '吴兰' , '1992-03-01' , '女');
insert into [schema].Student values('07' , '郑竹' , '1989-07-01' , '女');
insert into [schema].Student values('08' , '王菊' , '1990-01-20' , '女');
--课程表测试数据
insert into [schema].Course values('01' , '语文' , '02');
insert into [schema].Course values('02' , '数学' , '01');
insert into [schema].Course values('03' , '英语' , '03');

--教师表测试数据
insert into [schema].Teacher values('01' , '张三');
insert into [schema].Teacher values('02' , '李四');
insert into [schema].Teacher values('03' , '王五');

--成绩表测试数据
insert into [schema].Score values('01' , '01' , 80);
insert into [schema].Score values('01' , '02' , 90);
insert into [schema].Score values('01' , '03' , 99);
insert into [schema].Score values('02' , '01' , 70);
insert into [schema].Score values('02' , '02' , 60);
insert into [schema].Score values('02' , '03' , 80);
insert into [schema].Score values('03' , '01' , 80);
insert into [schema].Score values('03' , '02' , 80);
insert into [schema].Score values('03' , '03' , 80);
insert into [schema].Score values('04' , '01' , 50);
insert into [schema].Score values('04' , '02' , 30);
insert into [schema].Score values('04' , '03' , 20);
insert into [schema].Score values('05' , '01' , 76);
insert into [schema].Score values('05' , '02' , 87);
insert into [schema].Score values('06' , '01' , 31);
insert into [schema].Score values('06' , '03' , 34);
insert into [schema].Score values('07' , '02' , 89);
insert into [schema].Score values('07' , '03' , 98);