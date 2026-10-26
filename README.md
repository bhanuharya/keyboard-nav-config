# keyboard-nav-config

Mouse-free clicking setup: [NeverClick](https://github.com/LazoVelko/neverclick) on Windows,
and [hints](https://github.com/AlfredoSequeida/hints) on Linux set up to feel the same.

```
neverclick/   NeverClick settings (exported from v0.4.2) + export/restore scripts
hints/        hints config + installer
```

## Key map

| Action | NeverClick (Windows) | hints (Linux) |
|---|---|---|
| Show labels / left click | `Ctrl+Enter`, type label | `Ctrl+Enter`, type label |
| Right click | `Alt+Enter`, type label | `Ctrl+Enter`, `Shift`+label |
| Select text | `Ctrl+Alt+Enter`, label at start, label at end | `Ctrl+Enter`, `Alt`+label at start, `h j k l` to extend, `Esc` |
| Drag | `Ctrl+Shift+Enter`, label to grab, label to drop | `Ctrl+Enter`, `Alt`+label, `h j k l` to move, `Esc` |
| Ctrl+click (new tab) | `Ctrl+Enter`, `.`, label | — |
| Double / triple click | — | `Ctrl+Enter`, `2` or `3`, label |
| Hover | — | `Ctrl+Enter`, `Ctrl`+label |
| Grid of labels for empty space | `;` while labels show | — |
| Cancel | `Esc` | `Esc` |

In NeverClick's text selection, `1` / `9` move the grab point to the start / end of each box
before you pick a label.

Labels use NeverClick's letter order (home row first) and are lowercase in both.

## NeverClick (Windows)

Settings live in `%APPDATA%\Neverclick\configs`:

- `app-config.json`: appearance and behaviour (`instanceId` is left out; it identifies the install)
- `hotkey-config.json`: hotkeys and the keys used while labels show (NeverClick stores it gzipped)

Update the repo after changing settings:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\neverclick\export.ps1
```

Restore on a PC (quit NeverClick from the tray first; on a fresh install, start it once before):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\neverclick\restore.ps1
```

The current files are kept as `*.bak` and NeverClick is started again.

## hints (Linux)

1. Install hints and run its setup, following the [upstream README](https://github.com/AlfredoSequeida/hints#installing).
2. Link this config to `~/.config/hints/config.json` (an existing file is moved to `config.json.bak`):

   ```bash
   hints/install.sh
   ```

3. Bind `Ctrl+Enter` to `hints`:

   | Desktop | How |
   |---|---|
   | Hyprland | `bind = CTRL, Return, exec, hints` in `~/.config/hypr/hyprland.conf` |
   | Sway / i3 | `bindsym Ctrl+Return exec hints` in the sway or i3 config |
   | KDE Plasma | System Settings → Keyboard → Shortcuts → Add New → Command or Script |
   | GNOME | Settings → Keyboard → View and Customize Shortcuts → Custom Shortcuts |

   The [hints wiki](https://github.com/AlfredoSequeida/hints/wiki/Window-Manager-and-Desktop-Environment-Setup-Guide)
   has per-desktop details.

`Ctrl+Enter` is taken in every app once bound, as with NeverClick (e.g. "send" in some chat apps).
