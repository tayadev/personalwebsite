// ── Page & text defaults ──────────────────────────────────────────────────────

#set document(title: "Lebenslauf")
#set page(
  paper: "a4",
  margin: (x: 1.6cm, y: 1.4cm),
)
#set text(font: ("Noto Sans", "Liberation Sans", "DejaVu Sans"), size: 10pt)
#set par(leading: 0.55em, spacing: 0.9em)
#set list(indent: 0.5em, body-indent: 0.4em)

// ── Palette ───────────────────────────────────────────────────────────────────

#let accent = rgb("#4338ca")   // deep indigo
#let subtle = rgb("#374151")   // secondary text
#let dim    = rgb("#9ca3af")   // dates, locations

// ── Components ────────────────────────────────────────────────────────────────

#let contact-dot = text(fill: dim, "  ·  ")

#let section(title) = {
  v(1.4em)
  text(size: 10pt, weight: "bold", fill: accent, tracking: 1pt, upper(title))
  v(0.25em)
  line(length: 100%, stroke: 0.5pt + rgb("#d1d5db"))
  v(0.5em)
}

#let subsection(title) = {
  v(0.8em)
  text(size: 9.5pt, weight: "bold", fill: accent, tracking: 0.5pt, upper(title))
  v(0.4em)
}

#let entry(title: "", org: "", location: "", dates: "", body: none) = {
  block(breakable: false)[
    #grid(
      columns: (1fr, auto),
      column-gutter: 0.5em,
      [
        *#title* #h(0.4em) #text(fill: subtle, org)
        #if location != "" [ \ #text(size: 9pt, fill: dim, location) ]
      ],
      align(right + horizon, text(size: 9pt, fill: dim, dates)),
    )
    #if body != none {
      v(0.2em)
      body
    }
  ]
  v(0.85em)
}

#let skill-row(label, value) = {
  grid(
    columns: (6.5em, 1fr),
    column-gutter: 0.75em,
    text(weight: "bold", fill: subtle, label),
    value,
  )
  v(0.25em)
}

// ══════════════════════════════════════════════════════════════════════════════
// HEADER
// ══════════════════════════════════════════════════════════════════════════════

#grid(
  columns: (1fr, auto),
  column-gutter: 1.2em,
  align(horizon)[
    #text(size: 26pt, weight: "bold", tracking: -0.5pt, "Taya Ueberwasser")
    #v(0.15em)
    #text(size: 10.5pt, fill: subtle, "Full-Stack Developer & DevOps Engineer")
    #v(0.4em)
    #text(fill: subtle, size: 9.5pt)[
      #link("mailto:taya@taya.net")[taya\@taya.net]
      #contact-dot #link("https://taya.net")[taya.net]
      #contact-dot Zürich, Schweiz
    ]
  ],
  box(clip: true, radius: 4pt, image("photo.png", height: 3.5cm)),
)
#v(0.5em)
#line(length: 100%, stroke: 0.5pt + rgb("#e5e7eb"))

// ══════════════════════════════════════════════════════════════════════════════
// ÜBER MICH
// ══════════════════════════════════════════════════════════════════════════════

#section("Über mich")

Selbstgelernte Full-Stack-Entwicklerin mit umfangreicher Erfahrung in DevOps,
Infrastruktur, Automatisierung und Observability. Mitgründerin und technische Leitung
von GINCo, einer internationalen Spieleentwicklungs-Kooperative, wo ich Infrastruktur
und Entwicklung in einem Team aus sieben Ländern leite. Meine Arbeit umfasst
Reliability Engineering, Entwickler-Tools und die Skalierung von Systemen.
Mir liegt Systemdesign am Herzen und ich baue gerne Tools, die Teams
effektiver machen.

// ══════════════════════════════════════════════════════════════════════════════
// ERFAHRUNG
// ══════════════════════════════════════════════════════════════════════════════

#section("Berufserfahrung")

#entry(
  title: "Mitgründerin & Technische Leitung",
  org: "GINCo",
  location: "Remote",
  dates: "2024 – heute",
  body: [
    - Mitgründerin einer internationalen Spieleentwicklungs-Kooperative mit Fokus auf
      Hytale- und Minecraft-Modding, Leitung von Infrastruktur und Entwicklung in
      einem Team aus sieben Ländern.
    - Erster Platz in den Kategorien Community- und Jury-Voting beim Hytale New Worlds
      Modding Contest mit *Byte Crashers*, gegen Hunderte von Einträgen weltweit.
    - Verantwortlich für Infrastruktur, interne Tools und organisatorische
      Verwaltung neben aktiver Entwicklungsarbeit.
  ]
)

#entry(
  title: "Freiberufliche Entwicklerin & DevOps Engineer",
  org: "Selbstständig",
  location: "Remote",
  dates: "2020 – 2024",
  body: [
    - Infrastruktur mit Linux, Docker, Ansible und NixOS aufgebaut und verwaltet.
    - CI/CD-Pipelines mit GitHub Actions und GitLab CI eingerichtet und betreut.
    - Monitoring und Alerting mit Prometheus und Grafana implementiert.
    - Frontend- und Backend-Projekte für Kunden in verschiedenen Bereichen umgesetzt.
  ]
)

#entry(
  title: "Tooling Developer",
  org: "oectway (Microsoft Partner)",
  location: "Zürich, Schweiz",
  dates: "2020",
  body: [
    - Interne Tools in Node.js entwickelt zur Unterstützung von
      Entwicklungsabläufen.
    - Code refaktoriert, um Portierbarkeit und Wiederverwendbarkeit zu verbessern.
    - Build- und Release-Prozesse mit GitHub Actions automatisiert.
  ]
)

#entry(
  title: "Systemadministratorin & Broadcast-Leiterin",
  org: "Klimastreik Schweiz / FridaysForFuture International",
  location: "Zürich, Schweiz",
  dates: "2018 – 2021",
  body: [
    - Systemadministration und DevOps für die IT-Infrastruktur beider Organisationen
      verwaltet.
    - Broadcast- und Videoproduktion für Klimastreik-Veranstaltungen und
      -Kampagnen geleitet.
  ]
)

// ══════════════════════════════════════════════════════════════════════════════
// FÄHIGKEITEN & PROJEKTE
// ══════════════════════════════════════════════════════════════════════════════

#pagebreak()
#section("Skills & Projekte")

#subsection("Skills")

#skill-row("Sprachen", "Lua, JavaScript/TypeScript, Java/Kotlin, C#, HTML/CSS, Python, Bash")
#skill-row("DevOps & Infra", "Docker, Ansible, NixOS, GitHub Actions, GitLab CI, Kubernetes, Proxmox")
#skill-row("Plattformen", "Web, Desktop, Linux-Server, Cloud, Container")
#skill-row("Sprach­kenntnisse", "Deutsch (Muttersprache), Englisch (fliessend)")

#subsection("Projekte")

#entry(
  title: "Byte Crashers",
  org: "GINCo",
  dates: "2026",
  body: [
    - Multiplayer-Spiel, entwickelt mit GINCo für den Hytale New Worlds Game Jam.
      Erster Platz in den Kategorien Community- und Jury-Voting, gegen Hunderte
      von Einträgen weltweit.
  ]
)

#entry(
  title: "Homelab & GINCo-Infrastruktur",
  org: "Persönlich / GINCo",
  dates: "Laufend",
  body: [
    - Selbst gehostetes Homelab mit Talos Linux und Kubernetes, das auch als
      Produktionsinfrastruktur für GINCo dient.
  ]
)

#entry(
  title: "StreamdeckLinux",
  org: "Persönlich",
  dates: "2025",
  body: [
    - Rust-Daemon und CLI für Elgato Stream Deck-Geräte unter Linux, mit
      systemd-Integration.
  ]
)

#entry(
  title: "Luma",
  org: "Persönlich",
  dates: "2024 – 2025",
  body: [
    - Eine Programmiersprache inspiriert von Lua und Rust entworfen und
      implementiert, mit einem Referenz-Interpreter in Rust.
    - Beinhaltet eine VS Code-Erweiterung mit Sprachunterstützung.
  ]
)

#entry(
  title: "Hytale Thankmas",
  org: "GINCo",
  dates: "2024, 2025",
  body: [
    - Minecraft-Erlebnisserver für das Thankmas-Charity-Event entwickelt.
  ]
)

#entry(
  title: "Klimastreik Schweiz Website",
  org: "Ehrenamtlich",
  dates: "2018 – 2021",
  body: [
    - Die Website für Klimastreik Schweiz entwickelt und gewartet.
  ]
)
