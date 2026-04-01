//@ pragma UseQApplication
import Quickshell
import QtQuick
import QtQuick.Layouts
import "./modules"

ShellRoot {
    
    Variants {
        model: Quickshell.screens;

        delegate: Component {
            PanelWindow {
                id: panel
                required property var modelData
                color: "transparent"
                exclusionMode: ExclusionMode.Auto

                screen: modelData
                anchors {
                    top: true
                    left: true
                    right: true
                }

                margins {
                    top: 10
                    left: 5
                    right: 5
                    bottom: 0
                }

                implicitHeight: 35

                // Main bar
                RowLayout {
                    id: bar
                    anchors.fill: parent
                    spacing: 0
                    // anchors.topMargin: 10
                    anchors.bottomMargin: 5
                
                    // Left section
                    RowLayout {
                        Layout.alignment: Qt.AlignLeft

                        Media { }
                        Cava { }
                        Workspaces{
                            qsScreen: panel.modelData
                        }
                    }

                    RowLayout {
                        anchors.centerIn: parent

                        WindowTitle {
                            qsScreen: panel.modelData
                        }
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignRight

                        Tray {}

                        Actions {}

                        DateTime {}
                    }

                }
                // This requires the panel top margin to be gone
                // MouseArea {
                //     width: 100
                //     height: 10
                //     cursorShape: Qt.PointingHandCursor
                //     anchors.bottom: bar.top
                //     anchors.horizontalCenter: bar.horizontalCenter
                // }

            }
        }

    }
}
