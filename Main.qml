import QtQuick
import curio

QtObject {
    property var authWindow: AuthWindow {
        visible: true

        onParentSelected: {
            authWindow.visible = false
            mainWindow.childId = -1  // Режим родителя
            mainWindow.visible = true
        }

        onChildSelected: {
            selectChildWindow.visible = true
        }
    }

    property var selectChildWindow: SelectChildWindow {
        childRepository: globalChildRepo

        onChildSelected: function(childId) {
            authWindow.visible = false
            selectChildWindow.visible = false
            mainWindow.childId = childId  // Режим ребенка
            mainWindow.visible = true
        }

        onCancelled: {
            selectChildWindow.visible = false
        }
    }

    property var mainWindow: MainWindow {
        visible: false

        onBackToAuth: {
            mainWindow.visible = false
            authWindow.visible = true
        }

        onOpenChildrenWindow: {
            childWindow.visible = true
        }

        onOpenTeachersWindow: {
            teacherWindow.visible = true
        }
    }

    property var childWindow: ChildWindow {
        visible: false
        childRepository: globalChildRepo
    }

    property var teacherWindow: TeacherWindow {
        visible: false
        teacherRepository: globalTeacherRepo
    }
}
