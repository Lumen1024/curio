import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import curio

Window {
    id: mainWindow
    width: 1100
    height: 700
    minimumWidth: 1000
    minimumHeight: 400
    maximumWidth: 1400
    visible: false
    title: qsTr("Curio - Главная")
    flags: Qt.Window | Qt.WindowTitleHint | Qt.WindowSystemMenuHint | Qt.WindowMinimizeButtonHint | Qt.WindowMaximizeButtonHint | Qt.WindowCloseButtonHint

    Colors { id: colors }
    Utils { id: utils }

    signal backToAuth()
    signal openChildrenWindow()
    signal openTeachersWindow()

    Connections {
        target: globalLessonRepo
        function onDataChanged() {
            loadLessons()
        }
    }

    Connections {
        target: globalRepeatLessonRepo
        function onDataChanged() {
            loadLessons()
        }
    }

    Connections {
        target: globalChildRepo
        function onDataChanged() {
            loadLessons()
        }
    }

    property int childId: -1  // -1 родитель
    property date currentWeekStart: utils.getMondayOfWeek(new Date())
    property string selectedLessonType: ""  // Выбранный тип урока для фильтрации
    property string highlightLessonKey: ""  // Ключ для подсветки урока

    onCurrentWeekStartChanged: {
        unionLessons()
    }

    
    property var lessons: []
    property var repeatLessons: []

    property var filteredLessons: []
    property var filteredRepeatedLessons: []

    property var weekLessons: []

    function filterLessons() {
        if (selectedLessonType === "") {
            filteredLessons = lessons
            filteredRepeatedLessons = repeatLessons
        } else {
            var typeValue = utils.getLessonTypeValue(selectedLessonType)

            filteredLessons = lessons.filter(function(lesson) {
                return lesson.type === typeValue
            })

            filteredRepeatedLessons = repeatLessons.filter(function(repeatLesson) {
                return repeatLesson.type === typeValue
            })
        }

        unionLessons()
    }

    function unionLessons() {
        var result = []

        var weekEnd = new Date(currentWeekStart)
        weekEnd.setDate(weekEnd.getDate() + 7)

        for (var i = 0; i < filteredLessons.length; i++) {
            var lesson = filteredLessons[i]
            if (lesson.dateTime >= currentWeekStart && lesson.dateTime < weekEnd) {
                var child = (childId === -1 && lesson.childId !== -1)
                    ? globalChildRepo.getById(lesson.childId)
                    : null
                var childName = child ? child.fullName : ""

                var normalLesson = {
                    id: lesson.id,
                    childId: lesson.childId,
                    teacherId: lesson.teacherId,
                    name: lesson.name,
                    location: lesson.location,
                    type: lesson.type,
                    dateTime: lesson.dateTime,
                    isRepeated: false,
                    childName: childName
                }
                result.push(normalLesson)
            }
        }

        for (var j = 0; j < filteredRepeatedLessons.length; j++) {
            var repeatLesson = filteredRepeatedLessons[j]

            for (var day = 0; day < 7; day++) {
                var checkDate = new Date(currentWeekStart)
                checkDate.setDate(checkDate.getDate() + day)

                if (utils.isDateInRepeat(repeatLesson.dateTime, checkDate, repeatLesson.repeatType)) {
                    var lessonDateTime = new Date(
                        checkDate.getFullYear(),
                        checkDate.getMonth(),
                        checkDate.getDate(),
                        repeatLesson.dateTime.getHours(),
                        repeatLesson.dateTime.getMinutes()
                    )

                    var child2 = (childId === -1 && repeatLesson.childId !== -1)
                        ? globalChildRepo.getById(repeatLesson.childId)
                        : null
                    var childName2 = child2 ? child2.fullName : ""

                    var generatedLesson = {
                        id: repeatLesson.id,
                        childId: repeatLesson.childId,
                        teacherId: repeatLesson.teacherId,
                        name: repeatLesson.name,
                        location: repeatLesson.location,
                        type: repeatLesson.type,
                        dateTime: lessonDateTime,
                        isRepeated: true,
                        repeatType: repeatLesson.repeatType,
                        childName: childName2
                    }
                    result.push(generatedLesson)
                }
            }
        }

        weekLessons = result
    }
    

    function searchLessons(query) {
        if (query.trim() === "") {
            searchBar.searchResults = []
            return
        }
        var searchQuery = query.toLowerCase()

        var results = []

        for (var i = 0; i < lessons.length; i++) {
            var lesson = lessons[i]
            var teacher = (lesson.teacherId != -1) ? globalTeacherRepo.getById(lesson.teacherId) : null
            var child = (childId === -1 && lesson.childId !== -1)
                ? globalChildRepo.getById(lesson.childId)
                : null
            var childName = child ? child.fullName : ""

            var nameMatch = (lesson.name.toLowerCase().indexOf(searchQuery) !== -1)
            var teacherMatch = (teacher && teacher.fullName.toLowerCase().indexOf(searchQuery) !== -1)
            var locationMatch = (lesson.location.toLowerCase().indexOf(searchQuery) !== -1)
            var childMatch = (childId === -1 && childName && childName.toLowerCase().indexOf(searchQuery) !== -1)

            if (nameMatch || teacherMatch || locationMatch || childMatch) {
                results.push({
                    lesson: lesson,
                    childName: childName,
                    isRepeated: false
                })
            }
        }

        for (var j = 0; j < repeatLessons.length; j++) {
            var repeatLesson = repeatLessons[j]
            var teacher2 = (repeatLesson.teacherId != -1) ? globalTeacherRepo.getById(repeatLesson.teacherId) : null
            var child2 = (childId === -1 && repeatLesson.childId !== -1)
                ? globalChildRepo.getById(repeatLesson.childId)
                : null
            var childName2 = child2 ? child2.fullName : ""

            var nameMatch2 = (repeatLesson.name.toLowerCase().indexOf(searchQuery) !== -1)
            var teacherMatch2 = (teacher2 && teacher2.fullName.toLowerCase().indexOf(searchQuery) !== -1)
            var locationMatch2 = (repeatLesson.location.toLowerCase().indexOf(searchQuery) !== -1)
            var childMatch2 = (childId === -1 && childName2 && childName2.toLowerCase().indexOf(searchQuery) !== -1)

            if (nameMatch2 || teacherMatch2 || locationMatch2 || childMatch2) {
                results.push({
                    lesson: repeatLesson,
                    childName: childName2,
                    isRepeated: true,
                    repeatType: repeatLesson.repeatType
                })
            }
        }

        searchBar.searchResults = results
    }

    function loadLessons() {
        lessons = childId === -1
            ? globalLessonRepo.getAll()
            : globalLessonRepo.getByChildId(childId)

        repeatLessons = childId === -1
            ? globalRepeatLessonRepo.getAll()
            : globalRepeatLessonRepo.getByChildId(childId)

        filterLessons()
    }

    onVisibleChanged: {
        if (visible) {
            loadLessons()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: colors.color_bg

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                IconButton {
                    iconSource: "qrc:/qt/qml/curio/res/ic_left.svg"
                    backgroundColor: colors.color_card
                    onClicked: {
                        mainWindow.backToAuth()
                    }
                }

                Text {
                    text: utils.getMonthName(currentWeekStart)
                    font.pixelSize: 24
                    color: colors.color_text_1
                }

                SearchBar {
                    id: searchBar
                    Layout.fillWidth: true
                    placeholderText: "Поиск уроков..."
                    onTextChanged: {
                        searchLessons(text)
                    }
                    onResultClicked: function(index) {
                        if (index >= 0 && index < searchBar.searchResults.length) {
                            var resultItem = searchBar.searchResults[index]
                            var lesson = resultItem.lesson

                            var lessonKey = lesson.id + "_" + resultItem.isRepeated + "_" + lesson.dateTime.getTime()

                            currentWeekStart = utils.getMondayOfWeek(lesson.dateTime)

                            highlightTimer.lessonKey = lessonKey
                            highlightTimer.restart()

                            searchBar.focus = false

                            searchBar.text = ""
                            searchBar.searchResults = []
                        }
                    }
                }

                SelectButton {
                    id: filterButton
                    iconSource: "qrc:/qt/qml/curio/res/ic_filter.svg"
                    options: [
                        { name: "Умственное", color: colors.color_mind },
                        { name: "Спортивное", color: colors.color_sport },
                        { name: "Творческое", color: colors.color_creative }
                    ]
                    onOptionSelected: function(value) {
                        selectedLessonType = value
                        filterLessons()
                    }
                }

                CalendarButton {
                    id: calendarButton

                    isDaySelected: function(date) {
                        for (var i = 0; i < filteredLessons.length; i++) {
                            var lesson = filteredLessons[i]
                            if (utils.isSameDay(lesson.dateTime, date)) {
                                return true
                            }
                        }

                        for (var j = 0; j < filteredRepeatedLessons.length; j++) {
                            var repeatLesson = filteredRepeatedLessons[j]
                            if (utils.isDateInRepeat(repeatLesson.dateTime, date, repeatLesson.repeatType)) {
                                return true
                            }
                        }

                        return false
                    }

                    onDayClicked: function(date) {
                        console.log("Выбрана дата:", date)
                        currentWeekStart = utils.getMondayOfWeek(date)
                    }
                }

                NamedIconButton {
                    iconSource: "qrc:/qt/qml/curio/res/ic_child.svg"
                    text: "Дети"
                    visible: childId === -1
                    onClicked: {
                        mainWindow.openChildrenWindow()
                    }
                }

                NamedIconButton {
                    iconSource: "qrc:/qt/qml/curio/res/ic_face.svg"
                    text: "Учителя"
                    visible: childId === -1
                    onClicked: {
                        mainWindow.openTeachersWindow()
                    }
                }

                MenuButton {
                    iconSource: "qrc:/qt/qml/curio/res/ic_export.svg"
                    menuItems: ["Экспорт Json", "Импорт Json"]
                    visible: childId === -1
                    onItemSelected: function(value) {
                        if (value === "Экспорт Json") {
                            globalExportManager.exportToJson()
                        } else if (value === "Импорт Json") {
                            globalExportManager.importFromJson()
                        }
                    }
                }

                IconButton {
                    iconSource: "qrc:/qt/qml/curio/res/ic_settings.svg"
                    backgroundColor: colors.color_card
                    visible: childId === -1
                    onClicked: {
                        settingsWindow.visible = true
                    }
                }
            }

            WeekItem {
                id: weekItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                startDate: currentWeekStart
                lessons: weekLessons
                childMode: childId != -1
                highlightKey: highlightLessonKey

                onAddLessonClicked: function(selectedDate) {
                    lessonDetails.openForCreate(selectedDate)
                }

                onLessonClicked: function(lesson) {
                    if (childId === -1) {
                        lessonDetails.openForEdit(lesson)
                    } else {
                        childLessonDetails.openWithLesson(lesson)
                    }
                }
            }
        }

        Timer {
            id: highlightTimer
            interval: 100
            property string lessonKey: ""
            onTriggered: {
                highlightLessonKey = lessonKey
                resetTimer.restart()
            }
        }

        Timer {
            id: resetTimer
            interval: 2500
            onTriggered: {
                highlightLessonKey = ""
            }
        }
    }

    LessonDetails {
        id: lessonDetails
        childRepository: globalChildRepo
        teacherRepository: globalTeacherRepo
        lessonRepository: globalLessonRepo
        repeatedLessonsRepository: globalRepeatLessonRepo
    }

    ChildLessonDetails {
        id: childLessonDetails
        teacherRepository: globalTeacherRepo
    }

    SettingsWindow {
        id: settingsWindow
    }
}
