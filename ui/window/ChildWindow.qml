import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import curio

Window {
    id: childWindow
    width: 600
    height: 450
    visible: false
    title: qsTr("Управление детьми")

    property var childRepository: null

    Colors { id: colors }

    Connections {
        target: childRepository
        function onDataChanged() {
            loadChildren()
        }
    }

    enum FormMode {
        None,
        Add,
        Edit
    }

    property int formMode: ChildWindow.FormMode.None
    property int selectedChildId: -1

    Rectangle {
        anchors.fill: parent
        color: colors.color_bg

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: "Дети"
                font.pixelSize: 24
                font.bold: true
                color: colors.color_text_2
                Layout.alignment: Qt.AlignHCenter
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: listView
                    anchors.fill: parent
                    spacing: 8
                    clip: true

                    model: ListModel {
                        id: childrenModel
                    }

                    delegate: Rectangle {
                        width: listView.width
                        height: 32
                        color: colors.color_card
                        radius: height / 2
                        border.color: colors.color_stroke
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 8
                            spacing: 12

                            Text {
                                text: model.fullName
                                font.pixelSize: 13
                                font.bold: true
                                color: colors.color_text_1
                                Layout.fillWidth: true
                            }

                            Text {
                                text: "Класс: " + model.grade
                                font.pixelSize: 12
                                color: colors.color_text_2
                                Layout.preferredWidth: 80
                            }

                            IconButton {
                                iconSource: "qrc:/qt/qml/curio/res/ic_delete.svg"
                                backgroundColor: "transparent"
                                borderColor: "transparent"
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                onClicked: {
                                    deleteChild(model.childId)
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            propagateComposedEvents: true
                            z: -1
                            onClicked: {
                                selectedChildId = model.childId
                                formMode = ChildWindow.FormMode.Edit
                                loadChildToForm(model.childId)
                                editDialog.open()
                            }
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "Нет детей"
                    font.pixelSize: 16
                    color: colors.color_text_2
                    visible: listView.count === 0
                }
            }

            TextButton {
                text: "+ Добавить ребенка"
                backgroundColor: colors.color_mind
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 220
                height: 40
                onClicked: {
                    formMode = ChildWindow.FormMode.Add
                    clearForm()
                    editDialog.open()
                }
            }
        }
    }

    Dialog {
        id: editDialog
        anchors.centerIn: parent
        width: 400
        height: 300
        modal: true
        closePolicy: Dialog.CloseOnEscape

        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 200
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                property: "scale"
                from: 0.9
                to: 1.0
                duration: 200
                easing.type: Easing.OutQuad
            }
        }

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 150
                easing.type: Easing.InQuad
            }
            NumberAnimation {
                property: "scale"
                from: 1.0
                to: 0.9
                duration: 150
                easing.type: Easing.InQuad
            }
        }

        background: Rectangle {
            color: colors.color_bg
            radius: 12
            border.color: colors.color_stroke
            border.width: 1
        }

        header: Rectangle {
            width: parent.width
            height: 50
            color: colors.color_bg
            radius: 12

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: parent.height / 2
                color: colors.color_bg
            }

            Text {
                anchors.centerIn: parent
                text: formMode === ChildWindow.FormMode.Add ? "Добавление ребенка" : "Редактирование ребенка"
                font.pixelSize: 16
                font.bold: true
                color: colors.color_text_2
            }
        }

        contentItem: Item {
            implicitWidth: 360
            implicitHeight: 200

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 12

                TextInput {
                    id: fullNameInput
                    Layout.fillWidth: true
                    label: "ФИО:"
                    hint: "Введите полное имя"
                    labelWidth: 70
                }

                TextInput {
                    id: gradeInput
                    Layout.fillWidth: true
                    label: "Класс:"
                    hint: "1-11"
                    labelWidth: 70
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 8
                    spacing: 12
                    Layout.alignment: Qt.AlignHCenter

                    TextButton {
                        text: "Готово"
                        backgroundColor: colors.color_mind
                        Layout.preferredWidth: 100
                        height: 36
                        onClicked: {
                            if (formMode === ChildWindow.FormMode.Add) {
                                addChild()
                            } else if (formMode === ChildWindow.FormMode.Edit) {
                                updateChild()
                            }
                            editDialog.close()
                        }
                    }

                    TextButton {
                        text: "Отмена"
                        backgroundColor: colors.color_card
                        Layout.preferredWidth: 100
                        height: 36
                        onClicked: {
                            formMode = ChildWindow.FormMode.None
                            selectedChildId = -1
                            clearForm()
                            editDialog.close()
                        }
                    }
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

    function addChild() {
        if (!validateForm()) {
            return
        }

        if (childRepository) {
            var grade = parseInt(gradeInput.text)

            childRepository.create(
                fullNameInput.text,
                grade
            )

            loadChildren()
            clearForm()
            formMode = ChildWindow.FormMode.None
        }
    }

    function updateChild() {
        if (!validateForm() || selectedChildId < 0) {
            return
        }

        if (childRepository) {
            var grade = parseInt(gradeInput.text)

            childRepository.update(
                selectedChildId,
                fullNameInput.text,
                grade
            )

            loadChildren()
            clearForm()
            formMode = ChildWindow.FormMode.None
            selectedChildId = -1
        }
    }

    function deleteChild(childId) {
        if (childRepository) {
            childRepository.remove(childId)
            loadChildren()

            if (selectedChildId === childId) {
                selectedChildId = -1
                formMode = ChildWindow.FormMode.None
                clearForm()
            }
        }
    }

    function loadChildToForm(childId) {
        if (childRepository) {
            var child = childRepository.getById(childId)
            fullNameInput.text = child.fullName
            gradeInput.text = child.grade.toString()
        }
    }

    function clearForm() {
        fullNameInput.text = ""
        gradeInput.text = ""
    }

    function validateForm() {
        if (fullNameInput.text.trim() === "") {
            console.log("ФИО не может быть пустым")
            return false
        }

        var grade = parseInt(gradeInput.text)
        if (isNaN(grade) || grade < 1 || grade > 11) {
            console.log("Класс должен быть числом от 1 до 11")
            return false
        }

        return true
    }
}
