# Custom Shaders

This directory is reserved for future advanced shader effects.

## Current Shaders

All current shaders are inline in `qml/Main.qml`:
- **Scanlines** - Horizontal CRT scanline effect with vertical scrolling
- **Vignette** - Radial darkening from edges
- **Noise** - Procedural static/interference generation

## Planned Advanced Shaders (Phase 2)

### Chromatic Aberration
Simulate lens color separation (red/green/blue offset)

```glsl
// chromatic_aberration.frag
varying highp vec2 qt_TexCoord0;
uniform sampler2D source;
uniform lowp float qt_Opacity;
uniform lowp float aberrationAmount;

void main() {
    highp vec2 offset = (qt_TexCoord0 - 0.5) * aberrationAmount;
    lowp float r = texture2D(source, qt_TexCoord0 + offset).r;
    lowp float g = texture2D(source, qt_TexCoord0).g;
    lowp float b = texture2D(source, qt_TexCoord0 - offset).b;
    gl_FragColor = vec4(r, g, b, 1.0) * qt_Opacity;
}
```

### Barrel Distortion
Simulate CRT screen curvature

```glsl
// barrel_distortion.frag
varying highp vec2 qt_TexCoord0;
uniform sampler2D source;
uniform lowp float qt_Opacity;
uniform lowp float distortionAmount;

void main() {
    highp vec2 cc = qt_TexCoord0 - 0.5;
    highp float dist = dot(cc, cc) * distortionAmount;
    highp vec2 uv = qt_TexCoord0 + cc * (1.0 + dist) * dist;
    gl_FragColor = texture2D(source, uv) * qt_Opacity;
}
```

### Phosphor Glow
Simulate CRT phosphor persistence/bloom

```glsl
// phosphor_glow.frag
varying highp vec2 qt_TexCoord0;
uniform sampler2D source;
uniform lowp float qt_Opacity;
uniform lowp float time;

void main() {
    lowp vec4 col = texture2D(source, qt_TexCoord0);
    
    // Add glow in bright areas
    lowp float brightness = dot(col.rgb, vec3(0.299, 0.587, 0.114));
    lowp vec3 glow = col.rgb * brightness * 0.3;
    
    gl_FragColor = vec4(col.rgb + glow, col.a) * qt_Opacity;
}
```

## Using External Shaders

To use a separate shader file instead of inline:

```qml
ShaderEffect {
    id: customEffect
    anchors.fill: parent
    
    property real time: 0
    property real customParam: 1.0
    
    fragmentShader: "file:///" + Qt.resolvedUrl("../shaders/custom.frag")
    
    NumberAnimation on time {
        from: 0
        to: 100
        duration: 10000
        loops: Animation.Infinite
    }
}
```

## Shader Performance

### Optimization Tips
1. Minimize texture lookups
2. Use `lowp`, `mediump`, `highp` appropriately
3. Avoid conditionals in fragment shaders
4. Pre-calculate values in vertex shader when possible
5. Use built-in functions (`smoothstep`, `mix`, etc.)

### Performance Budget
- Target: <2ms per shader on mid-range GPU
- Combine shaders when possible (reduces passes)
- Test on integrated GPUs (Intel HD, AMD Vega)

## GLSL Version

Current implementation uses:
- **GLSL ES 1.0** (OpenGL ES 2.0)
- Compatible with Qt 5.12+
- Maximum compatibility across systems

For advanced features, require Qt 5.15+ and GLSL ES 3.0.

## Testing Shaders

Test shaders independently:

```bash
# Create test QML
cat > test_shader.qml <<'EOF'
import QtQuick 2.15

Rectangle {
    width: 800
    height: 600
    color: "black"
    
    ShaderEffect {
        anchors.fill: parent
        property real time: 0
        
        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform lowp float qt_Opacity;
            uniform lowp float time;
            
            void main() {
                // Your shader code here
                gl_FragColor = vec4(qt_TexCoord0, sin(time), 1.0);
            }
        "
        
        NumberAnimation on time {
            from: 0; to: 6.28
            duration: 2000
            loops: Animation.Infinite
        }
    }
}
EOF

# Test
qmlscene test_shader.qml
```

## Resources

- [Qt ShaderEffect Documentation](https://doc.qt.io/qt-5/qml-qtquick-shadereffect.html)
- [The Book of Shaders](https://thebookofshaders.com/)
- [Shadertoy](https://www.shadertoy.com/) (WebGL examples, adapt for Qt)
- [GLSL Reference](https://www.khronos.org/opengl/wiki/OpenGL_Shading_Language)

## Contributing Shaders

If creating custom shaders:
1. Test on multiple GPUs (integrated + discrete)
2. Provide performance metrics
3. Document all uniforms and their ranges
4. Include example usage in QML
5. License as CC BY-SA 4.0 (compatible with theme)

