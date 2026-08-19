// On désactive le header/footer pour la première page importée
#set page(
  paper: "a4",
  margin: 0cm,
  header: none,
  footer: none
)
#set text(
  font: "Liberation Sans",
  size: 14pt,
  lang: "fr"
)
#image("Couverture type rapport UTBM_P20XX.pdf", width: 100%, height: 100%)

#pagebreak()

#set page(
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2.5cm),
  header: align(right)[#text(12pt, fill: gray)[]],
  footer: context {
    let page_number = counter(page).get().first()
    let total_pages = counter(page).final().first()
    grid(
      columns: (1fr, 1fr),
      align(left)[#text(8pt, fill: gray)[Rapport de stage ST50 - P2026]],
      align(right)[#text(8pt, fill: gray)[Page #page_number sur #total_pages]]
    )
  }
)
#include "introduction.typ"
#pagebreak()
#include "remerciement.typ"
#pagebreak()
#include "glossaire.typ"
#pagebreak()
#include "table_des_matières.typ"
#pagebreak()

#set heading(numbering: "1.1.")

#include "presentation.typ"
#pagebreak()
#include "equipe.typ"
#pagebreak()
#include "travail_realise.typ"
#pagebreak()
#include "travail_realise_ia.typ"
#pagebreak()
#include "synthese.typ"
#pagebreak()
#include "conclusion.typ"
#pagebreak()
#include "annexes.typ"