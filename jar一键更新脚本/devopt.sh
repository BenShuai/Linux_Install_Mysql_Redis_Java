#!/bin/bash

echo "自动更新java程序..."

jarName="BenShuai.jar"

downLoadUrl="下载链接,可以用参数的方式传递进来"


isJavaPids=$(ps -ef|grep ${jarName})

#echo $isJavaPids

ind=0
//寻找当前服务是否有历史启动信息，有启动就kill掉进程
for i in $isJavaPids; do
	echo $i
	ind=$(($ind+1))
	
	if [ $ind -eq 2 ]; then
		echo $i
		echo $ind
		res=$(kill -9 $i)
	fi
	if [ $ind -eq 12 ]; then
		echo $i
		echo $ind
		res=$(kill -9 $i)
	fi
done

echo "开始备份当前jar包..."

mv ${jarName} ${jarName}.back.`date +%s`

echo "开始下载更新包"

wget ${downLoadUrl}

#暂停100秒执行下一个操作
ti1=`date +%s`    #获取时间戳
ti2=`date +%s`
i=$(($ti2 - $ti1 ))
while [[ "$i" -lt "100" ]]   
do
	ti2=`date +%s`
	i=$(($ti2 - $ti1 ))
done

nohup java -jar ${jarName} >${jarName}.log &