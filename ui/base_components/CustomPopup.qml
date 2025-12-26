import QtQuick
import QtQuick.Controls
import curio

Popup {
    id: popup

    Colors { id: colors }

    padding: 8
    visible: false
    opacity: 0
    closePolicy: Popup.CloseOnPressOutside
    transformOrigin: Popup.Top

    function open() {
        visible = true
        openAnimation.start()
    }

    function close() {
        closeAnimation.start()
    }

    SequentialAnimation {
        id: openAnimation
        ParallelAnimation {
            NumberAnimation {
                target: popup
                property: "opacity"
                from: 0
                to: 1
                duration: 200
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: popup
                property: "scale"
                from: 0.95
                to: 1.0
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }

    SequentialAnimation {
        id: closeAnimation
        ParallelAnimation {
            NumberAnimation {
                target: popup
                property: "opacity"
                from: 1
                to: 0
                duration: 200
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: popup
                property: "scale"
                from: 1.0
                to: 0.95
                duration: 200
                easing.type: Easing.InCubic
            }
        }
        ScriptAction {
            script: popup.visible = false
        }
    }

    background: Rectangle {
        color: colors.color_bg
        radius: 8
        border.width: 1
        border.color: colors.color_stroke
    }
}
