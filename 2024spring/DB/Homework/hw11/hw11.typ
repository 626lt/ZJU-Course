#import "template.typ": *
#[
  #set align(center)
  #set text(font: "Source Han Sans")

  #v(5cm)
  #set text(size: 36pt)
  《数据库系统》\ 作业11

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

== 15.2

#figure(  image("2024-05-19-16-33-26.png", width: 100%),  caption: "",) 

== 15.3

r1 800 blocks, r2 1500 blocks; 设内存大小为 M blocks.

- a. Nested-loop join.

  + r1在外层: $20000 times 1500 + 800 = 30000800$ disk accesses. $20000 + 800 = 20800$ disk seeks.
  + r2在外层: $45000 times 800 + 1500 = 36001,00$ disk accesses. $45000 + 1500 = 46500$ disk seeks.

- b. Block nested-loop join

  + r1在外层 $ceil(800/(M-2))times 1500 + 800$ disk accesses. $2 times ceil(800/(M-2))$ disk seeks.
  + r2在外层 $ceil(1500/(M-2))times 800 + 1500$ disk accesses. $2 times ceil(1500/(M-2))$ disk seeks.

- c.Merge join.
  假设$b_b = 1$
  $B_s = 1500(2ceil(log_(M-1)(1500/M)) + 2) + 800(2ceil(log_(M-1)(800/M)) + 2)$
  $B_r = 1500 + 800$
  那么 $B_r + B_s$ disk accesses and disk seeks.

- d. Hash join.

  + if no need recursive partitioning : $3 times (1500 + 800) = 6900$ disk accesses, $2 times (1500 + 800) = 4600$ disk seeks.
  + if recursive partitioning required : $2times(1500+800)ceil(log_(M-1)(800)-1)+1500+800$ disk accesses, $2times(1500+800)ceil(log_(M-1)(800)-1)$ disk seeks.
