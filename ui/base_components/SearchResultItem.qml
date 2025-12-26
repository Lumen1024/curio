import QtQuick
import QtQuick.Layouts
import curio

Rectangle {
    id: searchResultItem
    Colors { id: colors }
    Utils { id: utils }

    property var lesson: null
    property string childName: ""
    property bool isRepeated: false
    property int repeatType: 0

    signal clicked()

    implicitHeight: 32
    radius: width / 2
    border.width: 1
    border.color: colors.color_stroke

    color: {
        if (!lesson) return colors.color_card

        switch(lesson.type) {
            case 0: return colors.color_mind
            case 1: return colors.color_sport
            case 2: return colors.color_creative
            default: return colors.color_card
        }
    }

    // Эффект при наведении
    opacity: mouseArea.containsMouse ? 0.8 : 1.0

    Behavior on opacity {
        NumberAnimation { duration: 150 }
    }

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 8

        RowLayout {
            Layout.preferredWidth: 160
            Layout.minimumWidth: 160
            Layout.maximumWidth: 160
            spacing: 4

            Text {
                text: "↻"
                font.pixelSize: 14
                font.bold: true
                color: colors.color_text
                visible: isRepeated
            }

            Text {
                text: {
                    if (!lesson) return ""

                    if (isRepeated) {
                        var repeatText = ""
                        switch(repeatType) {
                            case 0: repeatText = "Ежедневно"; break
                            case 1: repeatText = "Еженедельно"; break
                            case 2: repeatText = "Ежемесячно"; break
                        }
                        return repeatText + " " + Qt.formatTime(lesson.dateTime, "hh:mm")
                    } else {
                        return Qt.formatDateTime(lesson.dateTime, "dd.MM hh:mm")
                    }
                }
                font.pixelSize: 14
                font.weight: Font.Light
                color: colors.color_text
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
            }
        }

        Text {
            text: lesson ? lesson.name : ""
            font.pixelSize: 14
            color: colors.color_text
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignLeft
            elide: Text.ElideRight
        }

        Text {
            text: searchResultItem.childName
            font.pixelSize: 14
            font.weight: Font.Light
            color: colors.color_text
            Layout.preferredWidth: childName !== "" ? 64 : 0
            Layout.minimumWidth: childName !== "" ? 64 : 0
            Layout.maximumWidth: childName !== "" ? 64 : 0
            horizontalAlignment: Text.AlignRight
            elide: Text.ElideRight
            visible: childName !== ""
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            searchResultItem.clicked()
        }
    }
}
