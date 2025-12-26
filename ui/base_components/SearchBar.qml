import QtQuick
import QtQuick.Controls
import curio

Item {
    id: root

    Colors { id: colors }

    property alias text: textInput.text
    property alias placeholderText: textInput.placeholderText

    property var searchResults: []

    signal resultClicked(int index)

    implicitHeight: 32

    onResultClicked: {
        resultsPanel.close()
    }

    Rectangle {
        id: control
        anchors.fill: parent
        radius: width / 2
        border.width: 1
        border.color: colors.color_stroke
        z: 2

        Row {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 8

            Image {
                id: searchIcon
                source: "qrc:/qt/qml/curio/res/ic_search.svg"
                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
            }

            TextField {
                id: textInput
                width: parent.width - searchIcon.width - parent.spacing
                height: parent.height
                verticalAlignment: TextInput.AlignVCenter
                color: colors.color_text
                font.pixelSize: 14
                background: null
                leftPadding: 0
                rightPadding: 0
                placeholderText: "Поиск..."

                onActiveFocusChanged: {
                    if (activeFocus && searchResults.length > 0) {
                        resultsPanel.open()
                    } else if (!activeFocus) {
                        closeTimer.start()
                    }
                }

                onTextChanged: {
                    if (activeFocus && searchResults.length > 0) {
                        resultsPanel.open()
                    }
                }
            }
        }
    }

    CustomPopup {
        id: resultsPanel
        x: 0
        y: control.height + 8
        width: root.width
        height: Math.min(searchResults.length * 36 + 16, 400)
        padding: 8

        contentItem: Item {
            implicitWidth: resultsPanel.width - 8
            implicitHeight: resultsPanel.height - 8

            ScrollView {
                anchors.fill: parent
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                Column {
                    spacing: 4
                    width: parent.parent.width

                    Repeater {
                        model: root.searchResults

                        SearchResultItem {
                            width: parent.width
                            lesson: modelData.lesson
                            childName: modelData.childName
                            isRepeated: modelData.isRepeated || false
                            repeatType: modelData.repeatType || 0

                            onClicked: {
                                root.resultClicked(index)
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: closeTimer
        interval: 200
        onTriggered: resultsPanel.close()
    }
}
