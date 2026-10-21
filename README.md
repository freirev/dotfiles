# Dotfiles

A lean dotfiles repository configuring my core shell environment, terminal editor, and document viewers. 

Designed to be lightweight, portable across Linux workstations/servers, and strictly devoid of machine-specific secrets.

## Overview

This repository centrally manages configurations for:
* **Zsh**: Prompt styling, aliases, history settings, and `zsh-autosuggestions`.
* **Vim**: One Half Dark theme, Wayland/terminal cursor shapes, clipboard integration, and VimTeX.
* **Zathura**: One Half Dark color palette and presentation keybindings.
* **LaTeX (latexmk)**: Build tooling and auto-cleanup rules for `latexmk`.

## Dependencies

Before installing, ensure the following core utilities are installed on the host system:
```bash
# Example for Fedora:
sudo dnf install git curl vim zsh
