<div align="center">

```
██████╗ ██╗   ██╗ ██████╗ ███╗   ███╗
██╔══██╗╚██╗ ██╔╝██╔═══██╗████╗ ████║
██████╔╝ ╚████╔╝ ██║   ██║██╔████╔██║
██╔══██╗  ╚██╔╝  ██║   ██║██║╚██╔╝██║
██║  ██║   ██║   ╚██████╔╝██║ ╚═╝ ██║
╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝
```

### *"Identify the original problem before solving the pre-existing one."*

**A modular Git automation toolkit for Philosopher-Builders.**

</div>

---

## What is RYOM CLI?

RYOM transforms complex Git workflows into a **simple, interactive dialogue**. It is built for developers who value:

- 🔬 **Atomic Commits** — granular, meaningful history
- 🌿 **Branch Sanity** — structured, intentional branching
- ✨ **Clean Histories** — linear, readable Git logs

No more copy-pasting Git commands. No more messy histories. Just a clean conversation between you and your codebase.

---

## 🚀 Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Gumbo-RM/ryom-git-automator.git
cd ryom-git-automator
```

### 2. Run the Installer

```bash
chmod +x install.sh
sudo ./install.sh
```

> This creates a symbolic link at `/usr/local/bin/ryom` — making RYOM available globally from any directory.

### 3. Initialize Your Identity

```bash
ryom setup
```

Configures your **Global Git Identity** and generates secure **SSH Ed25519 keys** automatically.

---

## 🛠 Command Modules

RYOM is organized into focused, single-purpose modules. Each command does one thing — and does it well.

---

### 📊 `ryom status` — The Dashboard

> *Mission Control for your workspace.*

Provides a high-level summary of your **branch health** at a glance:

- ↑ Commits **ahead** of remote
- ↓ Commits **behind** remote
- 📁 Count of **staged** and **modified** files

```bash
ryom status
```

---

### 📂 `ryom save` — Commit Logic

> *The heart of the system.*

Detects your current branch and offers two distinct commit paths:

| Mode | Description |
|------|-------------|
| **Single Commit** | Stage all changes and craft a structured [Conventional Commit](https://www.conventionalcommits.org/) message in one step |
| **Atomic Commits** | Iterate through changed files one-by-one — commit `file-a.js` with one message, `file-b.js` with another, keeping your history granular and professional |

```bash
ryom save
```

---

### 🔄 `ryom sync` — GitHub Integration

> *The handshake with your remote.*

Handles the full remote workflow safely:

- **Fetch & Rebase** — keeps your history linear by placing your work on top of the latest remote changes
- **Conflict Resolution** — detects merge conflicts and provides a safe `Abort` or `Manual Fix` path
- **Auto-Push** — seamlessly updates your GitHub branch once the local state is verified

```bash
ryom sync
```

---

### 🛑 `ryom quit` — Omni-Quit

> *A global escape hatch.*

Type `q` or `quit` at **any prompt** within the CLI to immediately and safely power down the environment — no matter where you are in the workflow.

```bash
# At any RYOM prompt:
> q
```

---

## 🏗 Project Architecture

RYOM is built on a **Separation of Concerns** principle. Logic is distributed across specialized libraries to ensure maintainability, readability, and speed.

```
ryom-git-automator/
├── bin/
│   └── ryom              # Entry point — command routing
├── lib/
│   ├── core.sh           # Shared utilities (colors, spinner, quit handler)
│   ├── status.sh         # Dashboard — branch health visualization
│   ├── setup.sh          # Identity — SSH key generation & git config
│   ├── save.sh           # Commit engine — atomic & single-commit logic
│   └── sync.sh           # Remote bridge — fetch, rebase, and push
└── install.sh            # Installer — creates global symlink
```

### Module Responsibilities

| Module | Type | Responsibility | Key Logic |
|--------|------|----------------|-----------|
| `bin/ryom` | Entry | Command Routing | Evaluates `$1` and `source`s the correct lib |
| `lib/core.sh` | Shared | Global Utilities | UI Colors, Spinner, `check_quit` |
| `lib/status.sh` | Dashboard | Health Check | Visualizes Ahead/Behind counts & workspace stats |
| `lib/setup.sh` | Config | Identity | Generates SSH Ed25519 keys and `git config` |
| `lib/save.sh` | Action | Commit Engine | Manages Branch Switching and Atomic Commits |
| `lib/sync.sh` | Network | Remote Bridge | Manages `fetch`, `rebase`, `pull` and `push` safely |

---

## ⚡ Quick Reference

```bash
ryom setup      # Initialize Git identity & SSH keys
ryom status     # View branch health & workspace summary
ryom save       # Stage and commit changes (single or atomic)
ryom sync       # Fetch, rebase, and push to remote
```

---

## Philosophy

> *"Identify the original problem before solving the pre-existing one."*

RYOM exists because most Git problems aren't Git problems — they're **clarity problems**. Unclear commit messages, tangled histories, and broken workflows all trace back to a lack of structure and intention.

RYOM gives that structure back to you, one atomic commit at a time.

---

<div align="center">

---

Developed with intention by **Ray Mcmillan Gumbo**

*Philosopher · Technologist · Builder*

---

</div>