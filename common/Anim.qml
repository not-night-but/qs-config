import QtQuick
import qs.services

NumberAnimation {
    duration: Settings.defaultDuration
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Settings.defaultCurve
}
