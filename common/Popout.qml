pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import qs.services

Item {
    id: root

    enum Location {
        TopLeft
    }

    property int location: Popout.Location.TopLeft
    property int radius: 30
    property color colour: Settings.background

    default property alias content: contentWrapper.data

    readonly property real _halfW: root.width * 0.5
    readonly property real _halfH: root.height * 0.5
    readonly property real _thirdH: root.height / 3
    readonly property real _r: root.radius
    readonly property real _r2: root.radius * 2
    readonly property real _clampedRW: Math.min(root._r, root._halfW)
    readonly property real _clampedRH: Math.min(root._r, root._halfH)
    readonly property real _clampedRH3: Math.min(root._r, root._thirdH)

    layer.enabled: true
    layer.samples: 16
    layer.smooth: true
    antialiasing: true
    smooth: true

    property list<Shape> positions: [
        attachedTopLeft
    ]

    Loader {
        anchors.fill: parent
        asynchronous: true

        sourceComponent: {
            const positions = [ attachedTopLeft ]
            return positions[root.location]
        }
    }

    Item {
        id: contentWrapper
        anchors.fill: parent
        anchors.margins: root.radius
    }

    component BubbleShape: Shape {
        anchors.fill: parent
        smooth: true
        antialiasing: true
        layer.enabled: true
        layer.smooth: true
        layer.samples: 16

        default property alias pathElements: shapePath.pathElements

        ShapePath {
            id: shapePath
            fillColor: root.colour
            // This outline thing still isn't ready yet.. [very unstable like rendering issues].
            strokeColor: Settings.accent
            strokeWidth: 0
            joinStyle: ShapePath.RoundJoin
            capStyle: ShapePath.RoundCap
        }
    }

    Component {
        id: attachedTopLeft
        BubbleShape {
            id: topLeftShape
            PathMove {
                x: topLeftShape.width
                y: 0
            }
            PathArc {
                x: topLeftShape.width - root._r
                y: root._clampedRH3
                radiusX: root._r
                radiusY: root._clampedRH3
                direction: PathArc.Counterclockwise
            }
            PathLine {
                x: topLeftShape.width - root._r
                y: Math.max(topLeftShape.height - root._r2, root._thirdH)
            }
            PathArc {
                x: topLeftShape.width - root._r2
                y: Math.max(topLeftShape.height - root._r, 2 * root._thirdH)
                radiusX: root._r
                radiusY: root._clampedRH3
            }
            PathLine {
                x: root._r
                y: Math.max(topLeftShape.height - root._r, 2 * root._thirdH)
            }
            PathArc {
                x: 0
                y: topLeftShape.height
                radiusX: root._r
                radiusY: root._clampedRH3
                direction: PathArc.Counterclockwise
            }
            PathLine {
                x: 0
                y: 0
            }
            PathLine {
                x: topLeftShape.width
                y: 0
            }
        }
    }

}
