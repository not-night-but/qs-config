import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common

RowLayout {
    id: root

    MaterialIcon {
        text: "download"
        size: Settings.iconMedium
    }

    StyledText {
        text: `${UpdatesService.availableUpdates}`
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            root.mouseClicked(mouse)
        }
    }

    function mouseClicked(mouse: MouseEvent) {
        if (mouse.button === Qt.LeftButton) {
            UpdatesService.update()
        } else if (mouse.button === Qt.RightButton) {
            UpdatesService.forceUpdateInfo()
        }
    }
}
