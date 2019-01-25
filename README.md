[![Travis](https://img.shields.io/badge/shell-green.svg)]()
[![Travis](https://img.shields.io/badge/Concourse-red.svg)](https://concourse-ci.org/)

IBM Internship : Pivotal Concourse CI/CD 
===
**Author:** Cookie Chou (周秉楠)
Concourse : https://pivotal.io/concourse
Introduction 
---
- CI is Continuous Integration, it creates a workflow where every commit made to the codebase is tested and built, and each developer on the project is expected to commit code at least once per day.
- CD is Continuous Delivery , it takes the principle of CI one step further: the automated build and test process is extended to every component of the application, including configuration files, database schemas, and environments.
- Concourse CI is a CI/CD Tool provided by Pivotal which is a Cloud Platform Company , and i assigned to research this tool and understood some DevOps knowledge to setup a CI pipline on Google Clou Platform when i was a IBM Application Consultant Intern in Summer , 2018.


## Concourse Pipeline UI
### git pull、package and cf push Pipeline (Cookie Chou)
- ![](https://i.imgur.com/6pBNCMK.png)
### CI/CD Pipeline
- ![](https://i.imgur.com/FlqybCO.png)


## 流程介紹:
1.  After `$git push`  Concourse will trigger to **pull**
![](https://i.imgur.com/i7JcJHe.png)

2.  `$mvn clean package` Using Maven to **package**
![](https://i.imgur.com/OTPITM2.png)


3.  `$cf push` push the new one to **PWS/PCF**
![](https://i.imgur.com/7GO4t7x.png)



## Concourse基本架設可參考:	[Concourse Tutorial by Stark & Wayne](https://concoursetutorial.com/)

## Why Concourse? [與其他CI/CD工具比較] :question: (https://blog.waterstrong.me/concourse-ci/) 


基本架設介紹
---

### 1. Deploy Concourse using Docker Compose:

`$ wget https://concourse-ci.org/docker-compose.yml`
`$ docker-compose up -d`

### 2. 根據自己的環境點選圖案做fly install :  http://127.0.0.1:8080/
![](https://i.imgur.com/wj8oizG.png)

### 3. 將fly工具搬移到bin底下並chmod fly來添加執行權限
`sudo mkdir -p /usr/local/bin`
`sudo mv ~/Downloads/fly /usr/local/bin`
`sudo chmod 0755 /usr/local/bin/fly`

### 4. Concourse on Terminal
- Concourse Login:
`fly --target tutorial login --concourse-url http://127.0.0.1:8080`

- Execute yaml:
`fly -t tutorial execute -c task_ubuntu_uname.yml`

- Push Pipeline to Concouse:
`fly -t tutorial set-pipeline -c pipeline.yml -p hello-world`

- Unpause Pipeline or job:
`fly -t tutorial unpause-pipeline -p hello-world`
`fly -t tutorial unpause-job --job hello-world/job-hello-world`

### 5. Concourse三大核心概念
- Resource: 提前定義跑某些任務的資源 (github、、s3、發slack、email等這樣的一些input)
![](https://i.imgur.com/Y00tXlt.png)

- Jobs: 如Java中的Class，去做相對應的事情

- Task: 如Class裡面的Function
---



### 此Demo利用 pipeline.yml 來控制整個pipeline :alien: 

![](https://i.imgur.com/09hdSbj.jpg)

:::success
resources分為兩個部分:
1. resource-tutorial ( type:git )
吃 https://github.com/CookieNotSession/twewcweightloss2018.git github上的資源

2. cloudfoundry ( type:cf )
將cloudfoundry的api、帳密以及指定空間設定好即可在jobs階段自動部署
:::

:::info
jobs也分為兩個部分:
1. maven install
`get`來取用`resource-tutorial`的資源
`task`中利用`file`來連接另一個yml檔 : `mvn.yml`
2. cloudfoundry
`put`將包好的新版本cf push到 PWS or PCF上
`params`取用`resource-tutorial`路徑中的manifest.yml，並從`mvn.yml`中將包好的新版本jar到`target-web`

:::

#### mvn.yml
![](https://i.imgur.com/gIsRNWw.png)

:::success
1. maven image
針對此Container利用`inputs`將git上的資源拉進來 ex. `inputs:resource-tutorial`
2. 利用`outputs`建立新資料夾 target-web (outputs artifact)
3. run script
`cd ./resource-tutorial` 進入Container中的resource-tutorial中
`mvn clean package` 進行包版動作
`cp ./target/twewcweightloss2018-1.0-SNAPSHOT.jar ../target-web/twewcweightloss2018-1.0-SNAPSHOT.jar` 將新版的jar複製到剛剛創立的新資料夾 target-web 當中
:::

#### 設定完yml檔即可將`pipeline.yml` Push到Concourse上 :+1: 
`fly -t tutorial set-pipeline -c pipeline.yml -p Test`

#### 成功push上去後即可利用UI上的介面手動觸發或是利用command觸發


### Warning :warning: 
:::danger
manifest.yml與pipeline.yml中的buildpack要去符合cf buildpacks
對於PCF來說要改成buildpack: java_buildpack_offline
但在PWS上卻只支援buildpack: java_buildpack
:::

### Reference :information_source: 

https://concoursetutorial.com/
https://concourse-ci.org/
https://blog.waterstrong.me/concourse-ci/
https://ithelp.ithome.com.tw/articles/10184547
https://edu.csdn.net/course/play/6326


