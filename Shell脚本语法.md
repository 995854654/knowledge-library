## shell脚本语法

打印日志：`echo "xxxx"`

获取当前日期(20211208)：`$(date "+%Y%m%d")`

判断：

```text
-e filename 如果 filename存在，则为真 
-d filename 如果 filename为目录，则为真 
-f filename 如果 filename为常规文件，则为真 
-L filename 如果 filename为符号链接，则为真 
-r filename 如果 filename可读，则为真 
-w filename 如果 filename可写，则为真 
-x filename 如果 filename可执行，则为真 
-s filename 如果文件长度不为0，则为真 
-h filename 如果文件是软链接，则为真
比如：
判断文件夹是否存在，不存在，则创建文件夹
if [ ! -d $DATE ];then
        mkdir $DATE
fi
```

调用变量

```shell
# 变量赋值不能有空格
PATH="/data/local/lib/bk/"
echo $PATH
```

脚本案例

备份数据库数据

[<font color='aqua'>备份脚本</font>](资源包/backup.sh)

```shell
DATE=$(date "+%Y%m%d")
bk="/data/local/lib/bk/$DATE"
USER="root"
PASSWORD="Sd_12345"
if [ ! -d $bk ];then
        mkdir -p $bk
fi
cd $bk
mysqldump -u$USER -p$PASSWORD -h127.0.0.1 byrsjyzx > byrsjyzx_$DATE.sql
mysqldump -u$USER -p$PASSWORD -h127.0.0.1 bysjybt > bysjybt_$DATE.sql
mysqldump -u$USER -p$PASSWORD -h127.0.0.1 lcy > lcy_$DATE.sql
mysqldump -u$USER -p$PASSWORD -h127.0.0.1 cyddjybt > cyddjybt_$DATE.sql
```

### $的使用

```text
$HOME 用户主目录名
$0  获取调用该程序的名字
$1-$9 shell程序的位置参量
$* 所有位置参数
$# 位置参数的个数
$$  当前命令大的进程标识
```

例子：

```shell
# test.sh
echo $HOME;
echo $$;
echo $2;
echo $0;
echo $#;
echo $@;
echo $*;
```

启动脚本：`sh test.sh "yangjj" 10 20 "yyds"`

```text
/root
4700  # 进程标识
10  # 输入的第二个参数
test.sh  # 该程序的名字
4  # 输入了四个参数
yangjj 10 20 yyds  # 返回全部参数 相当于 $1 $2 $3
yangjj 10 20 yyds  # 返回全部参数
```

## 数据库操作

```shell
USERNAME="root"
PASSWORD="Sd_12345"
DB="lcy"
USERID="fb148b8b-cf78-4798-9222-690ca9c59b2d"
CONN="mysql -u$USERNAME -p$PASSWORD"
$CONN -e "SHOW DATABASES;"
$CONN $DB -e "show tables;"

# -N 不输出列名(字段名)
# -B 不输出数据之间的边框竖线 (|)
# -s 不要表头
# 输出格式可以是其他的，比如 -H 输出 HTML 格式
```

## 循环

```shell
for 变量名 in 变量列表
do
	命令序列
done
```

## 判断

```shell
if [ command ];then
	符合该条件执行的语句
elif [ command ];then
	符合该条件执行的语句
else 
	符合该条件执行的语句	
fi	
#数字比较大小
INT1 -eq INT2           INT1和INT2两数相等为真 ,=
INT1 -ne INT2           INT1和INT2两数不等为真 ,<>
INT1 -gt INT2            INT1大于INT1为真 ,>
INT1 -ge INT2           INT1大于等于INT2为真,>=
INT1 -lt INT2             INT1小于INT2为真 ,<</div>
INT1 -le INT2             INT1小于等于INT2为真,<=

# 字符串比较大小
#> = >= <= != 
#注意：需要添加转义符
```

## 正则匹配

提取正则匹配的字符串

```shell
# grep
string1="fe23c18e-ba59-408f-b29b-cd0d2c93e5ad_0.0.1_招用工补贴-抓取企业信息-新版设计器_python_2022-01-04_23-03-21.zip"
regex="fe23c18e-ba59-408f-b29b-cd0d2c93e5ad_[0-9]\.[0-9]\.[0-9]_(.*)_python.*"
echo $string1|grep -P $regex -o
# -P 开启正则匹配模式
# -o 只输出匹配的字符串
# fe23c18e-ba59-408f-b29b-cd0d2c93e5ad_0.0.1_招用工补贴-抓取企业信息-新版设计器_python_2022-01-04_23-03-21.zip

# sed
string1="fe23c18e-ba59-408f-b29b-cd0d2c93e5ad_0.0.1_招用工补贴-抓取企业信息-新版设计器_python_2022-01-04_23-03-21.zip"
regex="s/fe23c18e-ba59-408f-b29b-cd0d2c93e5ad_[0-9]\.[0-9]\.[0-9]_\(.*\)_python.*/\1/g"
# s/  替换
# \1 表示用第一个括号里面的内容替换整个字符串
# /g  结束
# 括号一定加转义符
# 基本公式： s/内容1(内容2)内容3/\1/g   ---> 内容2， 如果适用/，记得加转义符
echo $string1|sed $regex
# 招用工补贴-抓取企业信息-新版设计器
```

## echo赋值给新变量

```shell
version=`echo ${item}|sed $regex_version`
echo ${item} :version
```

## 定义一个字典

``` shell
declare -A dict
dict["a"]="0.01"
dict=([zhangsan]=93\
	[lisi]=52\
	[wangwu]=32
)
echo ${!dict[*]}  # 打印字典中所有的keys
echo ${dict[*]}  # 打印字典中所有的values
```

## 定义一个数组

```shell
declare -a arr
arr[0]=1
arr[1]=2
echo ${arr[*]}

```

## 备份控制台所有的最新版流程脚本

```shell
declare -A chart_dict
declare -A chart_file_dict
USERNAME=root
PASSWORD=123456
now_date=$(date "+%Y%m%d")
# 用户ID
USERID="fe23c18e-ba59-408f-b29b-cd0d2c93e5ad"
# 备份位置
location=/data/local/lib/backup/$now_date
DBNAME="lcy"
CONN="mysql -u${USERNAME} -p${PASSWORD} ${DBNAME}"
SQL="SELECT flow_chart_path from process_version where file_name like '%${USERID}%';"
SQL_RESULT=`$CONN -e "$SQL" -s -N -B`
count=0

regex_version="s/.*\/${USERID}_\([0-9]*\.[0-9]*\.[0-9]*\)_\(.*\)_flowchart.*/\1/g"
regex_name="s/.*\/${USERID}_\([0-9]*\.[0-9]*\.[0-9]*\)_\(.*\)_flowchart.*/\2/g"
# 获取某个账号的最新版的所有流程名称+版本号
for item in $SQL_RESULT
do
        version=`echo ${item}|sed $regex_version`
        flowchart_name=`echo ${item}|sed $regex_name`
        if [ -n art_dict[$flowchart_name] ];then
                chart_dict[$flowchart_name]=$version
                chart_file_dict[$flowchart_name]=$item
        else
                temp_version=$chart_dict[$flowchart_name]
                if [ $version \> $temp_version ];then
                        chart_dict[$flowchart_name]=$version
                        chart_file_dict[$flowchart_name]=$item
                fi
        fi

done


#开始备份数据
if [ ! -d $location ];then
        mkdir -p $location
fi
# 打印筛选的结果
for key in ${!chart_dict[*]}
do
        cp ${chart_file_dict[$key]} ${location}/$key.zip
        echo "流程${key},流程版本号：${chart_dict[$key]}备份完成"
        #echo "流程名字：$key,流程版本号：${chart_dict[$key]}，流程路径：${chart_file_dict[$key]}"
        
done
```



## 项目启动脚本

注意：

- -n 判断是否为非空，非空为true，空为false
- -z 判断是否为空，空为true，非空为false

```shell
networkmanager_status=$(systemctl is-active NetworkManager)
if [ "$networkmanager_status" = "active" ]
then
    systemctl stop NetworkManager
    echo "网络管理器已关闭！！！"
fi




firewalld_status=$(systemctl is-active firewalld)

if [ "$firewalld_status" = "active" ]
then
    systemctl stop firewalld
    echo "防火墙已关闭！！！"
fi

docker_status=$(systemctl is-active docker)
if [ "$docker_status" = "inactive" ]
then
    systemctl start docker
    echo "docker启动完成"
else
    systemctl restart docker
    echo "docker重新启动"
fi
echo "docker mysql容器重新启动。。"


# 判断容器是否需要重新启动
mysql_container_status=$(docker inspect -f '{{.State.Status}}' mysql 2>/dev/null)
if [ "$mysql_container_status" == "running" ]
then
    docker stop mysql
    echo "docker mysql容器停止运行"
fi

docker start mysql
echo "docker mysql容器运行。。"

# -n 判断是否为非空，非空为true，空为false
# -z 判断是否为空，空为true，非空为false
# redis重启
redis_port=$(lsof -Pi :6379 -sTCP:LISTEN -t)
if [ -n "$jyzx_port" ]
then
    kill -9 $(lsof -i:6379 -t)
fi
# 后台模式启动
redis-server /usr/local/lib/redis/redis.conf --daemonize yes



# 启动就业系统项目文件
# 判断端口是否被占用，占用则杀掉再重新启动
jyzx_port=$(lsof -Pi :5000 -sTCP:LISTEN -t)
if [ -n "$jyzx_port" ]
then
    kill -9 $(lsof -i:5000 -t)
fi
cd /usr/local/lib/ldjyzx/jyzx
nohup python37 main.py > out.log 2>&1 &
echo "就业系统启动！！！"

# 启动人才引进项目文件
jyzx_port=$(lsof -Pi :5001 -sTCP:LISTEN -t)
if [ -n "$jyzx_port" ]
then
    kill -9 $(lsof -i:5001 -t)
fi
```

