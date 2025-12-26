import QtQuick
import QtQuick.Controls
import curio

Item {
    id: control

    Colors { id: colors }

    property alias label: labelText.text
    property bool checked: false
    property alias enabled: mouseArea.enabled

    property color labelColor: colors.color_text
    property color checkboxColor: colors.color_card
    property color checkedColor: colors.color_mind
    property color borderColor: colors.color_stroke

    implicitHeight: 40
    implicitWidth: 300

    Row {
        anchors.fill: parent
        spacing: 12

        Rectangle {
            id: checkbox
            width: 24
            height: 24
            anchors.verticalCenter: parent.verticalCenter
            color: control.checked ? control.checkedColor : control.checkboxColor
            border.color: control.borderColor
            border.width: 1
            radius: 4

            Text {
                anchors.centerIn: parent
                text: "✓"
                font.pixelSize: 16
                font.bold: true
                color: colors.color_text
                visible: control.checked
            }

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        Text {
            id: labelText
            height: parent.height
            color: control.labelColor
            font.pixelSize: 14
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            control.checked = !control.checked
        }
    }
}
