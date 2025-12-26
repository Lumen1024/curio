import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import curio

RowLayout {
    id: control

    Colors { id: colors }

    property string label: ""
    property int labelWidth: 120
    property bool enabled: true
    property var model: null
    property string textRole: "text"
    property string valueRole: "value"
    property int currentIndex: -1
    property string displayText: currentIndex >= 0 ? getDisplayText() : ""

    spacing: 12
    Layout.fillWidth: true

    Text {
        text: control.label
        font.pixelSize: 14
        color: control.enabled ? colors.color_text : colors.color_text_2
        Layout.preferredWidth: control.labelWidth
        visible: control.label !== ""
    }

    Rectangle {
        id: selectButton
        Layout.fillWidth: true
        height: 40
        color: control.enabled ? colors.color_card : Qt.darker(colors.color_card, 1.1)
        radius: selectButton.height / 2
        border.color: colors.color_stroke
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 10

            Text {
                text: control.displayText
                color: control.enabled ? colors.color_text : colors.color_text_2
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: "▼"
                color: control.enabled ? colors.color_text : colors.color_text_2
                font.pixelSize: 10
                verticalAlignment: Text.AlignVCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: control.enabled
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                popup.open()
            }
        }
    }

    CustomPopup {
        id: popup
        x: control.labelWidth + control.spacing
        y: selectButton.height + 4
        width: selectButton.width

        ScrollView {
            width: parent.width
            height: Math.min(contentHeight, 300)
            clip: true

            Column {
                spacing: 4
                width: parent.width

                Repeater {
                    model: control.model

                    Rectangle {
                        width: parent.width
                        height: 36
                        color: itemMouseArea.containsMouse ? Qt.darker(colors.color_card, 1.05) : colors.color_card
                        radius: height / 2

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            text: control.getItemText(index)
                            color: colors.color_text
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }

                        MouseArea {
                            id: itemMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                control.currentIndex = index
                                popup.close()
                            }
                        }
                    }
                }
            }
        }
    }

    function getItemText(index) {
        if (!model) return ""

        var item = model.get ? model.get(index) : model[index]
        if (!item) return ""

        return item[textRole] !== undefined ? item[textRole] : ""
    }

    function getDisplayText() {
        if (currentIndex < 0 || !model) return ""
        return getItemText(currentIndex)
    }
}
