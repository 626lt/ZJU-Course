# Ch1 introduction

## Database Systems

1. 数据库是关于企业的相互关联数据的集合，由DBMS（数据库管理系统）管理。
2. DBMS 的主要目标是提供一种既方便又高效的方法来存储和检索数据库信息。
3. 数据管理既包括定义信息存储的结构，也包括提供信息操作的机制。
4. 数据库系统必须确保所存储信息的安全性，即使系统崩溃或未经授权的访问尝试也是如此。
5. 如果要在多个用户之间共享数据，系统必须提供并发控制机制，以避免可能的异常结果。

## Database Applications（数据库应用、数据库应用系统）

!!! example

    + Enterprise Information（企业信息）
      + 销售：客户、产品、采购
      + 会计：付款、收据、资产
      + 人力资源：员工、工资、工资税。
    + 制造：生产、库存、订单、供应链
    + 银行：客户、账户、贷款、信用卡、交易
    + 大学：教师、学生、课程、注册、成绩
    + 航空公司：预订信息、时刻表
    + 基于web的服务
      + 在线零售商：订单跟踪、定制推荐、在线广告

+ Database 与生活息息相关
  + 数据库非常大 —— 大数据
  + 数据驱动人工智能 —— AI 2.0
  + 数字经济 —— 数据要素市场

!!! examle

    应用程序示例： 银行
    + 添加客户
    + 开立账户
    + 存钱/取款
    + 贷款/偿还贷款

    数据库示例： 大学
    + 添加新学生、教师和课程
    + 为学生注册课程，并生成班级名册
    + 为学生分配成绩
    + 计算平均绩点 （GPA） 并生成成绩

## 数据库系统的目标(purpose)

基于文件系统的数据库应用存在以下问题：

+ Data redundancy（数据冗余） and inconsistency（不一致）
  + Multiple file formats, duplication of information in different files
+ Data isolation（数据孤立，数据孤岛） 
  + multiple files and formats
+ Difficulty in accessing data （存取数据困难）
  + Need to write a new program to carry out each new task

因此数据库要实现的目标如下：

1. Integrity problems（完整性问题）
    完整性约束被“埋没”在程序代码中，而不是被明确声明（显式的）
    **Example**:  “account balance >=1”
    难以添加新约束或更改现有约束   
2. 原子性问题（原子性问题）
    故障可能会使数据库处于与执行部分更新不一致的状态
    示例：将资金从一个账户转移到另一个账户应该完成或根本不发生，而完成一半这种情况不允许存在（一边扣钱另一边没到账）
3. 并发访问异常（并发访问异常）
    性能所需的并发访问
    不受控制的并发访问可能会导致不一致
    **Example**: 两个人同时读取了账户余额并同时存入50元。
4. Security problems（安全性问题）
    很难为用户提供对某些（但不是全部）数据的访问权限，需要
    + Authentication（认证）
    + Priviledge （权限）
    + 审计（审计）

## 数据库系统的特征

+ Data persistence（数据持久性）
+ convenience in accessing data（数据访问便利性）
+ Data Integrity （数据完整性）
+ concurrency control for multiple users（多用户并发控制）
+ failure recovery（故障恢复）
+ security control（安全控制）

## 数据模型(Data Models)

1. 用于描述的工具集合
   + Data （数据）
   + Data relationships（联系）
   + Data semantics（语义）
   + Data constraints（约束）
2. **Relational model(关系模型)**
3. 基于对象的数据模型
   + Object-oriented （面向对象数据模型）
   + Object-relational（对象-关系模型模型）
4. Semistructured data model （XML）（半结构化数据模型）
5. 其他旧模型：
   + Network model （网状模型）
   + Hierarchical model（层次模型）
   + Entity-Relationship model（实体-联系模型） （ 主要用于数据库设计 ）

### Relation Model（关系模型）

提出者：Edgar F. Codd :Turing Award 1981

!!! example

    Columns / Attributes（列/属性）
    Rows / Tuples（行/元组）

## 数据视图

数据库的三级抽象：

![alt text](image.png)

### Schema and Instance （架构与实例）

+ 类似于编程语言中的类型和变量
+ Logical Schema （逻辑模式）– 数据库的逻辑结构
  + 示例：数据库包含有关一组客户和帐户的信息以及它们之间的关系
  + 类似于程序中变量的类型信息
+ Physical schema （物理模式） – 数据库的整体物理结构
+ Instance（实例） – 数据库在特定点的实际内容
  + 类似于变量的值

## 数据独立性

+ Physical Data Independence（物理数据独立性） – 在不更改逻辑架构的情况下修改物理架构的能力
  + 应用程序依赖于逻辑架构
  + 通常，各个级别和组件之间的接口应明确定义，以便某些部分的更改不会严重影响其他部分。
+ Logical Data Independence（逻辑数据独立性） – 在不更改用户视图架构的情况下修改逻辑架构的能力

## 数据库语言

+ Data Definition Language (DDL)  数据定义
+ Data Manipulation Language (DML)  数据操作
+ SQL Query Language SQL查询
+ Application Program Interface （API） 应用接口

### Data Definition Language (DDL) 数据定义语言

+ 用于定义数据库模式的规范表示
+ Example: 
  ``` 
  create table instructor(
        ID        char(5),
        name      varchar(20),
        dept_name varchar(20),
        salary    numeric(8,2)
  ) 
  ```
+ DDL 编译器生成一组存储在数据字典中的表模板（数据字典）
+ Data dictionary contains metadata (元数据， i.e., data about data)
  + Database schema （数据库架构）
  + Integrity constraints（完整性约束）
  + Primary key (ID uniquely identifies instructors)（主键）
    + Referential integrity (references constraint in SQL)（参照完整性）
      + e.g. dept_name value in any instructor tuple must appear in department relation
  + Authorization（权限）

### Data Manipulation language (DML) 数据操作语言

+ 用于访问和操作由相应数据模型组织的数据的语言
  + DML 也称为查询语言
+ 两类(class)语言
  + Procedural（过程式） – 用户指定需要哪些数据以及如何获取这些数据
  + Declarative （nonproprocedureural， 陈述式，非过程式） – 用户指定需要哪些数据，但未指定如何获取这些数据
+ SQL 是使用最广泛的查询语言

### SQL Query Language 查询语言

SQL：广泛使用的非过程语言

!!! example

    ![alt text](image-1.png)

### 从应用程序访问数据库

+ 过程查询语言（如 SQL）不如通用图灵机强大。
+ SQL 不支持用户输入、输出到显示器或通过网络进行通信等操作。
+ 此类计算和操作必须用宿主语言（宿主语言）编写，例如 C/C++、Java 或 Python。
+ 应用程序通常通过以下方式之一访问数据库
  + API（应用程序接口）（例如，ODBC/JDBC），允许将SQL查询发送到数据库
  + 允许嵌入式 SQL 的语言扩展

## Database Design（数据库设计）

+ Entity Relationship Model （实体-联系模型）
  + 将企业建模为数据实体和关系的集合 
  + 实体关系图以图示方式表示。
    ![alt text](image-2.png)
+ Normalization Theory（规范化理论）
  + 正式确定哪些设计是坏的，并对其进行测试

## Database Engine(数据库引擎)

+ 数据库系统（数据库引擎）被划分为多个模块，这些模块处理整个系统的每个职责。
+ 数据库系统的功能组件可分为
  + 存储管理器
  + 查询处理器 
  + 事务管理组件
![alt text](image-3.png)

## Storage Manager （存储管理）

+ 一个程序模块，它提供存储在数据库中的低级数据与提交给系统的应用程序和查询之间的接口。
+ 存储管理器负责以下任务：
  + 与操作系统文件管理器的交互
  + 高效存储、检索和更新数据
+ 存储管理器组件包括：
  + 文件管理器
  + 缓冲区管理器
  + 授权和完整性管理器
  + 事务管理器

+ 存储管理器在物理系统实现过程中实现多个数据结构：
  + 数据文件 -- 存储数据库本身
  + 数据字典 -- 存储有关数据库结构的元数据，特别是数据库的架构。
  + 索引 -- 可以提供对数据项的快速访问。 数据库索引提供指向包含特定值的数据项的指针。 
  + 统计数据

## Query Processor（查询处理器）

+ 查询处理器组件包括：
  + DDL 解释器 -- 解释 DDL 语句并将定义记录在数据字典中。
  + DML 编译器 -- 将查询语言中的 DML 语句转换为由查询评估引擎理解的低级指令组成的评估计划。
    + DML 编译器执行查询优化;也就是说，它从各种备选方案中选择成本最低的评估计划。
  + 查询评估引擎 -- 执行 DML 编译器生成的低级指令。

### 查询过程

1.	Parsing and translation 解析和翻译
2.	Optimization 优化
3.	Evaluation 评估

![alt text](image-4.png)

## Transaction Management	（事务管理）

+ 事务是在数据库应用程序中执行单个逻辑功能的操作集合。
+ Recover Manager 可确保数据库在发生系统故障（例如电源故障和操作系统崩溃）和事务故障时仍能保持一致（正确）的状态。
+ 并发控制管理器控制并发事务之间的交互，以保证数据库的一致性。

## 数据库用户

![alt text](image-5.png)
![alt text](image-6.png)

+ 用户通过他们期望与系统交互的方式进行区分
  + 应用程序程序员 – 通过 DML 调用与系统交互
  + 普通用户 – 调用以前编写的永久应用程序之一
    + 例如，通过网络访问数据库的人、银行出纳员、文员  
  + 数据库管理员 - 协调数据库系统的所有活动;数据库管理员对企业的信息资源和需求有很好的了解。

### Database Administrator（DBA）数据库管理员

+ 数据库管理员的职责包括：
  + Schema definition（架构定义）
    + 存储结构和访问方法定义
    + 架构和物理组织修改
  + 授予用户访问数据库的权限
  + 日常维护
    + 性能调优 - 监视性能并响应需求变化
    + 定期将数据库备份到远程服务器上
    + 确保有足够的可用磁盘空间用于正常操作，并根据需要升级磁盘空间
  
