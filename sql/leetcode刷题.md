leetcode sql刷题

## 185

编写一个 SQL 查询，找出每个部门获得前三高工资的所有员工

```
# Write your MySQL query statement below
select
d.Name as Department
,a.Name as Employee
,a.Salary
from
Department d join
    (
        select
        *
        ,dense_rank() over(partition by DepartmentId order by Salary desc) as rk
        from Employee
    ) a 
on d.Id = a.DepartmentId
where a.rk in (1,2,3)
order by d.Name,a.Salary desc
```

## 262

写一段 SQL 语句查出 `"2013-10-01"` 至 `"2013-10-03"` 期间非禁止用户（**乘客和司机都必须未被禁止**）的取消率。

```
# Write your MySQL query statement below
SELECT a.Request_at as 'Day', 
    ROUND(SUM(
        CASE WHEN a.Status!='completed' THEN 1
        ELSE 0
        END
    ) / 
    COUNT(
        *
    ), 2) as 'Cancellation Rate'
FROM 
    Trips a 
    JOIN Users b on (a.Client_id=b.users_id AND b.Banned='No')
WHERE a.Request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY a.Request_at
```

## 569

请编写SQL查询来查找每个公司的薪水中位数。挑战点：你是否可以在不使用任何内置的SQL函数的情况下解决此问题。

```
# Write your MySQL query statement below
select
t.Id
,t.Company
,t.Salary
from
(
    select
    *
    ,row_number() over(partition by Company order by Salary) as rk
    ,count(Salary) over(partition by Company) as num
    from Employee
) t
where rk between num/2 and num/2+1
```

## 571

![image-20210225091153161](C:/Users/lipan/AppData/Roaming/Typora/typora-user-images/image-20210225091153161.png)

```
# Write your MySQL query statement below
select
avg(tem.Number) as median
from 
(
    select
    *
    ,sum(Frequency) over(order by `Number` asc) as fre
    ,sum(Frequency) over() as num
    from Numbers
) tem
where tem.fre >= tem.num/2
and tem.fre <= tem.num/2 + tem.Frequency 
```

## 579

![image-20210225105725813](C:/Users/lipan/AppData/Roaming/Typora/typora-user-images/image-20210225105725813.png)

```

```

