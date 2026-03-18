
// Définition de la fonction de template pour le rapport
#let project(
  title: "",
  subtitle: "",
  author: "",
  school: "UTBM",
  company: "",
  date: datetime.today().display(),
  body
) = {
  // Configuration de base du document
  set document(author: author, title: title)
  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 2.5cm),
    numbering: "1 / 1",
    header: locate(loc => {
      if loc.page() > 1 {
        grid(
          columns: (1fr, 1fr),
          align(left)[#smallcaps(title)],
          align(right)[#date]
        )
        line(length: 100%, stroke: 0.5pt)
      }
    })
  )
  set text(font: "Linux Libertine", lang: "fr", size: 11pt)
  set heading(numbering: "1.1")

  // Page de garde
  align(center + horizon)[
    #text(2em, weight: "bold", school)
    #v(1em)
    #text(1.5em, weight: "bold", title)
    #if subtitle != "" {
      v(0.5em)
      text(1.2em, style: "italic", subtitle)
    }
    #v(2em)
    #text(1.1em)[Rapport de Stage ST50]
    #v(1em)
    #text(1.1em)[Auteur : #author]
    #if company != "" {
      v(0.5em)
      text(1.1em)[Entreprise : #company]
    }
    #v(2em)
    #text(0.9em)[#date]
  ]
  pagebreak()

  // Table des matières
  outline(depth: 3, indent: true)
  pagebreak()

  // Contenu du document
  body
}

