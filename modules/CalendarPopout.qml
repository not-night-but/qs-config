pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common
import qs.services

Popout {
    id: root

    location: PopoutBackground.Location.TopRight
    contentWidth: 275
    contentHeight: 200

    Rectangle {
        id: calWrapper
        color: "transparent"

        readonly property date currentDate: new Date()
        readonly property int currentMonth: currentDate.getMonth()
        readonly property int currentYear: currentDate.getFullYear()

        GridLayout {
            id: gridLayout
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.centerIn: parent
            columns: 2

            Item {
                implicitWidth: weekNumber.implicitWidth
                implicitHeight: header.implicitHeight
            }

            DayOfWeekRow {
                id: header
                locale: grid.locale

                delegate: Item {
                    id: dayOfWeekItem

                    required property var model
                    implicitWidth: implicitHeight
                    implicitHeight: weekText.implicitHeight + Settings.calendarLabelPadding

                    StyledText {
                        id: weekText

                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        text: dayOfWeekItem.model.shortName
                        color: (dayOfWeekItem.model.day === 0 || dayOfWeekItem.model.day === 6) ? Settings.disabled : Settings.accent
                    } 
                } 
            }

            WeekNumberColumn {
                id: weekNumber
                locale: grid.locale
                month: grid.month
                year: grid.year
                delegate: Item {
                    id: numCol
                    required property var weekNumber
                    implicitWidth: implicitHeight
                    implicitHeight: numText.implicitHeight + Settings.calendarLabelPadding

                    StyledText {
                        id: numText

                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        text: numCol.weekNumber
                        color: Settings.disabled
                        // TODO (@day): keep current week num at 1?
                        opacity:  0.4
                    }
                }
            }

            MonthGrid {
                id: grid
                locale: Qt.locale("de")
                month: calWrapper.currentMonth
                year: calWrapper.currentYear
                spacing: 3

                delegate: Rectangle {
                    id: dayItem

                    required property var model
                    property bool isToday: Qt.formatDate(dayItem.model.date) == Qt.formatDate(calWrapper.currentDate) 

                    implicitWidth: implicitHeight
                    implicitHeight: dayText.implicitHeight + Settings.calendarItemPadding

                    radius: Settings.cornerRadius

                    color: {
                        if (dayItem.isToday || itemHover.hovered) {
                            return Settings.accent
                        } else {
                            return "transparent"
                        }
                    }

                    StyledText {
                        id: dayText

                        anchors.centerIn: parent

                        text: dayItem.model.day
                        horizontalAlignment: Text.AlignHCenter

                        color: {
                            const dayOfWeek = dayItem.model.date.getUTCDay();
                            if (dayItem.isToday || itemHover.hovered) {
                                return Settings.background
                            } else if (dayOfWeek === 0 || dayOfWeek === 6) {
                                return Settings.disabled;
                            } else {
                                return Settings.accent
                            }
                        }

                        opacity: itemHover.hovered || dayItem.model.today || dayItem.model.month === grid.month ? 1 : 0.4
                    }

                    HoverHandler {
                        id: itemHover
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }
}
