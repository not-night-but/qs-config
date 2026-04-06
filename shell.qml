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
                    left: 5
                    right: 5
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

                        DateTime {}
                    }

                }
            }

            StyledWindow {
                id: rootWindow
                // visible: false
                screen: scope.modelData
                exclusionMode: ExclusionMode.Ignore
                focusable: true
                property bool showMedia: false
                // width: mouse.width

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

                    onClicked: rootWindow.showMedia = !rootWindow.showMedia
                }

                FocusScope {
                    id: mediaPopout
                    focus: rootWindow.showMedia

                    Keys.onEscapePressed: {
                        rootWindow.showMedia = false
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton

                        onClicked: rootWindow.showMedia = false
                    }

                    Popout {
                        anchors.fill: parent
                        location: Popout.Location.TopLeft

                        MediaWidget {
                            id: popoutContent
                            anchors.top: parent.top
                            anchors.left: parent.left
                        }

                    }

                    states: [
                        State {
                            name: "hidden"
                            when: !rootWindow.showMedia

                            PropertyChanges {
                                mediaPopout.implicitHeight: 0
                                mediaPopout.implicitWidth: 0
                                popoutContent.width: 0
                                popoutContent.height: 0
                                popoutContent.opacity: 0
                            }
                        },
                        State {
                            name: "visible"
                            when: rootWindow.showMedia

                            PropertyChanges {
                                mediaPopout.implicitHeight: 300
                                mediaPopout.implicitWidth: 450
                                popoutContent.width: 415
                                popoutContent.height: 220
                                popoutContent.opacity: 1
                            }
                        },
                    ]

                    transitions: [
                        Transition {
                            from: "hidden"
                            to: "visible"

                            Anim {
                                targets: [mediaPopout, popoutContent]
                                properties: "implicitHeight,implicitWidth,opacity"
                            }
                        },
                        Transition {
                            from: "visible"
                            to: "hidden"

                            Anim {
                                targets: [mediaPopout, popoutContent]
                                properties: "implicitHeight,implicitWidth,opacity"
                            }

                            Anim {
                                target: popoutContent
                                properties: "width,height"
                            }
                        }
                    ]
                }

                mask: Region {
                    Region {
                        item: mediaPopout
                    }

                    Region {
                        item: mouse
                    }
                }
            }
        }
    }
}
