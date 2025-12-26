import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import curio

Window {
    id: teacherWindow
    width: 600
    height: 450
    visible: false
    title: qsTr("Управление преподавателями")

    property var teacherRepository: null

    Colors { id: colors }

    Connections {
        target: teacherRepository
        function onDataChanged() {
            loadTeachers()
        }
    }

    enum FormMode {
        None,
        Add,
        Edit
    }

    property int formMode: TeacherWindow.FormMode.None
    property int selectedTeacherId: -1

    Rectangle {
        anchors.fill: parent
        color: colors.color_bg

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: "Преподаватели"
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
                        id: teachersModel
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
                                text: model.phone
                                font.pixelSize: 12
                                color: colors.color_text_2
                                Layout.preferredWidth: 120
                            }

                            IconButton {
                                iconSource: "qrc:/qt/qml/curio/res/ic_delete.svg"
                                backgroundColor: "transparent"
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                borderColor: "transparent"
                                onClicked: {
                                    deleteTeacher(model.teacherId)
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            propagateComposedEvents: true
                            z: -1
                            onClicked: {
                                selectedTeacherId = model.teacherId
                                formMode = TeacherWindow.FormMode.Edit
                                loadTeacherToForm(model.teacherId)
                                editDialog.open()
                            }
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "Нет преподавателей"
                    font.pixelSize: 16
                    color: colors.color_text_2
                    visible: listView.count === 0
                }
            }

            TextButton {
                text: "+ Добавить преподавателя"
                backgroundColor: colors.color_mind
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 220
                height: 40
                onClicked: {
                    formMode = TeacherWindow.FormMode.Add
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
                text: formMode === TeacherWindow.FormMode.Add ? "Добавление преподавателя" : "Редактирование преподавателя"
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
                    id: phoneInput
                    Layout.fillWidth: true
                    label: "Телефон:"
                    hint: "+7 (XXX) XXX-XX-XX"
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
                            if (formMode === TeacherWindow.FormMode.Add) {
                                addTeacher()
                            } else if (formMode === TeacherWindow.FormMode.Edit) {
                                updateTeacher()
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
                            formMode = TeacherWindow.FormMode.None
                            selectedTeacherId = -1
                            clearForm()
                            editDialog.close()
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        loadTeachers()
    }

    function loadTeachers() {
        teachersModel.clear()

        if (teacherRepository) {
            var teachers = teacherRepository.getAll()
            for (var i = 0; i < teachers.length; i++) {
                teachersModel.append({
                    teacherId: teachers[i].id,
                    fullName: teachers[i].fullName,
                    phone: teachers[i].phone
                })
            }
        }
    }

    function addTeacher() {
        if (!validateForm()) {
            return
        }

        if (teacherRepository) {
            teacherRepository.create(
                fullNameInput.text,
                phoneInput.text
            )

            loadTeachers()
            clearForm()
            formMode = TeacherWindow.FormMode.None
        }
    }

    function updateTeacher() {
        if (!validateForm() || selectedTeacherId < 0) {
            return
        }

        if (teacherRepository) {
            teacherRepository.update(
                selectedTeacherId,
                fullNameInput.text,
                phoneInput.text
            )

            loadTeachers()
            clearForm()
            formMode = TeacherWindow.FormMode.None
            selectedTeacherId = -1
        }
    }

    function deleteTeacher(teacherId) {
        if (teacherRepository) {
            teacherRepository.remove(teacherId)
            loadTeachers()

            if (selectedTeacherId === teacherId) {
                selectedTeacherId = -1
                formMode = TeacherWindow.FormMode.None
                clearForm()
            }
        }
    }

    function loadTeacherToForm(teacherId) {
        if (teacherRepository) {
            var teacher = teacherRepository.getById(teacherId)
            fullNameInput.text = teacher.fullName
            phoneInput.text = teacher.phone
        }
    }

    function clearForm() {
        fullNameInput.text = ""
        phoneInput.text = ""
    }

    function validateForm() {
        if (fullNameInput.text.trim() === "") {
            console.log("ФИО не может быть пустым")
            return false
        }

        if (phoneInput.text.trim() === "") {
            console.log("Телефон не может быть пустым")
            return false
        }

        return true
    }
}
