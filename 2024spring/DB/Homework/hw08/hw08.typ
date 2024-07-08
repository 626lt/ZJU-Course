#import "template.typ": *
#[
  #set align(center)
  #set text(font: "Source Han Sans")

  #v(5cm)
  #set text(size: 36pt)
  《数据库系统》\ 作业8

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
    [日期：], [#uline[2024年4月28日]],
  )

  #pagebreak()
]

#show: doc => dbhw(doc)

== 7.1

$R_1 sect R_2 = A, A$ 是 candidate key，因此 $R_1$ 和 $R_2$ 是无损链接的

== 7.13

$A -> B C$ 在 $R_1$ 中依赖保持

$C D->E$ 不满足依赖保持:
result = C D; 
- $"result" sect R_1 = {C}, C^+={C},C^+ sect R_1 ={C}$不包含E
- $"result" sect R_2 = {D}, D^+={D},D^+ sect R_2 ={D}$不包含E

== 7.21

$(A,B,C,E),(B,D)$

== 7.22

$R_1 = {A,B,C},R_2={C,D,E},R_3={B,D},R_4={E,A}$

== 7.30

a. $B^+={A,B,C,D,E}$

b. $A->B C,B C->D E$，所以$A->D E$，所以$A G$是superkey

c. $A->D,A->B,A->C,B C->E$

d. ${A,B,C},{B,C,E},{B,D},{D,A},{A,G}$

e. ${A,B,C},{B,D},{A,E},{A,G}$