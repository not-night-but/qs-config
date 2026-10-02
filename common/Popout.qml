import QtQuick

FocusScope {
    id: root

    default property alias content: contentLoader.sourceComponent

    required property bool showPopout
    required property int location
    required property int contentWidth
    required property int contentHeight

    signal close()

    focus: root.showPopout

    Keys.onEscapePressed: {
        root.close()
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton

        onClicked: root.close()
    }

    PopoutBackground {
        id: background
        anchors.fill: parent
        location: root.location

        Loader {
            id: contentLoader
        }
    }

    states: [
        State {
            name: "hidden"
            when: !root.showPopout

            PropertyChanges {
                root.implicitWidth: 0
                root.implicitHeight: 0
                contentLoader.width: 0
                contentLoader.height: 0
                contentLoader.opacity: 0
            }
        },
        State {
            name: "visible"
            when: root.showPopout

            PropertyChanges {
                root.implicitWidth: root.contentWidth + background.horizontalMargin
                root.implicitHeight: root.contentHeight + background.verticalMargin
                contentLoader.width: root.contentWidth
                contentLoader.height: root.contentHeight
                contentLoader.opacity: 1
            }
        },
    ]

    transitions: [
        Transition {
            from: "hidden"
            to: "visible"

            Anim {
                targets: [root, contentLoader]
                properties: "implicitHeight,implicitWidth,opacity"
            }
            Anim {
                target: contentLoader
                properties: "width,height"
            }
        },
        Transition {
            from: "visible"
            to: "hidden"

            Anim {
                targets: [root, contentLoader]
                properties: "implicitHeight,implicitWidth,opacity"
            }

            Anim {
                target: contentLoader
                properties: "width,height"
            }
        }
    ]
}
