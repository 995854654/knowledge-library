## 准备工作

1. 创建maven工程，配置pom.xml的dependency

```xml
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.5.7</version>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.16</version>
</dependency>
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.12</version>
    <scope>test</scope>
</dependency>
```

2. 创建并配置mybatis-config.xml

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
            "http://mybatis.org/dtd/mybatis-3-config.dtd">
    <configuration>
        <!-- 7.environments数据库环境配置 -->
        <!-- 和Spring整合后environments配置将被废除 -->
        <environments default="development">
            <environment id="development">
                <!-- 使用JDBC事务管理 -->
                <transactionManager type="JDBC"/>
                <!-- 数据库连接池 -->
                <dataSource type="POOLED">
                    <property name="driver" value="com.mysql.cj.jdbc.Driver"/>
                    <property name="url" value="jdbc:mysql://localhost:3306/blogdb?serverTimezone=UTC"/>
                    <property name="username" value="root"/>
                    <property name="password" value="123456"/>
                </dataSource>
            </environment>
        </environments>
    
        <!-- 8.加载映射文件 -->
        <mappers>
            <mapper resource="mappers/PersonInfoMapper.xml"/>
    
        </mappers>
    </configuration>
    
    ```



## 简单用例

创建mapper接口

```java
package com.yangjj.mapper;

public interface PersonInfoMapper {
    int insertPerson();
}
```

创建mapper映射文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.yangjj.mapper.PersonInfoMapper">
    <!--
        mapper接口和映射文件要保证两个一致：
            1. mapper接口的全类名和映射文件的namespace一致
            2. mapper接口中的方法的方法名要和映射文件中的sql的id保持一致
     -->
    <!-- int insertPerson(); -->
    <insert id="insertPerson">
            insert into person_info(`name`,`sex`,`age`,`balance`) VALUES
            ("李俊","男",37,51000.50);
    </insert>

</mapper>

```

运行sql语句

```java
@Test
public void test() throws IOException {
    // 获取核心配置文件的输入流
    InputStream is = Resources.getResourceAsStream("mybatis-config.xml");
    // 获取SqlSessionFactoryBuilder
    SqlSessionFactoryBuilder ssfb = new SqlSessionFactoryBuilder();
    SqlSessionFactory factory = ssfb.build(is);
    // 获取SqlSession，Mybatis提供的操作数据库对象
    SqlSession ss = factory.openSession();
    // 获取mapper接口
    PersonInfoMapper mapper = ss.getMapper(PersonInfoMapper.class);
    int result = mapper.insertPerson();
    System.out.println("数量：" + result);
    ss.commit();

    ss.close();

}
```



## 查

```java
// PersonInfoMapper.java
public interface PersonInfoMapper {
	PersonInfo getPersonById();  // 查询一条数据
    List<PersonInfo> getAllPerson();  // 查询多条数据
    
}
```



```xml
<!-- PersonInfoMapper.xml -->
<!--
	查询需要设置resultType或者resultMap,两者只能存在一个
resultType:设置结果类型，即查询的数据要转换的java类型
resultMap:自定义映射，处理多对一或者一对多的映射关系
-->
<select id="getPersonById" resultType="com.yangjj.beans.PersonInfo">
	select * from person_info where id=3;
</select>
<select id="getAllPerson" resultType="com.yangjj.beans.PersonInfo">
	select * from person_info;
</select>
```





## 核心配置文件解析

configuration配置需要根据顺序配置

`properties?,settings?,typeAliases?,typeHandlers?,objectFactory?,objectWrapperFactory?,reflectorFactory?,plugins?,environments?,databaseIdProvider?,mappers?`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
	<!-- 引入properties文件，此后就可以在当前文件中使用${key}的方式访问value -->
    <properties resource="jdbc.properties"/>
    
    <!--
		typeAliases:设置类型别名，即为某个具体的类型设置一个别名，
		在MyBatis的范围中，就可以使用别名表示一个具体的类型
	-->
	 <typeAliases>
         <!--
			type:具体的java类型
			alias：别名
			alias不设置时，默认别名为最后的类名，不区分大小写
		-->
        <!--        <typeAlias type="com.yangjj.beans.PersonInfo" alias="pi"></typeAlias>-->
		<!--        <typeAlias type="com.yangjj.beans.PersonInfo"></typeAlias>-->		
         <!--通过包设置类型别名，指定包下所有的类型将全部拥有默认的别名，即类名且不区分大小写-->
        <package name="com.yangjj.beans"/>
    </typeAliases> 
    
    <!-- 7.environments数据库环境配置 -->
    <!-- 和Spring整合后environments配置将被废除 -->
    <!--
		default属性设置默认选择的环境id
	-->
    <environments default="development">
        <environment id="development">
            <!-- transactionManager:设置事务管理器
			type属性：
				JDBC：使用JDBC中原生的事务管理方式
 				MANAGED：被管理，例如Spring
			-->
            <transactionManager type="JDBC"/>
            <!-- dataSource 设置数据源
			type属性：
 				POOLED: 表示使用数据库连接池
				UNPOOLED:表示不适用数据库连接池
				JNDI：使用上下文中的数据源
			-->
            <dataSource type="POOLED">
                <property name="driver" value="${jdbc.driver}"/>
                <property name="url" value="${jdbc.url}"/>
                <property name="username" value="${jdbc.username}"/>
                <property name="password" value="${jdbc.password}"/>
            </dataSource>
        </environment>
    </environments>

    <!-- 8.加载映射文件 -->
    <mappers>
        <mapper resource="mappers/PersonInfoMapper.xml"/>
		<!--
			以包的方式引入映射文件，但是必须满足两个条件：
			1. mapper接口和映射文件所在的包必须一致
			2. mapper接口的名字和映射文件的名字必须一致
-->
        <package name="com.yangjj.mapper" />
    </mappers>
</configuration>

```





## mapper文件获取参数

Mabatis获取参数值的两种方式：`#{}`和`${}`

1. mapper接口方法的参数为单个字面量类型

    #{}本质是占位符赋值，

    ${}本质是字符串拼接，所以字符串需要手动加单引号

2. mapper接口方法的参数有多个字面量类型

    此时MyBatis会将参数放在map集合中，以两种方式存储数据

    - 以arg0,arg1,...为键，以参数为值
    - 以param1,param2,...为键，以参数为值

    因此，只需要通过#{}和${}访问`map集合的键`，就可以获取相对应的值

    ```xml
    <!--    PersonInfo getAccessIdentify(String name,double balance);-->
    <select id="getAccessIdentify" resultType="PersonInfo">
        select *
        from person_info
        where name = #{arg0}
        and balance = #{arg1}
    </select>
    ```

    

3. mapper接口方法的参数为map集合

    因此，只需要通过#{}和${}访问`map集合的键`，就可以获取相对应的值

4. mapper接口方法的参数为实体类型的参数

    因此，只需要通过#{}和${}访问`实体类的属性名(get、set方法后的名字)`，就可以获取相对应的值

    ```xml
    <!-- insertPerson(PersonInfo p)-->
    <insert id="getPersonByName">
        INSERT INTO person_info(`name`,`sex`,`age`,`balance`) values(#{name},#{sex},#{age},#{balance})
    </insert>
    ```

5. 可以在mapper接口方法的参数上设置@Param注解

    此时MyBatis会将这些参数放在map中，以两种方式存储

    - 以@Param注解的value属性值为键，以参数为值
    - 以param1，param2,.....为键，以参数为值

    ```xml
    <!--    PersonInfo getAccessIdentify2(@Param("username") String name, @Param("balance") double balance);-->
    <select id="getAccessIdentify" resultType="PersonInfo">
        select *
        from person_info
        where name = #{username}
        and balance = #{balance}
    </select>
    ```

    



## 多种情况下的查询

1. 拼接表查询--[{},{}]

    ```java
    // mapper接口
    list<Map<String,Object>> getAllPerson();
    // 结果：
    // [{},{},{}]
    ```

    ```xml
    <!-- mapper.xml  -->
    <mapper>
    <select id="getAllPerson" resultType="map">
        select * from person_info;
        </select>
    </mapper>
    
    ```

2. 拼接表查询--{"":{},"":{}}

    ```java
    // 多条数据查询可以通过大的Map存放数据，前提是使用MapKey去定义键名
    @MapKey("id")
    Map<String,Object> getAllPersonToMap();
    // 结果：
    // {1={},2={},3={}}
    ```

    ```xml
    <!-- mapper.xml  -->
    <mapper>
    <select id="getAllPersonToMap" resultType="map">
        select * from person_info;
        </select>
    </mapper>
    ```

    

## 获取自增的主键

```xml
<!--    void insertPersonKey(PersonInfo p);-->
<!-- 
useGenerateKeys 允许获取自增主键。表示当前添加功能使用自增的主键
keyProperty  获取对象的哪个自增属性 。将添加的数据的自增主键为实体类类型的参数的属性赋值。
-->

<insert id="insertPersonKey" useGeneratedKeys="true" keyProperty="id">
    insert into person_info(`id`,`name`,`age`,`sex`,`balance`) values (null,#{name},#{age},#{sex},#{balance})
</insert>
```

```java
 @Test
public void test6(){
    SqlSession sqlSession = SQLSessionUtil.getSqlSession();
    PersonInfoMapper mapper = sqlSession.getMapper(PersonInfoMapper.class);
    PersonInfo p = new PersonInfo(null,"李连杰",90,"男",16000);
    mapper.insertPersonKey(p);
    System.out.println(p);
}

// 此时 p输出的id不是null，是自增后的数值

```





## 字段名和属性名不一致的处理手段

1. 查询字段起别名，和属性名保持一致。

2. MyBatis全局配置

    ```xml
    <settings>
        <!-- 将下划线映射为驼峰-->
    	<setting name="mapUnderscoreToCamelCase" value="true"></setting>
    </settings>
    ```

3. 使用resultMap自定义映射

    ```xml
    <!--
    	resultMap:设置自定义的映射关系
            id:唯一标识
            type:处理映射关系的实体类的类型
    		常用的标签：
    			id:处理主键和实体类中属性的关系
    			result：处理普通字段和实体类中属性的映射关系
    				column 表字段名，property：映射的名字（java属性名）
        -->
    <resultMap id="EmpResultMap" type="Emp">
        <id column="emp_id" property="empId"></id>
        <result column="emp_name" property="empName"></result>
    
    </resultMap>
    
    <select id="getEmpByIdNew" resultMap="EmpResultMap">
        select * from emp where emp_id = ${empId};
    </select>
    ```

    

## 多对一关系的映射处理

场景：连表查询

### 使用级联处理

```java
// Dept.java

public class Dept {
    private int deptId;
    private String deptName;
	...
}

// Emp.java
public class Emp {
    private int empId;
    private String empName;
    private int age;
    private String gender;
    private Dept dept;
}
```

```xml
<resultMap id="empAndDeptMap" type="Emp">
    <result column="emp_id" property="empId"/>
    <result column="emp_name" property="empName"/>
    <result column="dept_id" property="dept.deptId"/>
    <result column="dept_name" property="dept.deptName"/>
</resultMap>

<select id="getEmpAndDeptById" resultMap="empAndDeptMap">
    select * from emp
    left join dept on emp.dept_id = dept.dept_id
    where emp_id = ${empId}
</select>
```

### 使用association标签处理

```xml
<resultMap id="empAndDeptMap" type="Emp">
    <result column="emp_id" property="empId"/>
    <result column="emp_name" property="empName"/>
    <association property="dept" javaType="Dept">
        <result column="dept_id" property="deptId"/>
        <result column="dept_name" property="deptName"/>
    </association>
</resultMap>

<select id="getEmpAndDeptById" resultMap="empAndDeptMap">
    select * from emp
    left join dept on emp.dept_id = dept.dept_id
    where emp_id = ${empId}
</select>
```

### 分步查询（按步骤进行查询）

第一步：先查询左边sql

```xml
<!-- EmpMapper -->
<resultMap id="empAndDepStepMap" type="Emp">
    <result column="emp_id" property="empId"/>
    <result column="emp_name" property="empName"/>
    <!--
            property:实体类对象的属性，Emp的dept属性名
            select:设置分步查询的唯一标识
            column:设置分步查询的sql查询条件
			fetchType:在开启了延迟加载的环境中，通过该属性设置当前的分步查询是否使用延迟加载
			eager（立即加载）|lazy（延迟加载）
        -->
    <association
                 property="dept"
                 select="com.yangjj.mappers.DeptMapper.getDeptByStep"
                 column="dept_id"
                 />
</resultMap>

<!--    Emp getEmpAndDeptByStep(@Param("empId") int id);-->
<select id="getEmpAndDeptByStep" resultMap="empAndDepStepMap">
    select * from emp where emp_id = #{empId}
</select>
```

第二步：再查询右边sql

```xml
<!-- DeptMapper -->
<mapper namespace="com.yangjj.mappers.DeptMapper">
    <resultMap id="deptMapper" type="Dept">
        <result column="dept_id" property="deptId"/>
        <result column="dept_name" property="deptName"/>
    </resultMap>
    <!--    Dept getDeptByStep(@Param("deptId")int id);-->
    <select id="getDeptByStep" resultMap="deptMapper">
        select * from dept where dept_id=#{deptId}
    </select>
</mapper>
```

```java
public interface DeptMapper {

    Dept getDeptByStep(@Param("deptId")int id);

}
```

分步查询的优点：

1. 延迟加载

    比如调用dept属性的时候才会运行deptMapper里的查询语句

需要在setting中设置

```xml
<settings>
    <!-- 延迟加载 -->
	<setting name="lazyLoadingEnabled" value="true"/>
    <!-- 按需加载 -->
    <setting name="aggressiveLazyLoading" value="false"/>
</settings>
```





## 一对多关系的映射处理

### 使用collection

```xml
<resultMap id="deptAndEmpsMap" type="Dept">
    <result property="deptId" column="dept_id"/>
    <result property="deptName" column="dept_name"/>
    <!--
		ofType:设置集合类型的属性中存储的数据的类型
-->
    <collection property="emps" ofType="Emp">
        <result property="empId" column="emp_id"/>
        <result property="empName" column="emp_name"/>
    </collection>
</resultMap>
<!--    Dept getDeptAndEmpsByCollection(@Param("deptId")int id);-->
<select id="getDeptAndEmpsByCollection" resultMap="deptAndEmpsMap">
    select * from dept left join emp on emp.dept_id=dept.dept_id where dept.dept_id=#{deptId}
</select>
```

### 分步查询

```xml
 <collection
     property="emps"
     select="com.yangjj.mappers.EmpMapper.getEmpList"
     column="dept_id"
 />
```

## 动态查询

### if标签

```xml
<select id="xxxx" resultType="Emp">
select * from student_info where 
    <if test="empName != null and empName != ''">
    	emp_name = #{empName}
    </if>
</select>
```

### where标签

作用：

1. 若where标签中有条件成立，会自动生成where
2. 能够自动去除多余的and
3. 若where标签中没有任何一个条件成立，where标签无功能

```xml
<select id="getEmpList" resultType="Emp">
    select * from emp
    <where>
        <if test="empName != null and empName != ''">
            and emp_name = #{empName}
        </if>
        <if test="age != null and age != 0">
            and age = #{age}
        </if>
        <if test="gender != null and gender != ''">
            and gender = #{gender}
        </if>
    </where>
</select>
```

### trim标签

prefix、suffix：在前面或者后面添加指定内容

prefixOverrides、suffixOverrides：前面或者后面去除指定内容

### choose、when、otherwise标签

等同于if、else if、else

```xml
<select id="getEmpList" resultType="Emp">
    select * from emp
    <where>
        <choose>
            <when test="empName != null and empName != ''">
            	 emp_name = #{empName}
            </when>
            <when test="age != null and age != 0">
                 age = #{age}
            </when>
            <when test="gender != null and gender != ''">
                 gender = #{gender}
            </when>
            <otherwise>
            	
            </otherwise>
        </choose>
        
    </where>
</select>
```



### foreach批量操作

属性：

- collection：对应@Param注解里的名字
- item：遍历的元素名
- separator: 每个元素之间的分隔符

```xml
<!--    void insertMoreEmp(@Param("emps")List<Emp> emps);-->
<insert id="insertMoreEmp">
    insert into emp(`emp_name`,`age`,`gender`) VALUES
    <foreach collection="emps" item="item" separator=",">
        (#{item.empName},#{item.age},#{item.gender})
    </foreach>
</insert>
```


### sql标签

sql片段，记录一段sql，在需要使用的地方用include标签引用。

```xml
<sql id="columns">
	emp_id,emp_name,age,gender
</sql>

<select id="getEmpList" resultType="Emp">
    select <include refid='columns'/> from emp
</select>
```





## MyBatis一级缓存

使用同一个`SqlSession`对象，查询同一条件的sql语句时，会自动缓存，只查询一次。



一级缓存失效的四种情况：

- 不同的SqlSession对应不同的一级缓存
- 同一个SqlSession但是查询条件不同
- 同一个SqlSession两次查询期间执行了任何一次增删改操作
- 同一个SqlSession两次查询期间手动清空了缓存






## 分页操作

1.   添加依赖

     ```xml
      <dependency>
          <groupId>com.github.pagehelper</groupId>
          <artifactId>pagehelper</artifactId>
          <version>5.3.2</version>
     </dependency>
     ```

2.   在mybatis核心配置文件中配置插件

     ```xml
     <plugins>
     	<plugin interceptor="com.github.pagehelper.PageInterceptor"></plugin>
     </plugins>
     ```

3.   使用

     ```java
     SqlSession sqlSession = SqlSessionUtil.getConnection();
     EmpMapper mapper = sqlSession.getMapper(EmpMapper.class);
     // 查询功能前开启分页功能拦截器
     Page<Object> page = PageHelper.startPage(1,4);  // 获取分页的部分数据，包括查询结果
     // 自动在查询语句中添加limit
     List<Emp> list = mapper.selectAll();
     PageInfo<Emp> pageInfo = new PageInfo<>(list,5);  // 获取完整的分页数据，包括查询结果
     ```





## MyBatis-Plus

### 安装

1. 安装插件->mybatisx

2. 引入pom

    ```xml
    <dependency>
    	<groupId>com.baomidou</groupId>
        <artifactId>mybatis-plus-boot-starter</artifactId>
        <version>3.4.1</version>
    </dependency>
    ```

    

### 使用

