#import "template.typ": *
#[
  #set align(center)
  #set text(font: "Source Han Sans")

  #v(5cm)
  #set text(size: 36pt)
  《数据库系统》\ 作业10

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

== 14.3[a]

#figure(  image("2024-05-12-18-30-50.png", width: 100%), ) 

== 14.4

=== [a]

+ Insert 9.
  #figure(  image("2024-05-12-18-36-03.png", width: 100%),) 
+ Insert 10.
  #figure(  image("2024-05-12-18-39-09.png", width: 100%), ) 
+ Insert 8.
  #figure(  image("2024-05-12-18-39-48.png", width: 100%), ) 
+ Delete 23.
  #figure(  image("2024-05-12-18-43-12.png", width: 100%), ) 
+ Delete 19.
  #figure(  image("2024-05-12-18-44-20.png", width: 100%), ) 

=== [b]

+ Insert 9.
  #figure(  image("2024-05-12-18-49-40.png", width: 100%), ) 
+ Insert 10.
  #figure(  image("2024-05-12-18-50-39.png", width: 100%), ) 
+ Insert 8.
  #figure(  image("2024-05-12-18-53-05.png", width: 100%), ) 
+ Delete 23.
  #figure(  image("2024-05-12-18-53-34.png", width: 100%), ) 
+ Delete 19.
  #figure(  image("2024-05-12-18-54-28.png", width: 100%), ) 

=== [c]

+ Insert 9.
  #figure(  image("2024-05-12-18-58-10.png", width: 100%), ) 
+ Insert 10.
  #figure(  image("2024-05-12-18-58-37.png", width: 100%), ) 
+ Insert 8.
  #figure(  image("2024-05-12-19-00-39.png", width: 100%), ) 
+ Delete 23.
  #figure(  image("2024-05-12-19-01-09.png", width: 100%), ) 
+ Delete 19.
  #figure(  image("2024-05-12-19-01-39.png", width: 100%), ) 

== 14.11

如果有一段时间没有更新，但是在某个level上有很多索引查找，那么可以把这个level的索引合并到下一个level上，减少了在这个level上的索引查找次数，提高了查询性能。

== 24.10

- 优点
  + 每个级别有多个树，可以减少数据的重复写入，从而减小写放大效应。
  + 可以并行地将数据写入多个树，从而提高写入性能。
  + 在查询时，可以并行地从多个树中读取数据，从而提高读性能。
- 缺点
  + 每个级别有多个树，意味着需要更多的存储空间来存储这些树。
  + 需要维护更多的树，这可能会增加维护成本，例如，需要更多的时间来合并树，需要更多的内存来缓存树的元数据等。
  + 在查询时，需要从多个树中查找数据，这可能会增加查询的复杂性。