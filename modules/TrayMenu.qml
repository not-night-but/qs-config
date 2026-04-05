pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.services

PopupWindow {
    id: root

    required property QsMenuHandle menuHandle
    required property Item popupAnchor
    property TrayMenu parentMenu: null
    property TrayMenu childMenu: null

    anchor.item: popupAnchor
    anchor.edges: Edges.Bottom | Edges.Left // qmllint disable missing-type

    implicitWidth: menuLayout.implicitWidth + 10
    implicitHeight: menuLayout.implicitHeight + 10

    color: "transparent"

    Loader {
        id: childMenuLoader
        active: false
    }

    QsMenuOpener {
        id: menuOpener
        menu: root.menuHandle
    }

    Rectangle {
        id: menuBg
        anchors.fill: parent
        border.color: Settings.accent

        implicitWidth: menuLayout.implicitWidth + 20

        color: Settings.background
        radius: Settings.cornerRadius

        scale: root.visible ? 1 : 0.8 
        opacity: root.visible ? 1 : 0 

        Behavior on scale {
            NumberAnimation {
                duration: Settings.defaultDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Settings.defaultCurve
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Settings.defaultDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Settings.defaultCurve
            }
        }

        ColumnLayout {
            id: menuLayout
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            Repeater {
                model: menuOpener.children.values

                Rectangle {
                    id: item

                    required property QsMenuEntry modelData

                    Layout.fillWidth: true

                    implicitHeight: modelData.isSeparator ? 1 : children.implicitHeight
                    implicitWidth: Settings.trayMenuWidth
                    color: modelData.isSeparator ? Settings.accent : "transparent"

                    Loader {
                        id: children

                        asynchronous: true
                        anchors.left: parent.left
                        anchors.right: parent.right

                        active: item.modelData && !item.modelData.isSeparator

                        sourceComponent: Item {
                            id: source
                            implicitHeight: label.implicitHeight

                            property color textColour: {
                                if (!item.modelData.enabled) {
                                    return Settings.disabled;
                                } else if (entryMouseArea.containsMouse) {
                                    return Settings.accent;
                                } else {
                                    return Settings.text;
                                }
                            }


                            Loader {
                                id: icon
                                asynchronous: true
                                anchors.left: parent.left

                                active: item.modelData.icon !== ""

                                sourceComponent: IconImage {
                                    asynchronous: true
                                    implicitSize: label.implicitHeight
                                    source: item.modelData.icon
                                }
                            }

                            TruncatedText {
                                id: label

                                anchors.left: icon.right
                                anchors.leftMargin: icon.active ? 10 : 0

                                text: item.modelData.text
                                color: source.textColour
                                maxWidth: Settings.trayMenuWidth - (icon.active ? icon.implicitWidth + label.anchors.leftMargin : 0) - (expand.active ? expand.implicitWidth + 10 : 0)
                            }

                            Loader {
                                id: expand

                                asynchronous: true
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right

                                active: item.modelData.hasChildren || item.modelData.buttonType != QsMenuButtonType.None

                                sourceComponent: FAIcon {
                                    text: {
                                        if (item.modelData.hasChildren) {
                                            return "chevron-right"
                                        } else if (item.modelData.buttonType === QsMenuButtonType.CheckBox) {
                                            return item.modelData.checkState === Qt.Checked ? "square-check" : "square"
                                        } else if (item.modelData.buttonType === QsMenuButtonType.RadioButton) {
                                            return item.modelData.checkState === Qt.Checked ? "circle-dot" : "circle"
                                        }
                                    }
                                    color: source.textColour
                                }
                            }

                            MouseArea {
                                id: entryMouseArea
                                anchors.fill: parent
                                hoverEnabled: true

                                onEntered: {
                                    if (item.modelData && item.modelData.hasChildren) {
                                    }
                                }

                                onExited: {
                                    if (root.childMenu) {
                                        root.childMenu.startSelfCloseTimer();
                                    }
                                }

                                onClicked: {
                                    if (item.modelData && item.modelData.hasChildren) {
                                        childMenuLoader.setSource("TrayMenu.qml", {
                                            menuHandle: item.modelData,
                                            popupAnchor: entryMouseArea,
                                            parentMenu: root
                                        })
                                        childMenuLoader.active = true
                                        root.childMenu = childMenuLoader.item
                                        root.childMenu.visible = true
                                    } else {
                                        item.modelData.triggered();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    HoverHandler {
        id: menuHover

        onHoveredChanged: {
            if (hovered) {
                root.stopSelfCloseTimer();
            } else {
                root.startSelfCloseTimer();
            }
        }
    }

    Timer {
        id: selfCloseTimer
        interval: 500
        repeat: false
        onTriggered: root.closeSelf()
    }

    function closeSelf() {
        destroyChild();
        if (menuHover.hovered) {
            return;
        }
        if (root.parentMenu) {
            root.parentMenu.destroyChild();
            root.parentMenu.closeSelf();
        } else {
            visible = false;
        }
    }

    function destroyChild() {
        if (childMenu) {
            childMenu.destroyChild();
            childMenuLoader.active = false
            childMenu = null;
        }
    }

    function startSelfCloseTimer() {
        selfCloseTimer.start();
    }

    function stopSelfCloseTimer() {
        if (parentMenu) {
            parentMenu.stopSelfCloseTimer();
        }
        selfCloseTimer.stop();
    }

    function toggleVisibility() {
        console.log("CHILDREN: ", menuOpener.children)
        if (visible) {
            root.closeSelf();
        } else {
            visible = true;
        }
    }
}
