pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.services

ComponentWrapper {
    id: root

    RowLayout {
        spacing: Settings.trayIconSpacing

        Repeater {
            model: root.getTrayItems()

            delegate: Rectangle {
                id: trayRect
                implicitWidth: icon.implicitWidth + Settings.trayIconSpacing
                implicitHeight: icon.implicitHeight

                required property SystemTrayItem modelData
                IconImage {
                    id: icon
                    anchors.centerIn: parent
                    height: Settings.trayIconSize
                    width: Settings.trayIconSize
                    source: trayRect.modelData.icon
                    Loader {
                        id: trayMenuLoader
                        anchors.fill: parent
                        active: true
                        sourceComponent: TrayMenu {
                            id: trayMenu
                            menuHandle: trayRect.modelData.menu
                            popupAnchor: icon
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                        onClicked: mouse => {
                            const tray = trayRect.modelData
                            if (mouse.button == Qt.LeftButton) {
                                tray.activate()
                            } else if (mouse.button == Qt.RightButton) {
                                trayMenuLoader.item.toggleVisibility()
                            } else if (mouse.button == Qt.MiddleButton) {
                                tray.secondaryActivate()
                            }
                        }
                    }
                }

            }
        }

        // TODO (@day): this looks like shit, we should make our own with QsMenuOpener
        // QsMenuAnchor {
        //     id: trayMenu
        //     anchor.item: root
        //     anchor.edges: Edges.Bottom | Edges.Left
        // }
    }


    function getTrayItems() {
        return SystemTray.items.values.filter((t) => {
            return t.status != Status.Passive
        })
    }

    function trayClicked(tray, mouse) {
        if (mouse.button == Qt.LeftButton) {
            tray.activate()
        } else if (mouse.button == Qt.RightButton) {
            // trayMenu.menu = tray.menu
            // trayMenu.open()
            trayMenuLoader.item.toggleVisibility()
        } else if (mouse.button == Qt.MiddleButton) {
            tray.secondaryActivate()
        }
    }
}
