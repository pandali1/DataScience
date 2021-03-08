select
       sum(user_id is null)
       ,sum(auction_id is null)
       ,sum(cat1 is null)
       ,sum(cat_id is null)
       ,sum(trade.property is null)
       ,sum(trade.buy_mount is null)
       ,sum(trade.day is null)
from trade;

select
       count(user_id)
      ,count(distinct user_id)
from trade;

select
buy_num
,count(user_id) as user_num
from
(
    select
    user_id
    ,count(user_id) as buy_num
    from trade
    group by user_id
    )as tem
group by buy_num
order by user_num;

select
       cat1,
       count(distinct cat_id) as 子类数量
from trade
group by cat1
order by 子类数量;

select
       buy_mount 每次购买数量
       ,count(user_id) 消费次数
from trade
group by buy_mount
order by 消费次数;

select max(day),
       min(day)
from trade;



select sum(user_id is null),
       sum(birthday is null),
       sum(gender is null)
from babyinfo;

select count(distinct user_id) -- 有信息的用户数量
from babyinfo;

select gender, -- 不同性别的数量
       count(gender)
from babyinfo
group by gender;

-- ------------数据分析
-- 按天统计每天的销量和每天购买的用户数
select day,
       sum(buy_mount) as 销量,
       count(distinct user_id) as 用户数量
from trade
group by day
order by day;

-- 查询单次购买超过100的记录数
select user_id,day,
       buy_mount
from trade
where buy_mount>100
order by buy_mount desc ;

-- 分析按星期的销量，用户量
select dayname(day) as D,
       sum(buy_num) as 销量,
       sum(user_num) as 活跃用户量
from
    (
        select
            day,
            sum(buy_mount ) as buy_num,
            count(distinct user_id) as user_num
        from trade
        where buy_mount<30
        group by day
        ) as tem
group by D,dayofweek(day)
order by dayofweek(day) ;

-- 分析按月购买的情况
select
       月份,
       max(if(年份 = 2012,buy_num,0)) as 2012年,
       max(if(年份 = 2013,buy_num,0)) as 2013年,
       max(if(年份 = 2014,buy_num,0)) as 2014年,
       max(if(年份 = 2015,buy_num,0)) as 2015年
from
    (
        select
        month(day) as 月份,
        year(day) as 年份,
        sum(buy_mount ) as buy_num,
        count(distinct user_id) as user_num
        from trade
        where buy_mount<30
        group by year(day), month(day)
        ) as tem
group by 月份
order by 月份;




-- 每个大类奶粉的购买情况
select
       cat1 as 类别,
        sum(buy_mount) as 销量,
       count(distinct user_id) as 用户数
from trade
where buy_mount<30
group by cat1
order by cat1;

-- 寻找热销子类（销量前十或用户数量前十）
select
tem1.*,
用户量排名, 用户量
from
         (select cat_id,
                 @j := @j + 1 as 销量排名,
                 销量
          from (select @j := 0) as t,
               (
                   select cat_id,
                          sum(buy_mount) as 销量
                   from trade
                   where buy_mount < 30
                   group by cat_id
                   order by sum(buy_mount) desc) as n
         ) as tem1

join
         (select cat_id,
                 @i := @i + 1 as 用户量排名,
                 用户量
          from (select @i := 0) as t,
               (
                   select cat_id,
                          count(distinct user_id ) as 用户量
                   from trade
                   where buy_mount < 30
                   group by cat_id
                   order by count(distinct user_id ) desc) as m
         ) as tem2
on tem1.cat_id = tem2.cat_id
where 销量排名<10 or 用户量排名<10;

-- 统计不同大类冷门小类（销量和用户数量都小于10）
select
cat1 as 大类,
       count(distinct cat_id) as 冷门小类数量
from
(
    select
    cat1,cat_id
    from trade
    group by cat1,cat_id
    having count(distinct user_id)<10
        or sum(buy_mount)<10
    )as tem
group by cat1
order by 冷门小类数量;


-- 婴儿分析
-- 划分年龄段
select
    b.user_id,
       cat1,
       cat_id,
       buy_mount,
       day as buy_day,
       birthday,
       (
           case
            when datediff(day,birthday)/30<0 then '未出生'
            when datediff(day,birthday)/30<6 then '0-6个月'
            when datediff(day,birthday)/365<1 then '6-12个月'
           when datediff(day,birthday)/365<3 then '1-3岁'
           when datediff(day,birthday)/365<7 then '3-7岁'
           else '大于七岁'
           end
        ) as 年龄分段,
       if((floor((to_days(`t`.`day`) - to_days(`b`.`birthday`)) / 365) < 0), '未出生',
          floor((to_days(`t`.`day`) - to_days(`b`.`birthday`)) / 365)) AS `年龄`,
       (
           case gender
           when 0 then '男'
           when 1 then '女'
           else '不明'
           end
        ) as 性别
from babyinfo b
join trade t
    on b.user_id = t.user_id
where t.buy_mount<30;

-- 创建年龄段信息视图
create view mytest.age_info as
(
    select
    b.user_id,
       cat1,
       cat_id,
       buy_mount,
       day as buy_day,
       birthday,
       (
           case
            when datediff(day,birthday)/30<0 then '未出生'
            when datediff(day,birthday)/30<6 then '0-6个月'
            when datediff(day,birthday)/365<1 then '6-12个月'
           when datediff(day,birthday)/365<3 then '1-3岁'
           when datediff(day,birthday)/365<7 then '3-7岁'
           else '大于七岁'
           end
        ) as 年龄分段,
      if((floor((to_days(`t`.`day`) - to_days(`b`.`birthday`)) / 365) < 0), '未出生',
          floor((to_days(`t`.`day`) - to_days(`b`.`birthday`)) / 365)) AS `年龄`,
       (
           case gender
           when 0 then '男'
           when 1 then '女'
           else '不明'
           end
        ) as 性别
from babyinfo b
join trade t
    on b.user_id = t.user_id
where t.buy_mount<30
    );


-- 每个年龄段的人数和购买量：
select
        年龄分段,
       count(distinct user_id) as 人数,
       sum(buy_mount) as 购买总量
from age_info
group by 年龄分段
order by field(年龄分段,'未出生','0-6个月','6-12个月','1-3岁','3-7岁','大于七岁');

-- 复购查询
create view mytest.multi_info
as
    (
select
       user_id,
       cat_id,
       cat1,
       buy_mount,
       day
from trade
where
      user_id in
(
    select
    user_id
    from trade
    where buy_mount<30
    group by user_id
    having count(auction_id)>1
)
order by  user_id,day);

-- 查询有重复购买行为用户复购的是否是同一小类的奶粉
select
       t.num as 复购产品种类数,
       count(user_id) as 用户数
from
    (select
    user_id,count(distinct cat_id) as num
    from multi_info
    group by user_id) as t
group by t.num;



-- 查询有重复购买行为用户复购的是否是同一大类的奶粉
select
       t.num as 复购产品种类数,
       count(user_id) as 用户数
from
    (select
    user_id,count(distinct cat1) as num
    from multi_info
    group by user_id) as t
group by t.num;

-- 计算复购率
select
a.num1/count(distinct user_id) as 复购率
from
       (select count(distinct user_id) as num1 from multi_info) as a ,
     trade b;

select
cat1,sum(buy_mount)
from trade
where buy_mount<30
and day<=date('20140115')
and day>= date('20140101')
group by cat1;

select
sum(buy_mount)
from trade
where buy_mount<30
and day<=date('20150203')
and day>= date('20150120')
;

([Day]>=DATE('20150120')AND
[Day]<=DATE('20150203'))

select
cat1,sum(buy_mount)
from trade
where buy_mount<30
group by cat1;