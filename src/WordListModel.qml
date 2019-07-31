import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "./CustomQml"

Item {
    property alias listView: listView
    property int mediumFontSize: 12
    property var markedElements: []
    property bool menuEnabled: false

    Pane {
        id: rectangle

        Material.elevation: 6
        anchors.fill: parent
        padding: 0

        ListView {
            id: listView

            anchors.fill: parent
            headerPositioning: ListView.OverlayHeader
            clip: true
            spacing: 1
            header: RowLayout {
                width: parent.width
                height: 26
                Layout.rowSpan: 5
                spacing: 0
                z: 2

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#FFFFFF"

                    Text {
                        anchors.centerIn: parent
                        color: "#333333"
                        font.weight: Font.Light
                        text: !listView.model ? "" : listView.model.wordOrigin.toUpperCase()
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#FFFFFF"

                    Text {
                        color: "#333333"
                        font.weight: Font.Light
                        anchors.centerIn: parent
                        text: !listView.model ? "" : listView.model.translationOrigin.toUpperCase()
                    }
                }

                MouseArea {
                    id: moreBtn

                    width: 26
                    Layout.fillHeight: true
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "white"

                        Image {
                            id: moreBtnImg

                            anchors.centerIn: parent
                            source: "qrc:///Graphics/ic_more_vert_black_24px.svg"
                            sourceSize: Qt.size(parent.height - 4, parent.height - 4)
                            smooth: true
                            visible: false
                        }

                        ColorOverlay {
                            id: moreBtnOverlay

                            anchors.fill: moreBtnImg
                            source: moreBtnImg
                            color: "#333333"
                        }
                    }

                    Menu {
                        id: menu
                        width: 100

                        MenuItem {
                            id: control

                            font.pixelSize: 10
                            height: 22
                            onTriggered: unmark()
                            enabled: menuEnabled
                            contentItem: Text {
                                      text: qsTr("uncheck")
                                      font: control.font
                                      opacity: enabled ? 1.0 : 0.3
                                      color: control.down ? "#17a81a" : "#21be2b"
                                      horizontalAlignment: Text.AlignHCenter
                                      verticalAlignment: Text.AlignVCenter
                                      elide: Text.ElideRight
                                  }
                        }

                        MenuItem {
                            id: control2

                            font.pixelSize: 10
                            height: 22
                            onTriggered: {
                                listView.model.removeRows(markedElements)
                                clearMarkedElements()
                            }
                            enabled: menuEnabled
                            contentItem: Text {
                                      text: "delete"
                                      font: control.font
                                      opacity: enabled ? 1.0 : 0.3
                                      color: control2.down ? "#17a81a" : "#21be2b"
                                      horizontalAlignment: Text.AlignHCenter
                                      verticalAlignment: Text.AlignVCenter
                                      elide: Text.ElideRight
                                  }
                        }
                    }

                    onClicked: {
                        menu.open()
                    }

                    onEntered: state = "hoover"

                    onExited: state = ""

                    states: State {
                        name: "hoover"
                        PropertyChanges { target: moreBtnOverlay; color: "black"}
                    }
                }
            }
            model: model
            delegate: rowDelegate
        }

        Component {
            id: rowDelegate

            CheckDelegate {
                id: control

                width: parent.width
                height: 24
                indicator: Rectangle {
                    width: parent.width
                    height: parent.height
                    color: control.checked ? "white" : "transparent"
                }

                RowLayout {
                    width: parent.width
                    height: parent.height
                    spacing: 2

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 6

                        Text {
                            font.pixelSize: mediumFontSize
                            elide: Text.ElideRight
                            text: word
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 6

                        Text {
                            font.pixelSize: mediumFontSize
                            elide: Text.ElideRight
                            text: translation
                        }
                    }
                }

                onClicked: {
                    if(checked){
                        markedElements.push(index)
                    }else{
                        var el = markedElements.indexOf(index)
                        if (el != -1) {
                            markedElements.splice(el,1)
                        }
                    }
                    menuEnabled = markedElements.length
                }
            }
        }
    }

    function unmark(){
        for(var i = 0; i < markedElements.length; ++i) {
            listView.currentIndex = markedElements[i]
            listView.currentItem.toggle()
        }
        clearMarkedElements()
    }

    function clearMarkedElements() {
        markedElements = []
        menuEnabled = false
    }
}
