import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
    id: rootRect
    height: 32
    implicitWidth: rowLayout.implicitWidth + 20
    required default property Item child

    color: Settings.background
    radius: Settings.cornerRadius

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 10

        children: [rootRect.child]
    }
}
