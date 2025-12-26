cmake_minimum_required(VERSION 3.16)

project(curio VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Widgets)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appcurio
    main.cpp
    app_icon.rc
    # Data classes
    src/data/LessonType.h
    src/data/LessonType.cpp
    src/data/RepeatType.h
    src/data/RepeatType.cpp
    src/data/Teacher.h
    src/data/Teacher.cpp
    src/data/Lesson.h
    src/data/Lesson.cpp
    src/data/RepeatLesson.h
    src/data/RepeatLesson.cpp
    src/data/Child.h
    src/data/Child.cpp
    # Repositories
    src/repository/ChildRepository.h
    src/repository/ChildRepository.cpp
    src/repository/TeacherRepository.h
    src/repository/TeacherRepository.cpp
    src/repository/LessonRepository.h
    src/repository/LessonRepository.cpp
    src/repository/RepeatLessonRepository.h
    src/repository/RepeatLessonRepository.cpp
    # Storage
    src/storage/StorageManager.h
    src/storage/StorageManager.cpp
    # Export
    src/export/ExportManager.h
    src/export/ExportManager.cpp
)

qt_add_qml_module(appcurio
    URI curio
    QML_FILES
        Main.qml
        ui/Colors.qml
        ui/Utils.qml
        ui/base_components/IconButton.qml
        ui/base_components/TextButton.qml
        ui/base_components/SearchBar.qml
        ui/base_components/SearchResultItem.qml
        ui/base_components/SelectButton.qml
        ui/base_components/MenuButton.qml
        ui/base_components/CalendarButton.qml
        ui/base_components/TextInput.qml
        ui/base_components/NamedIconButton.qml
        ui/base_components/CustomPopup.qml
        ui/base_components/CustomCheckBox.qml
        ui/base_components/SelectField.qml
        ui/components/LessonItem.qml
        ui/components/DayItem.qml
        ui/components/WeekItem.qml
        ui/components/LessonDetails.qml
        ui/components/ChildLessonDetails.qml
        ui/window/AuthWindow.qml
        ui/window/MainWindow.qml
        ui/window/SelectChildWindow.qml
        ui/window/TeacherWindow.qml
        ui/window/ChildWindow.qml
        ui/window/SettingsWindow.qml
    RESOURCES
        res/ic_search.svg
        res/ic_calendar.svg
        res/ic_left.svg
        res/ic_right.svg
        res/ic_add.svg
        res/ic_child.svg
        res/ic_export.svg
        res/ic_face.svg
        res/ic_settings.svg
        res/ic_filter.svg
        res/ic_delete.svg
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appcurio PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appcurio
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appcurio
    PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Widgets
)

include(GNUInstallDirs)
install(TARGETS appcurio
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
