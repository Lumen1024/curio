import QtQuick
import QtQuick.Layouts
import curio

Window {
    id: authWindow
    width: 600
    height: 400
    visible: true
    title: qsTr("Curio - Авторизация")

    Colors { id: colors }

    signal parentSelected()
    signal childSelected()

    Rectangle {
        anchors.fill: parent
        color: colors.color_bg

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 32

            Text {
                text: "Выберите пользователя"
                font.pixelSize: 24
                font.bold: true
                color: colors.color_text_1
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                spacing: 16
                Layout.alignment: Qt.AlignHCenter

                TextButton {
                    text: "Ребенок"
                    backgroundColor: colors.color_creative
                    Layout.preferredWidth: 120
                    onClicked: authWindow.childSelected()
                }

                TextButton {
                    text: "Родитель"
                    backgroundColor: colors.color_mind
                    Layout.preferredWidth: 120
                    onClicked: authWindow.parentSelected()
                }
            }
        }
    }
}
