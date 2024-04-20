# 知识点

## 指令大全网站

![image-20240115143837059](images/image-20240115143837059.png)



## Systemd

`Systemd`是linux的系统工具，用来启动守护进程

Systemd并不是一个命令，是一组命令，涉及到系统管理的方方面面

`systemctl`是Systemd的主命令，用于管理系统

### systemctl相关指令集合

```text
# 重启系统
systemctl reboot

# 关闭系统
systemctl poweroff

# CPU停止工作
systemctl halt

# 暂停系统
systemctl suspend

# 让系统进入冬眠状态
systemctl hibernate

# 启动docker服务
systemctl start docker

# 查看docker进程状态
systemctl status docker

# 停止docker进程
systemctl stop docker
```

### systemd-analyze相关指令集合

`systemd-analyze`命令用于查看启动耗时。

```text
# 查看每个服务的启动耗时
systemd-analyze blame

# 显示指定服务的启动流
systemd-analyze critical-chain atd.service
```





# 代码片段

## 设置定时任务

```text
设置脚本的定时任务
#通过crontab计划任务运行sh脚本
执行命令：  crontab -e
添加一行记录：
0 23 * * * /bin/bash /data/mysql_bak/mysql_dump.sh
#从左往右分别表示“分 时 日 月 星期”
#如上面例子：0表示0分，23表示时间23点，*表示任意数（此处可理解未占位符）
##查看最新的计划任务
执行命令：  crontab -l
```







# 问题集

## 云服务器部署与本地部署的区别

1. 服务器位置不同。本地服务器一般都在用户办公室或者数据中心。云服务器则在云服务器提供商的数据中心。
2. 灵活性不一样。云服务器可以根据自身需求随时增加或减少服务器资源。本地服务器则需要用户购买和维护固定的硬件。
3. 可拓展性不一样。云服务器可以轻松拓展到多个地理位置，达到更好的性能和可用性。本地服务器需要自行处理拓展和负载均衡。
4. 成本不一样。云服务器通常是按需付费的，用户只需要支付他们实际使用的资源，而本地服务器则需要用户支付固定的硬件成本和运营成本
5. 可靠性不一样。云服务器通常由专业的团队管理和维护，具有更高的可靠性和可用性。本地服务器需要自行管理和维护。

