import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import "./MediaPopup.qml"

ComponentWrapper {
    id: root

    property bool playerVisible: false

    signal openMediaPopout()

    RowLayout {
        FAIcon {
            text: "music"
        }

        TruncatedText {
            text: root.getPlayerText()
            maxWidth: Settings.playerStatusWidth
        }

        MouseArea {
            anchors.fill: parent
            onClicked: () => {
                root.openMediaPopout();
                // root.playerVisible = !root.playerVisible
            }
            cursorShape: Qt.PointingHandCursor
        }

        MediaPopup {
            popupAnchor: root
            playerVisible: root.playerVisible
        }
    }

    function getPlayerText(): string {
        if (!MediaService.activePlayer?.isPlaying) {
            return "Play Something"
        }

        return MediaService.activePlayer.trackTitle
    }

}
