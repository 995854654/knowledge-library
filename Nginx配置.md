### root和alias的区别

> **nginx** **指定文件路径有两种方式root和alias，这两者的用法区别，使用方法总结了下，方便大家在应用过程中，快速响应。root与alias主要区别在于nginx如何解释location后面的uri，这会使两者分别以不同的方式将请求映射到服务器文件上。**

**root**:

```nginx
location ~ ^/weblogs/ {
     root /data/weblogs/wwwttlsa.com;
}
```

如果用户访问 /weblogs/httplogs/wwwttlsa.com-access.log，

那实际上访问：<font color='red'>/data/weblogs/wwwttlsa.com</font><font color='aqua'>/weblogs/httplogs/wwwttlsa.com-access.log</font>

alias

```nginx
location ~ ^/weblogs/ {
     alias /data/weblogs/wwwttlsa.com;
}
```

如果用户访问 /weblogs/httplogs/wwwttlsa.com-access.log，

那实际上访问：<font color='red'>/data/weblogs/wwwttlsa.com</font><font color='aqua'>/httplogs/wwwttlsa.com-access.log</font>

### 同一个端口下部署多个前端项目

```nginx
location  /fangyi {
                alias /usr/local/lib/fangyi;
                index index.html;
                try_files $uri $uri/ /index.html;
}
```

如果是react或者vue项目，则需要在package.json添加  **"homepage": "./"**

###  查看本地的静态文件

> 访问/app时，跳转访问本地/home/app目录下的文件
>
> **autoindex on 是可以查看该目录下的文件列表。**

```nginx
 location /app {
                        alias /home/app;
                        proxy_http_version 1.1;
                        proxy_send_timeout 300;
                        proxy_read_timeout 900;
                        proxy_set_header Host $host:$server_port;
                        autoindex on;
        }
```

### 跨域请求nginx配置

在http模块中添加

```nginx
http {
    add_header Access-Control-Allow-Origin *; //允许所有域名跨域访问代理地址
add_header Access-Control-Allow-Headers X-Requested-With;
add_header Access-Control-Allow-Methods GET; //跨域请求访问请求方式，
}
```



###  监控访问IP

```nginx
location /api{
            proxy_pass http://127.0.0.1:5000/api;
            proxy_set_header   Host             $host;
            proxy_set_header   X-Real-IP        $remote_addr;
            proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
}
		   
```

### 前端项目配置

```nginx
location / {
                root /usr/local/lib/build;
                index index.html;
                proxy_http_version 1.1;
                proxy_set_header Upgrade  $http_upgrade;
                proxy_set_header Connection "Upgrade";
                client_max_body_size 100m;
                try_files $uri $uri/ /index.html;

        }
```

### websocket配置

```nginx
location / {
    		proxy_http_version 1.1;
			proxy_set_header Upgrade $http_upgrade;
			proxy_set_header Connection "upgrade";
}

```

```text
其中第一行是告诉nginx使用HTTP/1.1通信协议，这是websoket必须要使用的协议。

第二行和第三行告诉nginx，当它想要使用WebSocket时，响应http升级请求。
```



**Flask项目配置**

```python
addr = request.environ.get('HTTP_X_FORWARDED_FOR',None)  打印ip
print(addr)
```

### 3、 加快访问速度

**设置缓冲大小**

```nginx
location /api{
            proxy_pass http://127.0.0.1:5000/api;
            proxy_set_header   Host             $host;
            proxy_set_header   X-Real-IP        $remote_addr;
            proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
            proxy_buffer_size 64k;
        	proxy_buffers 4 32k;
        	proxy_busy_buffers_size 64k;
}

```

### 问题处理

`open() "/usr/local/nginx/proxy_temp/3/00/0000000003" failed (13: Permission denied) while reading upstream`

响应数据超过nginx的缓冲区，所以数据加载不出来

设置nginx的缓冲区即可

```nginx
proxy_buffer_size 64k;
        	proxy_buffers 4 32k;
        	proxy_busy_buffers_size 64k;
```



## nginx添加安全配置

### nginx版本信息隐藏

```nginx
server_tokens off;
```



### proxy_buffers和client_body_buffer_size的区别

client_body_buffer_size 　　
   处理客户端请求体buffer大小。用来处理POST提交数据，上传文件等。

client_body_buffer_size

  需要足够大以容纳如果需要上传POST数据。

proxy_buffers
处理后端响应，一般是代理服务器请求后端服务的response。

如果这个buffer不够大，会引起磁盘IO，response的body内容会先写入临时目录中。




### 隐藏Nginx后端服务X-Powered-By头

在http下配置proxy_hide_header项

增加或修改为

```nginx
http {
    proxy_hide_header X-Power-By;
	proxy_hide_header Server;
}

```



### 黑白名单设置：http、server、location、limit_except

如果网站被恶意灌水或CC攻击，可以从网站日志中分析特征IP，将其IP或IP段进行屏蔽

```nginx
http{
    # 更多的时候客户端请求会经过层层代理，我们需要通过$http_x_forwarded_for来进行限制，可以这样写
	set $allow false;
	if ($http_x_forwarded_for = "211.144.204.2") { set $allow true; }
	if ($http_x_forwarded_for ~ "108.2.66.[89]") { set $allow true; }
	if ($allow = false) { return 404; }
    
    
    server {
        白名单：
        # 只允许192.168.1.0/24网段的主机访问，拒绝其他所有
        location /path/ {
            allow 192.168.1.0/24;
            deny all;
        }
        
        黑名单：
        location /path/ {
            deny 192.168.1.0/24;
            allow all;
        }
    }
    
    
}




```



### 屏蔽非常见爬虫



```nginx
# 分析网站日志发现，一些奇怪的 UA 总是频繁的来访问，而这些 UA 对网站毫无意义，反而给服务器增加压力，可以直接将其屏蔽。 
# ~ 开启正则匹配
if ($http_user_agent ~(SemrushBot|python|MJ12bot|AhrefsBot|AhrefsBot|hubspot|opensiteexplorer|leiki|webmeup)) {
 
    return 444;
 
}
```



上面规则报错 444 状态码而不是 403。444 状态码在 nginx 的中有特殊含义，nginx 的 444 状态是直接由服务器中断连接，不会向客户端再返回任何消息。比返回 403 更加暴力。 



### 禁止某个目录执行脚本

 网站目录，通常存放的都是静态文件，如果因程序验证不严谨被上传木马程序，导致网站被黑。以下规则请根据自身情况改为您自己的目录，需要禁止的脚本后缀也可以自行添加。 

```nginx
#uploads|templets|data 这些目录禁止执行 <a href="https://hexsen.com/tag/phpcode" title="更多关于 PHP 的文章" target="_blank">PHP</a>

location ~* ^/(uploads|templets|data)/.*.(php|php5)$ {
    return 444;
}

```

### 防止文件被下载

比如将网站数据库导出到站点根目录进行备份，很有可能也会被别人下载，从而导致数据丢失的风险。以下规则可以防止一些常规的文件被下载，可根据实际情况增减。 

```nginx
location ~ \.(zip|rar|sql|bak|gz|7z)$ {
    return 444;
} 
```



### 防止XSS攻击：server 

在通常的请求响应中，浏览器会根据Content-Type来分辨响应的类型，但当响应类型未指定或错误指定时，浏览会尝试启用MIME-sniffing来猜测资源的响应类型，这是非常危险的,例如一个.jpg的图片文件被恶意嵌入了可执行的js代码，在开启资源类型猜测的情况下，浏览器将执行嵌入的js代码，可能会有意想不到的后果

```nginx
add_header X-Frame-Options "SAMEORIGIN";

add_header X-XSS-Protection "1; mode=block";

add_header X-Content-Type-Options "nosniff";

* X-Frame-Options： 响应头表示是否允许浏览器加载frame等属性，有三个配置

    DENY：禁止任何网页被嵌入;

    SAMEORIGIN: 只允许本网站的嵌套;

    ALLOW-FROM: 允许指定地址的嵌套;

* X-XSS-Protection： 表示启用XSS过滤（禁用过滤为X-XSS-Protection: 0），mode=block表示若检查到XSS攻击则停止渲染页面

* X-Content-Type-Options： 响应头用来指定浏览器对未指定或错误指定Content-Type资源真正类型的猜测行为，nosniff 表示不允许任何猜测;

```



定义页面可以加载哪些资源，上边的配置会限制所有的外部资源，都只能从当前域名加载，其中default-src定义针对所有类型资源的默认加载策略，self允许来自相同来源的内容

add_header Content-Security-Policy "default-src 'self'";

add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";

会告诉浏览器用HTTPS协议代替HTTP来访问目标站点，上边的配置表示当用户第一次访问后，会返回一个包含了Strict-Transport-Security响应头的字段，这个字段会告诉浏览器，在接下来的31536000秒内，当前网站的所有请求都使用https协议访问，参数includeSubDomains是可选的，表示所有子域名也将采用同样的规则



### 防盗链：server、location



valid_referers： 验证referer，

none：允许referer为空

blocked：允许不带协议的请求

除了以上两类外仅允许referer为www.ops-coffee.cn或ops-coffee.cn时访问images下的图片资源，否则返回403

```nginx
location /images/ {
    valid_referers none blocked www.ops-coffee.cn ops-coffee.cn;
    if ($invalid_referer) {
        return 403;
    }    
}
```



给不符合referer规则的请求重定向到一个默认的图片

```nginx
location /images/ {
    valid_referers blocked www.ops-coffee.cn ops-coffee.cn
    if ($invalid_referer) {
        rewrite ^/images/.*\.(gif|jpg|jpeg|png)$ /static/qrcode.jpg last;
    }
}
```





### 添加账号认证：http、server、location

```nginx
server {

    location / {

        auth_basic "please input user&passwd";

        auth_basic_user_file key/auth.key;

    }

}
```

