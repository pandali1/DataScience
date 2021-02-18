> 本文主要记录在使用sqlserver数据库时，遇到的一些函数
# 常用函数
## 长宽表转换
1. pivot函数
	--  使用方法：[链接](https://docs.microsoft.com/en-us/sql/t-sql/queries/from-using-pivot-and-unpivot?view=sql-server-ver15)
	-- 可以将长表转换为宽表
	```sql
	SELECT <non-pivoted column>,  
    [first pivoted column] AS <column name>,  
    [second pivoted column] AS <column name>,  
    ...  
    [last pivoted column] AS <column name>  
	FROM  
	    (<SELECT query that produces the data>)   
	    AS <alias for the source query>  
	PIVOT  
	(  
	    <aggregation function>(<column being aggregated>)  
	FOR   
	[<column that contains the values that will become column headers>]   
	    IN ( [first pivoted column], [second pivoted column],  
	    ... [last pivoted column])  
	) AS <alias for the pivot table>  
	<optional ORDER BY clause>;  
	```
	## 时间函数
	
	```sql
	--1 获取当前日期
	getdate()
	
	--2 获取日期中的特定部分
	year(日期)
	month（字段）
	day(字段）
	datepart（part，日期字段）
	常用的part请参见：https://docs.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql?view=sql-server-ver15
	    
	--3 获取日期差
	DATEDIFF ( datepart , startdate , enddate )
	datepart是要日期差的单位
	    
	-- 4日期偏移
	DATEADD (datepart , number , date )  
		
	```
	

