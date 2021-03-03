> 本文参考和鲸社区数据分析项目：[大型家用电器和电子产品在线商店购买数据分析](https://www.kesci.com/mw/project/5fb9107915a3c3003060af6c)  
> 本文github地址：[DataSicence](https://github.com/pandali1/DataScience)  
> seaborn绘图包需要时最新版本


```python
import pandas as pd 
import numpy as np 
import matplotlib.pyplot as plt
import seaborn as sns 
```

# 数据读取
- event_time -购买时间  
- event_type -行为类别  
- product_id -产品编号  
- category_id -产品的类别ID  
- category_code -产品的类别分类法（代码名称）  
- brand -品牌名称  
- price -产品价格  
- user_id -用户ID 


```python
df = pd.read_csv('D:\Code\Github\data\kz.csv',sep=',')
df.head()
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
      <th>event_time</th>
      <th>order_id</th>
      <th>product_id</th>
      <th>category_id</th>
      <th>category_code</th>
      <th>brand</th>
      <th>price</th>
      <th>user_id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2020-04-24 11:50:39 UTC</td>
      <td>2294359932054536986</td>
      <td>1515966223509089906</td>
      <td>2.268105e+18</td>
      <td>electronics.tablet</td>
      <td>samsung</td>
      <td>162.01</td>
      <td>1.515916e+18</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2020-04-24 11:50:39 UTC</td>
      <td>2294359932054536986</td>
      <td>1515966223509089906</td>
      <td>2.268105e+18</td>
      <td>electronics.tablet</td>
      <td>samsung</td>
      <td>162.01</td>
      <td>1.515916e+18</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2020-04-24 14:37:43 UTC</td>
      <td>2294444024058086220</td>
      <td>2273948319057183658</td>
      <td>2.268105e+18</td>
      <td>electronics.audio.headphone</td>
      <td>huawei</td>
      <td>77.52</td>
      <td>1.515916e+18</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2020-04-24 14:37:43 UTC</td>
      <td>2294444024058086220</td>
      <td>2273948319057183658</td>
      <td>2.268105e+18</td>
      <td>electronics.audio.headphone</td>
      <td>huawei</td>
      <td>77.52</td>
      <td>1.515916e+18</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2020-04-24 19:16:21 UTC</td>
      <td>2294584263154074236</td>
      <td>2273948316817424439</td>
      <td>2.268105e+18</td>
      <td>NaN</td>
      <td>karcher</td>
      <td>217.57</td>
      <td>1.515916e+18</td>
    </tr>
  </tbody>
</table>
</div>




```python
df.shape
```




    (2633521, 8)



## 查看数据缺失情况


```python
df.isnull().sum()
```




    event_time             0
    order_id               0
    product_id             0
    category_id       431954
    category_code     612202
    brand             506005
    price             431954
    user_id          2069352
    dtype: int64



为处理快捷，删除有所有缺失值的行


```python
df = df.dropna()
df.shape
```




    (420718, 8)



## 查看数据类型


```python
df.info()
```

    <class 'pandas.core.frame.DataFrame'>
    Int64Index: 420718 entries, 0 to 2633520
    Data columns (total 8 columns):
     #   Column         Non-Null Count   Dtype  
    ---  ------         --------------   -----  
     0   event_time     420718 non-null  object 
     1   order_id       420718 non-null  int64  
     2   product_id     420718 non-null  int64  
     3   category_id    420718 non-null  float64
     4   category_code  420718 non-null  object 
     5   brand          420718 non-null  object 
     6   price          420718 non-null  float64
     7   user_id        420718 non-null  float64
    dtypes: float64(3), int64(2), object(3)
    memory usage: 28.9+ MB



```python
# 将时间列更改为时间类型
df['event_time'] = pd.to_datetime(df.event_time)
print(df.event_time.max(),df.event_time.min())
```

    2020-11-21 10:10:30+00:00 1970-01-01 00:33:40+00:00



```python
# 提取日期中的月份
df['month'] = df.event_time.dt.month
```

# 用户消费趋势分析


```python
df_month = df.loc[df.event_time.dt.year == 2020].groupby(['month'])
```

## 每月消费总金额


```python
df_month_sum = df_month.sum().reset_index().rename(columns = {'price':'销售额','month':'月份'})
```


```python
plt.rcParams['font.sans-serif']=['SimSun'] # 用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False # 用来正常显示负号
%matplotlib inline
plt.style.use("ggplot")
#plt.figure(figsize = (15,8))
sns.relplot(x='月份',y = '销售额',data= df_month_sum,kind='line',height=4,aspect=15/8)
plt.title('每月消费总金额')
```




    Text(0.5, 1.0, '每月消费总金额')




![png](https://gitee.com/panli1998/mycloudimage/raw/master/output_17_1.png)


## 每月消费人数


```python
df_month_count = df_month.count().reset_index().rename(columns = {'price':'活跃人数','month':'月份'})
```


```python
plt.rcParams['font.sans-serif']=['SimSun'] # 用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False # 用来正常显示负号
%matplotlib inline
plt.style.use("ggplot")

sns.relplot(x='月份',y = '活跃人数',data= df_month_count,kind='line',height=4,aspect=15/8)
plt.title('每月消费人数')
```




    Text(0.5, 1.0, '每月消费人数')




![png](https://gitee.com/panli1998/mycloudimage/raw/master/output_20_1.png)


两者对比


```python
df_month = df.groupby(['month'])['price'].agg(['sum','count']).reset_index().rename(columns = {'sum':'销售额','month':'月份','count':'活跃人数'})
df_month
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
      <th>月份</th>
      <th>销售额</th>
      <th>活跃人数</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>1.670965e+06</td>
      <td>9982</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>1.928107e+06</td>
      <td>11566</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>2.532487e+06</td>
      <td>12461</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>1.550330e+06</td>
      <td>8807</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>7.180919e+06</td>
      <td>30826</td>
    </tr>
    <tr>
      <th>5</th>
      <td>6</td>
      <td>6.834606e+06</td>
      <td>29750</td>
    </tr>
    <tr>
      <th>6</th>
      <td>7</td>
      <td>1.511283e+07</td>
      <td>61037</td>
    </tr>
    <tr>
      <th>7</th>
      <td>8</td>
      <td>2.601872e+07</td>
      <td>82198</td>
    </tr>
    <tr>
      <th>8</th>
      <td>9</td>
      <td>1.571325e+07</td>
      <td>53591</td>
    </tr>
    <tr>
      <th>9</th>
      <td>10</td>
      <td>1.763243e+07</td>
      <td>74107</td>
    </tr>
    <tr>
      <th>10</th>
      <td>11</td>
      <td>1.075389e+07</td>
      <td>46393</td>
    </tr>
  </tbody>
</table>
</div>




```python
# 将表格进行转换
df_month_melt = df_month.melt(id_vars=['月份'],value_vars=['销售额','活跃人数'],var_name='cal',value_name='value')
```


```python
sns.relplot(data=df_month_melt,x = '月份',y = 'value',col = 'cal',col_wrap=1,height=4,aspect=15/8,kind='line',facet_kws = {'sharey':False})
```




    <seaborn.axisgrid.FacetGrid at 0x21e94bd46d0>




![png](https://gitee.com/panli1998/mycloudimage/raw/master/output_24_1.png)


- 7-10月是消费高峰时节，其他月份的消费额和活跃人数相对比较少 

# 品牌消费情况

## 品牌销售额


```python
df_grand = df.loc[df.event_time.dt.year == 2020].groupby('brand')['price'].agg(['sum']).reset_index().sort_values('sum',ascending = False).rename(
    columns = {'brand':'品牌','sum':'销售额'})
df_grand
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
      <th>品牌</th>
      <th>销售额</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>443</th>
      <td>samsung</td>
      <td>2.872334e+07</td>
    </tr>
    <tr>
      <th>31</th>
      <td>apple</td>
      <td>2.590539e+07</td>
    </tr>
    <tr>
      <th>300</th>
      <td>lg</td>
      <td>7.726328e+06</td>
    </tr>
    <tr>
      <th>43</th>
      <td>asus</td>
      <td>5.072569e+06</td>
    </tr>
    <tr>
      <th>299</th>
      <td>lenovo</td>
      <td>4.565506e+06</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>47</th>
      <td>att</td>
      <td>9.200000e-01</td>
    </tr>
    <tr>
      <th>163</th>
      <td>elfe</td>
      <td>8.800000e-01</td>
    </tr>
    <tr>
      <th>547</th>
      <td>wurth</td>
      <td>6.700000e-01</td>
    </tr>
    <tr>
      <th>102</th>
      <td>celebrat</td>
      <td>2.300000e-01</td>
    </tr>
    <tr>
      <th>390</th>
      <td>pedigree</td>
      <td>2.300000e-01</td>
    </tr>
  </tbody>
</table>
<p>570 rows × 2 columns</p>
</div>




```python
sns.barplot(x = '销售额',y='品牌',data=df_grand.iloc[:15,:])
```




    <matplotlib.axes._subplots.AxesSubplot at 0x21e9445f2b0>




![png](https://gitee.com/panli1998/mycloudimage/raw/master/output_29_1.png)


- 三星、苹果、LG的销售额最高 

## 品牌用户数量


```python
df_grand = df.loc[df.event_time.dt.year == 2020].groupby('brand')['user_id'].agg(pd.Series.nunique).reset_index().sort_values('user_id',ascending = False).rename(
    columns = {'brand':'品牌','user_id':'用户数量'})
df_grand
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
      <th>品牌</th>
      <th>用户数量</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>443</th>
      <td>samsung</td>
      <td>34602.0</td>
    </tr>
    <tr>
      <th>31</th>
      <td>apple</td>
      <td>18441.0</td>
    </tr>
    <tr>
      <th>50</th>
      <td>ava</td>
      <td>10095.0</td>
    </tr>
    <tr>
      <th>300</th>
      <td>lg</td>
      <td>8243.0</td>
    </tr>
    <tr>
      <th>554</th>
      <td>xiaomi</td>
      <td>7627.0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>227</th>
      <td>highwaybaby</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>226</th>
      <td>herschel</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>445</th>
      <td>sandisk</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>320</th>
      <td>matrix</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>80</th>
      <td>blackvue</td>
      <td>1.0</td>
    </tr>
  </tbody>
</table>
<p>570 rows × 2 columns</p>
</div>




```python
g = sns.barplot(x = '用户数量',y='品牌',data=df_grand.iloc[:15,:])
```


![png](https://gitee.com/panli1998/mycloudimage/raw/master/output_33_0.png)


## 每个品牌人均销售额


```python
df_grand = df.loc[df.event_time.dt.year == 2020].groupby('brand')['price','user_id'].agg({'price':'sum','user_id':pd.Series.nunique}).reset_index()
df_grand.head()
```

    <ipython-input-26-02fbe5db5420>:1: FutureWarning: Indexing with multiple keys (implicitly converted to a tuple of keys) will be deprecated, use a list instead.
      df_grand = df.loc[df.event_time.dt.year == 2020].groupby('brand')['price','user_id'].agg({'price':'sum','user_id':pd.Series.nunique}).reset_index()





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
      <th>brand</th>
      <th>price</th>
      <th>user_id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>acana</td>
      <td>175.21</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>adguard</td>
      <td>2.75</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>aeg</td>
      <td>50246.59</td>
      <td>38.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>aerocool</td>
      <td>81000.46</td>
      <td>519.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>agu</td>
      <td>99.54</td>
      <td>2.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
df_grand['人均销售额'] = df_grand.price/df_grand.user_id
sns.barplot(x = '人均销售额',y='brand',data=df_grand.sort_values('人均销售额',ascending = False).iloc[:30,:])
```




    <matplotlib.axes._subplots.AxesSubplot at 0x21e949fd4c0>




![png](https://gitee.com/panli1998/mycloudimage/raw/master/output_36_1.png)


# 用户个体销售

## 用户消费次数、消费金额散点图  


```python
data = df.groupby('user_id')['order_id','price'].agg({'order_id':'count','price':'sum'}).rename(columns = {'order_id':'消费次数','price':'消费金额'})
data
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
      <th>消费次数</th>
      <th>消费金额</th>
    </tr>
    <tr>
      <th>user_id</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1.515916e+18</th>
      <td>1</td>
      <td>416.64</td>
    </tr>
    <tr>
      <th>1.515916e+18</th>
      <td>2</td>
      <td>56.43</td>
    </tr>
    <tr>
      <th>1.515916e+18</th>
      <td>12</td>
      <td>5984.92</td>
    </tr>
    <tr>
      <th>1.515916e+18</th>
      <td>7</td>
      <td>3785.72</td>
    </tr>
    <tr>
      <th>1.515916e+18</th>
      <td>2</td>
      <td>182.83</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>1.515916e+18</th>
      <td>1</td>
      <td>208.31</td>
    </tr>
    <tr>
      <th>1.515916e+18</th>
      <td>1</td>
      <td>3472.20</td>
    </tr>
    <tr>
      <th>1.515916e+18</th>
      <td>2</td>
      <td>277.74</td>
    </tr>
    <tr>
      <th>1.515916e+18</th>
      <td>1</td>
      <td>925.67</td>
    </tr>
    <tr>
      <th>1.515916e+18</th>
      <td>1</td>
      <td>418.96</td>
    </tr>
  </tbody>
</table>
<p>90800 rows × 2 columns</p>
</div>




```python
sns.scatterplot(x = '消费次数',y = '消费金额',data = data)
plt.title('用户消费次数与消费金额之间的关系') 
```




    Text(0.5, 1.0, '用户消费次数与消费金额之间的关系')








```python

sns.displot(data=data.query('消费金额<10000'),x = '消费金额')
```




    <seaborn.axisgrid.FacetGrid at 0x192e63e9c10>



<img src="https://gitee.com/panli1998/mycloudimage/raw/master/output_41_1.svg" alt="svg"  />



```python
sns.displot(data=data.query('消费次数<50'),x = '消费次数',kind='hist',bins = 20)
```




    <seaborn.axisgrid.FacetGrid at 0x192e6ecc370>



<img src="https://gitee.com/panli1998/mycloudimage/raw/master/output_42_1.svg" alt="svg"  />



```python
data_cum = data.sort_values('消费金额')['消费金额'].cumsum()/data['消费金额'].sum()
data_cum.reset_index()['消费金额'].plot()
```




    <matplotlib.axes._subplots.AxesSubplot at 0x192f8331460>



<img src="https://gitee.com/panli1998/mycloudimage/raw/master/output_43_1.svg" alt="svg"  />


- 可以看到消费金额最低50%用户只贡献了10%左右的销售额，超过一半的销售额，都来自不到10%的用户，可见用户之间的购买力相差比较大

# 用户消费行为

## 新增人数记录


```python
df.loc[df.event_time.dt.year == 2020].groupby('user_id')['event_time'].min().value_counts().plot()
```




    <matplotlib.axes._subplots.AxesSubplot at 0x1928877a520>



<img src="https://gitee.com/panli1998/mycloudimage/raw/master/output_47_1.svg" alt="svg"  />



```python
data = df.loc[df.event_time.dt.year == 2020].groupby('user_id')['event_time'].min().value_counts().reset_index()
data = data.groupby(data['index'].dt.month)['event_time'].sum().reset_index().rename(columns = {'index':'月份','event_time':'新增人数'})
data 
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
      <th>月份</th>
      <th>新增人数</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>1431</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>1390</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>1393</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>3776</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>13046</td>
    </tr>
    <tr>
      <th>5</th>
      <td>6</td>
      <td>8427</td>
    </tr>
    <tr>
      <th>6</th>
      <td>7</td>
      <td>21540</td>
    </tr>
    <tr>
      <th>7</th>
      <td>8</td>
      <td>22496</td>
    </tr>
    <tr>
      <th>8</th>
      <td>9</td>
      <td>8552</td>
    </tr>
    <tr>
      <th>9</th>
      <td>10</td>
      <td>5771</td>
    </tr>
    <tr>
      <th>10</th>
      <td>11</td>
      <td>2959</td>
    </tr>
  </tbody>
</table>
</div>




```python
sns.barplot(data = data,x = '月份',y = '新增人数')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x1928a1c9fa0>



<img src="https://gitee.com/panli1998/mycloudimage/raw/master/output_49_1.svg" alt="svg"  />


## 用户流失时间（用户最后一次购买时间）


```python
df.loc[df.event_time.dt.year == 2020].groupby('user_id')['event_time'].min().value_counts().plot()
```




    <matplotlib.axes._subplots.AxesSubplot at 0x192f7eba6a0>



<img src="https://gitee.com/panli1998/mycloudimage/raw/master/output_51_1.svg" alt="svg"  />



```python
data = df.loc[df.event_time.dt.year == 2020].groupby('user_id')['event_time'].max().value_counts().reset_index()
data = data.groupby(data['index'].dt.month)['event_time'].sum().reset_index().rename(columns = {'index':'月份','event_time':'最后一次购买人数'})
data 
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
      <th>月份</th>
      <th>最后一次购买人数</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>168</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>241</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>302</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>1747</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>8300</td>
    </tr>
    <tr>
      <th>5</th>
      <td>6</td>
      <td>6043</td>
    </tr>
    <tr>
      <th>6</th>
      <td>7</td>
      <td>17485</td>
    </tr>
    <tr>
      <th>7</th>
      <td>8</td>
      <td>25120</td>
    </tr>
    <tr>
      <th>8</th>
      <td>9</td>
      <td>13075</td>
    </tr>
    <tr>
      <th>9</th>
      <td>10</td>
      <td>10594</td>
    </tr>
    <tr>
      <th>10</th>
      <td>11</td>
      <td>7706</td>
    </tr>
  </tbody>
</table>
</div>




```python
sns.barplot(data = data,x = '月份',y = '最后一次购买人数')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x1928bd589d0>



<img src="https://gitee.com/panli1998/mycloudimage/raw/master/output_53_1.svg" alt="svg"  />


- 初次购买和最后一次购买的人数基本相同，说明2020年中，大部分用户的只购买了一次电子产品

## 统计新老用户的比例


```python
data = df.groupby('user_id')['event_time'].agg(['min','max'])
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
      <th>min</th>
      <th>max</th>
    </tr>
    <tr>
      <th>user_id</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1.515916e+18</th>
      <td>2020-07-09 06:35:18+00:00</td>
      <td>2020-07-09 06:35:18+00:00</td>
    </tr>
    <tr>
      <th>1.515916e+18</th>
      <td>2020-09-22 15:11:15+00:00</td>
      <td>2020-10-28 05:53:47+00:00</td>
    </tr>
    <tr>
      <th>1.515916e+18</th>
      <td>2020-10-23 03:51:26+00:00</td>
      <td>2020-11-16 15:49:50+00:00</td>
    </tr>
    <tr>
      <th>1.515916e+18</th>
      <td>2020-06-10 21:37:30+00:00</td>
      <td>2020-10-06 05:59:30+00:00</td>
    </tr>
    <tr>
      <th>1.515916e+18</th>
      <td>2020-05-16 16:09:13+00:00</td>
      <td>2020-07-14 13:04:12+00:00</td>
    </tr>
  </tbody>
</table>
</div>




```python
data = data.reset_index()
data['is_new'] = (data['min'] == data['max'])
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
      <th>user_id</th>
      <th>min</th>
      <th>max</th>
      <th>is_new</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.515916e+18</td>
      <td>2020-07-09 06:35:18+00:00</td>
      <td>2020-07-09 06:35:18+00:00</td>
      <td>True</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.515916e+18</td>
      <td>2020-09-22 15:11:15+00:00</td>
      <td>2020-10-28 05:53:47+00:00</td>
      <td>False</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.515916e+18</td>
      <td>2020-10-23 03:51:26+00:00</td>
      <td>2020-11-16 15:49:50+00:00</td>
      <td>False</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1.515916e+18</td>
      <td>2020-06-10 21:37:30+00:00</td>
      <td>2020-10-06 05:59:30+00:00</td>
      <td>False</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1.515916e+18</td>
      <td>2020-05-16 16:09:13+00:00</td>
      <td>2020-07-14 13:04:12+00:00</td>
      <td>False</td>
    </tr>
  </tbody>
</table>
</div>




```python
data = data.is_new.value_counts().rename(index={False:'多次购买',True:'一次用户'}).to_frame().reset_index().rename(columns={'index':'用户类型','is_new':'用户数量'})
```


```python
data 
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
      <th>用户类型</th>
      <th>用户数量</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>多次购买</td>
      <td>48071</td>
    </tr>
    <tr>
      <th>1</th>
      <td>一次用户</td>
      <td>42729</td>
    </tr>
  </tbody>
</table>
</div>




```python
sns.barplot(data=data,x = '用户类型',y = '用户数量')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x1928650d280>



<img src="https://gitee.com/panli1998/mycloudimage/raw/master/output_60_1.svg" alt="svg"  />


- 从用户类型可以看出，有一半的用户都只购买了一次，复购率很低，需要进一步提高新用户的转换率

## 用户分层

![img](https://gitee.com/panli1998/mycloudimage/raw/master/ae51f3deb48f8c549307731933292df5e0fe7f2b)

![问他咋做数据分析，张口就来RFM，结果还用错！](https://gitee.com/panli1998/mycloudimage/raw/master/islHD6lXjooU3yvpRgDD.png)

- 最近一次消费 (Recency)
- 消费频率 (Frequency)
- 消费金额 (Monetary)


```python
data = df.pivot_table(index='user_id',values = ['price','order_id','event_time'],aggfunc=
{'price':'sum','order_id':'count','event_time':'max'}).reset_index().rename(columns={'event_time':'最后购买日期','order_id':'购买次数','price':'消费总金额'})
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
      <th>user_id</th>
      <th>最后购买日期</th>
      <th>购买次数</th>
      <th>消费总金额</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.515916e+18</td>
      <td>2020-07-09 06:35:18+00:00</td>
      <td>1</td>
      <td>416.64</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.515916e+18</td>
      <td>2020-10-28 05:53:47+00:00</td>
      <td>2</td>
      <td>56.43</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.515916e+18</td>
      <td>2020-11-16 15:49:50+00:00</td>
      <td>12</td>
      <td>5984.92</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1.515916e+18</td>
      <td>2020-10-06 05:59:30+00:00</td>
      <td>7</td>
      <td>3785.72</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1.515916e+18</td>
      <td>2020-07-14 13:04:12+00:00</td>
      <td>2</td>
      <td>182.83</td>
    </tr>
  </tbody>
</table>
</div>




```python
data['最后一次购买间隔'] = -(data['最后购买日期']-data['最后购买日期'].max())/np.timedelta64(1,'D')
data
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
      <th>user_id</th>
      <th>最后购买日期</th>
      <th>购买次数</th>
      <th>消费总金额</th>
      <th>最后一次购买间隔</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.515916e+18</td>
      <td>2020-07-09 06:35:18+00:00</td>
      <td>1</td>
      <td>416.64</td>
      <td>135.149444</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.515916e+18</td>
      <td>2020-10-28 05:53:47+00:00</td>
      <td>2</td>
      <td>56.43</td>
      <td>24.178275</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.515916e+18</td>
      <td>2020-11-16 15:49:50+00:00</td>
      <td>12</td>
      <td>5984.92</td>
      <td>4.764352</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1.515916e+18</td>
      <td>2020-10-06 05:59:30+00:00</td>
      <td>7</td>
      <td>3785.72</td>
      <td>46.174306</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1.515916e+18</td>
      <td>2020-07-14 13:04:12+00:00</td>
      <td>2</td>
      <td>182.83</td>
      <td>129.879375</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>90795</th>
      <td>1.515916e+18</td>
      <td>2020-11-21 09:13:23+00:00</td>
      <td>1</td>
      <td>208.31</td>
      <td>0.039664</td>
    </tr>
    <tr>
      <th>90796</th>
      <td>1.515916e+18</td>
      <td>2020-11-21 09:18:31+00:00</td>
      <td>1</td>
      <td>3472.20</td>
      <td>0.036100</td>
    </tr>
    <tr>
      <th>90797</th>
      <td>1.515916e+18</td>
      <td>2020-11-21 10:10:01+00:00</td>
      <td>2</td>
      <td>277.74</td>
      <td>0.000336</td>
    </tr>
    <tr>
      <th>90798</th>
      <td>1.515916e+18</td>
      <td>2020-11-21 10:04:42+00:00</td>
      <td>1</td>
      <td>925.67</td>
      <td>0.004028</td>
    </tr>
    <tr>
      <th>90799</th>
      <td>1.515916e+18</td>
      <td>2020-11-21 10:10:13+00:00</td>
      <td>1</td>
      <td>418.96</td>
      <td>0.000197</td>
    </tr>
  </tbody>
</table>
<p>90800 rows × 5 columns</p>
</div>



通过RFM方法判断顾客种类


```python
def rfm_func(x):
    level = x.apply(lambda x: '1' if x >=0 else '0')
    label = level['最后一次购买间隔']+level['购买次数']+level['消费总金额']
    d={
        '111' : '重要价值客户'
        ,'011': '重要保持客户' 
        ,'101': '重要发展客户'
        ,'001': '重要挽留客户'
        ,'110': '一般价值客户'
        ,'010': '一般保持客户'
        ,'100': '一般发展客户'
        ,'000': '一般挽留客户'
    }
    result = d[label]
    return  result
data['label' ] = data[['最后一次购买间隔','购买次数','消费总金额']].apply(lambda x:x - x.mean()).apply(rfm_func,axis = 1)
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
      <th>user_id</th>
      <th>最后购买日期</th>
      <th>购买次数</th>
      <th>消费总金额</th>
      <th>最后一次购买间隔</th>
      <th>label</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.515916e+18</td>
      <td>2020-07-09 06:35:18+00:00</td>
      <td>1</td>
      <td>416.64</td>
      <td>135.149444</td>
      <td>一般发展客户</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.515916e+18</td>
      <td>2020-10-28 05:53:47+00:00</td>
      <td>2</td>
      <td>56.43</td>
      <td>24.178275</td>
      <td>一般挽留客户</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.515916e+18</td>
      <td>2020-11-16 15:49:50+00:00</td>
      <td>12</td>
      <td>5984.92</td>
      <td>4.764352</td>
      <td>重要保持客户</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1.515916e+18</td>
      <td>2020-10-06 05:59:30+00:00</td>
      <td>7</td>
      <td>3785.72</td>
      <td>46.174306</td>
      <td>重要保持客户</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1.515916e+18</td>
      <td>2020-07-14 13:04:12+00:00</td>
      <td>2</td>
      <td>182.83</td>
      <td>129.879375</td>
      <td>一般发展客户</td>
    </tr>
  </tbody>
</table>
</div>




```python
data.groupby('label')[['最后一次购买间隔','购买次数','消费总金额']].agg(['count','sum','mean'])
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
    
    .dataframe thead tr th {
        text-align: left;
    }
    
    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th colspan="3" halign="left">最后一次购买间隔</th>
      <th colspan="3" halign="left">购买次数</th>
      <th colspan="3" halign="left">消费总金额</th>
    </tr>
    <tr>
      <th></th>
      <th>count</th>
      <th>sum</th>
      <th>mean</th>
      <th>count</th>
      <th>sum</th>
      <th>mean</th>
      <th>count</th>
      <th>sum</th>
      <th>mean</th>
    </tr>
    <tr>
      <th>label</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>一般价值客户</th>
      <td>1456</td>
      <td>1.934602e+05</td>
      <td>132.871021</td>
      <td>1456</td>
      <td>9019</td>
      <td>6.194368</td>
      <td>1456</td>
      <td>952390.01</td>
      <td>654.114018</td>
    </tr>
    <tr>
      <th>一般保持客户</th>
      <td>3367</td>
      <td>1.921168e+05</td>
      <td>57.058746</td>
      <td>3367</td>
      <td>21993</td>
      <td>6.531928</td>
      <td>3367</td>
      <td>2427027.58</td>
      <td>720.827912</td>
    </tr>
    <tr>
      <th>一般发展客户</th>
      <td>36611</td>
      <td>5.695113e+06</td>
      <td>155.557437</td>
      <td>36611</td>
      <td>56771</td>
      <td>1.550654</td>
      <td>36611</td>
      <td>11417308.76</td>
      <td>311.854600</td>
    </tr>
    <tr>
      <th>一般挽留客户</th>
      <td>28052</td>
      <td>1.831255e+06</td>
      <td>65.280719</td>
      <td>28052</td>
      <td>52324</td>
      <td>1.865250</td>
      <td>28052</td>
      <td>11691016.52</td>
      <td>416.762317</td>
    </tr>
    <tr>
      <th>重要价值客户</th>
      <td>2080</td>
      <td>2.580487e+05</td>
      <td>124.061853</td>
      <td>2080</td>
      <td>18024</td>
      <td>8.665385</td>
      <td>2080</td>
      <td>5904772.28</td>
      <td>2838.832827</td>
    </tr>
    <tr>
      <th>重要保持客户</th>
      <td>10315</td>
      <td>4.886402e+05</td>
      <td>47.371809</td>
      <td>10315</td>
      <td>238375</td>
      <td>23.109549</td>
      <td>10315</td>
      <td>57886716.90</td>
      <td>5611.896937</td>
    </tr>
    <tr>
      <th>重要发展客户</th>
      <td>2927</td>
      <td>4.261963e+05</td>
      <td>145.608568</td>
      <td>2927</td>
      <td>7467</td>
      <td>2.551076</td>
      <td>2927</td>
      <td>5133287.36</td>
      <td>1753.770878</td>
    </tr>
    <tr>
      <th>重要挽留客户</th>
      <td>5992</td>
      <td>3.576382e+05</td>
      <td>59.685946</td>
      <td>5992</td>
      <td>16745</td>
      <td>2.794559</td>
      <td>5992</td>
      <td>11516020.92</td>
      <td>1921.899352</td>
    </tr>
  </tbody>
</table>
</div>




```python
data.groupby('label')['user_id'].agg(['count']).sort_values('count').plot(kind = 'barh')
```




    <matplotlib.axes._subplots.AxesSubplot at 0x1928f663880>



<img src="https://gitee.com/panli1998/mycloudimage/raw/master/output_71_1.svg" alt="svg"  />


- 需要针对不同类别的客户，制定不同的刺激措施，来提高客户价值

## 用户留存时间


```python
data = df.groupby('user_id')['event_time'].agg(['min','max'])
data = data.reset_index()
data['留存天数'] = (data['max'] - data['min']).dt.days
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
      <th>user_id</th>
      <th>min</th>
      <th>max</th>
      <th>留存天数</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.515916e+18</td>
      <td>2020-07-09 06:35:18+00:00</td>
      <td>2020-07-09 06:35:18+00:00</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.515916e+18</td>
      <td>2020-09-22 15:11:15+00:00</td>
      <td>2020-10-28 05:53:47+00:00</td>
      <td>35</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.515916e+18</td>
      <td>2020-10-23 03:51:26+00:00</td>
      <td>2020-11-16 15:49:50+00:00</td>
      <td>24</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1.515916e+18</td>
      <td>2020-06-10 21:37:30+00:00</td>
      <td>2020-10-06 05:59:30+00:00</td>
      <td>117</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1.515916e+18</td>
      <td>2020-05-16 16:09:13+00:00</td>
      <td>2020-07-14 13:04:12+00:00</td>
      <td>58</td>
    </tr>
  </tbody>
</table>
</div>




```python
sns.histplot(data = data.query('留存天数<200'),x ='留存天数',bins =100)
```




    <matplotlib.axes._subplots.AxesSubplot at 0x1928324d190>



<img src="https://gitee.com/panli1998/mycloudimage/raw/master/output_75_1.svg" alt="svg"  />

