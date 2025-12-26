import QtQuick
import QtQuick.Controls
import curio

Button {
    id: control

    Colors { id: colors }

    property string iconSource: ""
    property color backgroundColor: colors.color_card
    property color borderColor: colors.color_stroke

    implicitWidth: 32
    implicitHeight: 32

    // Анимация масштаба и поворота
    scale: control.pressed ? 0.9 : (control.hovered ? 1.1 : 1.0)
    rotation: control.hovered ? 2 : 0

    background: Rectangle {
        color: control.backgroundColor
        radius: width / 2
        border.width: 1
        border.color: control.borderColor
    }

    Behavior on scale {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    Behavior on rotation {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    contentItem: Image {
        source: control.iconSource
        anchors.fill: parent
        anchors.margins: 4
        sourceSize.width: 32
        sourceSize.height: 32
        fillMode: Image.PreserveAspectFit
    }
}
