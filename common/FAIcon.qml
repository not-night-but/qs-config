import qs.services

StyledText {
    property real fill
    property int grade: -25

    font.family: "Font Awesome 6 Free Solid"
    font.pointSize: Settings.fontSize
    font.variableAxes: ({
        FILL: fill.toFixed(1),
        GRAD: grade,
        opsz: fontInfo.pixelSize,
        wght: fontInfo.weight
    })
}
