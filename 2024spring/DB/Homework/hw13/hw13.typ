#import "template.typ": *
#[
  #set align(center)
  #set text(font: "Source Han Sans")

  #v(5cm)
  #set text(size: 36pt)
  《数据库系统》\ 作业13

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
    [日期：], [#uline[2024年6月2日]],
  )

  #pagebreak()
]

#show: doc => dbhw(doc)

== 17.6

使用topological sort，可以得到如下的执行顺序：$T_1,T_2,T_3,T_4,T_5$

== 17.7

a cascadeless schedule 指的是事务$T_j$读的时候如果$T_i$之前写了, 那么会阻塞直到$T_i$提交.

cascadeless schedule 可以确保不会因为一个事物abort导致其他事物rollback.但是缺点是并发性差，如果很少出现abort的话，可以使用noncascadeless schedules.