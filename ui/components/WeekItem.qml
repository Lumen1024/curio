import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import curio

Rectangle {
    id: weekItem

    Colors { id: colors }
    Utils { id: utils }

    property var childMode: false

    property date startDate: new Date()
    property var lessons: []
    property string highlightKey: ""

    signal addLessonClicked(date selectedDate)
    signal lessonClicked(var lesson)

    width: parent.width
    color: colors.color_bg
    radius: 8

    function getDayDate(dayOffset) {
        var date = new Date(weekItem.startDate)
        date.setDate(date.getDate() + dayOffset)
        return date
    }

    function getLessonsForDay(dayDate) {
        var result = []

        for (var i = 0; i < lessons.length; i++) {
            var lesson = lessons[i]
            if (utils.isSameDay(lesson.dateTime, dayDate)) {
                result.push({
                    lesson: lesson,
                    childName: lesson.childName
                })
            }
        }

        return result
    }

    ScrollView {
        anchors.fill: parent
        clip: true

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff

        contentWidth: contentGrid.width + 20
        contentHeight: contentGrid.height + 20

        GridLayout {
            id: contentGrid
            x: 10
            y: 10
            width: weekItem.width - 20
            columns: 3
            rowSpacing: 32
            columnSpacing: 32

            Repeater {
                model: 7

                DayItem {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: (contentGrid.width - contentGrid.columnSpacing * 2) / 3
                    date: getDayDate(index)
                    lessonPairs: getLessonsForDay(getDayDate(index))
                    isChildMode: childMode
                    highlightKey: weekItem.highlightKey

                    onAddLessonClicked: {
                        weekItem.addLessonClicked(date)
                    }

                    onLessonClicked: function(lesson) {
                        weekItem.lessonClicked(lesson)
                    }
                }
            }
        }
    }
}
