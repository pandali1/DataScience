> [投票学习](https://blog.csdn.net/weixin_43822124/article/details/115673544)

# bagging原理

<img src="https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210416110048495.png" alt="image-20210416110048495" style="zoom:80%;" />

1. ## bootstrap抽样：

   - 有放回地从原始数据集中，随机抽取相同数量的数据
   - 也可以对特征属性进行抽样

2. ## 降低模型的方差

   - 因为每个基模型的训练数据都不同，因此模型之间存在细微的差异，这样可以有效降低最终模型的结果方差，并且提高泛化能力

3. ## 与投票法的区别

   - 基模型可以选择相同的模型
   - 在投票环节，方法与投票法相同

4. ## 缺点

   - 不能降低的模型的偏差，也就是如果基模型效果不好，那么无论如何改进bagging模型，也无法得到较好的训练结果
   - 训练时间偏长，
   - boosting既可以降低方差，又可以降低偏差

# bagging案例

## 数据读取

> 通过酒的属性，对酒进行分类


```python
import pandas as pd 
df_wine = pd.read_csv('https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data',
                     header=None)
df_wine.head()
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
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
      <th>6</th>
      <th>7</th>
      <th>8</th>
      <th>9</th>
      <th>10</th>
      <th>11</th>
      <th>12</th>
      <th>13</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>14.23</td>
      <td>1.71</td>
      <td>2.43</td>
      <td>15.6</td>
      <td>127</td>
      <td>2.80</td>
      <td>3.06</td>
      <td>0.28</td>
      <td>2.29</td>
      <td>5.64</td>
      <td>1.04</td>
      <td>3.92</td>
      <td>1065</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>13.20</td>
      <td>1.78</td>
      <td>2.14</td>
      <td>11.2</td>
      <td>100</td>
      <td>2.65</td>
      <td>2.76</td>
      <td>0.26</td>
      <td>1.28</td>
      <td>4.38</td>
      <td>1.05</td>
      <td>3.40</td>
      <td>1050</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>13.16</td>
      <td>2.36</td>
      <td>2.67</td>
      <td>18.6</td>
      <td>101</td>
      <td>2.80</td>
      <td>3.24</td>
      <td>0.30</td>
      <td>2.81</td>
      <td>5.68</td>
      <td>1.03</td>
      <td>3.17</td>
      <td>1185</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1</td>
      <td>14.37</td>
      <td>1.95</td>
      <td>2.50</td>
      <td>16.8</td>
      <td>113</td>
      <td>3.85</td>
      <td>3.49</td>
      <td>0.24</td>
      <td>2.18</td>
      <td>7.80</td>
      <td>0.86</td>
      <td>3.45</td>
      <td>1480</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1</td>
      <td>13.24</td>
      <td>2.59</td>
      <td>2.87</td>
      <td>21.0</td>
      <td>118</td>
      <td>2.80</td>
      <td>2.69</td>
      <td>0.39</td>
      <td>1.82</td>
      <td>4.32</td>
      <td>1.04</td>
      <td>2.93</td>
      <td>735</td>
    </tr>
  </tbody>
</table>
</div>




```python
df_wine.columns = ['label', 'Alcohol'
,'Malic ac'
,'Ash'
,'Alcalinity of ash ' 
,'Magnesium'
,'Total phenols'
,'Flavanoids'
,'Nonflavanoid phenols'
,'Proanthocyanins'
,'Color intensity'
,'Hue'
,'OD280/OD315 of diluted wines'
,'Proline'       ]
df_wine.head()
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
      <th>label</th>
      <th>Alcohol</th>
      <th>Malic ac</th>
      <th>Ash</th>
      <th>Alcalinity of ash</th>
      <th>Magnesium</th>
      <th>Total phenols</th>
      <th>Flavanoids</th>
      <th>Nonflavanoid phenols</th>
      <th>Proanthocyanins</th>
      <th>Color intensity</th>
      <th>Hue</th>
      <th>OD280/OD315 of diluted wines</th>
      <th>Proline</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>14.23</td>
      <td>1.71</td>
      <td>2.43</td>
      <td>15.6</td>
      <td>127</td>
      <td>2.80</td>
      <td>3.06</td>
      <td>0.28</td>
      <td>2.29</td>
      <td>5.64</td>
      <td>1.04</td>
      <td>3.92</td>
      <td>1065</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>13.20</td>
      <td>1.78</td>
      <td>2.14</td>
      <td>11.2</td>
      <td>100</td>
      <td>2.65</td>
      <td>2.76</td>
      <td>0.26</td>
      <td>1.28</td>
      <td>4.38</td>
      <td>1.05</td>
      <td>3.40</td>
      <td>1050</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>13.16</td>
      <td>2.36</td>
      <td>2.67</td>
      <td>18.6</td>
      <td>101</td>
      <td>2.80</td>
      <td>3.24</td>
      <td>0.30</td>
      <td>2.81</td>
      <td>5.68</td>
      <td>1.03</td>
      <td>3.17</td>
      <td>1185</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1</td>
      <td>14.37</td>
      <td>1.95</td>
      <td>2.50</td>
      <td>16.8</td>
      <td>113</td>
      <td>3.85</td>
      <td>3.49</td>
      <td>0.24</td>
      <td>2.18</td>
      <td>7.80</td>
      <td>0.86</td>
      <td>3.45</td>
      <td>1480</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1</td>
      <td>13.24</td>
      <td>2.59</td>
      <td>2.87</td>
      <td>21.0</td>
      <td>118</td>
      <td>2.80</td>
      <td>2.69</td>
      <td>0.39</td>
      <td>1.82</td>
      <td>4.32</td>
      <td>1.04</td>
      <td>2.93</td>
      <td>735</td>
    </tr>
  </tbody>
</table>
</div>

## 划分训练测试集


```python
Y = df_wine.label
X = df_wine.iloc[:,1:]
```


```python
from sklearn.model_selection import train_test_split
X_train,X_test,y_train,y_test = train_test_split(X,Y,test_size = 0.30,random_state = 1)
```


```python
X_train.shape,X_test.shape
```




    ((124, 13), (54, 13))

## 构造bagging分类器


```python
from sklearn.model_selection import cross_val_score,RepeatedStratifiedKFold
from sklearn.ensemble import BaggingClassifier
from sklearn.tree import DecisionTreeClassifier
import numpy as np 
tree = DecisionTreeClassifier()

bag_model = BaggingClassifier(base_estimator=tree,
                             n_estimators=100,
                             max_samples=1.0,
                             max_features=1.0,
                             bootstrap=True,
                             bootstrap_features=True,
                             n_jobs=-1,
                             random_state=1)


cv = RepeatedStratifiedKFold(n_splits=10, n_repeats=3, random_state=1)
n_scores_en = cross_val_score(bag_model, X_train, y_train, scoring='accuracy', cv=cv, n_jobs=-1, error_score='raise')
n_scores_tree = cross_val_score(DecisionTreeClassifier(), X_train, y_train, scoring='accuracy', cv=cv, n_jobs=-1, error_score='raise')
# report performance
print('Bagging:Accuracy: %.3f (%.3f)' % (np.mean(n_scores_en), np.std(n_scores_en)))
print('tree   :Accuracy: %.3f (%.3f)' % (np.mean(n_scores_tree), np.std(n_scores_tree)))
```

    Bagging:Accuracy: 0.979 (0.041)
    tree   :Accuracy: 0.922 (0.075)

**可以看到在训练集上，准确率提升了大概5%，不是很多，但是模型的方差降低了接近50%，bagging可以有效地降低模型的方差**

## 泛化能力提高

```python
from sklearn.metrics import accuracy_score
base_tree = DecisionTreeClassifier()

base_tree.fit(X_train,y_train)
y_test_pred = base_tree.predict(X_test)
print('tree   :Accuracy: %.3f' % (accuracy_score(y_pred=y_test_pred,y_true=y_test)))

bag_model.fit(X_train,y_train)
y_test_pred = bag_model.predict(X_test)
print('Bagging:Accuracy: %.3f' % (accuracy_score(y_pred=y_test_pred,y_true=y_test)))
```

    tree   :Accuracy: 0.944
    Bagging:Accuracy: 0.981

**在测试集上，bagging的准确率也高于单个决策树模型**

> 参考资料：《Python 机器学习》