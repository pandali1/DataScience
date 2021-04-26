# XGBoost原理

Xgboost的大致原理与GBDT相似，但是在部分步骤中进行了改进

## 目标函数

xgboost与GBDT最大的不同就是目标函数

<img src="https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210426100407643.png" alt="image-20210426100407643" style="zoom:67%;" />

上式中，$\hat y_{i}^{t-1}$表示前面t-1轮中生成的加权树模型的预测结果，$Ω(f_i)表示正则项$

接下来是重点，**利用泰勒展开拟合目标函数**：

<img src="https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210426101024758.png" alt="image-20210426101024758" style="zoom:67%;" />

前面t-1轮的训练误差是已知的，因此将上式改变为：

<img src="https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210426101229206.png" alt="image-20210426101229206" style="zoom:67%;" />

函数g和h分别是1阶和2阶导数

## 定义树模型


$$
f_t(x)=w_q(x)  \ \ 每个节点的权重\\
𝑞(𝑥)\ \ 每个样本属于的节点 \\ 
𝐼_𝑗=\{𝑖∣𝑞(𝐱_𝑖)=𝑗\}\ \ 每个节点的样本集合
$$
<img src="https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210426102227348.png" alt="image-20210426102227348" style="zoom:40%;" />

如上图所示，$q(x_1) = 1,q(x_2) = 3,q(x_3) = 1,q(x_4) = 2,q(x_5) = 3$，$I_1 = \{1,3\},I_2 = \{4\},I_3 = \{2,5\}$，$w = (15,12,20)$ 

重新定义树的复杂度：
$$
\Omega\left(f_{K}\right) = \gamma T+\frac{1}{2} \lambda \sum_{j=1}^{T} w_{j}^{2}
$$

## 重构目标函数

$$
\begin{aligned}
Obj^{(t)} &=\sum_{i=1}^{n}\left[g_{i} f_{K}\left(\mathrm{x}_{i}\right)+\frac{1}{2} h_{i} f_{K}^{2}\left(\mathrm{x}_{i}\right)\right]+\gamma T+\frac{1}{2} \lambda \sum_{j=1}^{T} w_{j}^{2} \\
&=\sum_{j=1}^{T}\left[\left(\sum_{i \in I_{j}} g_{i}\right) w_{j}+\frac{1}{2}\left(\sum_{i \in I_{j}} h_{i}+\lambda\right) w_{j}^{2}\right]+\gamma T\\
&=[G_jw_j+\frac{1}{2}(H_j+λ)w^2_j]+γT
\end{aligned}
$$

式中：

<img src="https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210426103512664.png" alt="image-20210426103512664" style="zoom:50%;" />

## 求解w和L：

找到令Obj最小的w:($ax^2+bx+c$求解公式：$x^*=-\frac{b}{2a}$)

<img src="https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210426103950934.png" alt="image-20210426103950934" style="zoom:50%;" />

将$w_j^*代入Obj$即可求得目标函数的值

所以分支后，目标函数的降低值为：

<img src="https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210426105324266.png" alt="image-20210426105324266" style="zoom:50%;" />

## 寻找最佳分支

使用精确算法或近似算法，选择每一步中使Gain最大的分支方法

# Xgboost案例

## 加载数据集

```python
from sklearn.datasets import load_iris
import xgboost as xgb 
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score,classification_report
```


```python
iris = load_iris()
X,y = iris.data,iris.target
```


```python
import pandas as pd 
X = pd.DataFrame(X,columns=iris.feature_names)
X.head()
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
      <th>sepal length (cm)</th>
      <th>sepal width (cm)</th>
      <th>petal length (cm)</th>
      <th>petal width (cm)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>5.1</td>
      <td>3.5</td>
      <td>1.4</td>
      <td>0.2</td>
    </tr>
    <tr>
      <th>1</th>
      <td>4.9</td>
      <td>3.0</td>
      <td>1.4</td>
      <td>0.2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>4.7</td>
      <td>3.2</td>
      <td>1.3</td>
      <td>0.2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4.6</td>
      <td>3.1</td>
      <td>1.5</td>
      <td>0.2</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5.0</td>
      <td>3.6</td>
      <td>1.4</td>
      <td>0.2</td>
    </tr>
  </tbody>
</table>
</div>

## 训练模型


```python
X_train,X_test,y_train,y_test = train_test_split(X,y,test_size = 0.3)
```


```python
# 算法参数
params = {
    'booster': 'gbtree',
    'objective': 'multi:softmax',
    'num_class': 3,
    'gamma': 0.1,
    'max_depth': 6,
    'lambda': 2,
    'subsample': 0.7,
    'colsample_bytree': 0.75,
    'min_child_weight': 3,
    'eta': 0.1,
    'seed': 1,
    'nthread': 4,
}
```


```python
dtrain = xgb.DMatrix(X_train,y_train)

model = xgb.XGBClassifier(**params)
model.fit(X_train,y_train)
y_pred = model.predict(X_test)
print(classification_report(y_test,y_pred))
```

    [16:55:13] WARNING: C:/Users/Administrator/workspace/xgboost-win64_release_1.3.0/src/learner.cc:1061: Starting in XGBoost 1.3.0, the default evaluation metric used with the objective 'multi:softprob' was changed from 'merror' to 'mlogloss'. Explicitly set eval_metric if you'd like to restore the old behavior.
                  precision    recall  f1-score   support
    
               0       1.00      1.00      1.00        13
               1       1.00      0.86      0.93        22
               2       0.77      1.00      0.87        10
    
        accuracy                           0.93        45
       macro avg       0.92      0.95      0.93        45
    weighted avg       0.95      0.93      0.94        45

##     绘制特征重要性

```python
xgb.plot_importance(model)
```




    <matplotlib.axes._subplots.AxesSubplot at 0x2c2d525cc10>



<img src="https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210426111824609.png" alt="image-20210426111824609" style="zoom:80%;" />

## 调参

常用参数：

参考：[机器学习集成学习之XGBoost](https://zhuanlan.zhihu.com/p/143009353)

```python
from sklearn.model_selection import GridSearchCV
def Tuning(cv_params, other_params,x_train_array,y_train_):
    model2 = xgb.XGBClassifier(**other_params)
    optimized_GBM = GridSearchCV(estimator=model2, 
                                 param_grid=cv_params,
                                 scoring='accuracy',
                                 cv=5, 
                                 n_jobs=-1)
    optimized_GBM.fit(x_train_array, y_train_)
    evalute_result = optimized_GBM.cv_results_['mean_test_score']
    #print('每轮迭代运行结果:{0}'.format(evalute_result))
    print('参数的最佳取值：{0}'.format(optimized_GBM.best_params_))
    print('最佳模型得分:{0}'.format(optimized_GBM.best_score_))
    return optimized_GBM
```


```python
other_params = {
    'booster': 'gbtree',
    'objective': 'multi:softmax',
    'num_class': 3
}
cv_params = {
    'learning_rate':[0.01, 0.02, 0.05, 0.1, 0.15],
}
opt = Tuning(cv_params,other_params,X_train,y_train)
```

    [17:02:24] WARNING: C:/Users/Administrator/workspace/xgboost-win64_release_1.3.0/src/learner.cc:1061: Starting in XGBoost 1.3.0, the default evaluation metric used with the objective 'multi:softprob' was changed from 'merror' to 'mlogloss'. Explicitly set eval_metric if you'd like to restore the old behavior.
    参数的最佳取值：{'learning_rate': 0.01}
    最佳模型得分:0.9619047619047618



```python
other_params = {
    'booster': 'gbtree',
    'objective': 'multi:softmax',
    'num_class': 3,
    'learning_rate':0.01,
}
cv_params = {
    'max_depth': [2,3,4,5],
    'min_child_weight': [0, 2, 5, 10, 20],
}
opt = Tuning(cv_params,other_params,X_train,y_train)
```

    [17:03:16] WARNING: C:/Users/Administrator/workspace/xgboost-win64_release_1.3.0/src/learner.cc:1061: Starting in XGBoost 1.3.0, the default evaluation metric used with the objective 'multi:softprob' was changed from 'merror' to 'mlogloss'. Explicitly set eval_metric if you'd like to restore the old behavior.
    参数的最佳取值：{'max_depth': 2, 'min_child_weight': 0}
    最佳模型得分:0.9619047619047618


    C:\Users\lipan\anaconda3\lib\site-packages\xgboost\sklearn.py:888: UserWarning: The use of label encoder in XGBClassifier is deprecated and will be removed in a future release. To remove this warning, do the following: 1) Pass option use_label_encoder=False when constructing XGBClassifier object; and 2) Encode your labels (y) as integers starting with 0, i.e. 0, 1, 2, ..., [num_class - 1].
      warnings.warn(label_encoder_deprecation_msg, UserWarning)



```python
other_params = {
    'booster': 'gbtree',
    'objective': 'multi:softmax',
    'num_class': 3,
    'learning_rate':0.01,
    'max_depth': 2,
    'min_child_weight': 0,

}
cv_params = {
    'subsample': [0.6, 0.7, 0.8, 0.85, 0.95],
    'colsample_bytree': [0.5, 0.6, 0.7, 0.8, 0.9],
}
opt = Tuning(cv_params,other_params,X_train,y_train)
```

    C:\Users\lipan\anaconda3\lib\site-packages\xgboost\sklearn.py:888: UserWarning: The use of label encoder in XGBClassifier is deprecated and will be removed in a future release. To remove this warning, do the following: 1) Pass option use_label_encoder=False when constructing XGBClassifier object; and 2) Encode your labels (y) as integers starting with 0, i.e. 0, 1, 2, ..., [num_class - 1].
      warnings.warn(label_encoder_deprecation_msg, UserWarning)


    [17:04:37] WARNING: C:/Users/Administrator/workspace/xgboost-win64_release_1.3.0/src/learner.cc:1061: Starting in XGBoost 1.3.0, the default evaluation metric used with the objective 'multi:softprob' was changed from 'merror' to 'mlogloss'. Explicitly set eval_metric if you'd like to restore the old behavior.
    参数的最佳取值：{'colsample_bytree': 0.5, 'subsample': 0.95}
    最佳模型得分:0.9619047619047618



```python
other_params = {
    'booster': 'gbtree',
    'objective': 'multi:softmax',
    'num_class': 3,
    'learning_rate':0.01,
    'max_depth': 2,
    'min_child_weight': 0,
    'subsample': 0.95,
    'colsample_bytree': 0.5
}
cv_params = {
    
    'reg_alpha': [0, 0.25, 0.5, 0.75, 1],
}
opt = Tuning(cv_params,other_params,X_train,y_train)
```

    [17:06:08] WARNING: C:/Users/Administrator/workspace/xgboost-win64_release_1.3.0/src/learner.cc:1061: Starting in XGBoost 1.3.0, the default evaluation metric used with the objective 'multi:softprob' was changed from 'merror' to 'mlogloss'. Explicitly set eval_metric if you'd like to restore the old behavior.
    参数的最佳取值：{'reg_alpha': 0}
    最佳模型得分:0.9619047619047618


    C:\Users\lipan\anaconda3\lib\site-packages\xgboost\sklearn.py:888: UserWarning: The use of label encoder in XGBClassifier is deprecated and will be removed in a future release. To remove this warning, do the following: 1) Pass option use_label_encoder=False when constructing XGBClassifier object; and 2) Encode your labels (y) as integers starting with 0, i.e. 0, 1, 2, ..., [num_class - 1].
      warnings.warn(label_encoder_deprecation_msg, UserWarning)



```python
y_pred = opt.best_estimator_.predict(X_test)
print(classification_report(y_test,y_pred))
```

                  precision    recall  f1-score   support
    
               0       1.00      1.00      1.00        13
               1       1.00      0.86      0.93        22
               2       0.77      1.00      0.87        10
    
        accuracy                           0.93        45
       macro avg       0.92      0.95      0.93        45
    weighted avg       0.95      0.93      0.94        45


​    
