import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import curio

Rectangle {
    id: dayItem

    Colors { id: colors }

    property date date: new Date()
    property var lessonPairs: []
    property bool isChildMode: false
    property string highlightKey: ""

    signal addLessonClicked()
    signal lessonClicked(var lesson)

    function formatDate(date) {
        var dayNames = ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
        var dayOfWeek = dayNames[date.getDay()]
        var dayOfMonth = date.getDate()
        return dayOfWeek + " " + dayOfMonth
    }

    implicitWidth: 200
    implicitHeight: column.implicitHeight + 32
    radius: 4

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        anchors.topMargin: 16
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 32
                radius: height / 2
                border.width: 1
                border.color: colors.color_stroke
                color: "transparent"

                Text {
                    anchors.centerIn: parent
                    text: formatDate(dayItem.date)
                    font.pixelSize: 16
                    color: colors.color_text_1
                }
            }

            IconButton {
                id: addButton
                iconSource: "qrc:/qt/qml/curio/res/ic_add.svg"
                visible: !dayItem.isChildMode
                onClicked: dayItem.addLessonClicked()
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            spacing: 8

            Repeater {
                model: dayItem.lessonPairs

                LessonItem {
                    Layout.fillWidth: true
                    lesson: modelData.lesson
                    childName: modelData.childName
                    highlightKey: dayItem.highlightKey

                    onClicked: {
                        dayItem.lessonClicked(modelData.lesson)
                    }
                }
            }

            Text {
                text: "Нет занятий"
                font.pixelSize: 16
                color: colors.color_text_2
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                Layout.topMargin: 10
                visible: dayItem.lessonPairs.length === 0
            }
        }
    }

    Shape {
        anchors.fill: parent

        ShapePath {
            strokeWidth: 1
            strokeColor: colors.color_stroke
            strokeStyle: ShapePath.DashLine
            dashPattern: [16, 16]
            fillColor: "transparent"

            startX: dayItem.radius
            startY: 0

            PathLine { x: dayItem.width - dayItem.radius; y: 0 }
            PathArc { x: dayItem.width; y: dayItem.radius; radiusX: dayItem.radius; radiusY: dayItem.radius }
            PathLine { x: dayItem.width; y: dayItem.height - dayItem.radius }
            PathArc { x: dayItem.width - dayItem.radius; y: dayItem.height; radiusX: dayItem.radius; radiusY: dayItem.radius }
            PathLine { x: dayItem.radius; y: dayItem.height }
            PathArc { x: 0; y: dayItem.height - dayItem.radius; radiusX: dayItem.radius; radiusY: dayItem.radius }
            PathLine { x: 0; y: dayItem.radius }
            PathArc { x: dayItem.radius; y: 0; radiusX: dayItem.radius; radiusY: dayItem.radius }
        }
    }
}
