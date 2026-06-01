# <img align="right" src="/img/posix-nexus.png" alt="posix-nexus" title="posix-nexus" width="15%">posix‑nexus

*A POSIX‑first, polyglot tooling framework for millisecond‑scale workflows and reproducible CI artifacts — with a zero‑dependency POSIX core.*

---

## Overview

**posix‑nexus** turns small, composable utilities into fast, deterministic developer workflows.  
The **core requires only POSIX‑mandated tools** (`sh`, `awk`, `sed`, `cat`, `mkfifo`, etc.) and runs unmodified on any real POSIX environment, including BusyBox, Alpine, BSD, macOS, Android (Termux), iSH (thoroughly tested), containers, and embedded systems.

Optional modules extend the platform with:

- high‑precision math (bc modules)  
- native acceleration (small C helpers)  
- reproducible documentation (LaTeX)  
- consistent previews (CSS)  
- Python services (web, PKI)  
- VimL editor ergonomics  
- PowerShell bootstrap for Windows  

The design goal is **deterministic, portable, dependency‑free tooling** that composes cleanly across shells, AWK, bc, and native helpers.

---

## Features

### ⚡ Millisecond‑Scale CLI Dispatch
`nex-bundle.sh` performs deterministic bundling with tmpfs staging and preloaded runtime fragments.

- **~64ms** full multi‑MiB bundle build  
- **1–3ms** hot‑path CLI execution  
- atomic swaps for reproducible builds  

### 🔁 Reliable Shell↔AWK Streaming
`nex-io.sh` provides:

- FIFO lifecycle management  
- message framing  
- AWK worker supervision  
- long‑running, composable pipelines  

### 🌐 Reproducible Virtual Networks
`nex-ip.d/` and `nex-dev.d/` automate:

- network namespaces  
- bridges  
- bonds  
- veth pairs  
- VLANs  
- tuntap devices  

Useful for CI, testing, and ephemeral topologies.

### 🧮 High‑Precision Math & Native Acceleration
`nex-bc.d/` and C helpers provide:

- algebra  
- calculus  
- geometry  
- trigonometry  
- complex numbers  
- conversions  
- linear algebra  
- fast IO and bitwise primitives  

### 📄 Deterministic Documentation & Previews
- modular LaTeX toolkit (LuaTeX, TikZ/PGF, plotting helpers)  
- CSS design system for consistent HTML previews  
- local preview server (`nex-web.sh`)  

### 🖥️ Editor & Cross‑Platform Tooling
- composable VimL layer  
- PowerShell bootstrap for Windows  
- sed utilities for parsing and transforms  

---

## Zero‑Dependency Core

The **core of posix‑nexus has no dependencies** beyond POSIX‑required utilities:

- `sh`  
- `awk`  
- `sed`  
- `cat`  
- `mkfifo`  
- standard POSIX tools  

Everything else is **optional** and modular.

This ensures portability across:

- BusyBox  
- Alpine  
- Debian/Ubuntu  
- BSDs  
- macOS  
- Android (Termux)  
- iSH (thoroughly tested)  
- containers  
- embedded systems  

---

## Module Inventory

### Shell & IPC
- `nex-io.sh` — FIFO IPC, framing, AWK worker supervision  
- `nex-bundle.sh` — deterministic bundling, tmpfs staging, atomic swaps  
- `nex-web.sh` — local preview + service orchestration  
- `nex-tty.sh` — TTY normalization, pty helpers  
- `nex-ip.d/` — iproute2 automation  
- `nex-dev.d/` — bond, bridge, tuntap, veth, vlan drivers  

### Math & Native
- `nex-bc.d/` — bc math modules  
- C helpers — IO, bitwise ops, DB primitives  

### AWK Runtime & Parsing
- schema‑driven option system  
- typed coercion  
- help generation  
- JSON tokenizer/transformer  

### Docs & Previews
- LaTeX toolkit (LuaTeX, TikZ/PGF, typography)  
- CSS design system (reset, components, icons, animations)  

### Cross‑Platform & Utilities
- `ps1/` — PowerShell bootstrap + hardware helpers  
- `sed/` — parsing and transform utilities  

---

## Status
Actively developed.  
Core modules are stable; new subsystems are added incrementally.

---

## License
This project is licensed under the **BSD‑2‑Clause License**.  
See the `LICENSE` file for details.

