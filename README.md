脚本中的安装包下载地址(百度网盘)：

    链接：https://pan.baidu.com/s/1R5FLTvDdNngPgYzjOKWG-w 
    提取码：hcgg

文件全部下载到服务器。

将脚本`install-Mysql-Redis-Java.sh`和`安装包`放到同一个位置。

脚本中mysql和redis的默认密码都是：BenShuaiOne

可按需修改

然后执行   
    
    ./install-Mysql-Redis-Java.sh

注意：部分环境下运行会报  \r   的错，是因为编码格式问题，请在linux中重新新建文件并复制内容，即可正常执行,

或者使用如下方法修改文件的编码:


修改从windows上传到linux的sh文件的编码（按顺序执行下面的命令）

vi 文件名
esc
:set ff=unix
esc
:wq