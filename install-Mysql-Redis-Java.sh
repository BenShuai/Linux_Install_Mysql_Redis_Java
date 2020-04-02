#!/bin/bash


echo "开始卸载旧版本的mysql。。。"
#卸载旧的mysql
isMysql=$(rpm -qa | grep mysql)
echo $isMysql
for i in $isMysql; do
	echo $i
	rpm -e $i --nodeps
done
echo "旧版本mysql卸载完毕"
echo ""




echo "开始卸载旧版本java。。。"
#卸载旧的java
isJava=$(rpm -qa | grep java)
echo $isJava
for i in $isJava; do
	echo $i
	rpm -e $i --nodeps
done
echo "旧版本java卸载完毕"
echo ""





echo "开始卸载旧版本redis。。。"
#卸载旧的redis
isRedis=$(rpm -qa | grep redis)
echo $isRedis
for i in $isRedis; do
	echo $i
	rpm -e $i --nodeps
done
echo "旧版本redis卸载完毕"
echo ""




echo "必要文件检查。。。"


#判断目录中需要的文件是否都在
fileList=$(ls)
fileNum=0
for i in $fileList; do
	if [ ${i} == 'jdk-8u171-linux-x64.tar.gz' ]; then
		fileNum=$[$fileNum+1]
	fi
	if [ ${i} == 'mysql-5.7.12-linux-glibc2.5-x86_64.tar' ]; then
		fileNum=$[$fileNum+1]
	fi
	if [ ${i} == 'redis-5.0.5.tar.gz' ]; then
		fileNum=$[$fileNum+1]
	fi
	echo $i
done

if [ $fileNum -eq 3 ]; then
	echo "文件正常，准备安装。。。"
else
	echo "安装文件缺失，请上传全部安装文件。。。"
	exit
fi

echo "继续执行安装程序。。。"





cd /root/ck

############################################################################################################






#开始安装mysql

echo "初始化mysql系统用户"

#判断mysql用户是否存在，不存在则创建
isMysqluser=$(cat /etc/group | grep mysql)
sqlUserNum=0
for i in $isMysqluser; do
	if [[ ${i} =~ "mysql:" ]]; then
		sqlUserNum=$[$sqlUserNum+1]
	fi
	echo $i
done

#echo $sqlUserNum

if [ ! $sqlUserNum -eq 1 ]; then
	echo "mysql用户不存在,创建mysql用户中。。。"
	$(groupadd mysql)
	$(useradd -r -g mysql mysql)
	echo "mysql用户创建成功。。。"
fi



#开始解压mysql安装包
echo "解压mysql安装包。。。"
tar xvf mysql-5.7.12-linux-glibc2.5-x86_64.tar && mkdir /usr/local/apps/

#暂停10秒执行下一个操作
ti1=`date +%s`    #获取时间戳
ti2=`date +%s`
i=$(($ti2 - $ti1 ))
while [[ "$i" -lt "10" ]]   
do
	ti2=`date +%s`
	i=$(($ti2 - $ti1 ))
done


tar -zxvf mysql-5.7.12-linux-glibc2.5-x86_64.tar.gz -C /usr/local/apps/


#暂停20秒执行下一个操作
ti3=`date +%s`    #获取时间戳
ti4=`date +%s`
i=$(($ti4 - $ti3 ))
while [[ "$i" -lt "20" ]]   
do
	ti4=`date +%s`
	i=$(($ti4 - $ti3 ))
done


echo "创建mysql软连接"
cd /usr/local/apps/ && ln -s mysql-5.7.12-linux-glibc2.5-x86_64 mysql

echo "初始化mysql基础库"
/usr/local/apps/mysql/bin/mysqld --initialize --user=mysql --datadir=/usr/local/apps/mysql/data --basedir=/usr/local/apps/mysql

echo "创建mysql日志输出"
cd  /usr/local/apps/mysql/ && mkdir  tmp && chown -R mysql:mysql  tmp

echo "创建mysql快捷方式"
cp  /usr/local/apps/mysql/support-files/mysql.server  /etc/init.d/mysql && chmod +x /etc/init.d/mysql

chkconfig --add mysql

echo "删除历史mysql配置文件"
rm -rf /etc/my.cnf



echo "初始化mysql配置文件"
cat > /etc/my.cnf <<EOF
[mysqld]
character-set-server = utf8
basedir = /usr/local/apps/mysql
datadir = /usr/local/apps/mysql/data
port = 3306
socket = /usr/local/apps/mysql/tmp/mysql.sock

lower_case_table_names=1

skip-grant-tables

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
[client]
default-character-set=utf8
socket=/usr/local/apps/mysql/tmp/mysql.sock

[mysql]
default-character-set=utf8
socket=/usr/local/apps/mysql/tmp/mysql.sock
EOF


echo "设置mysql的环境变量"
echo "export MYSQL_HOME=/usr/local/apps/mysql" >> /etc/profile
echo "export PATH=\$PATH:\$MYSQL_HOME/bin" >> /etc/profile
source  /etc/profile



echo "启动mysql服务，并将root用户初始化"
service mysql start

mysql -uroot  -e "update mysql.user set authentication_string=password('CkioskWuhan01') where user='root';"
mysql -uroot  -e "use mysql;update user set host='%',password_expired='N' where user='root' and host='localhost';"
mysql -uroot  -e "flush privileges;"

service mysql stop

echo "去掉mysql免登陆"
sed -i "s/skip-grant-tables/ /g" /etc/my.cnf

echo "重启mysql。。。"
service mysql start

#关闭防火墙
echo "关闭防火墙"
service firewalld stop



cd /root/ck




############################################################################################################




#开始安装redis
echo "开始安装redis依赖包。。。"
yum -y install gcc automake autoconf libtool make

echo "解压redis。。。"
tar -zxvf redis-5.0.5.tar.gz -C /usr/local/apps/

#暂停20秒
ti5=`date +%s`    #获取时间戳
ti6=`date +%s`
i=$(($ti6 - $ti5 ))
while [[ "$i" -lt "20" ]]   
do
	ti6=`date +%s`
	i=$(($ti6 - $ti5 ))
done


cd /usr/local/apps/redis-5.0.5

echo "开始安装redis。。。"
make MALLOC=libc

cd src && make install

echo "初始化redis。。。"

sed -i "s/daemonize no/daemonize yes/g" /usr/local/apps/redis-5.0.5/redis.conf

sed -i "s/# requirepass foobared/requirepass CkioskWuhan01/g" /usr/local/apps/redis-5.0.5/redis.conf

echo "设置redis开机启动。。。"
cd  /etc
mkdir redis
cp /usr/local/apps/redis-5.0.5/redis.conf /etc/redis/6379.conf
cp /usr/local/apps/redis-5.0.5/utils/redis_init_script /etc/init.d/redisd
cd  /etc/init.d
chkconfig redisd on

echo "redis启动。。。"
service redisd start



cd /root/ck



############################################################################################################








#开始安装java
echo "开始安装java服务。。。"

cd /home/
mkdir java
chmod -R 777 java

cd /root/ck

tar -zxvf jdk-8u171-linux-x64.tar.gz -C /home/java/


echo "配置java环境变量。。。"
echo "export JAVA_HOME=/home/java/jdk1.8.0_171" >> /etc/profile
echo "export CLASSPATH=.:\$JAVA_HOME/jre/lib/rt.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile
echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile
. /etc/profile

java -version

echo "java环境安装完成。。。"


cd /root/ck



############################################################################################################