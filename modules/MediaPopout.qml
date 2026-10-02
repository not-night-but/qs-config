import QtQuick
import qs.common
import qs.services

Popout {
    location: PopoutBackground.Location.TopLeft

    contentWidth: Settings.mediaWidgetWidth
    contentHeight: Settings.mediaWidgetHeight

    MediaWidget {
        id: popoutContent
        anchors.fill: parent
    }
}
