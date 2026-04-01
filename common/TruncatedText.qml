import QtQuick
import qs.services

Item {
    id: root

    required property string text
    required property int maxWidth
    property color color: Settings.accent

    implicitWidth: txt.implicitWidth
    implicitHeight: txt.implicitHeight

    StyledText {
        id: txt

        text: txtMetric.elidedText
        color: root.color
    }   

    TextMetrics {
        id: txtMetric

        text: root.text
        font.pointSize: txt.font.pointSize
        font.family: txt.font.family

        elide: Text.ElideRight
        elideWidth: root.maxWidth
    }
}
