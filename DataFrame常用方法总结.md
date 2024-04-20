## DataFrame简介
Pandas中内嵌了多种方法，可以对数据进行查询、筛选、分组查询、整体计算（求和计数等）、表与表之间的连接等操作，非常方便。
1、Series，等同于一维数组，可以理解为excel表格里面的一行或者一列
2、DataFrame，等同于二维数组，可以理解为excel表格里面的一个表格

## 补充依赖库
![834593b963984312068dee67219891aa57025b4f3b75b12059b6e55bdce1e40aQzpcVXNlcnNcQ0NDQ0NcQXBwRGF0YVxSb2FtaW5nXERpbmdUYWxrXDE0NTIwNDQ0NjhfdjJcSW1hZ2VGaWxlc1wxNjUzMDM1NzcwNzgyXzMwNzZFMTRELTEyOUMtNGE1OC05OEEwLTNBNUM1NUFCNkMwRi5wbmc=.png](https://cdn.nlark.com/yuque/0/2022/png/26230530/1653037270147-702d5ad4-f43e-48ae-992c-2b1d571962dc.png#clientId=u4db3435a-f696-4&crop=0&crop=0&crop=1&crop=1&from=drop&id=u877eefa1&margin=%5Bobject%20Object%5D&name=834593b963984312068dee67219891aa57025b4f3b75b12059b6e55bdce1e40aQzpcVXNlcnNcQ0NDQ0NcQXBwRGF0YVxSb2FtaW5nXERpbmdUYWxrXDE0NTIwNDQ0NjhfdjJcSW1hZ2VGaWxlc1wxNjUzMDM1NzcwNzgyXzMwNzZFMTRELTEyOUMtNGE1OC05OEEwLTNBNUM1NUFCNkMwRi5wbmc%3D.png&originHeight=604&originWidth=617&originalType=binary&ratio=1&rotation=0&showTitle=false&size=374902&status=done&style=none&taskId=u4985f297-8930-42cb-86f1-d5f3ac44a81&title=)

## 安装导入Pandas库
如果是xls文件后缀的excel使用pandas读取可能会报错缺少xlrd库，可以手动下载包文件，解压保存到机器人按照目录底下（release\Python\python3_lib\Lib\site-packages）
```bash
# 导入pandas库
import pandas as pd

# 如果报错缺少xlrd库需要按照并导入
import xlrd
```

## 读取或写入excel文件

```bash
# 读取xlsx文件，sheet_name属性可以省略
df = pd.read_excel(r'文件路径', sheet_name='Sheet1')

# 读取csv文件，sheet_name属性可以省略
df = pd.read_csv(r'文件路径', sheet_name='Sheet1')

# 写入excel文件
df.to_excel(r'文件路径')

# 写入csv文件
df.to_csv(r'文件路径')
```

### read_excel参数解析

1. sheet_name： 读取表，支持 表格名字和表格位置索引

2. keep_default_na：空值的处理，默认是True，如果数据为空的时候，为NaN，False时，数据为空，显示空字符串

3. header：第几行为表头，默认索引为0

4. usecols：读取第几列，

   ```text
   "A:B,E:I" ---> 读取A到B，E到I列数据
   [0,1,4]  ---> 读取0，1，4列的数据
   
   ```

   



## 创建DataFrame

1、最外层是一个列表类型，以行形式创建，列表的每个子元素表示一行
2、最外层是一个字典类型，以列形式创建，字典的每个子元素键表示列名、值表示一行
```bash
# 空dataframe
df = pd.DataFrame()

>>> df
Empty DataFrame
Columns: []
Index: []
>>>

# 最外层是一个列表类型
## 根据series创建
df = pd.DataFrame([series1,series2])

## 根据列表字典创建
lst = [{ 'name' : '小明', 'age' : 20 }, { 'name' : '小红', 'age' : 21 }]
df = pd.DataFrame(lst)

>>> df
    name  age
0   小明   20
1   小红   21
>>>

## 根据二维数组创建
二维数组 = [['小明', 20], ['小红', 21],['小方', 22]]
df = pd.DataFrame(dic, columns = ['name', 'age'], index = [0, 1, 2])

>>> df
    name  age
0   小明   20
1   小红   21
2   小方   22
>>>

# 最外层是一个字典类型
## 根据字典列表创建
dic = { 'name' : ['小明','小红','小方'], 'age' : [20,21,22]}
df = pd.DataFrame(dic, index = [0, 1, 2])

>>> df
    name  age
0   小明   20
1   小红   21
2   小方   22
>>>

## 根据嵌套字典创建
dic = { 'name' : {0 : '小明', 1 : '小红', 2 : '小方'}, 'age' : {0 : 20, 1 : 21, 2 : 22}}
df = pd.DataFrame(dic)

>>> df
    name  age
0   小明   20
1   小红   21
2   小方   22
>>>
```

## 查看数据
```bash
# 查看形状，返回一个元组类型值(行,列)
df.shape

>>> df.shape
(3, 2)
>>>

# 默认查看前5条数据，可以在括号里添加查看数量
df.head()

# 默认查看后5条数据，可以在括号里添加查看数量
df.tail()
```

## 数据选取
1、列根据列名逐一选取（以逗号分隔）
2、行使用切片选取一行或多行
3、loc根据列名及行索引选取df区域
4、iloc根据切片的位置索引选取df区域，不用知道对应列名或行索引
5、选取规则都是先行后列
```bash
# 选取整行或者整列
## 选取单列，返回series类型
df['列名']
df.列名

## 选取多列，返回dataframe类型
df[['列名1','列名2']]

## 选取行，行使用切片选取，返回dataframe类型
df[0:10:1]

# 选取某个元素或某片区域
## 选取某个元素
df.loc['行索引','列名']
## 选取某片区域
df.loc['行索引1':'行索引2','列名1':'列名2']

## 根据索引选取元素或者dataframe，逗号前是行，后是列
df.iloc[:,:16]
## 选取前66行，列部分切片可以省略
df.iloc[:66]

## 根据条件筛选df
df[df.index == 'zhangsan']
df[df['列名1'] >= 100]

## 获取df的值，返回类型<class 'numpy.ndarray'>
二位数组 = df.values
```

## 数据操作
inplace参数为True表示更改应用到原df，默认为false，可以通过设置inplace参数值或者赋值给新变量以应用操作
### 增加删除行、列
```bash
# 新增列
df['列名x'] = 20

# 新增行，行索引可以是数字也可以是字符串，列表长度应跟列长度保持一致
df.loc[行索引] = ['张三', 20]

# 删除列
df.drop(['列名1', '列名2'], axis = 1, inplace = True)

# 删除行
df.drop(['行索引', '行索引'], axis = 0, inplace = True)
```

### 重定义行名、列名
```bash
# 重新定义df的行索引
## 方法一：设置行索引为‘列名1’的值加上‘列名2’的值
df.index = df['列名1'] + df['列名2']
## 方法二：设置行索引为‘列名1’
df.set_index('列名1', inplace=True)
## 方法三：自动生成从0开始的数字索引，drop值为True表示删除原索引，Flase表示将原索引新增一列
df.reset_index(drop = True, inplace = True)

# 重新定义df的列名
## 等号右边需为列表类型，且列表长度跟列数相等，否则报错
df.columns = list(range(16))
## 以字典匹配的形式重定义列名
df.rename(columns = { '列名1' : '列名2' }, inplace = True)
```

### 缺失值处理
#### 缺失值有三种形态
1、NaN
这种类型是numpy类型的空值类型，等同于np.nan
2、None
这种是python的空值对象
3、空字符串、‘\n’或者’\t‘等异常值
#### 两种处理方案
1、删除
2、填充
```bash
# 处理第一和第二种形态
## 删除所有包含空值的行
df.dropna(how='any', axis=0)
## 删除整行都是空的行
df.dropna(how='all', axis=0)
## 删除列同理行，axis参数改为1

## 填充为空字符串
df.fillna('', inplace=True)
## 填充缺失值所在位置的前一个非缺失值，设置参数method='ffill'
df['列名1'].fillna(method='ffill')

# 处理第三种形态，试用正则表达式，第一个参数正则表达式，第二个参数替换值，第三个表示使用正则模式
df.replace('^\s+$|(^$)', '数据缺失', regex=True, inplace=True)
```

### 数据去重
```bash
# subset表示根据指定的列名进行去重，默认整个数据集
df.drop_duplicates(subset = ['列名1','列名2'], inplace = True)
```

### 整表操作
对表整个数据集强制类型转换为字符串类型
```bash
# 指定参数 errors='ignore',忽略无法转换的数据值
df = df.astype(str, errors='ignore')

# 把数据集中“性别”列的男替换为1，⼥替换为0
## 对表列或者行替换，使用map方法，使用字典映射的形式
df['性别'].map({"男" : 1, "女" : 0 })

## 对表列或者行替换，使用apply方法，相比较与map可以实现更复杂的操作，axis参数0表示按列columns操作，1表示按行row操作
df[['性别']].apply(lambda x:x.replace('男',1).replace('女',0), axis = 0)
df['性别'].apply(lambda x:x.replace('男',1).replace('女',0))

## 对整表所有元素执行操作
df.applymap(lambda x:x.repalce(('男',1).replace('女',0))
```

### 遍历DataFrame
```bash
# df.items()返回一个元组列表
for index, value in df.items():
  print(index, value)
```

## 多个DataFrame连接合并
### 表格合并（也可以做数据匹配）——等同于MySQL中表连接
内连接(inner)——交集，截取两表基于基准列的共有值
外连接(outer)——并集，所有数据都添加进来
左连接(left)——以左表为准，左表基准列所有值都保存，把右表数据匹配到左表数据
右连接(right)——以右表为准，右表基准列所有值都保存，把左表数据匹配到右表数据
左表右表类似，应用场景包括但不限于连表匹配值（类似于excel中vlookup效果）
```bash
# on表示根据相同列名1合并，如果合并基准列列名不同，则用left_on, right_on两个参数。
# how表示连接方式，有inner, left, right, outer
df = pd.merge(df1, df2, on = '列名1', how = 'inner')
df = pd.merge(df1, df2, left_on = '列名1', right_on = '列名2', how = 'inner')

# 跟merge区别在于on参数默认值是left
df = df1.join(df2, on = 'left', lsuffix = '', rsuffix = '')
```

### 表格堆叠
ignore_index = True表示忽略索引
```bash
# 纵向堆叠
df = pd.concat([df1, df2])
# 横向堆叠
df = pd.concat([df1, df2], axis = 1)

# dataframe行追加append
df = df1.append(df2, ignore_index = True)
```

## 房价数据清洗案例
表格一：[房价表.xlsx](https://www.yuque.com/attachments/yuque/0/2022/xlsx/12804161/1653038144102-fee8ad8d-15f5-4063-8dcd-f88b83342cf5.xlsx?_lake_card=%7B%22src%22%3A%22https%3A%2F%2Fwww.yuque.com%2Fattachments%2Fyuque%2F0%2F2022%2Fxlsx%2F12804161%2F1653038144102-fee8ad8d-15f5-4063-8dcd-f88b83342cf5.xlsx%22%2C%22name%22%3A%22%E6%88%BF%E4%BB%B7%E8%A1%A8.xlsx%22%2C%22size%22%3A94688%2C%22type%22%3A%22application%2Fvnd.openxmlformats-officedocument.spreadsheetml.sheet%22%2C%22ext%22%3A%22xlsx%22%2C%22source%22%3A%22%22%2C%22status%22%3A%22done%22%2C%22mode%22%3A%22title%22%2C%22download%22%3Atrue%2C%22taskId%22%3A%22u5402b05c-1cdb-4731-be0c-99a434fba47%22%2C%22taskType%22%3A%22upload%22%2C%22id%22%3A%22uc61261d1%22%2C%22card%22%3A%22file%22%7D)
表格二：[一二线城市表.xlsx](https://www.yuque.com/attachments/yuque/0/2022/xlsx/12804161/1653038144232-03dbb781-c319-4396-a125-da2f62eed77a.xlsx?_lake_card=%7B%22src%22%3A%22https%3A%2F%2Fwww.yuque.com%2Fattachments%2Fyuque%2F0%2F2022%2Fxlsx%2F12804161%2F1653038144232-03dbb781-c319-4396-a125-da2f62eed77a.xlsx%22%2C%22name%22%3A%22%E4%B8%80%E4%BA%8C%E7%BA%BF%E5%9F%8E%E5%B8%82%E8%A1%A8.xlsx%22%2C%22size%22%3A13174%2C%22type%22%3A%22application%2Fvnd.openxmlformats-officedocument.spreadsheetml.sheet%22%2C%22ext%22%3A%22xlsx%22%2C%22source%22%3A%22%22%2C%22status%22%3A%22done%22%2C%22mode%22%3A%22title%22%2C%22download%22%3Atrue%2C%22taskId%22%3A%22u8084b470-5318-405f-a1d6-ff4b725dcc4%22%2C%22taskType%22%3A%22upload%22%2C%22id%22%3A%22ub1ba9da5%22%2C%22card%22%3A%22file%22%7D)
### 清洗规则
一、去重
按照Address和City字段去重，Address字段内容是由行政区和写字楼组成，首先筛选出所有唯一的写字楼的信息
二、清洗：(清洗原字段全部保留，新字段命名：**Amount_clean(元/月)，Area_clean(㎡)，Price_clean(元/m²/天) **)
1、Amount，Price两个字段中有部分单位是元，部分单位是万元，统一单位并且把“面议”和”暂无数据“两种内容 填充为空值。
2、“日租”，“月租”两个字段统一单位，文档中“面议”和”暂无数据“两种内容 填充为空值
3、空值处理，替换成空字符串

```bash
import pandas as pd

## 存放房价数据目录
文件夹路径 = r"C:\Users\CCCCC\Desktop\pandas常用方法"

## 统一area字段单位
def area(x):
    try:
        lst = x.split('m²')
    except:
        return 0
    if len(lst) == 2:
        return int(lst[0])
        
## 统一amount字段单位，处理‘面议’等字符
def amount(x):
    try:
        lst = x.split('万')
        lst_1 = x.split('元')
    except:
        return 0
    if len(lst) == 2:
        y = float(lst[0])*10000
        return y
    elif len(lst_1) == 2:
        return float(lst_1[0])
    elif len(lst) == 1 and len(lst_1) == 1:
        return 0
        
## 统一price字段单位，处理‘面议’等字符
def price(x):
    try:
        lst = x.split('元/m²/天')
        lst_1 = x.split('元/月')
    except:
        return 0
    if len(lst) == 2:
        y = float(lst[0])
        return y
    elif len(lst_1) == 2:
        return float(lst_1[0])/30
    elif len(lst) == 1 and len(lst_1) == 1:
        return 0
        
## 读取数据
房价数据 = pd.read_excel(文件夹路径 + '\\房价表.xlsx')

## 去除空值
房价数据.fillna('', inplace = True)

## 重新设置列名
房价数据.rename(columns={'link': '详情页链接', 'Titly':'标题', 'Address':'详细地址', 'Type':'写字楼类型', 'Float':'楼层', 'Name':'上传者', 'Company':'所属公司', 'Area':'面积', 'Amount':'月单价', 'Price':'日单价', 'Tap':'写字楼标签', 'City':'所属城市'}, inplace=True)

## 转换数据类型
房价数据 = 房价数据.astype(str)

## 整表操作，清洗() ,''等字符
房价数据 = 房价数据.applymap(lambda x: x.replace('(','').replace(')','').replace("'",'').replace(' ','').replace(',',''))

## 合并城市和地址字段，将合并后的字段作为去重字段
房价数据['地址_clean'] = 房价数据['所属城市'] + '-' + 房价数据['详细地址']

去重前行数 = 房价数据.shape[0]
print(去重前行数)
print('开始去重')
房价数据.drop_duplicates(subset = ["地址_clean"],inplace=True)
print(房价数据.shape[0])
print('去重完成，总共发现'+str(去重前行数 - 房价数据.shape[0])+'条重复数据')

## 处理空值
房价数据.fillna('', inplace = True)

## 清洗“面积”字段，统一单位并去掉单位
房价数据['面积_clean(㎡)'] = 房价数据['面积'].str.split('㎡',expand = True)[0]

## 清洗“月单价”字段，统一单位并去掉单位
房价数据['月单价_clean(元/月)'] = 房价数据['月单价'].apply(amount)

## 清洗“日单价”字段，统一单位并去掉单位
房价数据['日单价_clean(元/m²/天)'] = 房价数据['日单价'].apply(price)

## 删除无用id字段
房价数据 = 房价数据.drop("_id", axis=1)

## 重置索引
房价数据 = 房价数据.reset_index(drop=True)

## 按照Company字段分组计数
房价数据.groupby('所属公司')['地址_clean'].count()

## 读取表
城市数据表 = pd.read_excel(文件夹路径 + '\\一二线城市表.xlsx')

## 给城市字段添加‘市’关键字
城市数据表['城市'] = 城市数据表['城市'].apply(lambda x:x+'市')

## 在城市数据表中匹配城市，找到对应省份
合并表 = pd.merge(房价数据, 城市数据表, left_on='所属城市', right_on='城市', how = "left")

## 保存清洗后的数据到excel表
合并表.to_excel('房价数据_清洗结果.xlsx', index = False)  
```
