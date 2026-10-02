import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "./modules"
import qs.common

ShellRoot {
    Variants {
        model: Quickshell.screens;

        Scope {
            id: scope
            required property var modelData

            StyledWindow {
                id: panel
                exclusionMode: ExclusionMode.Auto
                WlrLayershell.layer: WlrLayer.Bottom

                screen: scope.modelData
                anchors {
                    top: true
                    left: true
                    right: true
                }
                // qmllint disable unresolved-type unqualified missing-property
                margins { 
                    top: 10
                    left: 10
                    right: 10
                    bottom: 0
                }
                // qmllint enable unresolved-type unqualified missing-property

                implicitHeight: 35

                // Main bar
                Item {
                    id: bar
                    anchors.fill: parent
                    anchors.bottomMargin: 5
                
                    // Left section
                    RowLayout {
                        anchors.left: parent.left

                        Media {
                            onOpenMediaPopout: rootWindow.showMedia = true
                        }
                        Cava { }
                        Workspaces {
                            qsScreen: scope.modelData
                        }
                    }

                    RowLayout {
                        anchors.centerIn: parent

                        WindowTitle {
                            qsScreen: scope.modelData
                        }
                    }

                    RowLayout {
                        anchors.right: parent.right

                        Tray {}

                        Actions {}

                        DateTime {
                            onOpenCalPopout: rootWindow.showCal = true
                        }
                    }

                }
            }

            StyledWindow {
                id: rootWindow
                screen: scope.modelData
                exclusionMode: ExclusionMode.Ignore
                focusable: true
                property bool showMedia: false
                property bool showCal: false

                anchors {
                    top: true
                    left: true
                    right: true
                    bottom: true
                }

                MouseArea {
                    id: mouse

                    width: 300
                    height: 10
                    cursorShape: Qt.PointingHandCursor
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top

                    onClicked: {
                        rootWindow.showMedia = false
                        rootWindow.showCal = false
                    }
                }

                CalendarPopout {
                    id: calPopout

                    anchors.top: parent.top
                    anchors.right: parent.right

                    showPopout: rootWindow.showCal
                    onClose: {
                        rootWindow.showCal = false
                    }
                }

                MediaPopout {
                    id: mediaPopout

                    showPopout: rootWindow.showMedia
                    onClose: {
                        rootWindow.showMedia = false
                    }
                }

                mask: Region {
                    Region {
                        item: mediaPopout
                    }

                    Region {
                        item: calPopout
                    }

                    Region {
                        item: mouse
                    }
                }
            }
        }
    }
}
