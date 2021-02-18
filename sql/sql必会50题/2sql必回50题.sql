-- 1.查询课程编号为“01”的课程比“02”的课程成绩高的所有学生的学号
select
st.*
,s1.c_id
,s1.s_Score
,s2.c_id
,s2.s_Score
from [schema].Score s1
join [schema].Score s2
    on s1.s_id = s2.s_id
join [schema].Student st
    on s1.s_id = st.s_id
where s1.c_id = '01'
    and s2.c_id = '02'
    and s1.s_Score > s2.s_Score
;

-- 2.查询平均成绩大于60分的学生的学号和平均成绩
select
sc.s_id
,avg(sc.s_Score) as 平均成绩
from [schema].Score sc
group by sc.s_id
having avg(sc.s_Score)>60
;

--  3. 查询所有学生的学号、姓名、选课数、总成绩
select
st.s_id
,st.s_name
,count(S.c_id) 选课数量
,sum(case when S.s_Score is null then 0
    else S.s_Score
    end ) 总成绩
from [schema].Student st
left join [schema].Score S on st.s_id = S.s_id
group by st.s_id, st.s_name;



-- 4. 查询姓“猴”的老师的个数
select
count(distinct t_name)
from [schema].Teacher
where t_name like '侯%'
;

-- 5. 查询没学过“张三”老师课的学生的学号、姓名
select
s_id
,s_name
from [schema].Student
where s_id not in
    (
        select
        s_id
        from [schema].Score sc join [schema].Course C
            on sc.c_id = C.c_id
        join [schema].Teacher T
            on C.t_id = T.t_id
        where T.t_name = '张三'
        );

-- 6. 查询学过“张三”老师所教的所有课的同学的学号、姓名
select
s_id
,s_name
from [schema].Student
where s_id in
    (
        select s_id
        from [schema].Score
        where c_id in
            (
                select c_id -- 张三教过的课
                from [schema].Course C
                join [schema].Teacher T on C.t_id = T.t_id
                where T.t_name = '张三'
                )
        group by s_id,c_id
        having count(c_id) =
               (
                   select count(c_id) -- 张三教的课的数量
                    from [schema].Course C
                    join [schema].Teacher T on C.t_id = T.t_id
                    where T.t_name = '张三'
                   )

        );

-- 7. 查询学过编号为“01”的课程并且也学过编号为“02”的课程的学生的学号、姓名
select
s_id
,s_name
from [schema].Student st
where s_id in
    (
        select
        s1.s_id
        from [schema].Score s1
        join [schema].Score s2
        on s1.s_id = s2.s_id
        and s1.c_id = '01'
        and s2.c_id = '02'
        );

-- 8.查询课程编号为“02”的总成绩
select
sum(sc.s_Score)
from [schema].Score sc
where sc.c_id = '02'
;

-- 9.查询所有课程成绩都小于60分的学生的学号、姓名
--A

-- 方法1 最大成绩＜60
select
st.s_id
,st.s_name
from [schema].Student st
join [schema].Score sc
on st.s_id = sc.s_id
group by st.s_id,s_name
having max(sc.s_Score)<60
;
-- 方法二
select
st.s_id
,st.s_name
from [schema].Student st
where s_id in
      (select a.s_id
      from
        (
            select
            s_id,
            count(distinct c_id) as cc -- 统计一个同学学了几门课
            from [schema].Score
            group by s_id
            ) as a
        inner join
        (
            select
            s_id,
            count(distinct c_id) as cc -- 统计一个同学不及格的门数
            from [schema].Score
            where s_Score <60
            group by s_id
            ) as sc
        on a.s_id = sc.s_id

        where a.cc = sc.cc
);

-- 10. 查询没有学全所有课的学生的学号、姓名
select
st.s_id
,st.s_name
from [schema].Student st
left join [schema].Score sc
    on st.s_id = sc.s_id
group by st.s_id, st.s_name
having count(sc.c_id) -- 已学课程的门数
        != (select count(distinct c_id)-- 全部课程的门数
            from [schema].Course
            )

-- 11. 查询至少有一门课与学号为“01”的学生所学课程相同的学生的学号和姓名
select
distinct
st.s_id
,st.s_name
from [schema].Student st
join [schema].Score S on st.s_id = S.s_id
where  S.c_id in (
    select
    distinct sc.c_id -- 01学习的所有课程
    from
    [schema].Score sc
    where sc.s_id = '01'
    )
and st.s_id != '01'

-- 12.查询和“01”号同学所学课程完全相同的其他同学的学号
select
s_id
from [schema].Score
where c_id in
    (
        select
        c_id
        from [schema].Score -- 01上的课的种类
        where s_id = '01'
        )
    and s_id != '01'-- 排除自身
group by s_id
having count(c_id) =
       (
           select
           count(distinct c_id) -- 01上了几门课
           from [schema].Score
           where s_id = '01'
           );

-- 13. 查询没学过"张三"老师讲授的任一门课程的学生姓名

select
s_id
,s_name
from [schema].Student
where s_id not in
    (
        select
        distinct s_id    -- 上过张三老师任何一门课的学生
        from [schema].Score
        where c_id in (
            select
            c_id
            from [schema].Course join [schema].Teacher T on Course.t_id = T.t_id
            where T.t_name = '张三'
            )
        );


-- 15. 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select
sc.s_id
,S.s_name
,avg(sc.s_Score)
from
[schema].Score sc join [schema].Student S on sc.s_id = S.s_id
where sc.s_id in
    (
    select
    s_id
    from [schema].Score
    where s_Score <60
    group by s_id
    having count(distinct c_id)>=2
        )
group by S.s_name, sc.s_id;

-- 16. 检索"01"课程分数小于60，按分数降序排列的学生信息
-- 当select中 使用distinct时，order by 的字段必须出现在select中的字段中
select
st.*
from [schema].Student st
join [schema].Score S on st.s_id = S.s_id
where S.c_id = '01'
    and S.s_Score <60
order by S.s_Score desc ;

-- 17. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
select
a.s_id
,a.c_id
,a.s_Score
,a.avg_s_Score
from
     (
        select
        S.*
        ,avg(S.s_Score) over ( partition by st.s_id ) as avg_s_Score
        from
        [schema].Student st
        left join [schema].Score S on st.s_id = S.s_id
         ) a
order by a.avg_s_Score desc;


-- 使用case长表转宽表
select s_id "学号",
max(case when c_id='01' then s_score else null end) "语文",
max(case when c_id='02' then s_score else null end) "数学",
max(case when c_id='03' then s_score else null end) "英语",
avg(s_score) "平均成绩"
from [schema].Score group by s_id order by "平均成绩" desc;

-- 使用pivot长表转宽表（SQLserver）
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/from-using-pivot-and-unpivot?view=sql-server-ver15

 select
 s_id,[01] as '语文',[02] as '数学',[03] as '英语'
 from [schema].Score as s
 pivot
 (
    sum(s_Score)
   for c_id in ([01],[02],[03])
 )
 as pvt;

-- 18. 查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
select
sc.c_id
,C.c_name
,max(s_Score) as 最高分
,min(s_Score) as 最低分
,avg(s_Score) as 平均分
,sum(case when sc.s_score >= 60 then 1.0 else 0 END)/count(sc.s_id) "及格",
sum(case when sc.s_score >= 70 and sc.s_score <=80 then 1.0 else 0 END)/count(sc.s_id) "中等",
sum(case when sc.s_score >= 80 and sc.s_score <=90 then 1.0 else 0 END)/count(sc.s_id) "优良",
sum(case when sc.s_score >= 90 then 1.0 else 0 END)/count(sc.s_id) "优秀"
from [schema].Score sc
join [schema].Course C on sc.c_id = C.c_id
group  by sc.c_id, C.c_name;

-- 19. 按各科成绩进行排序，并显示排名

select
c_id,s_id,s_Score
,dense_rank() over (partition by c_id order by s_Score desc) as 排名
from [schema].Score
order by c_id,排名

-- 20. 查询学生的总成绩并进行排名
select
s_id
,sum(s_Score) 总成绩
from [schema].Score
group by s_id
order by 总成绩 desc

-- 21. 查询不同老师所教不同课程平均分从高到低显示
select
C.t_id
,C.c_id
,avg(sc.s_Score) as 平均分
from [schema].Score sc
join [schema].Course C on sc.c_id = C.c_id
group by C.t_id,C.c_id
order by 平均分 desc;

-- 22. 查询所有课程的成绩第2名到第3名的学生信息及该课程成绩
select
a.c_id
,st.*
,a.s_Score
from
    (
        select
        sc.*
        ,row_number() over (partition by c_id order by s_Score desc) as rk
        from
        [schema].Score sc
        ) as a
join [schema].Student  st on a.s_id = st.s_id
where a.rk = 2 or a.rk = 3
order by a.c_id

-- 23.使用分段[100-85],[85-70],[70-60],[<60]来统计各科成绩，分别统计各分数段人数：课程ID和课程名称
-- 重要
select
c_id,c_name
,[85-100],[70-85],[60-70],[<60]
from (
    select
    C.c_id
    ,C.c_name
    ,S.s_Score
    ,(case  when S.s_Score >=85 then '85-100' -- 新造一行来记录每条记录所在的分数段
        when S.s_Score >=70 then '70-85'
        when S.s_Score >=60 then '60-70'
        else '<60'
        end)
        as 分数段
    from [schema].Course C
    join [schema].Score S on C.c_id = S.c_id
    )as t
pivot (-- 使用pivot来将长表变成宽表
    count(s_Score)
    for 分数段 in ([85-100],[70-85],[60-70],[<60])
    )
as pvt;

-- 25. 查询各科成绩前三名的记录（不考虑成绩并列情况）

select
a.c_id,a.s_id,a.s_Score
from
(
    select
    *,
    row_number() over (partition by c_id order by s_Score desc) as rk
    from [schema].Score
    ) as a
where a.rk in (1,2,3)
order by a.c_id,a.rk;

-- 26. 查询每门课程被选修的学生数
select
C.c_id
,C.c_name
,count(S.s_id) as 人数
from
[schema].Course C
join [schema].Score S
    on C.c_id = S.c_id
group by C.c_id,C.c_name
order by C.c_id;

-- 27. 查询出只上两门课程的全部学生的学号和姓名
select
st.s_id
,st.s_name
,count(distinct c_id) 选课门数
from [schema].Student st
join [schema].Score S on st.s_id = S.s_id
group by st.s_id,st.s_name
having count(distinct c_id) = 2

-- 查询男生、女生人数
select
sum(case s_sex when '男' then 1 else 0 end) as 男生人数,
sum(case s_sex when '女' then 1 else 0 end) as 男生人数
from [schema].Student;

select
s_sex
,count(s_id)
from [schema].Student
group by s_sex;

--29. 查询名字中含有"风"字的学生信息
select
*
from [schema].Student
where s_name like '%风%';

-- 31. 查询1990年出生的学生名单
select
*
from [schema].Student
where year(s_birth) = 1990;

-- 32. 查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩
select
st.s_id
,st.s_name
,avg(s_Score) as 成绩
from [schema].Student st
join [schema].Score S on st.s_id = S.s_id
group by st.s_id, st.s_name
having avg(s_Score)>=85;

-- 33. 查询每门课程的平均成绩，结果按平均成绩升序排序，平均成绩相同时，按课程号降序排列
select
sc.c_id
,C.c_name
,avg(s_Score) as 平均成绩
from
[schema].Score sc
join [schema].Course C on sc.c_id = C.c_id
group by sc.c_id,C.c_name
order by 平均成绩 asc,sc.c_id desc;

-- 34.查询课程名称为"数学"，且分数低于60的学生姓名和分数
select
st.s_name
,S.s_Score
from [schema].Student st
join [schema].Score S on st.s_id = S.s_id
join [schema].Course C on S.c_id = C.c_id
where C.c_name = '数学'
and S.s_Score <60;

-- 35. 查询所有学生的课程及分数情况
select
s_id
,s_name,
[数学],[语文],[英语]
from (
     select
     st.s_id
     ,st.s_name
     ,S.s_Score
     ,C.c_name
     from [schema].Student st
     join [schema].Score S on st.s_id = S.s_id
     join [schema].Course C on S.c_id = C.c_id
         ) t
pivot (
    sum(s_Score)
    for c_name in ([数学],[语文],[英语])
    )
as pvt;

-- 36. 查询任何一门课程成绩在70分以上的姓名、课程名称和分数
select
st.s_name
,C.c_name
,S.s_Score
from [schema].Student st
join [schema].Score S on st.s_id = S.s_id
join [schema].Course C on S.c_id = C.c_id
where S.s_Score > 70
order by st.s_id,S.s_Score desc;

-- 37. 查询不及格的课程并按课程号从大到小排列
select
st.s_name
,C.c_name
,S.s_Score
from [schema].Student st
join [schema].Score S on st.s_id = S.s_id
join [schema].Course C on S.c_id = C.c_id
where S.s_Score < 60
order by S.c_id,S.s_Score desc;

-- 38. 查询课程编号为03且课程成绩在80分以上的学生的学号和姓名
select
st.s_id
,st.s_name
,C.c_name
,S.s_Score
from [schema].Student st
join [schema].Score S on st.s_id = S.s_id
join [schema].Course C on S.c_id = C.c_id
where S.s_Score > 60 and S.c_id = '03'
order by S.s_id,S.s_Score desc;

-- 39. 求每门课程的学生人数
select
c_name
,count(distinct s_id)
from [schema].Course C
left join [schema].Score S on C.c_id = S.c_id
group by C.c_id,C.c_name

-- 40. 查询选修“张三”老师所授课程的学生中成绩最高的学生姓名及其成绩
select
s_id
,s_name
,s_Score
from
    (
        select
        st.s_id
        ,s_name
        ,s_Score
        ,row_number() over (order by S.s_Score desc) as rk
        from [schema].Student st
        join [schema].Score S on st.s_id = S.s_id
        join [schema].Course C on S.c_id = C.c_id
        join [schema].Teacher T on C.t_id = T.t_id
        where t_name = '张三'
        ) a
where rk = 1;

-- 41. 查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩
select
* from
[schema].Score
where s_id in
    (select
    s_id
    from [schema].Score sc
    group by s_id
    having count(c_id) >1
    and max(s_Score) = min(s_Score)
        );

-- 42. 查询每门功成绩最好的前两名
select
a.c_id,a.s_id,a.s_Score
from
(
    select
    *,
    row_number() over (partition by c_id order by s_Score desc) as rk
    from [schema].Score
    ) as a
where a.rk in (1,2)
order by a.c_id,a.rk;

-- 43. 统计每门课程的学生选修人数（超过5人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
select
c_id
,count(distinct s_id) as 人数
from [schema].Score
group by c_id
having count(distinct s_id)>5
order by 人数,c_id;

-- 44. 检索至少选修两门课程的学生学号
select
s_id,count(distinct c_id)
from [schema].Score
group by s_id
having count(distinct c_id) >=2;

-- 45. 查询选修了全部课程的学生信息
select *
from [schema].Student
where s_id in
(
    select
    Score.s_id
    from [schema].Score
    group by Score.s_id
    having count(distinct c_id) =
           (
               select count(distinct c_id)
               from [schema].Score
               )
    )

-- 46. 查询各学生的年龄
-- getutcdate回去当前计算机的日期
-- datediff返回时间差，第一个参数是返回日期的单位
select
*
,floor(datediff(day,s_birth,GETUTCDATE ( ))/365) as 年龄
from [schema].Student;

-- 47. 查询没学过“张三”老师讲授的任一门课程的学生姓名
select
s_name
from [schema].Student
where s_id not in
    (
        select
        distinct s_id
        from [schema].Score sc
        join [schema].Course C on sc.c_id = C.c_id
        join [schema].Teacher T on C.t_id = T.t_id
        where t_name = '张三'
        );

-- 48. 查询下周过生日的学生
-- 重要
-- 使用日期偏移
select *
from
[schema].Student
where datediff(day,concat('2021-',SUBSTRING(s_birth,6,5)),dateadd(day,15-datepart(weekday,getdate()) ,getdate())) between 0 and 7

-- 使用datepart
select *
from
[schema].Student
where datepart(week,concat('2021-',SUBSTRING(s_birth,6,5))) = datepart(week,getdate()) +1

-- 49. 查询本月过生日的人
select
*
from
[schema].Student
where month(s_birth) = month(getdate());

-- 50. 查询下月过生日的人
select
*
from
[schema].Student
where month(s_birth) = month( dateadd(month,1,getdate()) );