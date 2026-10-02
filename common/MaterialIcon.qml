import QtQuick
import qs.services

StyledText {
    id: icon

    property real fill
    property int grade: 150
    property alias size: icon.font.pixelSize

    font.family: "Material Symbols Rounded"
    font.pixelSize: Settings.iconSmall
    font.weight: Font.Normal
    font.variableAxes: ({
        FILL: fill.toFixed(1),
        GRAD: grade,
        opsz: fontInfo.pixelSize,
        wght: fontInfo.weight
    })
}
