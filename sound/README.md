# Sound Assets

This directory will contain audio files for the SCP Terminal theme.

## Planned Sounds (Future Implementation)

### Required Files
- `ambient_hum.ogg` - Low background hum (looping)
- `keypress.ogg` - Short beep on keyboard input
- `static_burst.ogg` - Interference effect
- `alert.ogg` - Authentication failure tone

### Optional Files
- `whisper.ogg` - Subtle ambient whisper (very low volume)
- `login_success.ogg` - Success confirmation tone
- `glitch.ogg` - Brief digital distortion

## Specifications

All audio files should be:
- Format: OGG Vorbis (best compatibility with Qt)
- Sample Rate: 44.1 kHz
- Bit Depth: 16-bit
- Compressed at quality 3-4

See `docs/ASSETS.md` for detailed specifications and creation instructions.

## Implementation Status

**Current:** Sound system not yet implemented in QML  
**Planned:** Phase 2 (see `docs/IMPLEMENTATION.md`)

Sound will be added using QtMultimedia Audio/SoundEffect components.

## Creating Sounds

Quick reference:

```python
# Python with pydub
from pydub import AudioSegment
from pydub.generators import Sine, WhiteNoise

# Keypress beep
beep = Sine(1000).to_audio_segment(duration=50) - 20
beep.export("keypress.ogg", format="ogg")

# Static burst
static = WhiteNoise().to_audio_segment(duration=200) - 25
static.export("static_burst.ogg", format="ogg")
```

Or use Audacity (free, cross-platform):
1. Generate → Tone/Noise
2. Apply effects (fade, filter)
3. Export as OGG Vorbis

