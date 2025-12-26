import QtQuick
import QtQuick.Controls
import curio

IconButton {
    id: control

    Colors { id: colors }

    property var options: []
    property string selectedValue: ""

    signal optionSelected(string value)

    backgroundColor: {
        if (selectedValue === "") {
            return colors.color_card
        }

        for (var i = 0; i < options.length; i++) {
            if (options[i].name === selectedValue) {
                return options[i].color
            }
        }
        return colors.color_card
    }

    Behavior on backgroundColor {
        ColorAnimation { duration: 200 }
    }

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
                model: control.options

                TextButton {
                    width: parent.width
                    text: modelData.name
                    backgroundColor: modelData.color

                    onClicked: {
                        if (control.selectedValue === modelData.name) {
                            control.selectedValue = ""
                        } else {
                            control.selectedValue = modelData.name
                        }
                        control.optionSelected(control.selectedValue)
                        popup.close()
                    }
                }
            }
        }
    }
}