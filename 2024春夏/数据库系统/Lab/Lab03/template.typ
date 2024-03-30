#let thickness = 0.8pt
#let offset = 4pt
#let ubox(..) = box(
  width: 1fr,
  baseline: offset,
  stroke: (bottom: thickness),
)
#let uline(body) = {
  ubox()
  underline(
    stroke: thickness,
    offset: offset,
  )[#body]
  ubox()
}

#let jizu(doc) = {
  set text(font: "Source Han Serif SC")
  set list(marker: ([♢], [▹], [–]))

  set par(first-line-indent: 2em, leading: 11pt)
  show heading: it => {it; h(0em); v(-1.2em)}
  show figure: it => {it; h(0em); v(-1.2em)}
  show list: it => {it; h(0em); v(-0.9em)}

  show heading.where(level: 1): set align(center)
  show heading.where(level: 2): set block(below: 15pt)
  show heading.where(level: 1): set text(size: 20pt, font: "Source Han Serif SC")
  show heading.where(level: 2): set text(size: 16pt, font: "Source Han Serif SC")
  show heading.where(level: 3): set text(size: 14pt, font: "Source Han Serif SC")
  show heading.where(level: 4): set text(size: 13pt, font: "SimHei")
  set heading(numbering: (..args) => {
    let nums = args.pos()
    let level = nums.len()
    if level == 2 {
      numbering("1.", nums.at(1))
    } else if level == 3 {
      [Part #numbering("I ", nums.at(2))]
    } else if level == 5 {
      numbering("（一）", nums.at(4))
    }
  })

  show figure.caption: it => [
    #set text(size: 8pt, font: "LXGW WenKai Mono")
    图#it.counter.display(it.numbering)：#it.body
  ]

  show raw: it => {
    set text(font: ("Fira Code", "LXGW WenKai Mono"))
    if it.block {
      set par(leading: 7pt)
      block(
        width: 100%,
        fill: rgb("#fafafa"),
        inset: 8pt,
        radius: 10pt,
        it
      )
      h(0em); v(-1.2em)
    } else {
      it
    }
  }

  doc
}