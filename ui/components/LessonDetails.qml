import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import curio

Window {
    id: lessonDetails
    width: 600
    height: 750
    visible: false
    title: qsTr("Детали урока")
    modality: Qt.ApplicationModal

    property var childRepository: null
    property var teacherRepository: null
    property var lessonRepository: null
    property var repeatedLessonsRepository: null

    Colors { id: colors }

    enum Mode {
        Add,
        Edit
    }

    property int mode: LessonDetails.Mode.Add
    property int lessonId: -1
    property int lessonTypeValue: 0
    property date selectedDate: new Date()

    property bool wasRepeated: false
    property bool isRepeated: false

    signal lessonSaved()
    signal lessonDeleted()
    signal cancelled()

    Rectangle {
        anchors.fill: parent
        color: colors.color_bg

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Text {
                text: mode === LessonDetails.Mode.Add ? "Создание урока" : "Редактирование урока"
                font.pixelSize: 24
                font.bold: true
                color: colors.color_text
                Layout.alignment: Qt.AlignHCenter
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ColumnLayout {
                    width: lessonDetails.width - 40
                    spacing: 15

                    TextInput {
                        id: nameInput
                        Layout.fillWidth: true
                        label: "Название:"
                        hint: "Введите название урока"
                        labelWidth: 120
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Тип урока:"
                            font.pixelSize: 14
                            color: colors.color_text
                            Layout.preferredWidth: 120
                        }

                        Row {
                            spacing: 8

                            TextButton {
                                id: mindButton
                                text: "Умственное"
                                backgroundColor: lessonTypeValue === 0 ? colors.color_mind : colors.color_card
                                width: 120
                                onClicked: lessonTypeValue = 0
                            }

                            TextButton {
                                id: sportButton
                                text: "Спортивное"
                                backgroundColor: lessonTypeValue === 1 ? colors.color_sport : colors.color_card
                                width: 120
                                onClicked: lessonTypeValue = 1
                            }

                            TextButton {
                                id: creativeButton
                                text: "Творческое"
                                backgroundColor: lessonTypeValue === 2 ? colors.color_creative : colors.color_card
                                width: 120
                                onClicked: lessonTypeValue = 2
                            }
                        }
                    }

                    TextInput {
                        id: timeInput
                        Layout.fillWidth: true
                        label: "Время:"
                        hint: "чч:мм"
                        labelWidth: 120
                    }

                    ListModel {
                        id: childrenModel
                    }

                    SelectField {
                        id: childCombo
                        label: "Ребенок:"
                        labelWidth: 120
                        model: childrenModel
                        textRole: "fullName"
                        valueRole: "childId"
                    }

                    ListModel {
                        id: teachersModel
                    }

                    SelectField {
                        id: teacherCombo
                        label: "Преподаватель:"
                        labelWidth: 120
                        model: teachersModel
                        textRole: "fullName"
                        valueRole: "teacherId"
                    }

                    TextInput {
                        id: locationInput
                        Layout.fillWidth: true
                        label: "Место:"
                        hint: "Введите адрес или название места"
                        labelWidth: 120
                    }

                    CustomCheckBox {
                        id: repeatCheckBox
                        label: "Повторяющийся урок"
                        Layout.fillWidth: true
                        Layout.topMargin: 10
                        onCheckedChanged: {
                            isRepeated = checked
                        }
                    }

                    SelectField {
                        id: repeatTypeCombo
                        label: "Повтор:"
                        labelWidth: 120
                        visible: isRepeated
                        Layout.fillWidth: true
                        model: ListModel {
                            ListElement { name: "Каждый день"; value: 0 }
                            ListElement { name: "Каждую неделю"; value: 1 }
                            ListElement { name: "Каждый месяц"; value: 2 }
                        }
                        textRole: "name"
                        valueRole: "value"
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 15
                Layout.alignment: Qt.AlignRight

                TextButton {
                    text: mode === LessonDetails.Mode.Add ? "Создать" : "Сохранить"
                    backgroundColor: colors.color_card
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 32
                    onClicked: {
                        if (mode === LessonDetails.Mode.Add) {
                            createLesson()
                        } else {
                            updateLesson()
                        }
                    }
                }

                TextButton {
                    text: "Удалить"
                    backgroundColor: colors.color_sport
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 32
                    visible: mode === LessonDetails.Mode.Edit
                    onClicked: {
                        deleteLesson()
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        loadChildren()
        loadTeachers()
    }

    function loadChildren() {
        childrenModel.clear()

        if (childRepository) {
            var children = childRepository.getAll()
            for (var i = 0; i < children.length; i++) {
                childrenModel.append({
                    childId: children[i].id,
                    fullName: children[i].fullName
                })
            }
        }
    }

    function loadTeachers() {
        teachersModel.clear()
        teachersModel.append({
            teacherId: -1,
            fullName: "Не выбран"
        })

        if (teacherRepository) {
            var teachers = teacherRepository.getAll()
            for (var i = 0; i < teachers.length; i++) {
                teachersModel.append({
                    teacherId: teachers[i].id,
                    fullName: teachers[i].fullName
                })
            }
        }
    }

    function loadLesson(lesson) {
        if (!lesson) return

        lessonId = lesson.id
        nameInput.text = lesson.name
        lessonTypeValue = lesson.type

        var date = new Date(lesson.dateTime)
        selectedDate = date
        timeInput.text = Qt.formatTime(date, "hh:mm")

        for (var i = 0; i < childrenModel.count; i++) {
            if (childrenModel.get(i).childId === lesson.childId) {
                childCombo.currentIndex = i
                break
            }
        }

        if (lesson.teacherId !== undefined && lesson.teacherId !== null) {
            for (var j = 0; j < teachersModel.count; j++) {
                if (teachersModel.get(j).teacherId === lesson.teacherId) {
                    teacherCombo.currentIndex = j
                    break
                }
            }
        } else {
            teacherCombo.currentIndex = 0
        }

        if (lesson.location !== undefined && lesson.location !== null) {
            locationInput.text = lesson.location
        }

        if (lesson.isRepeated !== undefined) {
            wasRepeated = lesson.isRepeated
            isRepeated = lesson.isRepeated
            repeatCheckBox.checked = lesson.isRepeated

            if (lesson.isRepeated && lesson.repeatType !== undefined) {
                repeatTypeCombo.currentIndex = lesson.repeatType
            }
        } else {
            wasRepeated = false
            isRepeated = false
            repeatCheckBox.checked = false
        }
    }

    function createLesson() {
        if (!validateForm()) return

        var dateTime = parseDateTime()

        if (childCombo.currentIndex < 0 || childCombo.currentIndex >= childrenModel.count) {
            console.log("Ошибка: неверный индекс ребенка")
            return
        }

        if (teacherCombo.currentIndex < 0 || teacherCombo.currentIndex >= teachersModel.count) {
            console.log("Ошибка: неверный индекс учителя")
            return
        }

        var childId = childrenModel.get(childCombo.currentIndex).childId
        var teacherId = teachersModel.get(teacherCombo.currentIndex).teacherId

        if (isRepeated) {
            if (repeatedLessonsRepository) {
                if (repeatTypeCombo.currentIndex < 0 || repeatTypeCombo.currentIndex >= repeatTypeCombo.model.count) {
                    console.log("Ошибка: неверный индекс типа повторения")
                    return
                }
                var repeatType = repeatTypeCombo.model.get(repeatTypeCombo.currentIndex).value
                repeatedLessonsRepository.create(
                    childId,
                    nameInput.text,
                    dateTime,
                    lessonTypeValue,
                    repeatType,
                    teacherId !== -1 ? teacherId : -1,
                    locationInput.text
                )
            }
        } else {
            if (lessonRepository) {
                lessonRepository.create(
                    childId,
                    nameInput.text,
                    dateTime,
                    lessonTypeValue,
                    teacherId !== -1 ? teacherId : -1,
                    locationInput.text
                )
            }
        }

        lessonDetails.lessonSaved()
        clearForm()
        lessonDetails.visible = false
    }

    function updateLesson() {
        if (!validateForm() || lessonId < 0) return

        var dateTime = parseDateTime()

        if (childCombo.currentIndex < 0 || childCombo.currentIndex >= childrenModel.count) {
            console.log("Ошибка: неверный индекс ребенка")
            return
        }

        if (teacherCombo.currentIndex < 0 || teacherCombo.currentIndex >= teachersModel.count) {
            console.log("Ошибка: неверный индекс учителя")
            return
        }

        var childId = childrenModel.get(childCombo.currentIndex).childId
        var teacherId = teachersModel.get(teacherCombo.currentIndex).teacherId

        if (wasRepeated !== isRepeated) {
            if (wasRepeated) {
                repeatedLessonsRepository.remove(lessonId)
                lessonRepository.create(
                    childId,
                    nameInput.text,
                    dateTime,
                    lessonTypeValue,
                    teacherId !== -1 ? teacherId : -1,
                    locationInput.text
                )
            } else {
                if (repeatTypeCombo.currentIndex < 0 || repeatTypeCombo.currentIndex >= repeatTypeCombo.model.count) {
                    console.log("Ошибка: неверный индекс типа повторения")
                    return
                }
                lessonRepository.remove(lessonId)
                var repeatType = repeatTypeCombo.model.get(repeatTypeCombo.currentIndex).value
                repeatedLessonsRepository.create(
                    childId,
                    nameInput.text,
                    dateTime,
                    lessonTypeValue,
                    repeatType,
                    teacherId !== -1 ? teacherId : -1,
                    locationInput.text
                )
            }
        } else {
            if (isRepeated) {
                if (repeatTypeCombo.currentIndex < 0 || repeatTypeCombo.currentIndex >= repeatTypeCombo.model.count) {
                    console.log("Ошибка: неверный индекс типа повторения")
                    return
                }
                var repeatType = repeatTypeCombo.model.get(repeatTypeCombo.currentIndex).value
                repeatedLessonsRepository.update(
                    lessonId,
                    childId,
                    nameInput.text,
                    dateTime,
                    lessonTypeValue,
                    repeatType,
                    teacherId !== -1 ? teacherId : -1,
                    locationInput.text
                )
            } else {
                lessonRepository.update(
                    lessonId,
                    childId,
                    nameInput.text,
                    dateTime,
                    lessonTypeValue,
                    teacherId !== -1 ? teacherId : -1,
                    locationInput.text
                )
            }
        }

        lessonDetails.lessonSaved()
        clearForm()
        lessonDetails.visible = false
    }

    function deleteLesson() {
        if (lessonId >= 0) {
            if (wasRepeated && repeatedLessonsRepository) {
                repeatedLessonsRepository.remove(lessonId)
            } else if (!wasRepeated && lessonRepository) {
                lessonRepository.remove(lessonId)
            }
            lessonDetails.lessonDeleted()
            clearForm()
            lessonDetails.visible = false
        }
    }

    function parseDateTime() {
        var timeParts = timeInput.text.split(":")
        var hour = parseInt(timeParts[0])
        var minute = parseInt(timeParts[1])

        var result = new Date(selectedDate)
        result.setHours(hour, minute, 0, 0)

        return result
    }

    function validateForm() {
        if (nameInput.text.trim() === "") {
            console.log("Название не может быть пустым")
            return false
        }

        if (timeInput.text.trim() === "") {
            console.log("Время не может быть пустым")
            return false
        }

        if (childCombo.currentIndex < 0) {
            console.log("Выберите ребенка")
            return false
        }

        return true
    }

    function clearForm() {
        lessonId = -1
        nameInput.text = ""
        lessonTypeValue = 0
        selectedDate = new Date()
        timeInput.text = ""
        childCombo.currentIndex = 0
        teacherCombo.currentIndex = 0
        locationInput.text = ""
        repeatCheckBox.checked = false
        isRepeated = false
        wasRepeated = false
        repeatTypeCombo.currentIndex = 0
    }

    function openForCreate(date) {
        mode = LessonDetails.Mode.Add
        clearForm()

        if (date) {
            selectedDate = date
            timeInput.text = "09:00"
        }

        loadChildren()
        loadTeachers()
        visible = true
    }

    function openForEdit(lesson) {
        mode = LessonDetails.Mode.Edit
        loadChildren()
        loadTeachers()
        loadLesson(lesson)
        visible = true
    }
}
