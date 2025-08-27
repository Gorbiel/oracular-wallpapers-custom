# oracular-wallpapers-custom

This repository provides a `.deb` package that restores the default wallpapers from **Ubuntu 24.10 (Oracular Oriole)** on newer Ubuntu releases. It includes:

- The official Oracular Oriole wallpapers (default, dark, dimmed, and light variants).
- Theme-dependent **switching** wallpaper
- Two **24-hour dynamic wallpaper** with long, subtle transitions.
- Integration with GNOME Settings

## Installation

### Build and install the package locally:

```bash
debuild -us -uc
cd ..
sudo apt install ./oracular-wallpapers-custom_VERSION.deb
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

This package depends on:
- `ubuntu-wallpapers-oracular` (for additional official Oracular wallpapers).

## License

- **Wallpapers:** © Canonical Ltd. and Ubuntu contributors. Licensed under [CC-BY-SA-4.0](https://creativecommons.org/licenses/by-sa/4.0/).
- **Dynamic XMLs and packaging scripts:** © 2025 Gorbiel. Licensed under the [MIT License](LICENSE).

See [CREDITS.md](CREDITS.md) for attribution details.

## Homepage

[https://github.com/Gorbiel/oracular-wallpapers-custom](https://github.com/Gorbiel/oracular-wallpapers-custom)
