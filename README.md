# Creality Helper Script

## About

This project provides a collection of scripts for the Creality **K1 Series**
and **Ender‑3 V3 Series** printers.  The scripts add extra features and give
quick access to common maintenance tasks.

If you are new to your printer or to Linux, take some time to read through
this document before running any commands.

## Repository layout

The repository is split into a few main parts:

```
helper.sh          # Entry point that loads every other script
scripts/           # Utility functions and menu definitions
files/             # Configuration files and assets copied to the printer
```

Running `helper.sh` on the printer sources all scripts in the `scripts/`
directory.  The `main_menu` function (defined in `scripts/menu/main_menu.sh`)
then presents a text interface that allows you to install features, remove
them or perform maintenance.

In short, the flow is:

1. **Start the helper** – execute `helper.sh` (a `/usr/bin/helper` symlink is
   created automatically for convenience).
2. **Scripts are loaded** – every `.sh` file under `scripts/` and
   `scripts/menu/*` is sourced, making their functions available.
3. **Main menu displays** – `main_menu` determines your printer model and
   displays the appropriate options.

## Quick start

Copy the repository to the printer and run:

```sh
./helper.sh
```

The menu driven interface guides you through installing or removing features.

## Wiki

A more complete guide is available on the [Wiki](https://guilouz.github.io/Creality-Helper-Script-Wiki/).

<br />
