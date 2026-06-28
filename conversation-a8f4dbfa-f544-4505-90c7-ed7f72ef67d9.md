# Conversation: Building LaTeX Skills with Claude

Conversation link: https://claude.ai/chat/a8f4dbfa-f544-4505-90c7-ed7f72ef67d9

---

## 1. Creating the `latex-to-docx` Skill

**User:** Let's create a skill together using your skill-creator skill. The skill is like this: whenever you get as input one latex file use always "math-basic.tex" to port the latex content inside the latex file to this template.

This template is useful and guarantees results with pandoc

After porting into "math-basic.tex" as a new latex file convert it using pandoc to Word docx:

```
pandoc -s math-basic.tex -o math-basic.docx
```

*(Uploaded: `math-basic.tex`)*

---

**Claude:** *(Read `skill-creator` SKILL.md, `math-basic.tex` template, and `docx` SKILL.md)*

Built and validated the `latex-to-docx` skill. The skill:

1. **Reads** any uploaded `.tex` file
2. **Ports** its content into the `math-basic.tex` template — extracting `\title`, `\author`, body content, and any extra `\usepackage` / `\newcommand` declarations, while omitting packages that conflict with pandoc (`fontenc`, `geometry`, `hyperref`, etc.)
3. **Runs** `pandoc -s math-basic.tex -o math-basic.docx`
4. **Delivers** the `.docx`

The skill bundles `math-basic.tex` as an asset so the template is always available.

The test `.docx` confirmed pandoc works with the template (exit 0, 11KB output with math content intact).

**Trigger phrases** that will activate the skill automatically:
- Upload a `.tex` file + ask to convert to Word/docx
- "latex to word", "pandoc from tex", "convert this to Word"

*Delivered: `latex-to-docx.skill`, `math-basic.docx`*

---

## 2. Can the Skill Be Used via `/latex-to-docx` in the Browser?

**User:** Can this skill be always used from this account in browser from chat through "/latex-to-docx"?

---

**Claude:** Unfortunately **no** — the `.skill` file can't be installed directly from the browser chat interface on claude.ai.

Skills are a **Claude Code feature**. They live on your local filesystem and are picked up by Claude Code (the desktop/terminal tool). In the browser chat, skills only appear if Anthropic has pre-configured them in the system prompt.

**What you *can* do instead:**

1. **Use Claude Code** (terminal or desktop app) — install the `.skill` file there and it will trigger automatically.
2. **Stay in browser chat** — just upload your `.tex` file and paste the instruction once. Since we built the skill together, Claude already knows the exact workflow.
3. **Create a Project** on claude.ai — paste the contents of `SKILL.md` into the Project's custom instructions. This mimics skill behavior in the browser.

---

## 3. Can the Skill Be Used from Claude for Windows?

**User:** But from Claude for Windows can it be used?

---

**Claude:** *(Searched for current Claude Code / Windows / skills documentation)*

Yes — and actually better than previously stated. Skills have expanded beyond just Claude Code.

**Skills are available for Free, Pro, Max, Team, and Enterprise plans** — not just Claude Code. The only requirement is that **Code execution and file creation** is enabled.

### To install in the browser (claude.ai):

1. Go to **Settings → Capabilities** and enable **Code execution and file creation**
2. Go to **Customize → Skills** and upload your `.skill` file
3. Toggle it on — Claude will auto-use it when relevant

### To invoke with `/latex-to-docx`:

In the desktop app's Code tab, type `/` in the prompt box or click `+` → **Slash commands** to browse and invoke skills by name. The browser chat works the same way.

### For the Windows desktop app specifically:

Claude Code on Windows runs inside **WSL (Windows Subsystem for Linux)**. Skills are stored at `~/.claude/skills/` within the WSL filesystem, accessible from Windows Explorer at:

```
\\wsl$\Ubuntu\home\yourname\.claude\skills\
```

**Bottom line:** Upload the `.skill` file via **Customize → Skills** in your claude.ai account settings and it will work in the browser chat, the desktop app, and be invokable with `/latex-to-docx` everywhere.

---

## 4. Creating the `fix-mathpix` Skill

**User:** Let's create a new skill called "fix-mathpix". Here's an example of how Mathpix OCR software gives me latex from a scan:

```latex
Capitolul 1
Subiecte - sesiunea iulie 2004
1.0.1 Facultatea de Comerţ

Facultatea de Marketing
1. Se consideră funcţia $f_m: D_m \rightarrow \mathbb{R}$,
$$
f_m(x)=\frac{4 x^2-25}{m x^2+2 x+1}
$$
...
а) $\alpha=-\frac{3}{25}$;
b) $\alpha=\frac{17}{25}$;
...
5
```

*(Uploaded: `mathpix_instructions.md` — instructions on how to handle Mathpix output)*

The input will usually be one latex file and output should also be one latex file.

---

**Claude:** *(Read `skill-creator` SKILL.md and `mathpix_instructions.md`)*

Built the `fix-mathpix` skill covering **10 fix categories**:

**From your instructions (`mathpix_instructions.md`):**

- **FIX 1** — Enumeration variants (plain `1.`, `a)`, `a.`, one-liner with semicolons) → nested `\begin{enumerate}`
- **FIX 2** — Bullet/dash lists → `\begin{itemize}`
- **FIX 3** — Bare `\includegraphics` → `\begin{figure}[H]` with `\centering` and `scale=0.3`
- **FIX 4** — Stray page numbers (isolated digits on their own line) → remove

**Added from Mathpix OCR knowledge:**

- **FIX 5** — Plain-text headings → `\chapter{}` / `\section{}` / `\subsection{}` (e.g. "Capitolul 1", "1.0.1 Facultatea de Comerţ")
- **FIX 6** — Display math spacing (missing blank lines around `$$...$$`)
- **FIX 7** — Preamble hygiene (missing packages, duplicates, no `\documentclass`)
- **FIX 8** — **Cyrillic "а" mixed with Latin letters** in answer options — a specific Mathpix OCR quirk where it OCRs Romanian "а)" as Cyrillic А (visible in the example)
- **FIX 9** — Markdown code fence artifacts (```` ```latex ... ``` ````) when Mathpix output is piped through markdown
- **FIX 10** — UTF-8 diacritics: adds `\usepackage[utf8]{inputenc}` if missing, never escapes diacritics

The test output applied all fixes to the provided example — the stray `5` page number was removed, headings became proper `\section{}`/`\subsection{}` commands, and answer options became clean nested enumerates with normalized Latin labels.

*Delivered: `fix-mathpix.skill`, `test-input-fixed.tex`*

---

## 5. Export This Conversation to Markdown

**User:** dump this chat conversation to a markdown

---

**Claude:** *(This file)*
