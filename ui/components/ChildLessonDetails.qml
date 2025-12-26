import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import curio

Window {
    id: childLessonDetails
    width: 500
    height: 500
    visible: false
    title: qsTr("Информация об уроке")
    modality: Qt.ApplicationModal

    property var teacherRepository: null

    Colors { id: colors }

    property var lesson: null
    property string teacherName: ""
    property string teacherPhone: ""

    signal closed()

    Rectangle {
        anchors.fill: parent
        color: colors.color_bg

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Text {
                text: "Информация об уроке"
                font.pixelSize: 24
                font.bold: true
                color: colors.color_text
                Layout.alignment: Qt.AlignHCenter
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                ColumnLayout {
                    width: childLessonDetails.width - 40
                    spacing: 20

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Название:"
                            font.pixelSize: 14
                            font.bold: true
                            color: colors.color_text
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 40
                            radius: 4
                            color: colors.color_card
                            border.width: 1
                            border.color: colors.color_stroke

                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                verticalAlignment: Text.AlignVCenter
                                text: lesson ? lesson.name : ""
                                font.pixelSize: 14
                                color: colors.color_text
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Время:"
                            font.pixelSize: 14
                            font.bold: true
                            color: colors.color_text
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 40
                            radius: 4
                            color: colors.color_card
                            border.width: 1
                            border.color: colors.color_stroke

                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                verticalAlignment: Text.AlignVCenter
                                text: lesson ? Qt.formatTime(new Date(lesson.dateTime), "hh:mm") : ""
                                font.pixelSize: 14
                                color: colors.color_text
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Место:"
                            font.pixelSize: 14
                            font.bold: true
                            color: colors.color_text
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 40
                            radius: 4
                            color: colors.color_card
                            border.width: 1
                            border.color: colors.color_stroke

                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                verticalAlignment: Text.AlignVCenter
                                text: lesson && lesson.location ? lesson.location : "Не указано"
                                font.pixelSize: 14
                                color: lesson && lesson.location ? colors.color_text : colors.color_text_2
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Преподаватель:"
                            font.pixelSize: 14
                            font.bold: true
                            color: colors.color_text
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 40
                            radius: 4
                            color: colors.color_card
                            border.width: 1
                            border.color: colors.color_stroke

                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                verticalAlignment: Text.AlignVCenter
                                text: teacherName !== "" ? teacherName : "Не указан"
                                font.pixelSize: 14
                                color: teacherName !== "" ? colors.color_text : colors.color_text_2
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Телефон преподавателя:"
                            font.pixelSize: 14
                            font.bold: true
                            color: colors.color_text
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 40
                            radius: 4
                            color: colors.color_card
                            border.width: 1
                            border.color: colors.color_stroke

                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                verticalAlignment: Text.AlignVCenter
                                text: teacherPhone !== "" ? teacherPhone : "Не указан"
                                font.pixelSize: 14
                                color: teacherPhone !== "" ? colors.color_text : colors.color_text_2
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight

                TextButton {
                    text: "Закрыть"
                    backgroundColor: colors.color_card
                    width: 180
                    height: 40
                    onClicked: {
                        childLessonDetails.closed()
                        childLessonDetails.visible = false
                    }
                }
            }
        }
    }

    function openWithLesson(lessonData) {
        lesson = lessonData
        loadTeacherInfo()
        visible = true
    }

    function loadTeacherInfo() {
        teacherName = ""
        teacherPhone = ""

        if (lesson && lesson.teacherId && lesson.teacherId !== -1 && teacherRepository) {
            var teacher = teacherRepository.getById(lesson.teacherId)
            if (teacher) {
                teacherName = teacher.fullName
                teacherPhone = teacher.phone
            }
        }
    }
}
