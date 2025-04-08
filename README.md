# Bash File Explorer

A terminal-based file explorer built entirely with Bash.  
This project simulates a lightweight file manager inside the shell, featuring real-time navigation, categorized file listings, and a visual tree structure—all without external libraries like `ncurses`.

---

## Features

- **Directory Tree Rendering**  
  Visually displays the directory structure using ASCII characters.

- **Color-coded File Categories**  
  - Executables, directories, and other files are grouped and styled differently using ANSI escape codes.

- **Keyboard Navigation**  
  - Cursor-based movement using arrow-like logic (within 20 items max per screen).

- **File Generator Script**  
  - `CFileMake.sh` creates a mock directory and file structure for testing.

---

## Getting Started

### Requirements
- Unix-like environment (Linux/macOS)
- Bash (version 4+ recommended)

### Run the Explorer

```bash
chmod +x FileExplorer.sh
./FileExplorer.sh
