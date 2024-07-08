#import "template.typ": *
#[
  #set align(center)
  #set text(font: "Source Han Sans")

  #v(5cm)
  #set text(size: 36pt)
  《数据库系统》\ 作业7

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
    [日期：], [#uline[2024年4月7日]],
  )

  #pagebreak()
]

#show: doc => dbhw(doc)

== 6.1

实体：customers,cars,recorded accidents,insurance policy,premium payments

#figure(image("2024-04-20-18-34-48.png"))

== 6.2

=== 

实体:students, courses, section, exam

#figure(image("2024-04-20-19-19-50.png"))

#pagebreak()
=== 

#figure(image("2024-04-20-19-22-22.png"))

== 6.21

=== 

#figure(image("2024-04-20-19-35-23.png"))

===

#figure(image("2024-04-20-19-43-08.png"))
