import QtQuick
import QtQuick.Controls
import curio

Item {
    id: control

    Colors { id: colors }

    property alias label: labelText.text
    property alias text: textField.text
    property alias hint: textField.placeholderText
    property alias readOnly: textField.readOnly

    property color labelColor: colors.color_text
    property color backgroundColor: colors.color_card
    property color textColor: colors.color_text

    property int labelWidth: 120

    implicitHeight: 40
    implicitWidth: 300

    Row {
        anchors.fill: parent
        spacing: 12

        Text {
            id: labelText
            width: control.labelWidth
            height: parent.height
            color: control.labelColor
            font.pixelSize: 14
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }

        TextField {
            id: textField
            width: parent.width - labelText.width - parent.spacing
            height: parent.height

            color: control.textColor
            font.pixelSize: 14
            verticalAlignment: Text.AlignVCenter

            background: Rectangle {
                color: control.backgroundColor
                border.color: colors.color_stroke
                border.width: 1
                radius: textField.height / 2
            }
        }
    }
}
