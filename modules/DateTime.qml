import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.common

ComponentWrapper {
    id: root

    RowLayout {
        spacing: 15

        StyledText {
            text: ` ${Qt.formatDateTime(clock.date, "HH:mm")}`
        }

        StyledText {
            text: ` ${Qt.formatDateTime(clock.date, "dd/MM")}`
        }

        SystemClock {
            id: clock
            precision: SystemClock.Seconds
        }
    }
}
