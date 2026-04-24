// ============= CHARTE GRAPHIQUE =============
#let primary-color = rgb("1f4e79")
#let secondary-color = rgb("eef4fa") 
#let accent-color = rgb("d9534f") 
#let success-color = rgb("5cb85c")
#let info-color = rgb("5bc0de")
#let warning-color = rgb("f0ad4e")
#let dark-color = rgb("2c3e50")

// ============= FONCTIONS UTILITAIRES =============

// Encart de mise en évidence avec bordure latérale
#let callout(body, title: "Important", color: primary-color) = {
  block(
    width: 100%,
    fill: color.lighten(90%),
    stroke: (left: 4pt + color),
    inset: 12pt,
    radius: 4pt,
    [
      #text(weight: "bold", fill: color, size: 11pt)[#title] \
      #v(0.2em)
      #body
    ]
  )
}

// Boîte d'information avec arrière-plan coloré
#let info-box(body, title: none, color: info-color) = {
  block(
    width: 100%,
    fill: color.lighten(85%),
    stroke: 1pt + color,
    inset: 12pt,
    radius: 4pt,
    [
      #if title != none [
        #text(weight: "bold", fill: color, size: 11pt)[#title]
        #v(0.3em)
      ]
      #text(size: 10pt)[#body]
    ]
  )
}

// Section avec titre et séparation
#let section-box(body, title: "Section") = {
  block(
    width: 100%,
    inset: 0pt,
    [
      #text(weight: "bold", fill: primary-color, size: 13pt)[#title]
      #line(length: 100%, stroke: 1.5pt + primary-color)
      #v(0.5em)
      #body
    ]
  )
}

// Liste stylisée avec puces colorées
#let styled-list(items, color: primary-color) = {
  list(
    ..items.map(item => {
      strong(text(fill: color, "▸ ")) + item
    })
  )
}

// Bloc de code avec titre
#let code-block(code, title: "Code", language: "") = {
  block(
    width: 100%,
    fill: rgb("f5f5f5"),
    stroke: 1pt + gray,
    inset: 12pt,
    radius: 4pt,
    [
      #if title != none [
        #text(weight: "bold", fill: dark-color, size: 10pt)[#title]
        #if language != "" [ (#language) ]
        #v(0.3em)
        #line(length: 100%, stroke: 0.5pt + gray)
        #v(0.3em)
      ]
      #raw(code, block: true, lang: if language != "" { language } else { none })
    ]
  )
}
