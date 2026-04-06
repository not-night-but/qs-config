pragma Singleton

import Quickshell
import QtQuick

Singleton {
    property color accent: "#e33353"
    property color text: "#cdd6f4"
    property color disabled: "#787878"
    property color dateText: "#fab387"
    property color urgent: "#a6e3a1"
    property color background: Qt.rgba(0, 0, 0, 0.85)

    // Text
    property int cornerRadius: 10
    property string fontFamily: "JetBrains Mono"
    property int fontSize: 14

    // Tray
    property int trayIconSize: 13
    property int trayIconSpacing: 10
    property int trayMenuWidth: 300

    property int workspaceSpacing: 8
    property real volumeStep: 5.0

    property var defaultCurve: [0.2, 0, 0, 1, 1, 1]
    property var defaultDuration: 500

    property int spacing: 10 
    property int iconSize: 24

    property int playerStatusWidth: 350
    property int windowTitleWidth: 500
}
