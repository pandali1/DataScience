@[TOC](Tableau可视化分析功能一览)

> 本文github项目地址：[链接](https://github.com/pandali1/DataScience/tree/main/Tableau%E5%AD%A6%E4%B9%A0)（数据集等文件）
>
> 本文主要记录了Tableau数据分析入门教程（B站地址：[链接](https://www.bilibili.com/video/BV1E4411B7ef))的课程记录和课后作业

# 使用体会

1. 与Excel相比，Tableau更适合绘制数据透视图
2. 若要制作数据透视表，感觉Excel功能已经够用，而且方便随时发送给别人
3. Tableau中有很多数据类型，有时候想要的图制作不出来，往往是数据类型不对，比如将“维度”转化为“数值”
4. Tableau中拖动字段时，默认会进行聚合运算，当绘制一些线图或者散点图时，需要取消汇总统计，而且汇总统计时，有时候需要指定对应的汇总维度，按照哪个维度进行聚合运算
5. 虽然通过拖拽已经可以绘制大量的图形，但是对于某些图形，还是需要掌握一些计算函数，来生成一些计算字段
6. 有很多图都是通过两幅图合成的，需要积累一些制图技巧

# 豆瓣电影数据分析

## 条形图（各国电影数量）

> 适合表示单维度数据量的相对大小

![各国电影](https://gitee.com/panli1998/mycloudimage/raw/master/img/1.1%E5%90%84%E5%9B%BD%E5%AE%B6%E7%94%B5%E5%BD%B1%E6%95%B0%E9%87%8F%E6%9D%A1%E5%BD%A2%E5%9B%BE.png)

## 直方图（电影评分分布）

> 适合探索数值在不同区间段的分布情况

<img src="https://gitee.com/panli1998/mycloudimage/raw/master/img/1.2%E7%94%B5%E5%BD%B1%E8%AF%84%E5%88%86%E5%88%86%E5%B8%83%E7%9B%B4%E6%96%B9%E5%9B%BE.png" style="zoom:67%;" />

## 折线图（电影数量逐年变化）

> 数据类型：单维度
>
> 显示变化趋势

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/2.1%E7%94%B5%E5%BD%B1%E6%95%B0%E9%87%8F%E9%80%90%E5%B9%B4%E5%8F%98%E5%8C%96%E6%8A%98%E7%BA%BF%E5%9B%BE.png)

## 环形图（不同类型电影比例）

> 数据类型：单维度数值信息
>
> 展示数值的占比信息

<img src="https://gitee.com/panli1998/mycloudimage/raw/master/img/2.2%E7%94%B5%E5%BD%B1%E7%B1%BB%E5%9E%8B%E6%AF%94%E4%BE%8B%E7%8E%AF%E5%BD%A2%E5%9B%BE.png" style="zoom:80%;" />

## 树状图（电影评分与数量）

> 数据类型：多维度
>
> 形象展示数据量大小对比，并可以通过颜色展示其他维度信息

大小表示数量，颜色表示评分

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/3.1%E7%94%B5%E5%BD%B1%E8%AF%84%E5%88%86%E6%A0%91%E7%8A%B6%E5%9B%BE1.png)

## 气泡图（不同类型电影数量）

> 数据类型：单维度
>
> 展示类别数据的数量对比

<img src="https://gitee.com/panli1998/mycloudimage/raw/master/img/3.2%E4%B8%8D%E5%90%8C%E7%B1%BB%E5%9E%8B%E7%94%B5%E5%BD%B1%E6%95%B0%E9%87%8F%E6%B0%94%E6%B3%A1%E5%9B%BE.png" style="zoom:80%;" />

## 标靶图（各国电影数量对比）

> 数据类型：单维度
>
> 通过添加平均值等参考线，方便评价不同数据的表现情况

虚线是人工设置的数量，橙黄色的区间表示各国电影数量的平均值的50%和100%

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/4.1%E5%90%84%E5%9B%BD2012%E5%B9%B4%E7%94%B5%E5%BD%B1%E6%95%B0%E9%87%8F%E6%A0%87%E9%9D%B6%E5%9B%BE.png)

## 地理符号图（各国电影数量与评分）

> 数据类型：多维度
>
> 通过地图直观显示各个国家的数据对比

大小表示电影数量，颜色表示电影评分

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/5.1%E5%90%84%E5%9B%BD%E7%94%B5%E5%BD%B1%E6%95%B0%E9%87%8F%E4%B8%8E%E8%AF%84%E5%88%86%E5%9C%B0%E5%9B%BE%E7%AC%A6%E5%8F%B7%E5%9B%BE.png)

## 面积图（电影数量变化）

> 折线图的另一种表现形式

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/5.2%E7%94%B5%E5%BD%B1%E6%95%B0%E9%87%8F%E5%8F%98%E5%8C%96%E9%9D%A2%E7%A7%AF%E5%9B%BE.png)

## 旋风图（中美各年电影数量对比）

> 数据类型： 多维度
>
> 可以表示两个个体之间在某个维度上，某项统计量的对比情况

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/10.1%E4%B8%AD%E7%BE%8E%E7%94%B5%E5%BD%B1%E6%95%B0%E9%87%8F%E5%AF%B9%E6%AF%94.png)

## 箱线图（不同产地电影评分）

> 直观显示数值信息的分布区间

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/10.3%E4%B8%8D%E5%90%8C%E4%BA%A7%E5%9C%B0%E7%94%B5%E5%BD%B1%E8%AF%84%E5%88%86%E7%AE%B1%E7%BA%BF%E5%9B%BE.png)

## 弧线图（电影强国数量对比）

> 以弧度的形式，展示数量对比

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/12.2%E7%94%B5%E5%BD%B1%E5%BC%BA%E5%9B%BD%E6%95%B0%E9%87%8F%E5%AF%B9%E6%AF%94%E5%BC%A7%E7%BA%BF%E5%9B%BE.png)

## 仪表盘（多图综合）

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/5.3%E8%B1%86%E7%93%A3%E7%94%B5%E5%BD%B1%E6%95%B0%E6%8D%AE%E5%88%86%E6%9E%90.png)

# 超市数据分析

## 瀑布图（拉丁美洲各国超市利润）

> 数据类型：多维度
>
> 同时展示某个维度累计值和当期值的信息

矩形的大小表示各国的利润

颜色表示累计利润是否大于零

数字表示各国的利润值

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/4.2%E6%8B%89%E4%B8%81%E7%BE%8E%E6%B4%B2%E5%90%84%E5%9B%BD%E8%B6%85%E5%B8%82%E5%88%A9%E6%B6%A6%E7%80%91%E5%B8%83%E5%9B%BE.png)

## 凹凸图

> 适合展示多个排名的变化信息

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/13.1%E4%B8%8D%E5%90%8C%E7%B1%BB%E5%88%AB%E8%A3%85%E8%BF%90%E6%88%90%E6%9C%AC%E5%87%B9%E5%87%B8%E5%9B%BE.png)

## 地理填充图（各国利润）

颜色深浅分别表示各国的利润值，负值为蓝色，正值为红色

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/6.1%E5%90%84%E5%9B%BD%E5%88%A9%E6%B6%A6%E5%9B%BE.png)

## 多维度地理信息图

> 数据类型：多维度
>
> 同时展示多个维度的地理位置信息变化情况

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/15.png)

## 分组条形图（各细分市场销售额）

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/8.1%E5%90%84%E7%BB%86%E5%88%86%E5%B8%82%E5%9C%BA%E9%94%80%E5%94%AE%E9%A2%9D.png)

## 分组地理信息图（中国各地区利润图）

**因为西藏省没有销量数据，所以未显示**

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/8.2%E4%B8%AD%E5%9B%BD%E5%90%84%E5%9C%B0%E5%8C%BA%E5%88%A9%E6%B6%A6%E5%9B%BE.png)

## 时间序列预测图

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/14%E6%9C%AA%E6%9D%A5%E9%94%80%E5%94%AE%E9%A2%9D%E9%A2%84%E6%B5%8B.png)

# 其他图

## 多边形图

通过地理位置信息，绘制地理区域

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/7.1%E8%92%99%E4%B8%9C%E5%9C%B0%E7%90%86%E4%BF%A1%E6%81%AF%E5%A4%9A%E8%BE%B9%E5%BD%A2%E5%9B%BE.png)



## 散点图

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/9.1%E6%BB%A1%E6%84%8F%E7%8E%87%E4%B8%8E%E4%BA%BA%E5%B7%A5%E6%9C%8D%E5%8A%A1%E6%8E%A5%E5%90%AC%E9%87%8F%E6%95%A3%E7%82%B9%E5%9B%BE.png)

## 移动平均折线图

通过设置参数可以显示n日移动平均图

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/9.2%E4%BA%BA%E5%B7%A5%E6%9C%8D%E5%8A%A1%E4%B8%A4n%E6%97%A5%E7%A7%BB%E5%8A%A8%E5%B9%B3%E5%9D%87%E5%AF%B9%E6%AF%94%E5%9B%BE.png)

## 漏斗图

> 数据类型：多维度
>
> 适合展示不同阶段之间的数量转化情况

条形大小表示相对数量

左侧百分比表示相对于上一阶段的转化率

右侧百分比表示相对于初始访问量的转化率

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/10.2%E6%88%90%E4%BA%A4%E9%87%8F%E6%BC%8F%E6%96%97%E5%9B%BE.png)

## 范围线图（员工呼入通话时长范围线图）

> 与标靶图类似，通过在折线图上添加参考分布或参考线，判断某个个体的表现情况

折线图表示某个员工的数据

横线表示平均值

灰色柱形表示最大值

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/11.1%E5%91%98%E5%B7%A5%E5%91%BC%E5%85%A5%E9%80%9A%E8%AF%9D%E6%97%B6%E9%95%BF%E8%8C%83%E5%9B%B4%E7%BA%BF%E5%9B%BE.png)



## 斜线图

> 适合表示两个不同变量的排名变化

线条粗细表示变化量的大小

线条方向表示排名上升趋势

颜色表示变化量的正负

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/11.2%E5%90%84%E7%9C%81%E5%B8%82%E7%94%A8%E7%94%B5%E9%87%8F%E5%8F%98%E5%8C%96%E6%83%85%E5%86%B5.png)

## 网络图

> 适合展示人员关系等

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/12.1NBA%E7%90%83%E5%91%98%E5%85%B3%E7%B3%BB%E7%BD%91%E7%BB%9C%E5%9B%BE.png)

## 雷达图

> 展示属性信息

![](https://gitee.com/panli1998/mycloudimage/raw/master/img/13.2%E5%91%98%E5%B7%A5%E5%B1%9E%E6%80%A7%E9%9B%B7%E8%BE%BE%E5%9B%BE.png)