# AULA F75 Max — Linux config via keyd

Bring normal F1–F12 keys back to the **AULA F75 Max** keyboard (2.4G dongle `05ac:024f`)
on Linux, and toggle between **F-keys mode** and **media-keys mode** with **FN + Esc**.

Works through [keyd](https://github.com/rvaiya/keyd) — no vendor driver needed
(the official driver hardcodes the F-mode switch and is Linux-unfriendly).

## What it does

The AULA sends media codes instead of F-keys on the function row, and FN is reported as
`KEY_RIGHTCTRL` (so FN+letter caused Ctrl+letter and closed windows). This config:

- remaps the function row back to **F1..F12** by default;
- adds a **media mode** (brightness, volume, mute, track control) toggleable with **FN + Esc**;
- stops FN from being sent as Ctrl.

## Install

```bash
git clone https://github.com/<you>/Aula-F75-Max-LinuxConfig.git
cd Aula-F75-Max-LinuxConfig
sudo ./install.sh
```

The script installs `keyd`, copies `keyd/aula-f75.conf` to `/etc/keyd/`, and starts the daemon.

## Usage

| Action | Effect |
|--------|--------|
| **FN + Esc** | toggle between F-keys mode and media-keys mode |
| F-mode: **F1..F12** | normal F keys (F5 = reload page, etc.) |
| Media mode: **F1/F2** | brightness down/up |
| Media mode: **F7/F9** | previous/next track |
| Media mode: **F8** | play/pause |
| Media mode: **F10** | mute |
| Media mode: **F11/F12** | volume down/up |

> FN is the key next to the right Alt; it is sent to the OS as `rightcontrol`.

## Configuration

See [`keyd/aula-f75.conf`](keyd/aula-f75.conf). The device is matched by id `05ac:024f`
(your keyboard's 2.4G dongle reports itself as *Apple Aluminium Keyboard (ANSI)*).

## Finding your device id

The `05ac:024f` id is the USB `vendor:product` of the AULA 2.4G dongle (it presents itself as
*Apple Aluminium Keyboard (ANSI)*). Find yours with:

```bash
lsusb
```

Example output:

```
Bus 001 Device 003: ID 05ac:024f Apple, Inc. Aluminium Keyboard (ANSI)
```

Put `<vendor>:<product>` (e.g. `05ac:024f`) in the `[ids]` section — it prefix-matches all three
interfaces of the dongle (keyboard / mouse / multimedia). The same id appears in keyd logs
as `DEVICE: match 05ac:024f:...`.

## Revert

```bash
sudo ./uninstall.sh
```

To fully remove keyd:

```bash
sudo systemctl disable --now keyd
sudo apt purge keyd
```

## Troubleshooting

- Key names in keyd 2.5.0: use `rightcontrol`/`leftcontrol` (not `rightctrl`).
- Verify that the config loaded and the dongle matched:

  ```bash
  journalctl -u keyd -n 30 --no-pager
  ```

  Expected lines:

  ```
  CONFIG: parsing /etc/keyd/aula-f75.conf
  DEVICE: match    05ac:024f:...  /etc/keyd/aula-f75.conf  (2.4G Dongle)
  ```

- If every device is "ignored": the daemon may have started before the config existed —
  just run `sudo systemctl restart keyd` again.

## References

- [keyd](https://github.com/rvaiya/keyd)
- [Aula-F75-Max-Driver (Windows/Android)](https://github.com/VitalyArt/Aula-F75-Max-Driver)