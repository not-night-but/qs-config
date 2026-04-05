import Quickshell
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

                        Media { }
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
        }
    }
    Variants {
        model: Quickshell.screens;

        delegate: Component {
            StyledWindow {
                required property var modelData
                screen: modelData
                exclusionMode: ExclusionMode.Ignore
                width: mouse.width

                anchors {
                    top: true
                }

                MouseArea {
                    id: mouse

                    width: 300
                    height: 10
                    cursorShape: Qt.PointingHandCursor
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                }
            }
        }
    }
}
