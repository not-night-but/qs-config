import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.services

ComponentWrapper {
    id: root

    signal openCalPopout()

    RowLayout {
        MaterialIcon {
            text: "schedule"
            size: Settings.iconMedium
        }

        StyledText {
            text: `${Qt.formatDateTime(clock.date, "HH:mm")} `
        }

        MaterialIcon {
            text: "calendar_month"
            size: Settings.iconMedium
        }

        StyledText {
            text: `${Qt.formatDateTime(clock.date, "dd/MM")}`
        }

        SystemClock {
            id: clock
            precision: SystemClock.Seconds
        }

        MouseArea {
            anchors.fill: parent

            cursorShape: Qt.PointingHandCursor
            onClicked: root.openCalPopout()
        }
    }
}
