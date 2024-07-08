#import "template.typ": *
#[
  #set align(center)
  #set text(font: "Source Han Sans")

  #v(5cm)
  #set text(size: 36pt)
  《数据库系统》\ 作业9

  #set text(font: ("Linux Libertine", "LXGW WenKai Mono"))
  #v(2cm)
  #set text(size: 15pt)
  #grid(
    columns: (80pt, 180pt),
    rows: (27pt, 27pt, 27pt, 27pt),
    [姓名：], [#uline[刘韬]],
    [学院：], [#uline[竺可桢学院]],
    [专业：], [#uline[人工智能]],
    [邮箱：], [#uline[3220103422\@zju.edu.cn]],
  )

  #v(2cm)
  #set text(size: 18pt)
  #grid(
    columns: (100pt, 200pt),
    [日期：], [#uline[2024年5月2日]],
  )

  #pagebreak()
]

#show: doc => dbhw(doc)

== 12.1

第一种情况下，SSD作为 storage layer 更好，如果作为 cache 一些请求可能需要在磁盘上读取，造成延迟

第二种情况下，SSD作为 cache 更好，由于 large customer relation，不能够将所有的 relation 都分配到SSD上，此时SSD作为cache可以提高性能

== 13.5

使用hash table，可以通过hash值快速定位到对应的数据，对数据量大的时候提高效率。

== 13.9

+ length fields = -1 ,offset 任意
+ 可以在记录的开头存储空 bitmap 就不用存储具体数据，这样的表示可以节省一定的空间，代价是需要额外的工作来提取记录的属性。

== 13.11

+ Store each relation in one file.
  - Advantages:
    + 简化数据管理：每个文件对应一个关系，可以方便地管理和操作每个关系，而无需在一个大文件中搜索特定的关系。
    + 提高性能：如果一个查询只涉及到一个或几个关系，那么数据库只需要读取这些关系对应的文件，而不需要读取整个数据库文件，这可以提高查询性能。
  — Disadvantages:
    + 空间浪费：每个关系对应一个文件，可能会导致空间浪费，因为每个文件都需要一定的存储空间来存储文件头等信息。
    + 管理复杂：如果数据库中有很多关系，那么管理这些文件可能会变得复杂，需要维护很多文件，可能会导致管理成本增加。

+ Store multiple relations (perhaps even the entire database) in one file.
  - Advantages
    + 每次读写只需要对一个file进行，减少了系统调用的开销。
    + 一个文件可以被多个进程共享，可以减少文件的打开和关闭的开销。
  - Disadvantages
    + 一个文件中包含多个关系，可能会导致文件过大，读取时需要读取整个文件，可能会导致性能下降。
    + 如果一个查询只涉及到一个或几个关系，那么数据库需要读取整个文件，可能会导致性能下降。  

