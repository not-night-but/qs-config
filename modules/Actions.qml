import QtQuick
import QtQuick.Layouts
import qs.common

ComponentWrapper {
    id: root

    RowLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignCenter
        spacing: 15

        Updates { }
        Volume { }
    }
}

