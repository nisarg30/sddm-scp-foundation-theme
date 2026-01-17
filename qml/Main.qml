import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

import SddmComponents 2.0 as SDDM

Rectangle {
    id: root
    property variant geometry: typeof screenModel !== 'undefined' 
        ? screenModel.geometry(screenModel.primary) 
        : Qt.rect(0, 0, 1366, 768)
    
    width: (typeof Screen !== 'undefined' && Screen.width > 0) ? Screen.width : geometry.width
    height: (typeof Screen !== 'undefined' && Screen.height > 0) ? Screen.height : geometry.height
    color: "#000000"
    
    ListModel {
        id: fallbackSessionModel
        ListElement { name: "Plasma (X11)"; file: "plasma" }
        ListElement { name: "GNOME"; file: "gnome" }
        ListElement { name: "XFCE"; file: "xfce" }
        property int lastIndex: 0
    }
    
    QtObject {
        id: fallbackUserModel
        property string lastUser: "user"
    }
    
    property var sessionModelActual: typeof sessionModel !== 'undefined' ? sessionModel : fallbackSessionModel
    property var userModelActual: typeof userModel !== 'undefined' ? userModel : fallbackUserModel
    
    // Theme Configuration
    property int sessionIndex: sessionModelActual.lastIndex
    property int sessionSelectedIndex: (sessionModelActual && sessionModelActual.lastIndex >= 0) ? sessionModelActual.lastIndex : 0
    property bool isProcessing: false
    property int glitchCounter: 0
    property real noiseOpacity: 0.08
    property bool safeMode: false
    
    property color paletteBackground: "#000000"
    property color paletteBrand: "#8B0000"
    property color paletteAccent: "#FF6B00"
    property color paletteText: "#FFFFFF"
    property color paletteTextLight: "#CCCCCC"
    property color paletteTextMuted: "#888888"
    property color paletteTextSubtle: "#666666"
    property color paletteBorder: "#333333"
    property color palettePanel: "#0a0a0a"
    property color paletteLine: "#444444"
    property color paletteDanger: "#FF0000"
    property color paletteSuccess: "#00FF00"
    property color paletteGreen: "#00AA00"
    
    readonly property real baseWidth: 1920
    readonly property real baseHeight: 1080
    readonly property real scaleFactor: Math.min(width / baseWidth, height / baseHeight)
    readonly property real scaleFactorX: width / baseWidth
    readonly property real scaleFactorY: height / baseHeight
    readonly property real minScale: 0.6
    readonly property real maxScale: 2.0
    readonly property real safeScale: Math.max(minScale, Math.min(maxScale, scaleFactor))
    
    function scaleSize(size) {
        return Math.max(8, Math.round(size * safeScale))
    }
    
    function scaleSizeX(size) {
        return Math.max(8, Math.round(size * Math.max(minScale, Math.min(maxScale, scaleFactorX))))
    }
    
    function scaleSizeY(size) {
        return Math.max(8, Math.round(size * Math.max(minScale, Math.min(maxScale, scaleFactorY))))
    }
    
    function loadColorsFromConfig() {
        try {
            var url = Qt.resolvedUrl("../config.toml")
            var xhr = new XMLHttpRequest()
            xhr.open("GET", url, false)
            xhr.send()
            if (xhr.status === 0 || xhr.status === 200) {
                var txt = xhr.responseText || ""
                if (txt && txt.length > 0) {
                    var map = parseTomlColors(txt)
                    if (map.background) paletteBackground = map.background
                    if (map.brand) paletteBrand = map.brand
                    if (map.accent) paletteAccent = map.accent
                    if (map.text) paletteText = map.text
                    if (map.text_light) paletteTextLight = map.text_light
                    if (map.text_muted) paletteTextMuted = map.text_muted
                    if (map.text_subtle) paletteTextSubtle = map.text_subtle
                    if (map.border) paletteBorder = map.border
                    if (map.panel) palettePanel = map.panel
                    if (map.line) paletteLine = map.line
                    if (map.danger) paletteDanger = map.danger
                    if (map.success) paletteSuccess = map.success
                    if (map.green) paletteGreen = map.green
                }
            }
        } catch (e) {
            // ignore and use defaults
        }
    }
    function parseTomlColors(toml) {
        var lines = toml.split(/\r?\n/)
        var inColors = false
        var res = {}
        for (var i = 0; i < lines.length; i++) {
            var raw = lines[i]
            if (!raw) continue
            var line = raw.trim()
            if (line.length === 0) continue
            if (line.charAt(0) === '#') continue
            if (line.match(/^\[.*\]$/)) {
                inColors = (line.toLowerCase() === "[colors]")
                continue
            }
            if (!inColors) continue
            var hashIndex = line.indexOf('#')
            if (hashIndex > 0) line = line.substring(0, hashIndex).trim()
            var eq = line.indexOf('=')
            if (eq <= 0) continue
            var key = line.substring(0, eq).trim().toLowerCase()
            var val = line.substring(eq + 1).trim()
            if (val.startsWith('"') && val.endsWith('"')) val = val.substring(1, val.length - 1)
            if (val.startsWith("'#") && val.endsWith("'")) val = val.substring(1, val.length - 1)
            if (val.match(/^#[0-9A-Fa-f]{6}$/)) res[key] = val
        }
        return res
    }

    function loadColorsFromJs() {
        try {
            Qt.include("../config.js")
            if (typeof __themeColors === 'object' && __themeColors) {
                var map = __themeColors
                if (map.background) paletteBackground = map.background
                if (map.brand) paletteBrand = map.brand
                if (map.accent) paletteAccent = map.accent
                if (map.text) paletteText = map.text
                if (map.text_light) paletteTextLight = map.text_light
                if (map.text_muted) paletteTextMuted = map.text_muted
                if (map.text_subtle) paletteTextSubtle = map.text_subtle
                if (map.border) paletteBorder = map.border
                if (map.panel) palettePanel = map.panel
                if (map.line) paletteLine = map.line
                if (map.danger) paletteDanger = map.danger
                if (map.success) paletteSuccess = map.success
                if (map.green) paletteGreen = map.green
                return true
            }
        } catch (e) {
            // ignore
        }
        return false
    }
    
    readonly property var bootMessages: [
        "INITIALIZING MNESTIC INTERFACE...",
        "CHECKING ANTIMEMETIC COUNTERMEASURES...",
        "LOADING COGNITOHAZARD FILTERS...",
        "ESTABLISHING SECURE CONNECTION TO SITE-41...",
        "VERIFYING CLEARANCE PROTOCOLS...",
        "SCP-055 SYSTEM ONLINE"
    ]
    
    readonly property var ambientFragments: [
        "DO YOU REMEMBER?",
        "THERE IS NO ANTIMEMETICS DIVISION",
        "YOU DO NOT RECOGNIZE THE BODIES IN THE WATER",
        "CLASS-W MNESTIC ADMINISTERED",
        "MEMORY RETENTION: 87%",
        "SCP-055? WHAT'S SCP-055?",
        "WE DIE IN THE DARK SO YOU CAN LIVE IN THE LIGHT",
        "COGNITOHAZARD DETECTED AND NEUTRALIZED",
        "ERROR: MEMORY INCONSISTENCY DETECTED",
        "BACKUP CONSCIOUSNESS RESTORED",
        "REALITY ANCHOR STATUS: STABLE",
        "HUME LEVEL: NOMINAL"
    ]
    
    readonly property var warningMessages: [
        "WARNING: UNAUTHORIZED ACCESS WILL RESULT IN IMMEDIATE TERMINATION",
        "WARNING: MNESTIC RESISTANCE DETECTED",
        "WARNING: TEMPORAL ANOMALY IN PROGRESS",
        "NOTICE: REALITY FLUCTUATION WITHIN ACCEPTABLE PARAMETERS"
    ]
    
    readonly property string glyphChars: "█▓▒░▀▄▌▐│┤┐└┴┬├─┼╭╮╰╯╔╗╚╝║═╠╣╩╦╬◄►▲▼"

    property bool globalCorruptionActive: false

    function sessionNameAt(idx) {
        if (!sessionModelActual || typeof idx === 'undefined' || idx < 0) return "Default Session"
        var cnt = sessionModelActual.count || 0
        if (idx >= cnt) idx = cnt - 1
        if (idx < 0) return "Default Session"
        var entry = sessionModelActual.get ? sessionModelActual.get(idx) : null
        if (!entry) return "Default Session"
        if (entry.name && entry.name.length) return entry.name
        if (entry.display && entry.display.length) return entry.display
        if (entry.file && entry.file.length) {
            var f = entry.file
            if (f.toLowerCase() === 'hyprland' || f.toLowerCase().indexOf('hypr') !== -1) return 'Hyprland'
            return f
        }
        return "Session " + idx
    }

    // Prefer last session; otherwise choose Hyprland if present
    function findHyprlandIndex() {
        if (!sessionModelActual) return -1
        var cnt = sessionModelActual.count || 0
        for (var i = 0; i < cnt; i++) {
            var entry = sessionModelActual.get ? sessionModelActual.get(i) : null
            if (!entry) continue
            var name = (entry.name || "") + " " + (entry.display || "") + " " + (entry.file || "")
            if (name.toLowerCase().indexOf('hypr') !== -1) return i
        }
        return -1
    }

    function corruptStringWithGlyphs(source, fraction) {
        if (!source || source.length === 0) return source
        var chars = source.split('')
        var count = Math.max(1, Math.floor(chars.length * (fraction || 0.3)))
        for (var i = 0; i < count; i++) {
            var idx = Math.floor(Math.random() * chars.length)
            if (chars[idx] === ' ') continue
            var gidx = Math.floor(Math.random() * glyphChars.length)
            chars[idx] = glyphChars.charAt(gidx)
        }
        return chars.join('')
    }
    
    function corruptWholeString(source) {
        if (!source || source.length === 0) return source
        var chars = source.split('')
        for (var i = 0; i < chars.length; i++) {
            if (chars[i] === ' ') continue
            var gidx = Math.floor(Math.random() * glyphChars.length)
            chars[i] = glyphChars.charAt(gidx)
        }
        return chars.join('')
    }
    
    function corruptTextItem(textItem, fraction) {
        if (!textItem || !textItem.text) return
        var src = textItem.text
        textItem.lastOriginalStr = src
        var chars = src.split('')
        var total = chars.length
        var count = Math.max(1, Math.floor(total * (fraction || 0.35)))
        var indices = []
        for (var i = 0; i < count; i++) {
            var idx = Math.floor(Math.random() * total)
            if (chars[idx] === ' ') { i--; continue }
            indices.push(idx)
            var gidx = Math.floor(Math.random() * glyphChars.length)
            chars[idx] = glyphChars.charAt(gidx)
        }
        textItem.lastCorruptedIndices = indices
        textItem.text = chars.join('')
    }

    function restoreTextItem(textItem) {
        if (!textItem || !textItem.text) return
        if (!textItem.lastOriginalStr || !textItem.lastCorruptedIndices) return
        var current = textItem.text.split('')
        var original = textItem.lastOriginalStr.split('')
        for (var i = 0; i < textItem.lastCorruptedIndices.length; i++) {
            var idx = textItem.lastCorruptedIndices[i]
            if (idx < current.length && idx < original.length) {
                current[idx] = original[idx]
            }
        }
        textItem.text = current.join('')
        textItem.lastCorruptedIndices = []
    }

    function corruptTextsForBurst() {
        corruptTextItem(mainTitle, 0.45)
        corruptTextItem(subTitle, 0.45)
        corruptTextItem(warnHeader, 0.5)
        corruptTextItem(cyclingWarning, 0.5)
    }

    function restoreTextsAfterBurst() {
        restoreTextItem(mainTitle)
        restoreTextItem(subTitle)
        restoreTextItem(warnHeader)
        restoreTextItem(cyclingWarning)
    }
    
    focus: true
    Keys.onPressed: {
        if (event.key === Qt.Key_Shift && event.modifiers === Qt.ShiftModifier) {
            safeMode = !safeMode
            safeModeIndicator.visible = safeMode
        }
    }
    
    // Background
    Rectangle {
        anchors.fill: parent
        color: paletteBackground
    }
    
    ShaderEffect {
        id: scanlineEffect
        anchors.fill: parent
        opacity: safeMode ? 0 : 0.15
        
        property real time: 0
        
        NumberAnimation on time {
            from: 0
            to: 100
            duration: 100000
            loops: Animation.Infinite
        }
        
        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform lowp float qt_Opacity;
            uniform lowp float time;
            
            void main() {
                highp float scanline = sin(qt_TexCoord0.y * 800.0 + time * 0.5) * 0.04 + 0.96;
                highp float flicker = sin(time * 10.0) * 0.01 + 0.99;
                gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0 - (scanline * flicker)) * qt_Opacity;
            }
        "
    }
    
    ShaderEffect {
        id: vignetteEffect
        anchors.fill: parent
        opacity: 0.6
        
        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform lowp float qt_Opacity;
            
            void main() {
                highp vec2 uv = qt_TexCoord0 - 0.5;
                highp float vignette = 1.0 - length(uv) * 1.2;
                vignette = smoothstep(0.3, 1.0, vignette);
                gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0 - vignette) * qt_Opacity;
            }
        "
    }
    
    ShaderEffect {
        id: noiseEffect
        anchors.fill: parent
        opacity: safeMode ? 0 : noiseOpacity
        
        property real time: 0
        
        NumberAnimation on time {
            from: 0
            to: 1000
            duration: 5000
            loops: Animation.Infinite
        }
        
        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform lowp float qt_Opacity;
            uniform lowp float time;
            
            highp float random(highp vec2 co) {
                return fract(sin(dot(co.xy + time, vec2(12.9898, 78.233))) * 43758.5453);
            }
            
            void main() {
                highp float noise = random(qt_TexCoord0 * 500.0);
                gl_FragColor = vec4(noise, noise, noise, 1.0) * qt_Opacity;
            }
        "
    }
    
    Timer {
        interval: 3000 + Math.random() * 7000
        running: !safeMode
        repeat: true
        onTriggered: {
            noiseBurstAnim.start()
        }
    }
    
    SequentialAnimation {
        id: noiseBurstAnim
        NumberAnimation {
            target: root
            property: "noiseOpacity"
            to: 0.25
            duration: 80
        }
        NumberAnimation {
            target: root
            property: "noiseOpacity"
            to: 0.08
            duration: 120
        }
    }
    
    Item {
        id: glitchContainer
        anchors.fill: parent
        
        property real offsetX: 0
        property real offsetY: 0
        
        Timer {
            interval: 8000 + Math.random() * 15000
            running: !safeMode
            repeat: true
            onTriggered: glitchAnimation.start()
        }
        
        SequentialAnimation {
            id: glitchAnimation
            
            ScriptAction {
                script: {
                    glitchContainer.offsetX = (Math.random() - 0.5) * 20
                    glitchContainer.offsetY = (Math.random() - 0.5) * 10
                }
            }
            PauseAnimation { duration: 50 }
            ScriptAction {
                script: {
                    glitchContainer.offsetX = (Math.random() - 0.5) * 15
                }
            }
            PauseAnimation { duration: 30 }
            ScriptAction {
                script: {
                    glitchContainer.offsetX = 0
                    glitchContainer.offsetY = 0
                }
            }
        }
    }
    
    Row {
        id: mainContent
        anchors.fill: parent
        anchors.margins: scaleSize(60)
        spacing: scaleSize(80)
        
        transform: Translate {
            x: glitchContainer.offsetX
            y: glitchContainer.offsetY
        }
        
        Item {
            width: parent.width * 0.40
            height: parent.height
            
            Column {
                anchors.centerIn: parent
                spacing: scaleSize(40)
                
                Column {
                    id: brandingTitleColumn
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: scaleSize(8)

                    Item {
                        width: mainTitle.font.pixelSize * 1.5
                        height: mainTitle.font.pixelSize * 1.5
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            id: mainTitleLogoSrc
                            anchors.fill: parent
                            source: "../assets/images/SCP-Logo.png"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            antialiasing: true
                            visible: false
                        }

                        ColorOverlay {
                            id: mainTitleLogo
                            anchors.fill: parent
                            source: mainTitleLogoSrc
                            color: paletteBrand
                        }

                        Glow {
                            id: mainTitleLogoGlow
                            anchors.fill: mainTitleLogo
                            source: mainTitleLogo
                            samples: 15
                            color: paletteBrand
                            spread: 0.3
                        }
                    }

                    Text {
                        id: mainTitle
                        property string lastOriginal: ""
                        property string lastOriginalStr: ""
                        property var lastCorruptedIndices: []
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "SCP FOUNDATION"
                        font.family: "JetBrains Mono"
                        font.pixelSize: scaleSize(42)
                        font.bold: true
                        font.letterSpacing: -1
                        font.kerning: false
                        renderType: Text.NativeRendering
                        color: paletteBrand

                        layer.enabled: true
                        layer.effect: Glow {
                            id: mainTitleGlow
                            samples: 15
                            color: paletteBrand
                            spread: 0.3
                        }
                    }
                }
                
                Text {
                    id: subTitle
                    property string lastOriginal: ""
                    property string lastOriginalStr: ""
                    property var lastCorruptedIndices: []
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "ANTIMEMETICS DIVISION"
                    font.family: "JetBrains Mono"
                    font.pixelSize: scaleSize(18)
                    font.letterSpacing: -1
                    font.kerning: false
                    renderType: Text.NativeRendering
                    color: paletteAccent
                    opacity: 0.9
                }
                
                Item {
                    width: scaleSize(320)
                    height: scaleSize(320)
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Image {
                        id: scpLogo
                        anchors.fill: parent
                        source: "../assets/images/scp_logo.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        antialiasing: true
                        visible: false
                        
                        property real rotationSpeed: 6.0
                    }
                    
                    Item {
                        id: logoGroup
                        anchors.fill: parent
                        
                        ColorOverlay {
                            id: scpLogoOverlay
                            anchors.fill: parent
                            source: scpLogo
                            color: paletteText
                        }

                        Glow {
                            id: scpLogoGlow
                            anchors.fill: scpLogoOverlay
                            source: scpLogoOverlay
                            samples: 20
                            color: paletteDanger
                            spread: 0.2
                        }
                    }

                    RotationAnimator {
                        target: logoGroup
                        from: 0
                        to: 360
                        duration: 60000
                        loops: Animation.Infinite
                        running: !safeMode
                    }

                    SequentialAnimation {
                        id: logoNeonPulse
                        running: true
                        loops: Animation.Infinite
                        NumberAnimation { target: scpLogoGlow; property: "spread"; from: 0.15; to: 0.45; duration: 1200; easing.type: Easing.InOutSine }
                        NumberAnimation { target: scpLogoGlow; property: "spread"; from: 0.45; to: 0.15; duration: 1200; easing.type: Easing.InOutSine }
                    }
                    
                    Timer {
                        interval: 12000 + Math.random() * 18000
                        running: !safeMode
                        repeat: true
                        onTriggered: logoFlickerAnim.start()
                    }
                    
                    SequentialAnimation {
                        id: logoFlickerAnim
                        NumberAnimation { target: logoGroup; property: "opacity"; to: 0.3; duration: 50 }
                        NumberAnimation { target: logoGroup; property: "opacity"; to: 1.0; duration: 50 }
                        NumberAnimation { target: logoGroup; property: "opacity"; to: 0.5; duration: 30 }
                        NumberAnimation { target: logoGroup; property: "opacity"; to: 1.0; duration: 80 }
                    }
                }
                
                Rectangle {
                    width: scaleSize(300)
                    height: Math.max(1, scaleSizeY(2))
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#8B0000"
                    opacity: 0.5
                }
                
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "SECURITY CLEARANCE REQUIRED"
                    font.family: "JetBrains Mono"
                    font.pixelSize: scaleSize(14)
                    color: "#CCCCCC"
                    opacity: 0.7
                }
            }
        }
        
        Item {
            width: parent.width * 0.60 - scaleSize(80)
            height: parent.height
            
            Column {
                anchors.top: parent.top
                width: parent.width
                spacing: scaleSize(30)
                
                Rectangle {
                    width: parent.width
                    height: warningColumn.height + scaleSize(40)
                    color: Qt.tint(paletteBackground, Qt.rgba(0.54, 0, 0, 0.1))
                    border.color: paletteBrand
                    border.width: Math.max(1, scaleSizeY(2))
                    
                    Column {
                        id: warningColumn
                        anchors.centerIn: parent
                        width: parent.width - scaleSize(40)
                        spacing: scaleSize(15)
                        
                        Text {
                            id: warnHeader
                            property string lastOriginal: ""
                            property string lastOriginalStr: ""
                            property var lastCorruptedIndices: []
                            width: parent.width
                            text: "⚠ RESTRICTED ACCESS ⚠"
                            font.family: "Monospace"
                            font.pixelSize: scaleSize(24)
                            font.bold: true
                            color: paletteDanger
                            horizontalAlignment: Text.AlignHCenter
                            
                            SequentialAnimation on opacity {
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.5; duration: 800 }
                                NumberAnimation { to: 1.0; duration: 800 }
                            }
                        }
                        
                        Text {
                            id: cyclingWarning
                            property string lastOriginal: ""
                            property string lastOriginalStr: ""
                            property var lastCorruptedIndices: []
                            width: parent.width
                            text: warningMessages[0]
                            font.family: "Monospace"
                            font.pixelSize: scaleSize(12)
                            color: paletteAccent
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                        }
                        
                        Timer {
                            interval: 6000
                            running: true
                            repeat: true
                            onTriggered: {
                                cyclingWarning.text = warningMessages[Math.floor(Math.random() * warningMessages.length)]
                            }
                        }
                    }
                }
                
                Column {
                    width: parent.width
                    spacing: scaleSize(8)
                    
                    Repeater {
                        model: 6
                        
                        Text {
                            id: bootText
                            property string lastOriginalStr: ""
                            property var lastCorruptedIndices: []
                            width: parent.width
                            text: ""
                            font.family: "Monospace"
                            font.pixelSize: scaleSize(11)
                            color: paletteSuccess
                            opacity: 0.8
                            
                            property int lineIndex: index
                            
                            Component.onCompleted: {
                                bootSequenceTimer.start()
                            }
                        }
                    }
                    
                    Timer {
                        id: bootSequenceTimer
                        interval: 400
                        running: false
                        repeat: true
                        property int currentLine: 0
                        property var bootTextItems: []
                        
                        onTriggered: {
                            if (currentLine < bootMessages.length) {
                                if (bootTextItems.length === 0) {
                                    for (var i = 0; i < parent.children.length; i++) {
                                        var c = parent.children[i]
                                        if (c && c.hasOwnProperty('lineIndex')) bootTextItems.push(c)
                                    }
                                }
                                var textItem = bootTextItems[currentLine]
                                textItem.text = "> " + bootMessages[currentLine]
                                currentLine++
                            } else {
                                stop()
                            }
                        }
                    }
                }
                
                Rectangle {
                    width: parent.width
                    height: Math.max(1, scaleSizeY(1))
                    color: paletteBorder
                }
                
                Column {
                    width: parent.width
                    spacing: scaleSize(20)
                    
                    Text {
                        text: "ANTIMEMETIC DIVISION TERMINAL"
                        font.family: "JetBrains Mono"
                        font.pixelSize: scaleSize(18)
                        font.bold: true
                        color: "#CCCCCC"
                    }
                    
                    Text {
                        text: "SITE-41 MNESTIC INTERFACE v4.7.2"
                        font.family: "JetBrains Mono"
                        font.pixelSize: scaleSize(11)
                        color: "#888888"
                    }
                    
                    Row {
                        spacing: scaleSize(10)
                        
                        Text {
                            text: "USER>"
                            font.family: "JetBrains Mono"
                            font.pixelSize: scaleSize(16)
                            color: paletteAccent
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        Item {
                            width: scaleSizeX(400)
                            height: scaleSizeY(35)
                            
                            Rectangle { anchors.fill: parent; color: "transparent" }
                            Rectangle {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: Math.max(1, scaleSizeY(1))
                                color: userInput.activeFocus ? paletteAccent : paletteLine
                            }
                            
                            TextInput {
                                id: userInput
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: -1
                                anchors.left: parent.left
                                anchors.leftMargin: scaleSize(8)
                                width: parent.width - scaleSize(16)
                                font.family: "JetBrains Mono"
                                font.pixelSize: scaleSize(16)
                                color: paletteText
                                selectionColor: paletteAccent
                                selectedTextColor: "#000000"
                                cursorVisible: false
                                cursorDelegate: Rectangle { width: 0; height: 0; opacity: 0; color: "transparent" }
                                focus: true
                                verticalAlignment: TextInput.AlignVCenter
                                
                                text: userModelActual.lastUser
                                
                                Keys.onReturnPressed: {
                                    passwordInput.focus = true
                                }
                                
                                Keys.onTabPressed: {
                                    passwordInput.focus = true
                                }
                                Keys.onUpPressed: {
                                    userInput.focus = true
                                }
                                Keys.onDownPressed: {
                                    passwordInput.focus = true
                                }
                                
                                onTextChanged: {
                                    if (!safeMode && Math.random() < 0.05) {
                                        glitchCounter++
                                    }
                                }
                            }
                            
                            Rectangle {
                                visible: userInput.activeFocus
                                width: userInput.font.pixelSize * 0.6
                                height: userInput.cursorRectangle.height
                                x: scaleSize(8) + userInput.cursorRectangle.x
                                y: (parent.height - userInput.cursorRectangle.height)/2 + userInput.cursorRectangle.y - 1
                                color: paletteAccent
                                
                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    running: userInput.activeFocus
                                    NumberAnimation { to: 0; duration: 500 }
                                    NumberAnimation { to: 1; duration: 500 }
                                }
                            }
                        }
                    }
                    
                    Row {
                        id: passwordRow
                        spacing: scaleSize(10)
                        property bool showPassword: false
                        
                        Text {
                            text: "AUTH>"
                            font.family: "JetBrains Mono"
                            font.pixelSize: scaleSize(16)
                            color: paletteAccent
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        Item {
                            id: passwordInputContainer
                            width: scaleSizeX(400)
                            height: scaleSizeY(35)
                            
                            Rectangle { anchors.fill: parent; color: "transparent" }
                            Rectangle {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: Math.max(1, scaleSizeY(1))
                                color: passwordInput.activeFocus ? paletteAccent : paletteLine
                            }
                            
                            function generateMask(len) {
                                if (!len || len <= 0) return ""
                                var out = ""
                                for (var i = 0; i < len; i++) {
                                    var gidx = Math.floor(Math.random() * glyphChars.length)
                                    out += glyphChars.charAt(gidx)
                                }
                                return out
                            }

                            TextInput {
                                id: passwordInput
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: -1
                                anchors.left: parent.left
                                anchors.leftMargin: scaleSize(8)
                                width: parent.width - scaleSize(16)
                                font.family: "JetBrains Mono"
                                font.pixelSize: scaleSize(16)
                                color: passwordRow.showPassword ? paletteText : "transparent"
                                echoMode: TextInput.Normal
                                selectionColor: paletteAccent
                                selectedTextColor: "#000000"
                                passwordCharacter: "●"
                                cursorVisible: false
                                cursorDelegate: Rectangle { width: 0; height: 0; opacity: 0; color: "transparent" }
                                verticalAlignment: TextInput.AlignVCenter
                                
                                Keys.onReturnPressed: {
                            loginButton.clicked()
                        }
                        
                        Keys.onTabPressed: {
                            userInput.focus = true
                        }
                        Keys.onUpPressed: {
                            userInput.focus = true
                        }
                        Keys.onDownPressed: {
                            passwordInput.focus = true
                        }
                                onTextChanged: {
                                    passwordMask.text = passwordInputContainer.generateMask(passwordInput.text.length)
                                }
                                
                            }
                            
                            // Visual mask overlay showing random glyphs when hidden
                            Text {
                                id: passwordMask
                                anchors.left: parent.left
                                anchors.leftMargin: scaleSize(8)
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: -1
                                width: parent.width - scaleSize(16)
                                text: ""
                                font.family: "JetBrains Mono"
                                font.pixelSize: scaleSize(16)
                                color: paletteText
                                visible: !passwordRow.showPassword
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideNone
                            }
                            
                            Rectangle {
                                visible: passwordInput.activeFocus
                                width: passwordInput.font.pixelSize * 0.6
                                height: passwordInput.cursorRectangle.height
                                x: scaleSize(8) + passwordInput.cursorRectangle.x
                                y: (parent.height - passwordInput.cursorRectangle.height)/2 + passwordInput.cursorRectangle.y - 1
                            color: paletteAccent
                                
                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    running: passwordInput.activeFocus
                                    NumberAnimation { to: 0; duration: 500 }
                                    NumberAnimation { to: 1; duration: 500 }
                                }
                            }
                        }
                        
                        Rectangle {
                            width: scaleSizeX(110)
                            height: scaleSizeY(35)
                            color: "transparent"
                            border.color: paletteBrand
                            border.width: Math.max(1, scaleSizeY(1))
                            
                            Text {
                                anchors.centerIn: parent
                                text: passwordRow.showPassword ? "[ HIDE ]" : "[ SHOW ]"
                                font.family: "Monospace"
                                font.pixelSize: scaleSize(12)
                                color: paletteAccent
                                font.bold: true
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    passwordRow.showPassword = !passwordRow.showPassword
                                    if (!passwordRow.showPassword) {
                                        passwordMask.text = passwordInputContainer.generateMask(passwordInput.text.length)
                                    }
                                }
                            }
                        }
                    }
                    
                    Rectangle {
                        id: loginButton
                        width: scaleSizeX(200)
                        height: scaleSizeY(45)
                        color: loginMouseArea.containsMouse ? Qt.darker(paletteBrand, 1.25) : paletteBrand
                        border.color: paletteDanger
                        border.width: Math.max(1, scaleSizeY(2))
                        
                        property bool isProcessing: false
                        
                        Text {
                            anchors.centerIn: parent
                            text: loginButton.isProcessing ? "AUTHENTICATING..." : "[ AUTHENTICATE ]"
                            font.family: "Monospace"
                            font.pixelSize: scaleSize(14)
                            font.bold: true
                            color: paletteText
                        }
                        
                        MouseArea {
                            id: loginMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: loginButton.clicked()
                        }
                        
                        function clicked() {
                            if (userInput.text === "" || passwordInput.text === "") {
                                authFailedText.visible = true
                                authFailedText.text = "ERROR: CREDENTIALS REQUIRED"
                                authFailedTimer.start()
                                return
                            }
                            
                            loginButton.isProcessing = true
                            authFailedText.visible = false
                            loginTimeoutTimer.restart()
                            
                            if (typeof sddm !== 'undefined') {
                                var idx = -1
                                if (sessionModelActual && typeof sessionModelActual.lastIndex !== 'undefined' && sessionModelActual.lastIndex >= 0) {
                                    idx = sessionModelActual.lastIndex
                                }
                                if (idx < 0) {
                                    var hyprIdx = findHyprlandIndex()
                                    idx = hyprIdx >= 0 ? hyprIdx : 0
                                }
                                sddm.login(userInput.text, passwordInput.text, idx)
                            } else {
                                loginSuccessTimer.start()
                            }
                        }
                        
                        layer.enabled: true
                        layer.effect: Glow {
                            samples: 15
                            color: paletteDanger
                            spread: 0.2
                        }
                    }
                    
                    Text {
                        id: authFailedText
                        visible: false
                        text: "AUTHENTICATION FAILED - ACCESS DENIED"
                            font.family: "JetBrains Mono"
                        font.pixelSize: scaleSize(14)
                        font.bold: true
                            color: paletteDanger
                        
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            running: authFailedText.visible
                            NumberAnimation { to: 0.3; duration: 300 }
                            NumberAnimation { to: 1.0; duration: 300 }
                        }
                    }
                    
                    Timer {
                        id: loginTimeoutTimer
                        interval: 8000
                        repeat: false
                        onTriggered: {
                            loginButton.isProcessing = false
                            authFailedText.visible = true
                            authFailedText.text = "⚠ TIMEOUT — NO RESPONSE FROM GREETER"
                            authFailedText.color = paletteAccent
                        }
                    }

                    Timer {
                        id: authFailedTimer
                        interval: 3000
                        onTriggered: {
                            authFailedText.visible = false
                            loginButton.isProcessing = false
                        }
                    }
                    
                    Timer {
                        id: loginSuccessTimer
                        interval: 1500
                        onTriggered: {
                            loginButton.isProcessing = false
                            authFailedText.visible = true
                            authFailedText.text = "✓ PREVIEW MODE - Authentication simulated"
                            authFailedText.color = paletteSuccess
                        }
                    }
                }
                
                Rectangle {
                    width: parent.width
                    height: Math.max(1, scaleSizeY(1))
                    color: paletteBorder
                }
                
                Text {
                    id: ambientText
                    width: parent.width
                    text: ambientFragments[0]
                    font.family: "JetBrains Mono"
                    font.pixelSize: scaleSize(10)
                    color: paletteTextSubtle
                    opacity: 0.6
                    horizontalAlignment: Text.AlignRight
                    
                    property int currentIndex: 0
                    
                    Timer {
                        interval: 5000
                        running: true
                        repeat: true
                        onTriggered: {
                            ambientTextFadeOut.start()
                        }
                    }
                    
                    SequentialAnimation {
                        id: ambientTextFadeOut
                        NumberAnimation {
                            target: ambientText
                            property: "opacity"
                            to: 0
                            duration: 400
                        }
                        ScriptAction {
                            script: {
                                ambientText.currentIndex = (ambientText.currentIndex + 1) % ambientFragments.length
                                ambientText.text = ambientFragments[ambientText.currentIndex]
                            }
                        }
                        NumberAnimation {
                            target: ambientText
                            property: "opacity"
                            to: 0.6
                            duration: 400
                        }
                    }
                }
            }
        }
    }

    ShaderEffect {
        id: tearingEffect
        anchors.fill: mainContent
        visible: !safeMode
        z: 100
        opacity: 0.24
        
        property variant source: ShaderEffectSource {
            id: tearingSource
            sourceItem: mainContent
            hideSource: tearingEffect.visible
            live: true
        }
        
        property real time: 0
        property real intensity: 0.0
        
        NumberAnimation on time { from: 0; to: 1000; duration: 60000; loops: Animation.Infinite }
        
        Timer {
            interval: 4000 + Math.random() * 6000
            running: !safeMode
            repeat: true
            onTriggered: tearingBurst.start()
        }
        
        SequentialAnimation {
            id: tearingBurst
            ScriptAction { script: { globalCorruptionActive = true; corruptTextsForBurst() } }
            NumberAnimation { target: tearingEffect; property: "intensity"; to: 1.0; duration: 180 }
            PauseAnimation { duration: 120 }
            NumberAnimation { target: tearingEffect; property: "intensity"; to: 0.0; duration: 220 }
            ScriptAction { script: {
                if (bootSequenceTimer && bootSequenceTimer.bootTextItems && bootSequenceTimer.bootTextItems.length > 0) {
                    for (var i = 0; i < bootSequenceTimer.bootTextItems.length; i++) {
                        var item = bootSequenceTimer.bootTextItems[i]
                        if (item && item.text && item.text.length > 0) {
                            if (item.lastOriginalStr === undefined) item.lastOriginalStr = ""
                            if (item.lastCorruptedIndices === undefined) item.lastCorruptedIndices = []
                            corruptTextItem(item, 0.4)
                        }
                    }
                }
                bootRestoreTimer.restart()
                restoreTextsAfterBurst(); globalCorruptionActive = false 
            } }
        }
        
        Timer {
            id: bootRestoreTimer
            interval: 140
            repeat: false
            onTriggered: {
                if (bootSequenceTimer && bootSequenceTimer.bootTextItems) {
                    for (var j = 0; j < bootSequenceTimer.bootTextItems.length; j++) {
                        var it = bootSequenceTimer.bootTextItems[j]
                        restoreTextItem(it)
                    }
                }
            }
        }
        
        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform lowp float time;
            uniform lowp float intensity;
            uniform sampler2D source;
            
            highp float rand(highp vec2 co) {
                return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
            }
            
            void main() {
                highp vec2 uv = qt_TexCoord0;
                
                highp float bands = 20.0;
                highp float bandIndex = floor(uv.y * bands);
                highp float bandSeed = rand(vec2(bandIndex, floor(time)));
                highp float bandMask = step(0.6, bandSeed);
                
                highp float xOffset = (bandSeed - 0.5) * 0.18 * intensity;
                highp float yJitter = (rand(uv + time) - 0.5) * 0.02 * intensity;
                
                uv.x = clamp(uv.x + xOffset * bandMask, 0.0, 1.0);
                uv.y = clamp(uv.y + yJitter, 0.0, 1.0);
                
                gl_FragColor = texture2D(source, uv);
            }
        "
    }
    
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: scaleSizeY(30)
                    color: palettePanel
                    border.color: paletteBorder
        border.width: Math.max(1, scaleSizeY(1))
        
        Row {
            anchors.fill: parent
            anchors.margins: scaleSize(5)
            spacing: scaleSize(20)
            
            Text {
                text: "SYSTEM TIME: " + Qt.formatDateTime(new Date(), "yyyy-MM-dd HH:mm:ss")
                font.family: "Monospace"
                font.pixelSize: scaleSize(10)
                color: paletteTextMuted
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: "| REALITY ANCHOR: STABLE"
                font.family: "JetBrains Mono"
                font.pixelSize: scaleSize(10)
                color: paletteGreen
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: "| MEMETIC HAZARDS: FILTERED"
                font.family: "JetBrains Mono"
                font.pixelSize: scaleSize(10)
                color: paletteGreen
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    
    Text {
        id: safeModeIndicator
        visible: false
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: scaleSize(20)
        text: "[SAFE MODE]"
        font.family: "JetBrains Mono"
        font.pixelSize: scaleSize(12)
        color: paletteSuccess
        opacity: 0.7
    }
    
    Connections {
        target: typeof sddm !== 'undefined' ? sddm : null
        ignoreUnknownSignals: true
        
        function onLoginSucceeded() {
            loginButton.isProcessing = false
            loginTimeoutTimer.stop()
            authFailedText.visible = true
            authFailedText.text = "✓ AUTHENTICATED — LAUNCHING SESSION"
            authFailedText.color = "#00FF00"
        }
        
        function onLoginFailed() {
            loginButton.isProcessing = false
            loginTimeoutTimer.stop()
            authFailedText.visible = true
            authFailedText.text = "⚠ AUTHENTICATION FAILED - MNESTIC RESISTANCE DETECTED"
            authFailedTimer.start()
            
            if (!safeMode) {
                glitchAnimation.start()
                noiseBurstAnim.start()
            }
            
            passwordInput.text = ""
            passwordInput.focus = true
        }
    }
    
    Component.onCompleted: {
        if (!loadColorsFromJs()) {
            loadColorsFromConfig()
        }
        if (Qt.application && Qt.application.font) {
            Qt.application.font.family = "JetBrains Mono"
        }
        if (typeof sessionSelectedIndex !== 'undefined') {
            if (sessionModelActual && typeof sessionModelActual.lastIndex !== 'undefined' && sessionModelActual.lastIndex >= 0) {
                sessionSelectedIndex = sessionModelActual.lastIndex
            } else {
                var hyprStartIdx = findHyprlandIndex()
                sessionSelectedIndex = hyprStartIdx >= 0 ? hyprStartIdx : 0
            }
        }
        userInput.forceActiveFocus()
    }
}

