import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import curio

Window {
    id: settingsWindow
    width: 600
    height: 400
    visible: false
    title: qsTr("Настройки")

    Colors { id: colors }

    Rectangle {
        anchors.fill: parent
        color: colors.color_bg

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "Настройки"
                font.pixelSize: 28
                font.bold: true
                color: colors.color_text_1
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Настроек пока нет"
                font.pixelSize: 18
                color: colors.color_text_2
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
