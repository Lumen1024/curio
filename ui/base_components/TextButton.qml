import QtQuick
import QtQuick.Controls
import curio

Button {
    id: control

    Colors { id: colors }

    property color backgroundColor: colors.color_card

    height: 32
    leftPadding: 8
    rightPadding: 8

    scale: control.pressed ? 0.9 : (control.hovered ? 1.1 : 1.0)
    rotation: control.hovered ? 2 : 0

    Behavior on scale {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    Behavior on rotation {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    background: Rectangle {
        color: control.backgroundColor
        radius: control.height / 2
        border.width: 1
        border.color: colors.color_stroke
    }

    contentItem: Text {
        text: control.text
        color: colors.color_text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 14
    }
}
