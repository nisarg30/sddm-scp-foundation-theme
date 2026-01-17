# Asset Guidelines & Specifications

This document details all visual and audio assets used in the SCP Terminal theme, including specifications for creating or replacing them.

## Visual Assets

### Logo (`assets/images/scp_logo.png`)

**Current Specifications:**
- Format: PNG (fallback), SVG recommended for production
- Dimensions: 512×512px minimum (1024×1024px recommended)
- Aspect Ratio: 1:1 (square)
- Background: Transparent
- Color: White/light gray (will be tinted red via shader)

**Usage:**
- Rotates continuously at 6°/second
- Red glow effect applied via QML Layer
- Occasional flicker animation

**Creating Your Own:**
1. Export as SVG for infinite scalability
2. Keep design centered for proper rotation
3. Use simple shapes (performs better with effects)
4. Test with transparency enabled

**Alternative Sources:**
- SCP Foundation logo: Wikimedia Commons (CC BY-SA 3.0)
- Create custom emblem in Inkscape/Illustrator
- Use geometric patterns for abstract feel

---

### CRT Scanline Overlay (Optional PNG)

**Note:** Current implementation uses shader-based scanlines. If you prefer a texture approach:

**Specifications:**
- Format: PNG with alpha channel
- Dimensions: 1920×1080px (or target resolution)
- Pattern: Horizontal lines, 2px thick, 2px spacing
- Opacity: 10-20% black lines on transparent background

**Creation in GIMP:**
1. Create 1920×1080 transparent image
2. Apply Filters → Render → Pattern → Grid
3. Set horizontal line thickness: 2px, spacing: 2px
4. Fill with black, adjust layer opacity to 15%
5. Export as PNG

**To Use:**
Replace the `scanlineEffect` ShaderEffect in `Main.qml` with:
```qml
Image {
    anchors.fill: parent
    source: "../assets/textures/scanlines.png"
    fillMode: Image.Tile
    opacity: 0.15
}
```

---

### Vignette Overlay (Optional PNG)

**Note:** Current implementation uses shader-based vignette. For texture approach:

**Specifications:**
- Format: PNG with alpha channel
- Dimensions: 1920×1080px (or target resolution)
- Pattern: Radial gradient from transparent (center) to black (edges)
- Feather: Heavy (400-600px)

**Creation in GIMP:**
1. Create 1920×1080 transparent image
2. Filters → Render → Gfig → Circle from edge to edge
3. Apply Radial Gradient: white (center) to black (edges)
4. Layer → Mask → Add Layer Mask → Grayscale copy
5. Invert mask if needed
6. Export as PNG

---

### Static/Noise Animation (Future)

**Specifications:**
- Format: Animated GIF or PNG sequence
- Dimensions: 512×512px (tiled across screen)
- Frame Rate: 10-15 FPS
- Duration: 1-2 seconds (looping)
- Opacity: Use low opacity (8-15%) in QML

**Creation:**
- Use Blender's noise texture animated over time
- Or procedurally generate in Processing/p5.js
- Export frame sequence and convert to GIF

**Note:** Current shader implementation is more efficient than GIF. Only use for specific aesthetic needs.

---

### Glyph Corruption Characters

**Current Implementation:**
Uses Unicode box-drawing and block elements:
```
█▓▒░▀▄▌▐│┤┐└┴┬├─┼╭╮╰╯╔╗╚╝║═╠╣╩╦╬◄►▲▼
```

**Alternative Approaches:**

1. **Custom Glyph Font:**
   - Create font with abstract symbols
   - Install in `fonts/` directory
   - Load in QML: `FontLoader { source: "../fonts/glyphs.ttf" }`

2. **Image Sprites:**
   - Create small PNG glyphs (16×16px)
   - Use Image components instead of Text
   - More control but higher complexity

3. **Extended Unicode:**
   - Mathematical symbols: ∑∏∫∂∇
   - Arrows: ⇒⇐⇑⇓⇔
   - Dingbats: ✓✗✘✚✦
   - Runes: ᚠᚢᚦᚨᚱᚲ

---

## Audio Assets (Future Implementation)

### Ambient Hum

**Specifications:**
- Format: OGG Vorbis (best compatibility) or WAV
- Sample Rate: 44.1 kHz
- Bit Depth: 16-bit
- Duration: 10-30 seconds (seamless loop)
- Frequency: Low (60-120 Hz) with subtle variation
- Volume: -30dB to -40dB (very quiet background)

**Creation:**
```python
# Python with pydub
from pydub import AudioSegment
from pydub.generators import Sine

hum = Sine(80).to_audio_segment(duration=20000)
hum = hum.fade_in(2000).fade_out(2000) - 35  # Reduce volume
hum.export("assets/sound/ambient_hum.ogg", format="ogg")
```

---

### Keypress Beep

**Specifications:**
- Format: OGG Vorbis
- Duration: 30-80ms
- Frequency: 800-1200 Hz
- Envelope: Sharp attack, quick decay
- Volume: -20dB

**Creation in Audacity:**
1. Generate → Tone → 1000 Hz sine wave, 50ms
2. Amplify: -20dB
3. Apply fast fade-out (last 20ms)
4. Export as OGG

---

### Static Burst

**Specifications:**
- Format: OGG Vorbis
- Duration: 100-300ms
- Type: White noise with bandpass filter
- Volume: -25dB (varies)

**Creation in Audacity:**
1. Generate → Noise → White, 200ms
2. Effect → Filter Curve → High-pass at 2kHz
3. Apply quick fade in/out
4. Amplify: -25dB
5. Export as OGG

---

### Whisper (Optional)

**Specifications:**
- Format: OGG Vorbis
- Duration: 1-3 seconds
- Content: Unintelligible whispered words
- Volume: -40dB to -50dB (barely audible)
- Processing: Heavy reverb, low-pass filter

**Note:** Use caution with whisper effects—can be unsettling. Keep volume very low and frequency rare.

---

### Alert Tone (Authentication Failed)

**Specifications:**
- Format: OGG Vorbis
- Duration: 200-500ms
- Type: Two-tone (high-low) or single harsh beep
- Frequencies: 400 Hz + 300 Hz or 1200 Hz
- Volume: -15dB

---

## Font Assets

### Recommended Monospace Fonts

Install these fonts in `fonts/` directory for offline availability:

1. **VT323** (Authentic Terminal)
   - Source: Google Fonts
   - License: OFL (Open Font License)
   - Best for: Nostalgic CRT feel

2. **IBM Plex Mono** (Modern Readable)
   - Source: IBM / Google Fonts
   - License: OFL
   - Best for: Clarity and professionalism

3. **Share Tech Mono** (Sci-Fi)
   - Source: Google Fonts
   - License: OFL
   - Best for: Futuristic aesthetic

4. **Courier Prime** (Classic)
   - Source: Google Fonts
   - License: OFL
   - Best for: Typewriter feel

**Loading Custom Fonts in QML:**
```qml
FontLoader {
    id: customFont
    source: "../fonts/VT323-Regular.ttf"
}

Text {
    font.family: customFont.name
    font.pixelSize: 16
}
```

---

## Creating Assets: Quick Reference

### GIMP Workflow
```
Scanlines:   Render → Pattern → Grid → Export PNG
Vignette:    Render → Filters → Lens Distortion → Export PNG
Noise:       Render → Noise → Export PNG
```

### Audacity Workflow
```
Beep:        Generate → Tone → Amplify → Export OGG
Static:      Generate → Noise → Filter → Export OGG
Hum:         Generate → Tone → Fade In/Out → Export OGG
```

### Command Line Tools
```bash
# Convert image to 512x512
convert input.png -resize 512x512 -background none -gravity center -extent 512x512 output.png

# Create seamless loop from audio
ffmpeg -i input.wav -af afade=t=out:st=9:d=1 output.ogg

# Batch convert fonts
for f in *.ttf; do cp "$f" ../fonts/; done
```

---

## Asset Checklist

- [x] `assets/images/scp_logo.png` - SCP Foundation logo (provided)
- [ ] `assets/textures/scanlines.png` - Optional texture overlay
- [ ] `assets/textures/vignette.png` - Optional vignette overlay
- [ ] `assets/textures/noise.png` - Optional static texture
- [ ] `fonts/VT323-Regular.ttf` - Terminal font
- [ ] `fonts/IBMPlexMono-Regular.ttf` - Modern mono font
- [ ] `sound/ambient_hum.ogg` - Background loop
- [ ] `sound/keypress.ogg` - Typing sound
- [ ] `sound/static_burst.ogg` - Interference
- [ ] `sound/alert.ogg` - Error/warning tone

---

## Performance Considerations

### Asset Optimization

**Images:**
- Use WebP format for better compression (requires Qt 5.13+)
- Keep textures power-of-two dimensions (256, 512, 1024)
- Use PNG compression tools: `optipng`, `pngcrush`

**Audio:**
- OGG Vorbis at quality 3-4 is sufficient
- Keep loops short and seamless
- Avoid high sample rates (44.1kHz is plenty)

**Fonts:**
- Subset fonts to Latin characters only: `pyftsubset`
- Use TTF over OTF for better Qt compatibility
- Include only regular weight (no bold/italic if unused)

### Memory Budget
- Logo: <200 KB
- Textures: <500 KB each
- Fonts: <100 KB each
- Audio: <50 KB per effect
- **Total theme size: <2 MB**

---

## License & Attribution

All assets should be:
1. Original creations (your own work)
2. Public domain (CC0)
3. Creative Commons licensed (CC BY, CC BY-SA)
4. Open source / freely licensed

**Always attribute:**
- Original creator
- License type
- Source URL
- Modification details (if any)

**Example Attribution Block:**
```
SCP Foundation Logo
- Source: Wikimedia Commons
- Author: far2
- License: CC BY-SA 3.0
- URL: https://commons.wikimedia.org/wiki/File:SCP_Foundation_logo.svg
- Modifications: None
```

---

**Last Updated:** 2025-10-12  
**Theme Version:** 1.0

