import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common

RowLayout {
    id: root

    FAIcon {
        text: "download"
    }

    StyledText {
        text: `${UpdatesService.availableUpdates}`
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            root.mouseClicked(mouse)
        }
        cursorShape: Qt.PointingHandCursor
    }

    function mouseClicked(mouse: MouseEvent) {
        if (mouse.button === Qt.LeftButton) {
            UpdatesService.update()
        } else if (mouse.button === Qt.RightButton) {
            UpdatesService.forceUpdateInfo()
        }
    }
}
