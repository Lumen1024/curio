import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import curio

Button {
    id: control

    Colors { id: colors }

    property string iconSource: ""
    property color backgroundColor: colors.color_card

    implicitHeight: 32
    leftPadding: 8
    rightPadding: 12

    background: Rectangle {
        color: control.backgroundColor
        radius: width / 2
        border.width: 1
        border.color: colors.color_stroke
    }

    scale: control.pressed ? 0.9 : (control.hovered ? 1.1 : 1.0)
    rotation: control.hovered ? 2 : 0

    Behavior on scale {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    Behavior on rotation {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    contentItem: Item {
        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 4

            Image {
                source: control.iconSource
                width: 24
                height: 24
                sourceSize.width: 24
                sourceSize.height: 24
            }

            Text {
                text: control.text
                color: colors.color_text
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
