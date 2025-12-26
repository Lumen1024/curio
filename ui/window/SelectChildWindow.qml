import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import curio

Window {
    id: selectChildWindow
    width: 400
    height: 500
    visible: false
    title: qsTr("Выбор ребенка")
    modality: Qt.ApplicationModal

    property var childRepository: null

    signal childSelected(int childId)
    signal cancelled()

    Colors { id: colors }

    Rectangle {
        anchors.fill: parent
        color: colors.color_bg

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Text {
                text: "Выберите ребенка"
                font.pixelSize: 24
                font.bold: true
                color: colors.color_text_1
                Layout.alignment: Qt.AlignHCenter
            }

            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8
                clip: false

                model: ListModel {
                    id: childrenModel
                }

                delegate: Item {
                    width: listView.width
                    height: 40

                    Rectangle {
                        id: childItem
                        anchors.fill: parent
                        anchors.leftMargin: 2
                        anchors.rightMargin: 2
                        radius: height / 2
                        border.width: 1
                        border.color: colors.color_stroke
                        color: colors.color_card

                        scale: mouseArea.pressed ? 0.95 : (mouseArea.containsMouse ? 1.02 : 1.0)
                        opacity: mouseArea.containsMouse ? 0.9 : 1.0

                        Behavior on scale {
                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }

                        Behavior on opacity {
                            NumberAnimation { duration: 150 }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 8

                            Text {
                                text: model.fullName
                                font.pixelSize: 14
                                color: colors.color_text
                                Layout.fillWidth: true
                            }

                            Text {
                                text: "Класс: " + model.grade
                                font.pixelSize: 14
                                font.weight: Font.Light
                                color: colors.color_text_2
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                selectChildWindow.childSelected(model.childId)
                            }
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "Нет доступных детей"
                    font.pixelSize: 16
                    font.weight: Font.Light
                    color: colors.color_text_2
                    visible: listView.count === 0
                }
            }

            TextButton {
                text: "Отмена"
                backgroundColor: colors.color_card
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 120
                onClicked: {
                    selectChildWindow.cancelled()
                }
            }
        }
    }

    Component.onCompleted: {
        loadChildren()
    }

    function loadChildren() {
        childrenModel.clear()

        if (childRepository) {
            var children = childRepository.getAll()
            for (var i = 0; i < children.length; i++) {
                childrenModel.append({
                    childId: children[i].id,
                    fullName: children[i].fullName,
                    grade: children[i].grade
                })
            }
        }
    }
}
