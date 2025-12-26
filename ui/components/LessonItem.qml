import QtQuick
import QtQuick.Layouts
import curio

Rectangle {
    id: lessonItem
    Colors { id: colors }

    property var lesson: null
    property string childName: ""
    property string highlightKey: ""

    signal clicked()

    implicitHeight: 32
    radius: width / 2
    border.width: 1
    border.color: colors.color_stroke

    property bool isHighlighted: false
    property real glowOpacity: 0.0

    function highlight() {
        isHighlighted = true
        highlightTimer.restart()
    }

    Timer {
        id: highlightTimer
        interval: 2000
        onTriggered: {
            lessonItem.isHighlighted = false
        }
    }

    onHighlightKeyChanged: {
        if (highlightKey !== "" && lesson) {
            var lessonKey = lesson.id + "_" + (lesson.isRepeated || false) + "_" + lesson.dateTime.getTime()
            if (lessonKey === highlightKey) {
                highlight()
            }
        }
    }


    color: {
        if (!lesson) return colors.color_card

        switch(lesson.type) {
            case 0: return colors.color_mind
            case 1: return colors.color_sport
            case 2: return colors.color_creative
            default: return colors.color_card
        }
    }

    opacity: mouseArea.containsMouse ? 0.8 : 1.0
    scale: isHighlighted ? 1.05 : 1.0

    Behavior on opacity {
        NumberAnimation { duration: 150 }
    }

    Behavior on scale {
        NumberAnimation { duration: 300; easing.type: Easing.OutBack }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: -4
        radius: parent.radius
        color: "white"
        opacity: glowOpacity
        z: -1
    }

    SequentialAnimation on glowOpacity {
        running: isHighlighted
        loops: 3
        NumberAnimation { to: 0.6; duration: 300; easing.type: Easing.InOutQuad }
        NumberAnimation { to: 0.0; duration: 300; easing.type: Easing.InOutQuad }
    }

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 8

        Text {
            text: lesson ? Qt.formatTime(lesson.dateTime, "hh:mm") : ""
            font.pixelSize: 14
            font.weight: Font.Light
            color: colors.color_text
            Layout.preferredWidth: 40
            horizontalAlignment: Text.AlignLeft
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
            text: lessonItem.childName
            font.pixelSize: 14
            font.weight: Font.Light
            color: colors.color_text
            Layout.preferredWidth: 64
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
            lessonItem.clicked()
        }
    }
}
