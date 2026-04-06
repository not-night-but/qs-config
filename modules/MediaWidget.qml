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
                spacing: 10
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.leftMargin: 10
                Layout.topMargin: 10
                Layout.bottomMargin: 0
                StyledText {
                    id: shuffleControl
                    text: "󰒟"
                    color: MediaService.isShuffled ? Settings.accent : Settings.text

                    MouseArea {
                        anchors.fill: shuffleControl
                        onClicked: MediaService.toggleShuffle()
                        cursorShape: Qt.PointingHandCursor
                    }
                }

                StyledText {
                    id: loopControl
                    text: MediaService.getLoopIcon()
                    color: MediaService.isLooping ? Settings.accent : Settings.text

                    MouseArea {
                        anchors.fill: loopControl
                        onClicked: MediaService.cycleLoopState()
                        cursorShape: Qt.PointingHandCursor
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
        anchors.left: trackArt.right
        anchors.leftMargin: 20

        Text {
            id: backButton
            Layout.topMargin: 30
            text: "󰒮"
            font.pixelSize: 30
            color: Settings.text
            font.family: "Cartograph CF"
            font.italic: true
            font.weight: Font.Bold

            MouseArea {
                anchors.fill: backButton
                onClicked: MediaService.activePlayer.previous()
                cursorShape: Qt.PointingHandCursor
            }
        }
        Text {
            id: playButton
            text: MediaService.activePlayer.isPlaying ? "󰏤" : "󰐊"
            font.pixelSize: 30
            color: Settings.text
            font.family: "Cartograph CF"
            font.italic: true
            font.weight: Font.Bold

            MouseArea {
                anchors.fill: playButton
                onClicked: MediaService.activePlayer.togglePlaying()
                cursorShape: Qt.PointingHandCursor
            }
        }
        Text {
            id: nextButton
            text: "󰒭"
            font.pixelSize: 30
            color: Settings.text
            font.family: "Cartograph CF"
            font.italic: true
            font.weight: Font.Bold

            MouseArea {
                anchors.fill: nextButton
                onClicked: MediaService.activePlayer.next()
                cursorShape: Qt.PointingHandCursor
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
