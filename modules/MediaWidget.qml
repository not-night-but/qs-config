import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import qs.services
import qs.common

Item {
    id: root

    width: 375
    height: 200

    ClippingWrapperRectangle {
        id: trackArt
        radius: Settings.cornerRadius * 2
        implicitWidth: root.width * 0.8
        implicitHeight: root.height - 20
        anchors.verticalCenter: root.verticalCenter
        anchors.left: root.left
        color: Settings.background

        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: MediaService.activePlayer.trackArtUrl
            asynchronous: true
            cache: true
            smooth: true

            Rectangle {
                anchors.fill: parent
                color: "transparent"

                gradient: LinearGradient {
                    x1: 0
                    y1: 0
                    x2: 1
                    y2: 0
                    orientation: Gradient.Horizontal
                    stops: [
                        GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.5) },
                        GradientStop { position: 1.0; color: Qt.rgba(25, 25, 25, 0.25 )}
                    ]
                }
            }

        }
    }

    Rectangle {
        anchors.fill: trackArt
        color: "transparent"

        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            RowLayout {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.leftMargin: 10
                Layout.topMargin: 10
                Layout.bottomMargin: 0
                MaterialIcon {
                    id: shuffleControl
                    text: "shuffle"
                    color: MediaService.isShuffled || shuffleMouse.containsMouse ? Settings.accent : Settings.text

                    MouseArea {
                        id: shuffleMouse
                        anchors.fill: shuffleControl
                        onClicked: MediaService.toggleShuffle()
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                    }
                }

                MaterialIcon {
                    id: loopControl
                    text: MediaService.getLoopIcon()
                    color: MediaService.isLooping || loopMouse.containsMouse ? Settings.accent : Settings.text

                    MouseArea {
                        id: loopMouse
                        anchors.fill: loopControl
                        onClicked: MediaService.cycleLoopState()
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                    }
                }

            }
            RowLayout {
                spacing: 0
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.topMargin: 5
                Layout.leftMargin: 10

                TruncatedText {
                    text: MediaService.activePlayer.trackTitle
                    maxWidth: trackArt.implicitWidth - 10
                    color: Settings.text
                }
            }

            RowLayout {
                spacing: 0
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.topMargin: 5
                Layout.leftMargin: 20

                TruncatedText {
                    text: MediaService.activePlayer.trackArtist
                    maxWidth: trackArt.implicitWidth - 20
                    color: Settings.text
                }

            }

            RowLayout {
            
            }
            Slider {
                id: progressSlider
                from: 0
                to: MediaService.activePlayer.length
                value: MediaService.activePlayer.position
                Layout.alignment: Qt.Left | Qt.AlignBottom
                Layout.leftMargin: 10
                Layout.bottomMargin: 10
                implicitWidth: 280
                implicitHeight: 10

                onMoved: MediaService.seek(progressSlider.value)

                palette {
                    base: Qt.rgba(200/255, 200/255, 200/255, 0.5)
                    window: Qt.rgba(200/255, 200/255, 200/255, 0.5)
                    highlight: Qt.rgba(227/255, 51/255, 83/255, 0.8)
                }

                background: Rectangle {
                    radius: 200
                    color: Qt.rgba(200/255, 200/255, 200/255, 0.5)

                    Rectangle {
                        width: progressSlider.visualPosition * parent.width
                        height: parent.height
                        color: Qt.rgba(227/255, 51/255, 83/255, 0.8)
                        radius: height / 2
                    }
                }

                handle: Rectangle {
                    x: progressSlider.leftPadding + progressSlider.visualPosition * (progressSlider.availableWidth - width)
                    y: progressSlider.topPadding + progressSlider.availableHeight / 2 - height / 2
                    implicitWidth: 10
                    implicitHeight: parent.height
                    radius: parent.height / 2
                    color: "transparent"
                    // color: Qt.rgba(227/255, 51/255, 83/255, 0.8)
                }

            }
            RowLayout {
                spacing: 0
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.topMargin: -5
                Layout.leftMargin: 10
                Layout.bottomMargin: 5

                Text {
                    text: root.getProgressString()
                    font.pixelSize: 10
                    color: Settings.text
                    font.family: "Cartograph CF"
                    font.italic: true
                    font.weight: Font.Bold
                }
            }
        }
    }

    ColumnLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: trackArt.right
        anchors.leftMargin: 10

        MaterialIcon {
            id: backButton
            text: "skip_previous"
            size: Settings.iconLarge
            color: backMouse.containsMouse ? Settings.accent : Settings.text

            MouseArea {
                id: backMouse
                anchors.fill: backButton
                onClicked: MediaService.activePlayer.previous()
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
            }
        }
        MaterialIcon {
            id: playButton
            text: MediaService.activePlayer.isPlaying ? "pause" : "play_arrow"
            size: Settings.iconLarge
            color: playMouse.containsMouse ? Settings.accent : Settings.text

            MouseArea {
                id: playMouse
                anchors.fill: playButton
                onClicked: MediaService.activePlayer.togglePlaying()
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
            }
        }

        MaterialIcon {
            id: nextButton
            text: "skip_next"
            size: Settings.iconLarge
            color: nextMouse.containsMouse ? Settings.accent : Settings.text

            MouseArea {
                id: nextMouse
                anchors.fill: nextButton
                onClicked: MediaService.activePlayer.next()
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
            }
        }
    }

    function secondsToTime(seconds: real): string {
        const min = Math.floor(seconds / 60);
        const sec = Math.floor(seconds % 60);

        const formattedMinutes = (min < 10 ? '0' : '') + min
        const formattedSeconds = (sec < 10 ? '0' : '') + sec

        return formattedMinutes + ':' + formattedSeconds
    }

    function getProgressString(): string {
        return `${secondsToTime(MediaService.activePlayer.position)}/${secondsToTime(MediaService.activePlayer.length)}`
    }
}
