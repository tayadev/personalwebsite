// ── Page & text defaults ──────────────────────────────────────────────────────

#set document(title: "Resume")
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
    columns: (5.5em, 1fr),
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
      #contact-dot Zürich, Switzerland
    ]
  ],
  box(clip: true, radius: 4pt, image("photo.png", height: 3.5cm)),
)
#v(0.5em)
#line(length: 100%, stroke: 0.5pt + rgb("#e5e7eb"))

// ══════════════════════════════════════════════════════════════════════════════
// ABOUT
// ══════════════════════════════════════════════════════════════════════════════

#section("About")

Self-taught full-stack developer with strong experience in DevOps, infrastructure,
automation, and observability. Co-founder and technical lead of GINCo, an
international game development cooperative where I lead infrastructure and
development across a team in seven countries. My work covers reliability
engineering, developer tooling, and scaling systems, built through open-source
collaboration and real-world projects. I care about systems design and building
tooling that makes teams more effective.

// ══════════════════════════════════════════════════════════════════════════════
// EXPERIENCE
// ══════════════════════════════════════════════════════════════════════════════

#section("Experience")

#entry(
  title: "Co-founder & Technical Lead",
  org: "GINCo",
  location: "Remote",
  dates: "2024 – Present",
  body: [
    - Co-founded an international game development cooperative focused on Hytale
      and Minecraft modding, leading infrastructure and development across a team
      in seven countries.
    - Won first place in both the community and jury vote categories of the Hytale
      New Worlds modding contest with *Byte Crashers*, beating hundreds of entries
      worldwide.
    - Handle infrastructure, internal tooling, and organizational administration
      alongside active development work.
  ]
)

#entry(
  title: "Freelance Developer & DevOps Engineer",
  org: "Self-employed",
  location: "Remote",
  dates: "2020 – 2024",
  body: [
    - Built and managed infrastructure using Linux, Docker, Ansible, and NixOS.
    - Set up and maintained CI/CD pipelines with GitHub Actions and GitLab CI.
    - Implemented monitoring and alerting with Prometheus and Grafana.
    - Delivered frontend and backend work for clients across a range of projects.
  ]
)

#entry(
  title: "Tooling Developer",
  org: "oectway (Microsoft Partner)",
  location: "Zürich, Switzerland",
  dates: "2020",
  body: [
    - Built internal tools in Node.js to support and streamline development workflows.
    - Refactored code to improve portability and reuse across projects.
    - Automated build and release processes with GitHub Actions.
  ]
)

#entry(
  title: "Systems Administrator & Broadcast Director",
  org: "Climatestrike Switzerland / FridaysForFuture International",
  location: "Zürich, Switzerland",
  dates: "2018 – 2021",
  body: [
    - Handled sysadmin and DevOps for IT infrastructure across both organizations.
    - Directed broadcast and video production for Climatestrike events and campaigns.
  ]
)

// ══════════════════════════════════════════════════════════════════════════════
// SKILLS & PROJECTS
// ══════════════════════════════════════════════════════════════════════════════

#pagebreak()
#section("Skills & Projects")

#subsection("Skills")

#skill-row("Languages", "Lua, JavaScript/TypeScript, Java/Kotlin, C#, HTML/CSS, Python, Bash")
#skill-row("DevOps & Infra", "Docker, Ansible, NixOS, GitHub Actions, GitLab CI, Kubernetes, Proxmox")
#skill-row("Platforms", "Web, Desktop, Linux servers, Cloud, Containers")
#skill-row("Spoken", "German (native), English (fluent)")

#subsection("Projects")

#entry(
  title: "Byte Crashers",
  org: "GINCo",
  dates: "2026",
  body: [
    - Multiplayer game built with GINCo for the Hytale New Worlds Game Jam.
  ]
)

#entry(
  title: "Homelab & GINCo Infrastructure",
  org: "Personal / GINCo",
  dates: "Ongoing",
  body: [
    - Self-hosted homelab running Talos Linux and Kubernetes, also used as
      production infrastructure for GINCo.
  ]
)

#entry(
  title: "StreamdeckLinux",
  org: "Personal",
  dates: "2025",
  body: [
    - Rust daemon and CLI for using Elgato Stream Deck devices on Linux, with
      systemd integration.
  ]
)

#entry(
  title: "Luma",
  org: "Personal",
  dates: "2024 – 2025",
  body: [
    - Designed and implemented a programming language inspired by Lua and Rust,
      with a reference interpreter written in Rust.
    - Includes a VS Code extension with language support.
  ]
)

#entry(
  title: "Hytale Thankmas",
  org: "GINCo",
  dates: "2024, 2025",
  body: [
    - Developed a Minecraft experience server for the Thankmas charity event.
  ]
)

#entry(
  title: "Climatestrike Switzerland Website",
  org: "Volunteer",
  dates: "2018 – 2021",
  body: [
    - Built and maintained the website for Climatestrike Switzerland.
  ]
)
