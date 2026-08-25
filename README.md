# Bug Bound

Welcome to the **Bug Bound** repository! _Bug Bound_ is a cozy, multiplayer 3D
creature-collection game developed in the Godot engine.

This README provides a complete guide to setting up your local development
environment, understanding our project structure, collaborating with Git, and
locating our living design documentation.

---

## Table of Contents

- **[Project Structure](#project-structure)**
- **[Prerequisites & Setup](#prerequisites--setup)**
    - **[Installing Requirements](#installing-requirements)**
    - **[Clone the Repository](#clone-the-repository)**
    - **[Open in Godot](#open-in-godot)**
- **[The Local dev/ Workflow](#the-local-dev-workflow)**
- **[Git & Version Control Workflow](#git--version-control-workflow)**
    - **[Branch Naming Conventions](#branch-naming-conventions)**
    - **[Synchronization (Always Pull First!)](#synchronization-always-pull-first)**
    - **[Pushing & Pull Requests](#pushing--pull-requests)**
- **[Documentation](#documentation)**

---

# Project Structure

Our repository is organized as follows:

```bash
bug-bound-repo/
├── bug-bound/             # The main Godot game project (source code, assets, scenes, scripts)
├── dev/                   # Local sandbox workspace for individual developers
│   └── developer_name/    # Assets in development
├── docs/                  # Project documentation (including the Design Doc)
└── .gitattributes         # Git LFS tracking rules (.blend, .png, .ogg, etc.)
```

---

# Prerequisites & Setup

To run and develop Bug Bound locally on your PC, follow these setup steps:

## Installing Requirements

- [Install Godot 4.7](https://godotengine.org/download/archive/4.7-stable/)
- [Install Git](https://git-scm.com/install/)
- [Install Git LFS](https://git-lfs.com/)

---

## Clone the Repository

**Using Git CLI:**

```bash
git clone https://github.com/justautoattack/bug-bound.git
cd bug-bound
```

(Make sure to run `git lfs pull` after cloning if assets don't download
automatically).

**Using GitHub Desktop:**

- Open GitHub Desktop
- Go to `File` > `Clone repository`
- Select the repository URL
- Choose your local path.

---

## Open in Godot

- Open the Godot Project Manager
- Click Import
- Navigate to the `bug-bound/project.godot` file inside your cloned repository.

---

# The Local dev/ Workflow

Every developer has access to a local dev/ folder at the root of the repository.

- **Purpose:** This folder acts as your personal sandbox workspace. It allows
  you to experiment, create raw assets, or draft scripts without risking
  accidental commits of WIP files into the core game structure (bug-bound/).

- **/dev Folder:** Once an asset, script, or feature built inside your dev/
  folder is fully tested and approved, move it into the dev/ready_for_game/
  subfolder (or migrate it directly into the bug-bound/ project directory). This
  signals to programmers and artists working within the bug-bound/ folder that
  the asset is polished, validated, and ready to use in game.

- **Git Status:** Note that the root dev/ folder is excluded from version
  control via .gitignore, keeping your personal workspace entirely local.

---

# Git & Version Control Workflow

To keep our multiplayer codebase and asset pipeline clean, all contributors must
follow these Git standards:

---

## Branch Naming Conventions

All work must be done on dedicated branches targeting the development branch
rather than directly committing to it. Use the following branch prefixes:

- **feature/feature-name** (e.g., `feature/capture-minigame-ui`) — For building
  new features or mechanics. Note: If you are working on a game bug (gameplay
  issue, not a code bug), you can use the same feature/ branch structure.

- **revision/feature-name** (e.g., `revision/player-movement-physics`) — For
  revising or refactoring existing systems.

- **hotfix/issue-description** (e.g., `hotfix/crash-on-server-join`) — For
  urgent, critical fixes.

---

## Synchronization (Always Pull First!)

Before you continue working on your branch or pushing your changes each day,
always do a `git pull` or `git fetch origin` followed by a merge/update from
development. This ensures that if anyone modified anything (like code or art),
it updates locally on your PC and prevents merge conflicts:

**Using Git CLI:**

```bash
git fetch origin
git pull origin development
```

**Using GitHub Desktop:**

- Click Fetch origin
- Click Pull origin (or switch to your working branch and choose Update from
  development).

---

## Pushing & Pull Requests

- All pushes will be made to the development branch (or via pull requests
  targeting it).

- Ensure your assets are tracked properly under Git LFS before committing large
  model, texture, or audio files.

# Documentation

Comprehensive project documentation, gameplay blueprints, and architectural
specifications are maintained right in the repository:

- **Design Document:** Located at `./docs/design/README.md`. Refer to this
  document for core gameplay pillars, UI wireframes, system mechanics, and our
  complete production roadmap.
