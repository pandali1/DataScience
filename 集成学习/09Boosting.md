# bootsting原理

<img src="https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210419103831137.png" alt="image-20210419103831137" style="zoom:80%;" />

如上图所示，问题是为了解决一个二分类问题，为此，我们选择一个深度为1的单层决策树进行训练

- 图1：
  - 原始分布中，通过最小化代价函数（不纯度等），得到一个决策边界，可以看到，两个圆形被错误分类，因此要增加他们的权重，并且降低正确分类的样本的权重，变成图2的分布
- 图2 ：
  - 由于上次模型训练中，错误分类的两个圆被赋予了更大的权重，因此产生了新的决策边界
  - 将正确分类的两个大圆和全部三角形的权重进一步降低，增大错误分类的右上方三个圆的权重，分布如图3所示
- 图3：
  - 产生新的分类边界
- 图4：
  - 对1，2，3的分类结果进行多数投票，得到结果4

因此，简单地说，boosting就是通过不断地增大分类错误的样本的权重，降低分类正确的权重，从而生成不同的弱分类器，并通过多数投票等组合形式，得到最终分类结果。

# boosting 案例

## 数据读取

```python
# 引入数据科学相关工具包：
import numpy as np
import pandas as pd 
import matplotlib.pyplot as plt
plt.style.use("ggplot")
%matplotlib inline
import seaborn as sns
```


```python
# 加载训练数据：         
wine = pd.read_csv("https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data",header=None)
wine.columns = ['Class label', 'Alcohol', 'Malic acid', 'Ash', 'Alcalinity of ash','Magnesium', 'Total phenols','Flavanoids', 'Nonflavanoid phenols', 
                'Proanthocyanins','Color intensity', 'Hue','OD280/OD315 of diluted wines','Proline']
```


```python
# 数据查看：
print("Class labels",np.unique(wine["Class label"]))
wine.head()
```

    Class labels [1 2 3]





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
      <th>Class label</th>
      <th>Alcohol</th>
      <th>Malic acid</th>
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

## 数据划分


```python
y = wine['Class label'].values
X = wine[['Alcohol','OD280/OD315 of diluted wines']].values

# 按8：2分割训练集和测试集
from sklearn.model_selection import train_test_split
X_train,X_test,y_train,y_test = train_test_split(X,y,test_size=0.3,random_state=1,stratify=y)  # stratify参数代表了按照y的类别等比例抽样
```

## 弱分类器：单层决策树


```python
# 使用单一决策树建模
from sklearn.tree import DecisionTreeClassifier
tree = DecisionTreeClassifier(criterion='entropy',random_state=1,max_depth = 1)
from sklearn.metrics import accuracy_score
tree = tree.fit(X_train,y_train)
y_train_pred = tree.predict(X_train)
y_test_pred = tree.predict(X_test)
tree_train = accuracy_score(y_train,y_train_pred)
tree_test = accuracy_score(y_test,y_test_pred)
print('Decision tree train/test accuracies %.3f/%.3f' % (tree_train,tree_test))
```

    Decision tree train/test accuracies 0.597/0.611

## adaboost

```python
# 使用sklearn实现Adaboost(基分类器为决策树)
'''
AdaBoostClassifier相关参数：
base_estimator：基本分类器，默认为DecisionTreeClassifier(max_depth=1)
n_estimators：终止迭代的次数
learning_rate：学习率
algorithm：训练的相关算法，{'SAMME'，'SAMME.R'}，默认='SAMME.R'
random_state：随机种子
'''
from sklearn.ensemble import AdaBoostClassifier
ada = AdaBoostClassifier(base_estimator=tree,n_estimators=300,learning_rate=0.01,random_state=1)
ada = ada.fit(X_train,y_train)
y_train_pred = ada.predict(X_train)
y_test_pred = ada.predict(X_test)
ada_train = accuracy_score(y_train,y_train_pred)
ada_test = accuracy_score(y_test,y_test_pred)
print('Adaboost train/test accuracies %.3f/%.3f' % (ada_train,ada_test))
```

    Adaboost train/test accuracies 0.855/0.852

## 结果对比

1. 可以看到以二层决策树为弱分类器的adaboost模型，在训练集和测试集上，效果都略好于弱分类器分身
2. 从下图分类边界曲线可以看到，adaboost的模型更加复杂，决策边界更加曲折，有可能产生过拟合

```python
# 画出单层决策树与Adaboost的决策边界：
x_min = X_train[:, 0].min() - 1
x_max = X_train[:, 0].max() + 1
y_min = X_train[:, 1].min() - 1
y_max = X_train[:, 1].max() + 1
xx, yy = np.meshgrid(np.arange(x_min, x_max, 0.1),np.arange(y_min, y_max, 0.1))
f, axarr = plt.subplots(nrows=1, ncols=2,sharex='col',sharey='row',figsize=(12, 6))
for idx, clf, tt in zip([0, 1],[tree, ada],['Decision tree', 'Adaboost']):
    clf.fit(X_train, y_train)
    Z = clf.predict(np.c_[xx.ravel(), yy.ravel()])
    Z = Z.reshape(xx.shape)
    axarr[idx].contourf(xx, yy, Z, alpha=0.3)
    axarr[idx].scatter(X_train[y_train==1, 0],X_train[y_train==1, 1],c='blue', marker='^')
    axarr[idx].scatter(X_train[y_train==2, 0],X_train[y_train==2, 1],c='red', marker='o')
    axarr[idx].scatter(X_train[y_train==3, 0],X_train[y_train==3, 1],c='green', marker='x')
    axarr[idx].set_title(tt)
axarr[0].set_ylabel('Alcohol', fontsize=12)
plt.tight_layout()
plt.text(0, -0.2,s='OD280/OD315 of diluted wines',ha='center',va='center',fontsize=12,transform=axarr[1].transAxes)
plt.show()
```


![image-20210419105501973](https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210419105501973.png)

## 当弱分类器变成强分类器时：

```python
def fuc(max_depth=2):
    tree = DecisionTreeClassifier(criterion='entropy',random_state=1,max_depth =max_depth)
    ada = AdaBoostClassifier(base_estimator=tree,n_estimators=300,learning_rate=0.01,random_state=1)
    tree = tree.fit(X_train,y_train)
    y_train_pred = tree.predict(X_train)
    y_test_pred = tree.predict(X_test)
    tree_train = accuracy_score(y_train,y_train_pred)
    tree_test = accuracy_score(y_test,y_test_pred)
    print('Decision tree train/test accuracies %.3f/%.3f' % (tree_train,tree_test))

    ada = ada.fit(X_train,y_train)
    y_train_pred = ada.predict(X_train)
    y_test_pred = ada.predict(X_test)
    ada_train = accuracy_score(y_train,y_train_pred)
    ada_test = accuracy_score(y_test,y_test_pred)
    print('Adaboost train/test accuracies %.3f/%.3f' % (ada_train,ada_test))

    x_min = X_train[:, 0].min() - 1
    x_max = X_train[:, 0].max() + 1
    y_min = X_train[:, 1].min() - 1
    y_max = X_train[:, 1].max() + 1
    xx, yy = np.meshgrid(np.arange(x_min, x_max, 0.1),np.arange(y_min, y_max, 0.1))
    f, axarr = plt.subplots(nrows=1, ncols=2,sharex='col',sharey='row',figsize=(12, 6))
    for idx, clf, tt in zip([0, 1],[tree, ada],['Decision tree', 'Adaboost']):
        clf.fit(X_train, y_train)
        Z = clf.predict(np.c_[xx.ravel(), yy.ravel()])
        Z = Z.reshape(xx.shape)
        axarr[idx].contourf(xx, yy, Z, alpha=0.3)
        axarr[idx].scatter(X_train[y_train==1, 0],X_train[y_train==1, 1],c='blue', marker='^')
        axarr[idx].scatter(X_train[y_train==2, 0],X_train[y_train==2, 1],c='red', marker='o')
        axarr[idx].scatter(X_train[y_train==3, 0],X_train[y_train==3, 1],c='green', marker='x')
        axarr[idx].set_title(tt)
    axarr[0].set_ylabel('Alcohol', fontsize=12)
    plt.tight_layout()
    plt.text(0, -0.2,s='OD280/OD315 of diluted wines',ha='center',va='center',fontsize=12,transform=axarr[1].transAxes)
    plt.show()

fuc(2)
```

    Decision tree train/test accuracies 0.903/0.852
    Adaboost train/test accuracies 0.960/0.870

![image-20210419110031133](https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210419110031133.png)



```python
fuc(3)
```

    Decision tree train/test accuracies 0.927/0.926
    Adaboost train/test accuracies 1.000/0.852

![output_7_1](https://gitee.com/panli1998/mycloudimage/raw/master/img/output_7_1.png)

**从结果可以看出，当弱分类器的分类效果逐渐增强时，boosting模型逐渐变得过拟合，泛化能力变化不大**

# boosting的特点

​     