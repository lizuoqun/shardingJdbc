<kbd>Backspace</kbd>

# ShardingJDBC 分库分表是什么？

<font size="5" color="" face="楷体">1.、为什么要进行分库分表？</font>

很简单的道理，数据库数据量不可控的，随着时间和业务发展，造成表里面数据越来越多，如果再去对数据库表 curd 操作时候，造成性能问题。

<font size="5" color="" face="楷体">2.、数据库数据过多的解决方案</font>

- 硬件
- 分库分表

<font size="5" color="" face="楷体">3、分库分表有两种方式：垂直切分和水平切分</font>

1. 垂直切分：垂直分表和垂直分库
	1. 垂直分表：操作数据库中某张表，把这张表中一部分字段数据存到一张新表里面，再把这张表另一
部分字段数据存到另外一张表里面
	2. 垂直分库：把单一数据库按照业务进行划分，专库专表
2. 水平切分：水平分表和水平分库
	1. 可以将数据的水平切分理解为是按照数据行的切分，就是将表中的某些行切分到一个数据库，而另外的某些行又切分到其他的数据库中，这也就是对应的分表和分库

<font size="5" color="" face="楷体">4、分库分表应用和存在的问题</font>

应用
- 在数据库设计时候考虑垂直分库和垂直分表
- 随着数据库数据量增加，不要马上考虑做水平切分，首先考虑缓存处理，读写分离，使用索引等等方式，如果这些方式不能根本解决问题了，再考虑做水平分库和水平分表

分库分表问题
- 跨节点连接查询问题（分页、排序）
- 多数据源管理问题

# ShardingJDBC分库分表实战

引入依赖

```xml
<dependency>
    <groupId>org.apache.shardingsphere</groupId>
     <artifactId>sharding-jdbc-spring-boot-starter</artifactId>
     <version>4.0.0-RC1</version>
</dependency>
```
<font size="5" color="" face="楷体">1、水平分表</font>

简单的制定一下分表的规则：如果添加用户id是奇数把数据添加user1表当中，如果偶数添加到user2表
```properties
# 配置真实数据源（给数据源取一个名字）
spring.shardingsphere.datasource.names=ds

# 配置数据源（对应自己的数据库）
spring.shardingsphere.datasource.ds.type=com.alibaba.druid.pool.DruidDataSource
spring.shardingsphere.datasource.ds.driver-class-name=com.mysql.cj.jdbc.Driver
spring.shardingsphere.datasource.ds.url=jdbc:mysql://localhost:3306/springboot?serverTimezone=GMT%2B8
spring.shardingsphere.datasource.ds.username=root
spring.shardingsphere.datasource.ds.password=root

# 分表规则 表名+1，2
spring.shardingsphere.sharding.tables.user.actual-data-nodes=ds.user$->{1..2}

# 指定主键生成策略 主键id通过雪花算法生成
spring.shardingsphere.sharding.tables.user.key-generator.column=id
spring.shardingsphere.sharding.tables.user.key-generator.type=SNOWFLAKE

# 指定分片策略 根据生成的id进行分表
spring.shardingsphere.sharding.tables.user.table-strategy.inline.sharding-column=id
spring.shardingsphere.sharding.tables.user.table-strategy.inline.algorithm-expression=user$->{id % 2 +1}
```
<font size="5" color="" face="楷体">2、水平分库分表</font>

约定规则：如果添加用户id是奇数把数据添加user1，如果偶数添加到user2。这里还是用上面的表结构，但是在这里我们将创建两个库，springboot1和springboot2两个库，当userid为奇数加入springboot1这个库当中，偶数加入到springboot2这个库当中。

```properties
# 配置真实数据源（给数据源取一个名字）
spring.shardingsphere.datasource.names=ds1,ds2

# 配置第 1 个数据源（对应自己的数据库）
spring.shardingsphere.datasource.ds1.type=com.alibaba.druid.pool.DruidDataSource
spring.shardingsphere.datasource.ds1.driver-class-name=com.mysql.jdbc.Driver
spring.shardingsphere.datasource.ds1.url=jdbc:mysql://localhost:3306/springboot1?serverTimezone=GMT%2B8
spring.shardingsphere.datasource.ds1.username=root
spring.shardingsphere.datasource.ds1.password=root

# 配置第 2 个数据源（对应自己的数据库）
spring.shardingsphere.datasource.ds2.type=com.alibaba.druid.pool.DruidDataSource
spring.shardingsphere.datasource.ds2.driver-class-name=com.mysql.jdbc.Driver
spring.shardingsphere.datasource.ds2.url=jdbc:mysql://localhost:3306/springboot2?serverTimezone=GMT%2B8
spring.shardingsphere.datasource.ds2.username=root
spring.shardingsphere.datasource.ds2.password=root

# 指定库表的分布规则
spring.shardingsphere.sharding.tables.user.actual-data-nodes=ds$->{1..2}.user$->{1..2}

# 指定主键生成策略 主键id通过雪花算法生成
spring.shardingsphere.sharding.tables.user.key-generator.column=id
spring.shardingsphere.sharding.tables.user.key-generator.type=SNOWFLAKE

# 指定分片策略 根据生成的id进行分表
spring.shardingsphere.sharding.tables.user.table-strategy.inline.sharding-column=id
spring.shardingsphere.sharding.tables.user.table-strategy.inline.algorithm-expression=user$->{id % 2 +1}

# 指定库的分片策略
spring.shardingsphere.sharding.tables.user.database-strategy.inline.sharding-column=user_id
spring.shardingsphere.sharding.tables.user.database-strategy.inline.algorithm-expression=ds$->{user_id % 2 +1}
```
<font size="5" color="" face="楷体">3、垂直分库分表</font>
```properties
# 配置真实数据源（给数据源取一个名字）
spring.shardingsphere.datasource.names=ds1,ds2,ds3

# 配置第 1 个数据源（对应自己的数据库）
spring.shardingsphere.datasource.ds1.type=com.alibaba.druid.pool.DruidDataSource
spring.shardingsphere.datasource.ds1.driver-class-name=com.mysql.jdbc.Driver
spring.shardingsphere.datasource.ds1.url=jdbc:mysql://localgost:3306/springboot1?serverTimezone=GMT%2B8
spring.shardingsphere.datasource.ds1.username=root
spring.shardingsphere.datasource.ds1.password=root

# 配置第 2 个数据源（对应自己的数据库）
spring.shardingsphere.datasource.ds2.type=com.alibaba.druid.pool.DruidDataSource
spring.shardingsphere.datasource.ds2.driver-class-name=com.mysql.jdbc.Driver
spring.shardingsphere.datasource.ds2.url=jdbc:mysql://localhost:3306/springboot2?serverTimezone=GMT%2B8
spring.shardingsphere.datasource.ds2.username=root
spring.shardingsphere.datasource.ds2.password=root

# 配置第 3 个数据源（对应自己的数据库）
spring.shardingsphere.datasource.ds3.type=com.alibaba.druid.pool.DruidDataSource
spring.shardingsphere.datasource.ds3.driver-class-name=com.mysql.jdbc.Driver
spring.shardingsphere.datasource.ds3.url=jdbc:mysql://localhost:3306/detail?serverTimezone=GMT%2B8
spring.shardingsphere.datasource.ds3.username=root
spring.shardingsphere.datasource.ds3.password=root

# 指定库表的分布规则
spring.shardingsphere.sharding.tables.user_detail.actual-data-nodes=ds3.user_detail

# 指定主键生成策略 主键id通过雪花算法生成
spring.shardingsphere.sharding.tables.user_detail.key-generator.column=user_id
spring.shardingsphere.sharding.tables.user_detail.key-generator.type=SNOWFLAKE

# 指定分片策略 根据生成的id进行分表
spring.shardingsphere.sharding.tables.user_detail.table-strategy.inline.sharding-column=user_id
spring.shardingsphere.sharding.tables.user_detail.table-strategy.inline.algorithm-expression=user_detail
```
<font size="5" color="" face="楷体">4、公共表操作</font>

在进行分库分表之后，多个数据表的数据会存在公共使用的表，在多个库当中的相同表，再每对其中一个公共表进行操作之后，另外库里面的公共表也会随之进行该变。

```properties
# 配置公共表
spring.shardingsphere.sharding.broadcast-tables=common
spring.shardingsphere.sharding.tables.common.key-generator.column=common_id
spring.shardingsphere.sharding.tables.common.key-generator.type=SNOWFLAKE
```
<font size="5" color="" face="楷体">5、主从复制与读写分离</font>

为了确保数据库产品的稳定性，很多数据库拥有双机热备功能。也就是，第一台数据库服务器，是对外提供增删改业务的生产服务器;第二台数据库服务器，主要进行读的操作。

原理∶让主数据库( master )处理事务性增、改、删操作，而从数据库( slave )处理SELECT查询操作。

从mysql服务安装，以windows下为例，直接复制一份已经安装了的mysql服务，修改对应的my.ini配置文件，将端口、安装位置，数据存储目录的值进行修改即可，修改之后直接进行安装
```cmd
mysqld install mysqlslave --defaults-file="F:\mysql\mysql-8.0.18-winx64-slave\my.ini"
```
下一步就是要对两台mysql服务进行设置主从。首先在主服务器上加上配置：
```ini
[mysqld]
server-id = 1        # 节点ID，确保唯一 一般设置为IP
binlog-do-db=springboot  # 复制过滤：需要备份的数据库，输出binlog
# log config
log-bin = mysql-bin        #开启mysql的binlog日志功能 可以随便取，最好有含义
sync_binlog = 1            #控制数据库的binlog刷到磁盘上去 , 0 不控制，性能最好，1每次事物提交都会刷到日志文件中，性能最差，最安全
binlog_format = mixed      #binlog日志格式，mysql默认采用statement，建议使用mixed
expire_logs_days = 7       #binlog过期清理时间 二进制日志自动删除/过期的天数。默认值为0，表示不自动删除
max_binlog_size = 100m     #binlog每个日志文件大小
binlog_cache_size = 4m     #binlog缓存大小  为每个session 分配的内存，在事务过程中用来存储二进制日志的缓存
max_binlog_cache_size= 512m   #最大binlog缓存大
binlog-ignore-db=mysql     #不需要备份的数据库不生成日志文件的数据库，多个忽略数据库可以用逗号拼接，或者 复制这句话，写多行
## 如：1062错误是指一些主键重复，1032错误是因为主从数据库数据不一致
## 跳过主从复制中遇到的所有错误或指定类型的错误，避免slave端复制中断。
#slave-skip-errors = all #跳过从库错误
slave-skip-errors = all 
auto-increment-offset = 1     # 自增值的偏移量
auto-increment-increment = 1  # 自增值的自增量
```
从服务器上同样的加上配置
```ini
[mysqld]
server-id = 2
log-bin=mysql-bin
relay-log=mysql-relay-bin
replicate-wild-ignore-table=mysql.%
replicate-wild-ignore-table=test.%
replicate-wild-ignore-table=information_schema.%
```
修改配置后将两个mysql服务都进行重启，先进入到主服务器当中查看主服务器的状态：
```cmd
mysql> SHOW MASTER STATUS;

+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000001 |      537 | springboot   | mysql            |                   |
+------------------+----------+--------------+------------------+-------------------+
```
而后进入到从库当中进行主从关联
```cmd
# 先停止同步
STOP SLAVE;

# 修改从库指向到主库，使用上一步记录的文件名以及位点，对应前面主服务的状态数据
CHANGE MASTER TO
MASTER_HOST = 'localhost',
MASTER_USER = 'root',
MASTER_PASSWORD = 'root',
MASTER_LOG_FILE = 'mysql-bin.000001',
MASTER_LOG_POS = 155;

# 启动同步
START SLAVE;

# 查看Slave_IO_Runing和Slave_SQL_Runing字段值都为Yes，表示同步配置成功。
SHOW SLAVE STATUS;
```
修改配置文件对主服务器和从服务器进行相关配置
```properties
# 配置真实数据源（给数据源取一个名字）
spring.shardingsphere.datasource.names=ds1,s1

# 主服务器
spring.shardingsphere.datasource.ds1.type=com.alibaba.druid.pool.DruidDataSource
spring.shardingsphere.datasource.ds1.driver-class-name=com.mysql.jdbc.Driver
spring.shardingsphere.datasource.ds1.url=jdbc:mysql://localhost:3306/springboot?serverTimezone=GMT%2B8
spring.shardingsphere.datasource.ds1.username=root
spring.shardingsphere.datasource.ds1.password=root

# 从服务器
spring.shardingsphere.datasource.s1.type=com.alibaba.druid.pool.DruidDataSource
spring.shardingsphere.datasource.s1.driver-class-name=com.mysql.jdbc.Driver
spring.shardingsphere.datasource.s1.url=jdbc:mysql://localhost:3307/springboot?serverTimezone=GMT%2B8
spring.shardingsphere.datasource.s1.username=root
spring.shardingsphere.datasource.s1.password=root

# 主从关系
spring.shardingsphere.sharding.master-slave-rules.ds1.master-data-source-name=ds1
spring.shardingsphere.sharding.master-slave-rules.ds1.slave-data-source-names=s1

spring.shardingsphere.sharding.tables.user1.actual-data-nodes=ds1.user1
```