# sadegroo/portfolio

Personal portfolio and project blog — built with [Hugo](https://gohugo.io/) and deployed via GitHub Pages.

Live at: **[sadegroo.github.io](https://sadegroo.github.io)** *(update once live)*

---

## About

This site collects writeups on projects I work on across embedded systems, control engineering, 3D printing, and home automation. Posts aim to be more readable than a technical README.

Current topics include:

- 3D printing projects and STL releases
- Home automation and embedded tinkering
- BLDC motor control and pendulum stabilization (STM32, FOC)

---

## Stack

- **[Hugo](https://gohugo.io/)** — static site generator
- **[PaperMod](https://github.com/adityatelange/hugo-PaperMod)** — theme
- **GitHub Actions** — automated build and deploy to `gh-pages` branch
- **GitHub Pages** — hosting

---

## Local Development

Requires [Hugo extended](https://gohugo.io/installation/) (v0.120+).

```bash
git clone --recurse-submodules git@github.com:sadegroo/portfolio.git
cd portfolio
hugo server -D
```

The site runs at `http://localhost:1313` with live reload.

---

## Structure

```
content/
  posts/          # Project writeups and blog posts
  projects/       # Project index pages
static/           # Images and other assets
themes/PaperMod/  # Theme (git submodule)
hugo.toml         # Site configuration
```

---

## License

This repository contains two types of content with different licenses:

**Site code** (Hugo configuration, templates, layouts, GitHub Actions workflows) is licensed under the **[MIT License](LICENSE)**.

**Written content** (all posts and articles under `content/`) is licensed under **[Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)** — you are free to share and adapt the writing with attribution.

Project source code discussed in posts lives in its own repositories and is licensed independently.
