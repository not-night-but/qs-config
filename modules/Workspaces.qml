pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.common
import qs.services

ComponentWrapper {
    id: root

    required property ShellScreen qsScreen

    property HyprlandMonitor monitor: Hyprland.monitorFor(qsScreen)

    RowLayout {
        spacing: Settings.workspaceSpacing
        Repeater {
            model: root.getMonitorWorkspaces()

            delegate: Rectangle {
                id: workspaceRect
                implicitHeight: workspaceBtn.implicitHeight + 8
                implicitWidth: getWorkspaceWidth()
                color: getColor()
                radius: 8
                required property var modelData

                StyledText {
                    anchors.centerIn: parent
                    id: workspaceBtn
                    text: `${workspaceRect.modelData.id}`
                    color: workspaceRect.modelData.focused || workspaceRect.modelData.urgent ? Settings.background : Settings.text
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: workspaceRect.modelData.activate()
                    cursorShape: Qt.PointingHandCursor
                }

                function getColor() {
                    if (modelData.focused) {
                        return Settings.accent
                    } else if (modelData.urgent) {
                        return Settings.urgent
                    } else {
                        return "transparent"
                    }
                }

                function getWorkspaceWidth() {
                    const base = workspaceBtn.implicitWidth + Settings.workspaceSpacing;
                    if (modelData.id < 10) {
                        return base + 8
                    } else {
                        return base
                    }
                }
            }
        }
    }

    function getMonitorWorkspaces() {
        const workspaces = Hyprland.workspaces.values.filter((w) => w.monitor.id === root.monitor.id && w.id >= 0)
        return workspaces
    }
}
