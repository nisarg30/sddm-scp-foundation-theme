# Customization Guide

How to customize the SCP Terminal theme to your preferences.

## Quick Customizations (No Code)

### 1. Disable Specific Effects

Edit `theme.conf`:

```ini
[General]
# Set any of these to false
enableScanlines=false     # Disable CRT scanlines
enableGlitch=false        # Disable screen jitter
enableNoise=false         # Disable static overlay
enableRotation=false      # Disable logo rotation
```

### 2. Adjust Animation Speeds

Edit `theme.conf`:

```ini
[General]
rotationSpeed=3.0         # Slower rotation (default: 6.0)
glitchInterval=30000      # Less frequent glitches (default: 15000)
noiseInterval=10000       # Less frequent noise bursts (default: 5000)
```

### 3. Change Colors

Edit `theme.conf`:

```ini
[General]
# Use hex color codes
primaryColor=#0000AA      # Blue instead of red
secondaryColor=#00AAFF    # Cyan instead of orange
backgroundColor=#001100   # Dark green tint
textColor=#FFFFFF         # Pure white text
```

## Content Customization

### Change Boot Messages

Edit `qml/Main.qml`, find the `bootMessages` array (around line 24):

```qml
readonly property var bootMessages: [
    "YOUR CUSTOM MESSAGE 1",
    "YOUR CUSTOM MESSAGE 2",
    "YOUR CUSTOM MESSAGE 3",
    "YOUR CUSTOM MESSAGE 4",
    "YOUR CUSTOM MESSAGE 5",
    "YOUR CUSTOM MESSAGE 6"
]
```

**Tips:**
- Keep messages short (max 60 characters)
- Use UPPERCASE for authentic terminal feel
- Add technical jargon for atmosphere

### Change Ambient Text

Edit `qml/Main.qml`, find the `ambientFragments` array (around line 32):

```qml
readonly property var ambientFragments: [
    "YOUR AMBIENT TEXT 1",
    "YOUR AMBIENT TEXT 2",
    "YOUR AMBIENT TEXT 3",
    // Add as many as you want
]
```

**Tips:**
- Keep concise (under 80 characters)
- Use cryptic or mysterious phrasing
- Mix technical terms with ominous statements

### Change Warning Messages

Edit `qml/Main.qml`, find the `warningMessages` array (around line 46):

```qml
readonly property var warningMessages: [
    "WARNING: YOUR WARNING HERE",
    "NOTICE: YOUR NOTICE HERE",
    "ALERT: YOUR ALERT HERE"
]
```

### Change Title Text

Edit `qml/Main.qml`, find the main title (around line 273):

```qml
Text {
    id: mainTitle
    text: "YOUR ORGANIZATION NAME"
    font.pixelSize: 42
    // ...
}
```

And subtitle (around line 284):

```qml
Text {
    text: "YOUR DIVISION NAME"
    font.pixelSize: 18
    // ...
}
```

## Visual Customization

### Replace Logo

1. Create your logo as PNG or SVG (512×512px recommended)
2. Save to `assets/images/your_logo.png`
3. Edit `qml/Main.qml`, find the logo Image (around line 296):

```qml
Image {
    id: scpLogo
    source: "../assets/images/your_logo.png"
    // ...
}
```

4. Optionally adjust size (line 294):

```qml
Item {
    width: 400  // Change this
    height: 400 // And this
    // ...
}
```

### Change Glow Colors

Edit `qml/Main.qml`, find any `layer.effect: Glow` section:

```qml
layer.effect: Glow {
    samples: 15
    color: "#00FF00"  // Change to your color
    spread: 0.3
}
```

**Common glow targets:**
- Main title (line 281)
- Logo (line 305)
- Login button (line 655)

### Adjust Layout Proportions

Edit `qml/Main.qml`, find the Row (around line 260):

```qml
// Left column
Item {
    width: parent.width * 0.35  // Change from 0.40 to smaller
    // ...
}

// Right column
Item {
    width: parent.width * 0.65  // Change from 0.60 to larger
    // ...
}
```

### Change Font Sizes

Find text elements and modify `font.pixelSize`:

```qml
// Title
font.pixelSize: 48  // Bigger title (default: 42)

// Input fields
font.pixelSize: 18  // Larger text (default: 16)

// Ambient text
font.pixelSize: 12  // More readable (default: 10)
```

## Advanced Customization

### Add Custom Font

1. Download font (e.g., `MyFont.ttf`)
2. Copy to `fonts/MyFont.ttf`
3. Load in `qml/Main.qml` at the top:

```qml
FontLoader {
    id: customFont
    source: "../fonts/MyFont.ttf"
}
```

4. Use in text elements:

```qml
Text {
    font.family: customFont.name
    font.pixelSize: 16
    // ...
}
```

### Adjust Effect Intensity

**Scanlines:**
```qml
ShaderEffect {
    id: scanlineEffect
    opacity: 0.25  // More visible (default: 0.15)
    // ...
}
```

**Vignette:**
```qml
ShaderEffect {
    id: vignetteEffect
    opacity: 0.8  // Darker edges (default: 0.6)
    // ...
}
```

**Noise:**
```qml
property real noiseOpacity: 0.15  // More static (default: 0.08)
```

### Change Glitch Intensity

Find `glitchContainer` (around line 240):

```qml
script: {
    glitchContainer.offsetX = (Math.random() - 0.5) * 50  // More intense (default: 20)
    glitchContainer.offsetY = (Math.random() - 0.5) * 25  // More intense (default: 10)
    glitchFlash.opacity = 0.6  // Brighter flash (default: 0.3)
}
```

### Adjust Corruption Characters

Find `glyphChars` property (around line 53):

```qml
readonly property string glyphChars: "!@#$%^&*()_+-=[]{}|;:,.<>?"  // ASCII symbols
// Or:
readonly property string glyphChars: "αβγδεζηθικλμνξοπρστυφχψω"  // Greek
// Or:
readonly property string glyphChars: "01"  // Binary only
```

### Change Cursor Style

Find cursor text (around line 527):

```qml
Text {
    text: "▌"  // Thin line cursor
    // Or: "▐" for right line
    // Or: "▄" for bottom line
    // Or: "_" for underscore
    // Default: "█" for block
}
```

### Adjust Animation Timing

**Logo rotation speed:**
```qml
RotationAnimator {
    duration: 30000  // Faster: 30 seconds (default: 60000)
    // Or: 120000 for slower (2 minutes)
}
```

**Cursor blink rate:**
```qml
SequentialAnimation on opacity {
    NumberAnimation { to: 0; duration: 250 }  // Faster blink (default: 500)
    NumberAnimation { to: 1; duration: 250 }
}
```

**Ambient text cycle:**
```qml
Timer {
    interval: 8000  // Slower cycling (default: 5000)
    // ...
}
```

## Creating Theme Variants

### Minimal Variant (No Effects)

1. Copy theme: `cp -r scp_terminal scp_terminal_minimal`
2. Edit `theme.conf`:
```ini
enableEffects=false
enableScanlines=false
enableGlitch=false
enableNoise=false
```
3. Remove shader effects from `Main.qml` entirely for best performance

### High Intensity Variant

Edit timer intervals to be more aggressive:

```qml
// Noise bursts
Timer {
    interval: 1000 + Math.random() * 2000  // Much more frequent
}

// Screen glitch
Timer {
    interval: 3000 + Math.random() * 7000  // More frequent
}

// Character corruption
Timer {
    interval: 4000 + Math.random() * 6000  // More frequent
}
```

### Alternative Color Schemes

**Blue/Cyan (Security):**
```ini
primaryColor=#0055AA
secondaryColor=#00AAFF
errorColor=#FF6600
```

**Green/Black (Matrix):**
```ini
primaryColor=#00FF00
secondaryColor=#00AA00
backgroundColor=#000000
textColor=#00FF00
```

**Purple/Pink (Cyberpunk):**
```ini
primaryColor=#AA00AA
secondaryColor=#FF00FF
backgroundColor=#110011
textColor=#FF00FF
```

**Orange/Black (Warning):**
```ini
primaryColor=#FF6600
secondaryColor=#FFAA00
backgroundColor=#000000
textColor=#FFCCCC
```

## Performance Tuning

### Low-End Systems

1. Disable shaders:
```qml
// Comment out or remove:
// ShaderEffect { id: scanlineEffect ... }
// ShaderEffect { id: vignetteEffect ... }
// ShaderEffect { id: noiseEffect ... }
```

2. Disable glows:
```qml
// Remove from all elements:
// layer.enabled: true
// layer.effect: Glow { ... }
```

3. Reduce animation frequency:
```ini
glitchInterval=60000
noiseInterval=30000
```

### High-End Systems

1. Increase shader resolution in fragment shaders:
```glsl
highp float scanline = sin(qt_TexCoord0.y * 1600.0 ...  // More scanlines
```

2. Increase glow samples:
```qml
layer.effect: Glow {
    samples: 25  // Smoother glow (default: 15)
    spread: 0.5
}
```

3. Add more effects (future):
   - Chromatic aberration
   - Barrel distortion
   - Animated particles

## Accessibility Modifications

### High Contrast Mode

```qml
// Set higher contrast colors
property string textColor: "#FFFFFF"  // Pure white
property string backgroundColor: "#000000"  // Pure black

// Increase font sizes
font.pixelSize: 20  // Instead of 16

// Remove low-opacity text
opacity: 1.0  // Instead of 0.7, 0.6, etc.
```

### Reduced Motion

```qml
// Disable all animations
RotationAnimator { running: false }

// Remove glitch effects entirely

// Keep only essential animations (cursor blink)
```

### Screen Reader Compatible

Add accessible names to inputs:

```qml
TextInput {
    id: userInput
    Accessible.name: "Username input field"
    Accessible.description: "Enter your username"
    Accessible.role: Accessible.EditableText
}
```

## Integration with Other Systems

### Multi-Monitor Setup

Theme auto-detects screen geometry, but you can force a specific resolution:

```qml
property variant geometry: screenModel.geometry(screenModel.primary)

// Override for testing:
// width: 1920
// height: 1080
```

### Wayland Compatibility

Theme works on both X11 and Wayland. If you encounter issues:

1. Check SDDM config for Wayland session
2. Verify compositor is running
3. Test with X11 first to isolate issues

## Testing Your Customizations

### Quick Preview (No SDDM)

```bash
qmlscene qml/Main.qml
```

**Limitations:** SDDM components won't work, but visuals will render.

### Test Mode (With SDDM)

```bash
sudo sddm-greeter --test-mode --theme /path/to/theme
```

**Benefits:** Full SDDM integration testing.

### Live System Test

```bash
sudo systemctl restart sddm
```

**Warning:** Logs you out. Save all work first.

## Troubleshooting Customizations

### Colors not changing
- Check hex format: `#RRGGBB` (6 digits)
- Verify theme.conf is being read
- Some colors are hardcoded in QML (override in Main.qml)

### Fonts not loading
- Verify font file exists in `fonts/`
- Check FontLoader source path
- Test font installation system-wide first

### Layout breaks
- Check width calculations add up to 100%
- Verify margins and spacing
- Test at your target resolution

### Effects disabled
- Check `safeMode` property (default: false)
- Verify shader syntax (check console output)
- Confirm Qt version supports ShaderEffect

## Getting Help

1. **Test incrementally:** Change one thing at a time
2. **Check QML console:** Run with `qmlscene` to see errors
3. **Revert changes:** Use git to undo: `git checkout Main.qml`
4. **Simplify:** Remove effects until it works, then add back

## Example: Complete Custom Theme

Here's a full example of creating a "Neon Matrix" variant:

```bash
# 1. Copy theme
cp -r scp_terminal matrix_terminal

# 2. Edit theme.conf
cat > matrix_terminal/theme.conf <<EOF
[General]
primaryColor=#00FF00
secondaryColor=#00AA00
backgroundColor=#000000
textColor=#00FF00
enableEffects=true
EOF

# 3. Edit Main.qml
# Change title: "THE MATRIX" / "SYSTEM ACCESS"
# Change boot messages to Matrix-themed
# Change ambient text: "Wake up, Neo...", "Follow the white rabbit", etc.
# Change logo to green tint

# 4. Test
sudo ./install.sh install
sudo systemctl restart sddm
```

---

**Remember:** Always backup your files before making changes!

```bash
cp qml/Main.qml qml/Main.qml.backup
```

**Last Updated:** 2025-10-12  
**Theme Version:** 1.0

