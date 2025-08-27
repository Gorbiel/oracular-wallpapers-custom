# Oracular Wallpapers Custom

This repository provides a `.deb` package that restores the default wallpapers from **Ubuntu 24.10 (Oracular Oriole)** on newer Ubuntu releases. It includes:

- The official Oracular Oriole wallpapers (default, dark, dimmed, and light variants).
- Theme-dependent **switchable wallpaper**.
- Two **24-hour dynamic wallpapers** with long, subtle transitions.
- Seamless integration with GNOME Settings.

## Installation

### Install from PPA (recommended)

`oracular-wallpapers-custom` is available pre-built via my Launchpad PPA.
As always, review the source code before installing third-party packages.

```bash
sudo add-apt-repository ppa:gorbiel/misc
sudo apt update
sudo apt install oracular-wallpapers-custom
```

### Build and install locally:

To build and install the package from source:

```bash
debuild -us -uc
sudo apt install ../oracular-wallpapers-custom_<version>_all.deb
```

Once installed, open **Settings → Appearance** to select either static or dynamic wallpapers.

### Remove the package:

```bash
sudo apt remove oracular-wallpapers-custom
```

## Package contents

- **Images:** Installed to `/usr/share/backgrounds/oracular-custom/`
- **Dynamic XMLs:** Installed to `/usr/share/backgrounds/contest/`
- **GNOME wallpaper list:** Installed to `/usr/share/gnome-background-properties/`

## Dependencies

- `ubuntu-wallpapers-oracular` (provides additional official Oracular wallpapers).

## License

- **Wallpapers:** © Canonical Ltd. and Ubuntu contributors. Licensed under [CC-BY-SA-4.0](https://creativecommons.org/licenses/by-sa/4.0/).
- **Dynamic XMLs and packaging scripts:** © 2025 Gorbiel. Licensed under the [MIT License](LICENSE).

See [CREDITS.md](CREDITS.md) for attribution details.

## Homepage

[https://github.com/Gorbiel/oracular-wallpapers-custom](https://github.com/Gorbiel/oracular-wallpapers-custom)
