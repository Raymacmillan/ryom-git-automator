#  RYOM CLI
> **"Identify the original problem before solving the pre-existing one."**

RYOM is a modular Git automation toolkit built for developers who value **Atomic Commits**, **Branch Sanity**, and **Clean Histories**. It turns complex Git workflows into a simple, interactive dialogue.

---

## 🚀 Installation & Setup

1. **Clone & Install**:
   ```bash
   
   1. git clone [https://github.com/your-username/ryom-git-automator.git](https://github.com/your-username/ryom-git-automator.git)
   
   2. cd ryom-git-automator
   
   3. chmod +x install.sh
   
   4. sudo ./install.sh

   ```bash

This creates a symbolic link at /usr/local/bin/ryom so you can use the command globally.

First Run:

ryom setup

Configures your Global Git Identity and generates secure SSH keys for GitHub.

🛠 Command Modules📂 

ryom save (Commit Logic)
The core of the system. It detects your current branch and offers two paths:

Single Commit: Stage all changes and provide a structured "Conventional Commit" message.

Atomic Commits: Iterate through changed files one-by-one. It allows you to commit File A with one message and File B with another, keeping your pull requests professional.

🔄 ryom sync (GitHub Integration)

Handles the "Handshake" with remote repositories:

Fetch & Rebase: Keeps your history linear by placing your work on top of the latest remote changes.

Conflict Resolution: Detects merge conflicts and provides a safe "Abort" or "Manual Fix" path.

Auto-Push: Seamlessly updates your GitHub branch once the local state is safe.

## 🏗 Project Architecture

RYOM is built on a **Separation of Concerns** principle. The logic is split between the entry point and specialized libraries.

| Module | Type | Responsibility | Key Logic |
| :--- | :--- | :--- | :--- |
| `bin/ryom` | **Entry** | Command Routing | Evaluates `$1` and `source`es the correct lib. |
| `lib/core.sh` | **Shared** | Global Utilities | Handles `UI Colors`, `Spinner`, and `Package Installs`. |
| `lib/setup.sh` | **Config** | Identity & Security | Generates `SSH Ed25519` keys and `git config`. |
| `lib/save.sh` | **Action** | Commit Orchestrator | Handles `Branch Switching` and `Atomic Commits`. |
| `lib/sync.sh` | **Network** | Remote Handshake | Manages `fetch`, `rebase`, and `push` safely. |

Developed by **Ray Mcmillan Gumbo** | Philosopher | Technologist | Builder
