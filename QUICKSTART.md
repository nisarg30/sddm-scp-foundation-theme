# Quick Start Guide

Get the SCP Terminal theme running in 3 minutes.

## Option 1: Install and Use (Recommended)

```bash
# Install the theme
sudo ./install.sh install

# Restart SDDM (will log you out!)
sudo systemctl restart sddm
```

**Done!** Next time you log out or reboot, you'll see the theme.

---

## Option 2: Test First (Safer)

Preview without installing:

```bash
# Quick visual test (no SDDM components)
qmlscene qml/Main.qml
```

Or full SDDM test:

```bash
# Install first
sudo ./install.sh install

# Test without logging out
sudo ./install.sh test
```

Press `Ctrl+C` to exit test mode.

---

## Option 3: Manual Installation

```bash
# Copy theme to SDDM directory
sudo cp -r /path/to/scp_terminal /usr/share/sddm/themes/scp_terminal

# Edit SDDM config
sudo nano /etc/sddm.conf

# Add or modify:
[Theme]
Current=scp_terminal

# Save and restart
sudo systemctl restart sddm
```

---

## Troubleshooting

### "qmlscene: command not found"
```bash
# Arch
sudo pacman -S qt5-declarative

# Debian/Ubuntu  
sudo apt install qml-module-qtquick-controls2
```

### "SDDM not found"
```bash
# Install SDDM first
# Arch
sudo pacman -S sddm

# Debian/Ubuntu
sudo apt install sddm

# Enable SDDM
sudo systemctl enable sddm
```

### Theme looks broken
1. Press `Shift` to enable Safe Mode (disables effects)
2. Check if you have Qt 5.15+ installed: `qmlscene --version`
3. Update your graphics drivers

### Can't log in
This is usually a PAM/system issue, not the theme. Test on TTY first:
- Press `Ctrl+Alt+F2`
- Try logging in there
- If that works, check `/var/log/sddm.log`

---

## Using the Theme

- **Username field**: Enter your username (Tab to next field)
- **Password field**: Enter your password (Enter to submit)
- **Session selector**: Choose your desktop environment
- **Authenticate button**: Click or press Enter to login

### Keyboard Shortcuts
- `Shift` - Toggle Safe Mode (disables glitch effects)
- `Tab` - Next field
- `Enter` - Submit / Next field

---

## What You're Seeing

✓ Rotating SCP logo with red glow  
✓ CRT scanlines and vignette effect  
✓ Occasional screen glitches and static bursts  
✓ Cycling ambient text ("DO YOU REMEMBER?", etc.)  
✓ Boot sequence messages  
✓ Terminal-style input fields with blinking cursors  

All effects can be disabled with Safe Mode or by editing `theme.conf`.

---

## Next Steps

- **Customize**: Edit `theme.conf` or see `docs/CUSTOMIZATION.md`
- **Add fonts**: Download VT323 or IBM Plex Mono for better aesthetics
- **Report issues**: Check `README.md` for troubleshooting

---

**WE DIE IN THE DARK SO YOU CAN LIVE IN THE LIGHT**






