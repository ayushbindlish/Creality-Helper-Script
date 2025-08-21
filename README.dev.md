# Developer Guide

This document provides an overview of the repository for contributors and maintainers.

## Directory Structure

- **helper.sh** – main entry point that loads all utility and menu scripts.
- **scripts/** – contains feature scripts and the menu system.
- **files/** – resource files such as macros, services and configuration templates used by utilities.

## Script Loading

`helper.sh` dynamically sources every script in the `scripts` tree before launching the menu. This makes all functions available to the menus and utilities.

## Menu System

Menu scripts live under `scripts/menu`.  `main_menu.sh` builds the top level menu and calls into model‑specific menus found in `scripts/menu/<model>/`.

## Major Utilities

A few notable features provided by this project:

- **Backup tools** – scripts for backing up Klipper configs, the Moonraker database and Git based backups.
- **KAMP** – installs Klipper Adaptive Meshing & Purging and its settings.
- **Timelapse** – adds the Moonraker timelapse component.

## Debug Flag

To enable verbose debugging output while developing, run the script with `DEBUG=1`:

```sh
DEBUG=1 ./helper.sh
```

This sets the shell to trace executed commands so you can diagnose issues.

## Contribution Guidelines

1. Fork the repository and create commits directly on the `main` branch.
2. Keep shell scripts POSIX compliant and run `sh -n` on modified scripts.
3. Provide documentation and menu entries for new features.
4. Submit a pull request with a clear description of your changes.

