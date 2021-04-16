> 案例文件与代码下载地址:[DataScience](https://github.com/pandali1/DataScience/tree/main/%E6%95%B0%E6%8D%AE%E5%88%86%E6%9E%90%E9%A1%B9%E7%9B%AE/%E9%98%BF%E9%87%8C%E5%B7%B4%E5%B7%B4AB%E6%B5%8B%E8%AF%95)

目标：以支付宝某次营销活动的数据为例，通过分析广告点击率，比较两组营销策略的广告投放效果

# 数据准备


```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
```

## 数据描述

- dmp_id：营销策略编号（源数据文档未作说明，这里根据数据情况设定为1：对照组，2：营销策略一，3：营销策略二）
- user_id：支付宝用户ID 
- label：用户当天是否点击活动广告（0：未点击，1：点击）


```python
data = pd.read_csv('data/effect_tb.csv')
data.columns = ["dt","user_id","label","dmp_id"]
data.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
    
    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>dt</th>
      <th>user_id</th>
      <th>label</th>
      <th>dmp_id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>1000004</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>1000004</td>
      <td>0</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>1000006</td>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1</td>
      <td>1000006</td>
      <td>0</td>
      <td>3</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1</td>
      <td>1000007</td>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




```python
data.drop(['dt'],axis=1,inplace=True)
data.shape
```




    (2645957, 3)



## 删除重复行   
重复的多条数据，会影响最终的计算比例，对结果造成干扰


```python
data.drop_duplicates(inplace=True)
data.shape
```




    (2632974, 3)



## 查看是否有缺失值


```python
data.isnull().sum()
```




    user_id    0
    label      0
    dmp_id     0
    dtype: int64



## 处理重复用户  
可能存在一个用户多次点击的情况，这种情况下，多次点击的用户的用户群体的权重就会增大，导致结果出现误差。 


```python
(data.user_id.value_counts() > 1).sum()
```




    201265




```python
data = data.drop_duplicates(subset=['user_id'])
```

## 确定样本量

计算对照组的广告点击率


```python
data[data.dmp_id == 1].label.mean()
```




    0.012551019015964006

计算样本量：[网页链接](https://www.evanmiller.org/ab-testing/sample-size.html)

输入：

1. 对照组的效果
2. 期望提升的效果
3. 置信度α和β



不同营销组的样本量


```python
data.dmp_id.value_counts()
```




    1    1905662
    2     411107
    3     316205
    Name: dmp_id, dtype: int64

可以看到样本量均符合要求

# 方法1：假设检验

## 不同策略的广告点击率


```python
data.groupby(['dmp_id'])['label'].mean().plot(kind='bar')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x1bfbfee9280>




![output_21_1](https://gitee.com/panli1998/mycloudimage/raw/master/output_21_1.png)

## 假设检验

> 当样本量>30时，均可认为样本为大样本，使用Z检验
>
> $H0:p_{对照组}\ge p_{实验组}$
>
> $H1:p_{对照组}\lt p_{实验组}$(我们想证明的结论)


```python
# 对照组样本数量
n_control = data[data.dmp_id==1].shape[0]
# 营销活动二的样本数量
n_test = data[data.dmp_id==3].shape[0]


c_control = data[(data.dmp_id==1) & (data.label==1)].shape[0]

c_test = data[(data.dmp_id==3) & (data.label==1)].shape[0]

# 对照组的广告点击率
r_control = c_control/n_control
# 营销活动二样本数量
r_test = c_test/n_test
```


```python
from statsmodels.stats.proportion import proportions_ztest

z_score,p = proportions_ztest([c_control,c_test],[n_control,n_test])

print("检验统计量z：",z_score,"，p值：", p)
```

    检验统计量z： -59.44164223047762 ，p值： 0.0

## 结论

**计算得到P值为0.0<0.05，因此否定原假设，认为备择假设成立，营销活动对广告点击率有明显的提升。**

# 方法二：蒙特卡洛法

> 通过假设对照组和实验组之间的广告点击率不存在差异，按照样本数量进行多次抽样模拟，从而得到一个新的样本，然后计算实验组和对照组的指标差，得到一个指标差的分布。
>
> 通过判断原始样本中实验组和对照组的指标差，在生成样本之间的罕见比例，从而可以判断A/B测试的结果是否显著。


```python
# 假设所有策略的点击率一样
p_all = data.label.mean() 
```


```python
p_all
```




    0.014620729259005216



### 模拟抽样


```python
diff = []

for i in range(1000):
    p_new_diff = np.random.choice(2,size = n_test,p=[1-p_all,p_all]).mean()
    p_old_diff = np.random.choice(2,size = n_control,p=[1-p_all,p_all]).mean()
    diff.append(p_old_diff - p_new_diff)
```


```python
diffs = np.array(diff)
plt.hist(diffs)
plt.axvline(r_control-r_test)
```




    <matplotlib.lines.Line2D at 0x1bfc798b250>




![output_30_1](https://gitee.com/panli1998/mycloudimage/raw/master/output_30_1.png)



```python
(diffs < r_control-r_test).mean()
```




    0.0

## 结果

**如上图所示，柱状图部分是蒙特卡洛方法模拟出来的$(p_{对照组}-p_{实验组})$的分布情况，左边的线表示了实际测验时的$(p_{对照组}-p_{实验组})$，可以看到只有0%的样本落在了垂线的左边，因此可以认为实验结果显著**

# A/B测试的其他知识

## A/B测试流程

一个完整的A/B test主要包括如下几部分：

1、分析现状，建立假设：分析业务，确定最高优先级的改进点，作出假设，提出优化建议。

2、设定指标：设置主要指标来衡量版本的优劣；设置辅助指标来评估其他影响。

3、设计与开发：设计优化版本的原型并完成开发。

4、确定测试时长：确定测试进行的时长。

5、确定分流方案：确定每个测试版本的分流比例及其他分流细节。

6、采集并分析数据：收集实验数据，进行有效性和效果判断。

7、给出结论：①确定发布新版本；②调整分流比例继续测试；③优化迭代方案重新开发，回到步骤1。



## A/B注意点

注意点：
1. 测试时长：测试的时长不宜过短，否则参与试验的用户几乎都是产品的高频用户。
2. 分流（或者说抽样）：应该保证同时性、同质性、唯一性、均匀性。

- 同时性：分流应该是同时的，测试的进行也应该是同时的。

- 同质性：也可以说是相似性，是要求分出的用户群，在各维度的特征都相似。可以基于用户的设备特征（例如手机机型、操作系统版本号、手机语言等）和用户的其他标签（例如性别、年龄、新老用户、会员等级等）进行分群，每一个A/B测试试验都可以选定特定的用户群进行试验。
  - 判断同质性的方法：
    - AAB测试，对两组对照组的结果进行方差检验，判断结果是否存在差异
- 唯一性：即要求用户不被重复计入测试。

- 均匀性：要求各组流量是均匀的。


> 参考资料：
>
> [**Analyse ab testing results**](https://www.heywhale.com/mw/project/5b98bf650cfcbf001030dc6a)
>
> [一文入门A/B测试（含流程、原理及示例） - 寐语的文章 - 知乎 ](https://zhuanlan.zhihu.com/p/68019926)

