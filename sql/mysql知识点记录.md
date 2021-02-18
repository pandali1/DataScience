> 牛客网刷题知识点总结

# 数据定义语言DDL

## 插入insert

```mysql
-- 插入多行
INSERT INTO table(column1,column2...)
VALUES (value1,value2,...),
       (value1,value2,...);

-- 从查询中插入
INSERT INTO table_1
SELECT c1, c2, FROM table_2;

-- insert repalce into:插入替换数据,如果存在主键或unique数据则替换数据
-- insert ignore into :如果存在主键或unique数据,则不进行insert。
```

## alter

- alter的常用方法：

- **ALTER TABLE 表名 ADD 列名/索引/主键/外键等；**
- **ALTER TABLE 表名 DROP 列名/索引/主键/外键等；**
- **ALTER TABLE 表名 ALTER 仅用来改变某列的默认值；**
- **ALTER TABLE 表名 RENAME 列名/索引名 TO 新的列名/新索引名；**
- **ALTER TABLE 表名 RENAME TO/AS 新表名;**
- **ALTER TABLE 表名 MODIFY 列的定义但不改变列名；**
- **ALTER TABLE 表名 CHANGE 列名和定义都可以改变。**

## delete

```mysql
DELETE FROM customers
WHERE country = 'France'
ORDER BY creditLimit
LIMIT 5;
```

- 使用order by 和limit也可以约束删除的范围
- 当删除表中全部数据时，使用`truncate table table_name`更加高效
- 注意，在删除或者跟更新时，条件中的子查询不能使用更新或者删除的表本身，必须使用别名的方式，将子查询存储为新表

## 索引

- 创建索引的方法与种类[链接](https://www.yiibai.com/mysql/create-drop-index.html)[链接](https://www.yiibai.com/mysql/mysql_indexes.html)

```mysql
-- 1通过create创建索引
CREATE [UNIQUE|FULLTEXT|SPATIAL] INDEX index_name
USING [BTREE | HASH | RTREE] -- 索引数据类型，可以省略
ON table_name (column_name [(length)] [ASC | DESC],...) -- 可以添加多个字段，并指定排序方式
-- 索引的类型 PRIMARY KEY，KEY，UNIQUE或INDEX，当创建表时，若声明了主键或者unique，会自动生成索引

-- 2 通过alter table创建索引
ALTER TABLE tbl_name ADD [PRIMARY KEY/UNIQUE INDEX indexname/fulltext indexname] (col_list);

-- 3删除索引
DROP INDEX index_name ON tbl_name;
// 或者
ALTER TABLE tbl_name DROP INDEX index_name；
ALTER TABLE tbl_name DROP PRIMARY KEY;
```

## 视图

- 创建视图的方法[链接](https://www.yiibai.com/mysql/create-sql-views-mysql.html)

```mysql
CREATE 
   [ALGORITHM = {MERGE  | TEMPTABLE | UNDEFINED}]
VIEW [database_name].[view_name] 
AS
	[SELECT  statement]
-- 使用条件：
-- SELECT语句可以在WHERE子句中包含子查询，但FROM子句中的不能包含子查询。
-- SELECT语句不能引用任何变量，包括局部变量，用户变量和会话变量。
-- SELECT语句不能引用准备语句的参数。
```

## 触发器

- 触发器创建：[链接](https://www.yiibai.com/mysql/create-the-first-trigger-in-mysql.html)
- 在触发语句中，使用new指代插入、更新后的行
- old代表更新==前==或者删除==前==的行

```mysqk
create trigger audit_log 
after insert
on employees_test
for each row
begin
    insert into audit(EMP_no,NAME)
    values(NEW.ID,NEW.NAME);-- 注意加分号，表示语句的结束
end
```



# 查询常用语句：

## limit

limit m,n 从m+1处开始，返回n行，m可以省略

分页显示：limit 每页显示数量*(第n页 -1)，每页显示数量

## replace

- [replace字句的三种使用方法](https://www.yiibai.com/mysql/replace.html)

1. 类似与insert

```sql
REPLACE INTO table_name(column_list)
VALUES(value_list)
```

2. 类似于update

```mysql
REPLACE INTO table
SET column1 = value1,
    column2 = value2
```

3. insert select

```mysql
REPLACE INTO cities(name,population)
SELECT name,population FROM cities 
WHERE id = 1
```

## exists

- exists和in通常可以实现相同的功能
- 当从表（子查询的表）很大时，通常使用in

## case

```mysql
CASE  case_expression
   WHEN when_expression_1 THEN commands
   WHEN when_expression_2 THEN commands
   ...
   ELSE commands
END CASE
```



## 开窗函数over

- [开窗函数简介](https://www.begtut.com/mysql/mysql-window-functions.html)

- [开窗函数使用](https://www.bilibili.com/video/BV1954y1v7tZ?from=search&seid=2600002023226557726)

- ```mysql
  window_function_name(expression) 
      OVER (
          [partition_defintion]
          [order_definition]
          [frame_definition]
      ) 
  
  frame_definition就是在partition内，取每一行的时候，在组内计算时，选择的计算范围,具体使用见下图
  ```

  ![image-20210214204524090](https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210214204524090.png)

- dense_rank() 对每个dept_no部门中的partition分组数据进行排序

- row_number()，rank()，ntile(n),以及其他聚合函数

# 常用函数：

## 计算函数

- 取整函数 
  - 四舍五入round()
  - 向上取整ceiling()
  - 向下取整floor()

## 字符串类函数

- 大小写；

​			Lower(列名） 

​			Upper(列名）

- 字符串定位

​			POSITION(字符 IN 列名) mysql

​			PATINDEX('%s1%', s2) sqlserver

- 合并

​			CONCAT(列名, ' is in ', 列名…)

- 替换

​			replace(列名，旧字符串，新字符串）

- 取左

​			left (列名，位数） 返回字符串列中左边多少位的字符

- 匹配单引号等特殊字符

​			使用转义字符\+特殊字符

- 提取字符串 

​		SUBSTRING(列名 , 开始位 ,字符长度 ) mysql

## 日期类函数

1. 获取当前日期

   - CURDATE()

2. 获取当前日期和时间

   - now() 所在整个语句开始执行的时间
   - sysdate() 执行到当前时间函数的时间

3. 日期偏移函数

   - 增加偏移==date_add==函数的使用：[链接](https://www.yiibai.com/mysql/date_add.html)

     ```
     DATE_ADD(start_date, INTERVAL expr unit)
     
     常用unit
     second,minute,hour,day,month,year
     ```

   - 减少偏移date_sub 用法同上

## 分组函数

- 字符串分组合并

  - group_concat函数使用方法：[链接](https://www.yiibai.com/mysql/group_concat.html)

    - 使用语法：

    - ```mysql
      GROUP_CONCAT(DISTINCT expression
          ORDER BY expression
          SEPARATOR sep);
      ```

      按照orderby的顺序，用sep分隔符，连接每个group中的字符串

## 其他函数

 	1. REPLACE(str,old_string,new_string);
     - replace函数的使用[连接](https://www.yiibai.com/mysql/string-replace-function.html)

# 技巧总结

1. 自连接

   - 当遇到薪水增加多少，升职次数等要求时，通常要对一个表的字段进行比较时，要使用自连接

2. `group by`与`distinct`

   - 数据量较大时，使用`group by`比`distinct`更高效

   - group by 和distinct在去重的时候，都会包含null,将所有的null看作一个组

3. 表连接与子查询

   - 一般情况下，连接的性能要高于子查询

4. 取第n大的值

   - 可以使用开窗函数
   - 也可以使用order by + limit

5. 多表复用与子查询

   - 当需要对一个表使用多次子查询的时候，一般可以通过重命名的方式，使用多个相同表的连接，实现同样的效果

6. 求累计和

   - `sum(xx) over (order by xx desc/asc)`

7. 求组内某项的比例

   - avg + case

   ```
   AVG(
           case xx when xx then 1
           else 0
           end
       )
   group by xx
   ```

8. 