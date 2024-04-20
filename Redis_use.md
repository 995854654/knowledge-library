## 数据类型

- String: 字符串
- Hash: 哈希
- List: 列表
- Set: 集合
- Sorted Set: 有序集合

## 基本指令

### redis配置

查看所有配置：`config get *`

### String类型

设置键值对：`set aa "stronger"`

获取设置的键的值：`get aa`  ==> "stronger"

删除设置的键：`del aa`

### Hash哈希

设置多个键值对：`HMSET runoob field1 "Hello" field2 "World"`

获取设置的某个键的值：`HGET runoob field2`  ==> "World"

### List列表

支持一次性添加多个

左添加：`lpush runoob "redis"` 

右添加:`rpush runoob "niubi"`

读取列表：`lrange runoob start_index end_index`

- 比如：读取完整列表:`lrange runoob 0 -1`

对已存在的列表左添加：`lpushx field value `

对已存在的列表右添加：`rpushx field value `

- lpush 和 lpushx的区别：
  - lpush：如果没有该列表，则先创建列表，再插入元素，返回列表元素个数。
  - lpushx:如果没有该列表，则不插入元素。如果列表存在，则插入元素，返回列表元素个数。

弹出列表最左侧元素，返回元素：`lpop todo-list`

弹出列表最右侧元素，返回元素：`rpop todo-list` 

获取列表长度：`llen todo-list`

更换列表索引为2的值：`lset todo-list 2 "xxx"`

在列表某个元素（前或者后）处插入元素：`linsert todo-list before|after "yyy" "xxx"`

修剪列表：`ltrim todo-list 0 5`

移除列表元素：`lrem list count element`

- count参数决定了lrem命令移除元素的方式：
  - 如果count参数的值等于0，那么lrem命令将移除列表中包含的所有指定元素
    如果count参数的值大于0，那么lrem命令将从列表的左端开始向右进行检查，并移除最先发现的count个指定元素
    如果count参数的值小于0，那么lrem命令将从列表的右端开始向左进行检查，并移除最先发现的abs(count)个指定元素（abs(count) 即count的绝对值）



### 键操作

| 方法               | 作用                                         | 参数说明                   | 示例                             | 示例说明                     | 示例结果  |
| ------------------ | -------------------------------------------- | -------------------------- | -------------------------------- | ---------------------------- | --------- |
| exists(name)       | 判断一个键是否存在                           | name：键名                 | redis.exists('name')             | 是否存在name这个键           | True      |
| delete(name)       | 删除一个键                                   | name：键名                 | redis.delete('name')             | 删除name这个键               | 1         |
| type(name)         | 判断键类型                                   | name：键名                 | redis.type('name')               | 判断name这个键类型           | b'string' |
| keys(pattern)      | 获取所有符合规则的键                         | pattern：匹配规则          | redis.keys('n*')                 | 获取所有以n开头的键          | [b'name'] |
| randomkey()        | 获取随机的一个键                             |                            | randomkey()                      | 获取随机的一个键             | b'name'   |
| rename(src, dst)   | 重命名键                                     | src：原键名；dst：新键名   | redis.rename('name', 'nickname') | 将name重命名为nickname       | True      |
| dbsize()           | 获取当前数据库中键的数目                     |                            | dbsize()                         | 获取当前数据库中键的数目     | 100       |
| expire(name, time) | 设定键的过期时间，单位为秒                   | name：键名；time：秒数     | redis.expire('name', 2)          | 将name键的过期时间设置为2秒  | True      |
| ttl(name)          | 获取键的过期时间，单位为秒，-1表示永久不过期 | name：键名                 | redis.ttl('name')                | 获取name这个键的过期时间     | -1        |
| move(name, db)     | 将键移动到其他数据库                         | name：键名；db：数据库代号 | move('name', 2)                  | 将name移动到2号数据库        | True      |
| flushdb()          | 删除当前选择数据库中的所有键                 |                            | flushdb()                        | 删除当前选择数据库中的所有键 | True      |
| flushall()         | 删除所有数据库中的所有键                     |                            | flushall()                       | 删除所有数据库中的所有键     | True      |

###  字符串操作

| 方法                          | 作用                                                         | 参数说明                                                     | 示例                                                         | 示例说明                                         | 示例结果                                    |
| ----------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------ | ------------------------------------------- |
| set(name, value)              | 给数据库中键为name的string赋予值value                        | name: 键名；value: 值                                        | redis.set('name', 'Bob')                                     | 给name这个键的value赋值为Bob                     | True                                        |
| get(name)                     | 返回数据库中键为name的string的value                          | name：键名                                                   | redis.get('name')                                            | 返回name这个键的value                            | b'Bob'                                      |
| getset(name, value)           | 给数据库中键为name的string赋予值value并返回上次的value       | name：键名；value：新值                                      | redis.getset('name', 'Mike')                                 | 赋值name为Mike并得到上次的value                  | b'Bob'                                      |
| mget(keys, *args)             | 返回多个键对应的value                                        | keys：键的列表                                               | redis.mget(['name', 'nickname'])                             | 返回name和nickname的value                        | [b'Mike', b'Miker']                         |
| setnx(name, value)            | 如果不存在这个键值对，则更新value，否则不变                  | name：键名                                                   | redis.setnx('newname', 'James')                              | 如果newname这个键不存在，则设置值为James         | 第一次运行结果是True，第二次运行结果是False |
| setex(name, time, value)      | 设置可以对应的值为string类型的value，并指定此键值对应的有效期 | name: 键名；time: 有效期； value：值                         | redis.setex('name', 1, 'James')                              | 将name这个键的值设为James，有效期为1秒           | True                                        |
| setrange(name, offset, value) | 设置指定键的value值的子字符串                                | name：键名；offset：偏移量；value：值                        | redis.set('name', 'Hello') redis.setrange('name', 6, 'World') | 设置name为Hello字符串，并在index为6的位置补World | 11，修改后的字符串长度                      |
| mset(mapping)                 | 批量赋值                                                     | mapping：字典                                                | redis.mset({'name1': 'Durant', 'name2': 'James'})            | 将name1设为Durant，name2设为James                | True                                        |
| msetnx(mapping)               | 键均不存在时才批量赋值                                       | mapping：字典                                                | redis.msetnx({'name3': 'Smith', 'name4': 'Curry'})           | 在name3和name4均不存在的情况下才设置二者值       | True                                        |
| incr(name, amount=1)          | 键为name的value增值操作，默认为1，键不存在则被创建并设为amount | name：键名；amount：增长的值                                 | redis.incr('age', 1)                                         | age对应的值增1，若不存在，则会创建并设置为1      | 1，即修改后的值                             |
| decr(name, amount=1)          | 键为name的value减值操作，默认为1，键不存在则被创建并将value设置为-amount | name：键名； amount：减少的值                                | redis.decr('age', 1)                                         | age对应的值减1，若不存在，则会创建并设置为-1     | -1，即修改后的值                            |
| append(key, value)            | 键为name的string的值附加value                                | key：键名                                                    | redis.append('nickname', 'OK')                               | 向键为nickname的值后追加OK                       | 13，即修改后的字符串长度                    |
| substr(name, start, end=-1)   | 返回键为name的string的子串                                   | name：键名；start：起始索引；end：终止索引，默认为-1，表示截取到末尾 | redis.substr('name', 1, 4)                                   | 返回键为name的值的字符串，截取索引为1~4的字符    | b'ello'                                     |
| getrange(key, start, end)     | 获取键的value值从start到end的子字符串                        | key：键名；start：起始索引；end：终止索引                    | redis.getrange('name', 1, 4)                                 | 返回键为name的值的字符串，截取索引为1~4的字符    | b'ello'                                     |



### 列表操作

| 方法                     | 作用                                                         | 参数说明                                          | 示例                             | 示例说明                                                     | 示例结果           |
| ------------------------ | ------------------------------------------------------------ | ------------------------------------------------- | -------------------------------- | ------------------------------------------------------------ | ------------------ |
| rpush(name, *values)     | 在键为name的列表末尾添加值为value的元素，可以传多个          | name：键名；values：值                            | redis.rpush('list', 1, 2, 3)     | 向键为list的列表尾添加1、2、3                                | 3，列表大小        |
| lpush(name, *values)     | 在键为name的列表头添加值为value的元素，可以传多个            | name：键名；values：值                            | redis.lpush('list', 0)           | 向键为list的列表头部添加0                                    | 4，列表大小        |
| llen(name)               | 返回键为name的列表的长度                                     | name：键名                                        | redis.llen('list')               | 返回键为list的列表的长度                                     | 4                  |
| lrange(name, start, end) | 返回键为name的列表中start至end之间的元素                     | name：键名；start：起始索引；end：终止索引        | redis.lrange('list', 1, 3)       | 返回起始索引为1终止索引为3的索引范围对应的列表               | [b'3', b'2', b'1'] |
| ltrim(name, start, end)  | 截取键为name的列表，保留索引为start到end的内容               | name：键名；start：起始索引；end：终止索引        | ltrim('list', 1, 3)              | 保留键为list的索引为1到3的元素                               | True               |
| lindex(name, index)      | 返回键为name的列表中index位置的元素                          | name：键名；index：索引                           | redis.lindex('list', 1)          | 返回键为list的列表索引为1的元素                              | b’2’               |
| lset(name, index, value) | 给键为name的列表中index位置的元素赋值，越界则报错            | name：键名；index：索引位置；value：值            | redis.lset('list', 1, 5)         | 将键为list的列表中索引为1的位置赋值为5                       | True               |
| lrem(name, count, value) | 删除count个键的列表中值为value的元素                         | name：键名；count：删除个数；value：值            | redis.lrem('list', 2, 3)         | 将键为list的列表删除两个3                                    | 1，即删除的个数    |
| lpop(name)               | 返回并删除键为name的列表中的首元素                           | name：键名                                        | redis.lpop('list')               | 返回并删除名为list的列表中的第一个元素                       | b'5'               |
| rpop(name)               | 返回并删除键为name的列表中的尾元素                           | name：键名                                        | redis.rpop('list')               | 返回并删除名为list的列表中的最后一个元素                     | b'2'               |
| blpop(keys, timeout=0)   | 返回并删除名称在keys中的list中的首个元素，如果列表为空，则会一直阻塞等待 | keys：键列表；timeout： 超时等待时间，0为一直等待 | redis.blpop('list')              | 返回并删除键为list的列表中的第一个元素                       | [b'5']             |
| brpop(keys, timeout=0)   | 返回并删除键为name的列表中的尾元素，如果list为空，则会一直阻塞等待 | keys：键列表；timeout：超时等待时间，0为一直等待  | redis.brpop('list')              | 返回并删除名为list的列表中的最后一个元素                     | [b'2']             |
| rpoplpush(src, dst)      | 返回并删除名称为src的列表的尾元素，并将该元素添加到名称为dst的列表头部 | src：源列表的键；dst：目标列表的key               | redis.rpoplpush('list', 'list2') | 将键为list的列表尾元素删除并将其添加到键为list2的列表头部，然后返回 | b'2'               |





### 集合操作

| 方法                           | 作用                                                 | 参数说明                                  | 示例                                           | 示例说明                                                    | 示例结果                     |
| ------------------------------ | ---------------------------------------------------- | ----------------------------------------- | ---------------------------------------------- | ----------------------------------------------------------- | ---------------------------- |
| sadd(name, *values)            | 向键为name的集合中添加元素                           | name：键名；values：值，可为多个          | redis.sadd('tags', 'Book', 'Tea', 'Coffee')    | 向键为tags的集合中添加Book、Tea和Coffee这3个内容            | 3，即插入的数据个数          |
| srem(name, *values)            | 从键为name的集合中删除元素                           | name：键名；values：值，可为多个          | redis.srem('tags', 'Book')                     | 从键为tags的集合中删除Book                                  | 1，即删除的数据个数          |
| spop(name)                     | 随机返回并删除键为name的集合中的一个元素             | name：键名                                | redis.spop('tags')                             | 从键为tags的集合中随机删除并返回该元素                      | b'Tea'                       |
| smove(src, dst, value)         | 从src对应的集合中移除元素并将其添加到dst对应的集合中 | src：源集合；dst：目标集合；value：元素值 | redis.smove('tags', 'tags2', 'Coffee')         | 从键为tags的集合中删除元素Coffee并将其添加到键为tags2的集合 | True                         |
| scard(name)                    | 返回键为name的集合的元素个数                         | name：键名                                | redis.scard('tags')                            | 获取键为tags的集合中的元素个数                              | 3                            |
| sismember(name, value)         | 测试member是否是键为name的集合的元素                 | name：键值                                | redis.sismember('tags', 'Book')                | 判断Book是否是键为tags的集合元素                            | True                         |
| sinter(keys, *args)            | 返回所有给定键的集合的交集                           | keys：键列表                              | redis.sinter(['tags', 'tags2'])                | 返回键为tags的集合和键为tags2的集合的交集                   | {b'Coffee'}                  |
| sinterstore(dest, keys, *args) | 求交集并将交集保存到dest的集合                       | dest：结果集合；keys：键列表              | redis.sinterstore('inttag', ['tags', 'tags2']) | 求键为tags的集合和键为tags2的集合的交集并将其保存为inttag   | 1                            |
| sunion(keys, *args)            | 返回所有给定键的集合的并集                           | keys：键列表                              | redis.sunion(['tags', 'tags2'])                | 返回键为tags的集合和键为tags2的集合的并集                   | {b'Coffee', b'Book', b'Pen'} |
| sunionstore(dest, keys, *args) | 求并集并将并集保存到dest的集合                       | dest：结果集合；keys：键列表              | redis.sunionstore('inttag', ['tags', 'tags2']) | 求键为tags的集合和键为tags2的集合的并集并将其保存为inttag   | 3                            |
| sdiff(keys, *args)             | 返回所有给定键的集合的差集                           | keys：键列表                              | redis.sdiff(['tags', 'tags2'])                 | 返回键为tags的集合和键为tags2的集合的差集                   | {b'Book', b'Pen'}            |
| sdiffstore(dest, keys, *args)  | 求差集并将差集保存到dest集合                         | dest：结果集合；keys：键列表              | redis.sdiffstore('inttag', ['tags', 'tags2'])  | 求键为tags的集合和键为tags2的集合的差集并将其保存为inttag`  | 3                            |
| smembers(name)                 | 返回键为name的集合的所有元素                         | name：键名                                | redis.smembers('tags')                         | 返回键为tags的集合的所有元素                                | {b'Pen', b'Book', b'Coffee'} |
| srandmember(name)              | 随机返回键为name的集合中的一个元素，但不删除元素     | name：键值                                | redis.srandmember('tags')                      | 随机返回键为tags的集合中的一个元素                          |                              |

### 有序集合操作

| 方法                                                         | 作用                                                         | 参数说明                                                     | 示例                                                         | 示例说明                                                     | 示例结果                            |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ----------------------------------- |
| zadd(name, *args, **kwargs)                                  | 向键为name的zset中添加元素member，score用于排序。如果该元素存在，则更新其顺序 | name： 键名；args：可变参数                                  | redis.zadd('grade', 100, 'Bob', 98, 'Mike'),<br/>python中使用：redis.zadd("grade",{"Bob"：100}) | 向键为grade的zset中添加Bob（其score为100），并添加Mike（其score为98） | 2，即添加的元素个数                 |
| zrem(name, *values)                                          | 删除键为name的zset中的元素                                   | name：键名；values：元素                                     | redis.zrem('grade', 'Mike')                                  | 从键为grade的zset中删除Mike                                  | 1，即删除的元素个数                 |
| zincrby(name, value, amount=1)                               | 如果在键为name的zset中已经存在元素value，则将该元素的score增加amount；否则向该集合中添加该元素，其score的值为amount | name：key名；value：元素；amount：增长的score值              | redis.zincrby('grade', 'Bob', -2)                            | 键为grade的zset中Bob的score减2                               | 98.0，即修改后的值                  |
| zrank(name, value)                                           | 返回键为name的zset中元素的排名，按score从小到大排序，即名次  | name：键名；value：元素值                                    | redis.zrank('grade', 'Amy')                                  | 得到键为grade的zset中Amy的排名                               | 1                                   |
| zrevrank(name, value)                                        | 返回键为name的zset中元素的倒数排名（按score从大到小排序），即名次 | name：键名；value：元素值                                    | redis.zrevrank('grade', 'Amy')                               | 得到键为grade的zset中Amy的倒数排名                           | 2                                   |
| zrevrange(name, start, end, withscores=False)                | 返回键为name的zset（按score从大到小排序）中index从start到end的所有元素 | name：键值；start：开始索引；end：结束索引；withscores：是否带score | redis.zrevrange('grade', 0, 3)                               | 返回键为grade的zset中前四名元素                              | [b'Bob', b'Mike', b'Amy', b'James'] |
| zrangebyscore(name, min, max, start=None, num=None, withscores=False) | 返回键为name的zset中score在给定区间的元素                    | name：键名；min：最低score；max：最高score； start：起始索引；num：个数；withscores：是否带score | redis.zrangebyscore('grade', 80, 95)                         | 返回键为grade的zset中score在80和95之间的元素                 | [b'Bob', b'Mike', b'Amy', b'James'] |
| zcount(name, min, max)                                       | 返回键为name的zset中score在给定区间的数量                    | name：键名；min：最低score；max：最高score                   | redis.zcount('grade', 80, 95)                                | 返回键为grade的zset中score在80到95的元素个数                 | 2                                   |
| zcard(name)                                                  | 返回键为name的zset的元素个数                                 | name：键名                                                   | redis.zcard('grade')                                         | 获取键为grade的zset中元素的个数                              | 3                                   |
| zremrangebyrank(name, min, max)                              | 删除键为name的zset中排名在给定区间的元素                     | name：键名；min：最低位次；max：最高位次                     | redis.zremrangebyrank('grade', 0, 0)                         | 删除键为grade的zset中排名第一的元素                          | 1，即删除的元素个数                 |
| zremrangebyscore(name, min, max)                             | 删除键为name的zset中score在给定区间的元素                    | name：键名；min：最低score；max：最高score                   | redis.zremrangebyscore('grade', 80, 90)                      | 删除score在80到90之间的元素                                  | 1，即删除的元素个数                 |
| zrange(name,start,end,[desc,withscores])                     | 查询键为name的zset中的区间元素                               | name:键名；<br/>start:索引开始位置<br/>end:索引结束位置<br/>desc:排序方式<br/>withscores:是否获取元素的分数，默认只获取元素的值 |                                                              |                                                              |                                     |



### 散列操作

| hset(name, key, value)       | 向键为name的散列表中添加映射                       | name：键名；key：映射键名；value：映射键值 | hset('price', 'cake', 5)                       | 向键为price的散列表中添加映射关系，cake的值为5 | 1，即添加的映射个数                                          |
| ---------------------------- | -------------------------------------------------- | ------------------------------------------ | ---------------------------------------------- | ---------------------------------------------- | ------------------------------------------------------------ |
| hsetnx(name, key, value)     | 如果映射键名不存在，则向键为name的散列表中添加映射 | name：键名；key：映射键名；value：映射键值 | hsetnx('price', 'book', 6)                     | 向键为price的散列表中添加映射关系，book的值为6 | 1，即添加的映射个数                                          |
| hget(name, key)              | 返回键为name的散列表中key对应的值                  | name：键名；key：映射键名                  | redis.hget('price', 'cake')                    | 获取键为price的散列表中键名为cake的值          | 5                                                            |
| hmget(name, keys, *args)     | 返回键为name的散列表中各个键对应的值               | name：键名；keys：映射键名列表             | redis.hmget('price', ['apple', 'orange'])      | 获取键为price的散列表中apple和orange的值       | [b'3', b'7']                                                 |
| hmset(name, mapping)         | 向键为name的散列表中批量添加映射                   | name：键名；mapping：映射字典              | redis.hmset('price', {'banana': 2, 'pear': 6}) | 向键为price的散列表中批量添加映射              | True                                                         |
| hincrby(name, key, amount=1) | 将键为name的散列表中映射的值增加amount             | name：键名；key：映射键名；amount：增长量  | redis.hincrby('price', 'apple', 3)             | key为price的散列表中apple的值增加3             | 6，修改后的值                                                |
| hexists(name, key)           | 键为name的散列表中是否存在键名为键的映射           | name：键名；key：映射键名                  | redis.hexists('price', 'banana')               | 键为price的散列表中banana的值是否存在          | True                                                         |
| hdel(name, *keys)            | 在键为name的散列表中，删除键名为键的映射           | name：键名；keys：映射键名                 | redis.hdel('price', 'banana')                  | 从键为price的散列表中删除键名为banana的映射    | True                                                         |
| hlen(name)                   | 从键为name的散列表中获取映射个数                   | name： 键名                                | redis.hlen('price')                            | 从键为price的散列表中获取映射个数              | 6                                                            |
| hkeys(name)                  | 从键为name的散列表中获取所有映射键名               | name：键名                                 | redis.hkeys('price')                           | 从键为price的散列表中获取所有映射键名          | [b'cake', b'book', b'banana', b'pear']                       |
| hvals(name)                  | 从键为name的散列表中获取所有映射键值               | name：键名                                 | redis.hvals('price')                           | 从键为price的散列表中获取所有映射键值          | [b'5', b'6', b'2', b'6']                                     |
| hgetall(name)                | 从键为name的散列表中获取所有映射键值对             | name：键名                                 | redis.hgetall('price')                         | 从键为price的散列表中获取所有映射键值对        | {b'cake': b'5', b'book': b'6', b'orange': b'7', b'pear': b'6'} |



## 中文编码问题

进入指令`redis-cli -a PASSWORD` 改成`redis-cli --raw -a PASSWORD`

## 基本使用--python

```python
import redis
from config.setting import REDIS_HOST, REDIS_PORT, REDIS_PASSWD, EXPIRE_TIME


class RedisDb():

    def __init__(self, host, port, passwd):
        # 建立数据库连接
        self.r = redis.Redis(
            host=host,
            port=port,
            password=passwd,
            decode_responses=True # get() 得到字符串类型的数据
        )

    def handle_redis_token(self, key, value=None):
        if value: # 如果value非空，那么就设置key和value，EXPIRE_TIME为过期时间
            self.r.set(key, value, ex=EXPIRE_TIME)
        else: # 如果value为空，那么直接通过key从redis中取值
            redis_token = self.r.get(key)
            return redis_token


redis_db = RedisDb(REDIS_HOST, REDIS_PORT, REDIS_PASSWD)


```

## 保持缓存内容与数据库的一致性

- 保持缓存内容与数据库的一致性，这里一般有两种做法：
  1. 只在数据库查询后将对象放入缓存，如果对象发生了修改或删除操作，直接清除对应缓存（或设为过期）。
  2. 在数据库新增和查询后将对象放入缓存，修改后更新缓存，删除后清除对应缓存（或设为过期）。

Redis内部是支持事务的，在使用时候能有效保证数据的一致性。 作为缓存使用时，一般有两种方式保存数据：

- 1、读取前，先去读Redis，如果没有数据，读取数据库，将数据拉入Redis。
- 2、插入数据时，同时写入Redis。

方案一：实施起来简单，但是有两个需要注意的地方：
1、避免缓存击穿。（数据库没有就需要命中的数据，导致Redis一直没有数据，而一直命中数据库。）
2、数据的实时性相对会差一点。

方案二：数据实时性强，但是开发时不便于统一处理。 。

当然，两种方式根据实际情况来适用。如：方案一适用于对于数据实时性要求不是特别高的场景。方案二适用于字典表、数据量不大的数据存储

## 分布式锁
如今都是分布式的环境下java自带的单体锁已经不适用的。在 Redis 2.6.12 版本开始，string的set命令增加了一些参数：

`EX`：设置键的过期时间（单位为秒）

`PX`：设置键的过期时间（单位为毫秒）

`NX`：只在键不存在时，才对键进行设置操作。 `SET key value NX` 效果等同于 `SETNX key value `。

`XX`：只在键已经存在时，才对键进行设置操作。

例如：`set lock_key locked NX EX 1`

如果这个操作返回false，说明 key 的添加不成功，也就是当前有人在占用这把锁。而如果返回true，则说明得了锁，便可以继续进行操作，并且在操作后通过del命令释放掉锁。并且即使程序因为某些原因并没有释放锁，由于设置了过期时间，该锁也会在 1 秒后自动释放，不会影响到其他程序的运行。



## Redis缓存穿透、击穿、雪崩

### 缓存穿透
描述
  指访问一个缓存和数据库中都不存在的key，由于这个key在缓存中不存在，则会到数据库中查询，数据库中也不存在该key，无法将数据添加到缓存中，所以每次都会访问数据库导致数据库压力增大。

解决方法

1. 将空key添加到缓存中。
2. 使用`布隆过滤器`过滤空key。
3. 一般对于这种访问可能由于遭到攻击引起，可以对请求进行身份鉴权、数据合法行校验等。

### 缓存击穿
描述
  指大量请求访问缓存中的一个key时，该key过期了，导致这些请求都去直接访问数据库，短时间大量的请求可能会将数据库击垮。

解决方法

1. 添加互斥锁或分布式锁，让一个线程去访问数据库，将数据添加到缓存中后，其他线程直接从缓存中获取。
2. 热点数据key不过期，定时更新缓存，但如果更新出问题会导致缓存中的数据一直为旧数据。

### 缓存雪崩
描述
  指在系统运行过程中，缓存服务宕机或大量的key值同时过期，导致所有请求都直接访问数据库导致数据库压力增大。

解决方法

1. 将key的过期时间打散，避免大量key同时过期。
2. 对缓存服务做高可用处理。
3. 加互斥锁，同一key值只允许一个线程去访问数据库，其余线程等待写入后直接从缓存中获取。







## 缓存分页

方法一：从redis拿出所有数据，再做内存分页（不推荐），热点数据小的时候可以这样做



