脚本中的安装包下载地址(百度网盘)：

    链接：https://pan.baidu.com/s/1R5FLTvDdNngPgYzjOKWG-w 
    提取码：hcgg

文件全部下载到 `/root/ck/` 目录。也可以自行修改脚本中的目录到自己需要的目录。

将脚本`install-Mysql-Redis-Java.sh`和`安装包`放到同一个位置(并修改脚本中的 `softDir`值 改成自己上传的目录)。

脚本中mysql和redis的默认密码都是：CkioskWuhan01

可按需修改

然后执行   
    
    ./install-Mysql-Redis-Java.sh

注意：部分环境下运行会报  \r   的错，是因为编码格式问题，请在linux中重新新建文件并复制内容，即可正常执行。