import QtQuick
import QtQuick.Controls
import curio

IconButton {
    id: control
    Colors { id: colors }

    property var menuItems: []

    signal itemSelected(string value)

    onClicked: {
        popup.open()
    }

    CustomPopup {
        id: popup
        x: control.width - width
        y: control.height + 8
        width: 150

        Column {
            spacing: 4
            width: parent.width

            Repeater {
                model: control.menuItems

                TextButton {
                    width: parent.width
                    text: modelData
                    
                    onClicked: {
                        control.itemSelected(modelData)
                        popup.close()
                    }
                }
            }
        }
    }
}
