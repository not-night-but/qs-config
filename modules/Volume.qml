import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common

RowLayout {
    id: root

    property int wheelAcc: 0

    StyledText {
        text: `${AudioService.getOutputIcon()} ${root.getVolumeString()}`
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: () => {
            AudioService.toggleOutputMuted()
        }

        onWheel: (wheel) => {
            root.onWheelEvent(wheel)
        }
    }

    function getVolumeString() {
        if (AudioService.muted) {
            return "Muted"
        } else {
            const displayVolume = Math.min(1.5, AudioService.volume);
            return `${Math.round(displayVolume * 100)}%`;
        }
    }

    function onWheelEvent(wheel: WheelEvent) {
        const delta = wheel?.angleDelta.y;

        root.wheelAcc += delta
        if (root.wheelAcc >= 120) {
            root.wheelAcc = 0
            AudioService.increaseVolume();
        } else if (root.wheelAcc <= -120) {
            root.wheelAcc = 0
            AudioService.decreaseVolume();
        }
    }
}
