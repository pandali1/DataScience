Docker入门（阿里云轻量应用服务器+xshell+xftp)

> 本文参考资料：
>
> [**手把手带你完成docker提交**](https://tianchi.aliyun.com/specials/activity/promotion/aicampdocker)
>
> [Docker练习场](https://tianchi.aliyun.com/competition/entrance/231759/tab/226)

## 步骤1购买服务器

1. 购买阿里云轻量级应用服务器（开发者计划，约10元/月）[购买链接](https://developer.aliyun.com/plan/grow-up)

![image-20210219160131873](https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210219160131873.png)

1. 配置服务器root密码

## 步骤2 安装docker

1. 安装xshell

2. 使用xshell登陆远程服务器

3. 安装docker

4. ```
   ## 需要先更新apt
   Sudo apt-get update
   
   ## 安装docker
   sudo apt install docker.io
   ```

5. 测试helloworld

   ```
   docker run hello-world
   ```

## 步骤3 上传本地代码

1. 参考[docker入门](https://tianchi.aliyun.com/competition/entrance/231759/tab/226)创建自己的docker仓库

2. 安装xftp

3. 使用xftp登陆服务器，创建一个自己的文件夹，从本地电脑上将需要的docker配置文件压缩包拖拽到创建的文件中

4. 解压文件

   ```
   apt install unzip
   
   cd 创建的文件夹
   
   unzip 文件压缩包
   
   cd 解压缩后的文件夹
   ```

5. 上传docker镜像到自己的docker云镜像仓库

   ```
   docker build -t 仓库地址:版本号 .   (不要漏掉后面的.)
   
   docker push 仓库地址:版本号
   ```

## 步骤4 提交比赛结果

在比赛提交页输入自己的docker仓库地址，用户名，密码即可

然后就等待结果了

![image-20210219161558362](https://gitee.com/panli1998/mycloudimage/raw/master/img/image-20210219161558362.png)

## 步骤5 修改代码

在本地修改好后，再次使用步骤3和步骤4进行提交即可