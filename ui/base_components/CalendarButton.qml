import QtQuick
import QtQuick.Controls
import curio

IconButton {
    id: control

    Colors { id: colors }

    property var isDaySelected: function(date) { return false }

    signal dayClicked(date selectedDate)

    iconSource: "qrc:/qt/qml/curio/res/ic_calendar.svg"

    onClicked: {
        popup.open()
    }

    property int currentMonth: new Date().getMonth()
    property int currentYear: new Date().getFullYear()
    property var calendarDays: []

    property var monthNames: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь",
                               "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    property var dayNames: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]

    Component.onCompleted: {
        calendarDays = buildCalendarDays()
    }

    function nextMonth() {
        currentMonth++
        if (currentMonth > 11) {
            currentMonth = 0
            currentYear++
        }
        calendarDays = buildCalendarDays()
    }

    function prevMonth() {
        currentMonth--
        if (currentMonth < 0) {
            currentMonth = 11
            currentYear--
        }
        calendarDays = buildCalendarDays()
    }

    function getDaysInMonth(month, year) {
        return new Date(year, month + 1, 0).getDate()
    }

    function getFirstDayOfMonth(month, year) {
        var day = new Date(year, month, 1).getDay()
        return day === 0 ? 6 : day - 1
    }

    function buildCalendarDays() {
        var days = []
        var daysInMonth = getDaysInMonth(currentMonth, currentYear)
        var firstDay = getFirstDayOfMonth(currentMonth, currentYear)

        var prevMonth = currentMonth === 0 ? 11 : currentMonth - 1
        var prevYear = currentMonth === 0 ? currentYear - 1 : currentYear
        var daysInPrevMonth = getDaysInMonth(prevMonth, prevYear)

        for (var i = firstDay - 1; i >= 0; i--) {
            days.push({
                day: daysInPrevMonth - i,
                month: prevMonth,
                year: prevYear,
                isCurrentMonth: false
            })
        }

        for (var d = 1; d <= daysInMonth; d++) {
            days.push({
                day: d,
                month: currentMonth,
                year: currentYear,
                isCurrentMonth: true
            })
        }

        var nextMonth = currentMonth === 11 ? 0 : currentMonth + 1
        var nextYear = currentMonth === 11 ? currentYear + 1 : currentYear
        var remainingDays = 7 - (days.length % 7)
        if (remainingDays < 7) {
            for (var n = 1; n <= remainingDays; n++) {
                days.push({
                    day: n,
                    month: nextMonth,
                    year: nextYear,
                    isCurrentMonth: false
                })
            }
        }

        return days
    }

    CustomPopup {
        id: popup
        x: control.width - width
        y: control.height + 8
        width: contentColumn.contentWidth + 16
        padding: 8

        Column {
            id: contentColumn
            spacing: 8
            readonly property int contentWidth: 7 * 32 + 6 * 4
            width: contentWidth

            Item {
                width: contentColumn.contentWidth
                height: 32

                IconButton {
                    id: prevButton
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: "qrc:/qt/qml/curio/res/ic_left.svg"
                    backgroundColor: "transparent"
                    onClicked: control.prevMonth()
                }

                Text {
                    anchors.centerIn: parent
                    text: control.monthNames[control.currentMonth] + " " + control.currentYear
                    color: colors.color_text
                    font.pixelSize: 14
                    font.bold: true
                }

                IconButton {
                    id: nextButton
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: "qrc:/qt/qml/curio/res/ic_right.svg"
                    backgroundColor: "transparent"
                    onClicked: control.nextMonth()
                }
            }

            Row {
                width: contentColumn.contentWidth
                height: 24
                spacing: 4

                Repeater {
                    model: control.dayNames

                    Text {
                        text: modelData
                        color: colors.color_text
                        font.pixelSize: 12
                        width: 32
                        height: 24
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            Grid {
                id: calendarGrid
                columns: 7
                spacing: 4
                width: contentColumn.contentWidth

                Repeater {
                    model: control.calendarDays

                    delegate: Button {
                        id: dayButton
                        width: 32
                        height: 32

                        property date itemDate: new Date(modelData.year, modelData.month, modelData.day)
                        property bool isSelected: control.isDaySelected(itemDate)

                        scale: pressed ? 0.9 : (hovered ? 1.1 : 1.0)
                        rotation: hovered ? 2 : 0

                        Behavior on scale {
                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }

                        Behavior on rotation {
                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }

                        background: Rectangle {
                            color: dayButton.isSelected
                                ? colors.color_card
                                : "transparent"
                            radius: width / 2
                            border.width: modelData.isCurrentMonth ? 1 : 0
                            border.color: modelData.isCurrentMonth ? colors.color_stroke : "transparent"
                        }

                        contentItem: Text {
                            text: modelData.day
                            color: colors.color_text
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            control.dayClicked(itemDate)
                            popup.close()
                        }
                    }
                }
            }
        }
    }
}