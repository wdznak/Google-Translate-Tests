import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import wd.qt.userwordsmodel 1.0
import wd.qt.groupsmodel 1.0
import wd.qt.groupwordsmodel 1.0

Item {
    id: panelContainer

    property var groupData
    property int mediumFontSize:  12
    property var wordsModel:      UserWordsModel {}
    property var groupWordsModel: GroupWordsModel { groupId: groupData.groupId }
    property var groupWordsIds:   []

    signal groupNameChanged(var groupData)
    signal deleteGroup(string groupName)
    signal close()

    anchors.fill: parent

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent

        RowLayout {
            id: rowPanel

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.leftMargin: 8
            Layout.rightMargin: 8

            TextField {
                id: groupNameTextField

                text: groupData.groupName
                onAccepted: {
                    panelContainer.groupData.groupName = text
                    panelContainer.groupNameChanged(panelContainer.groupData)
                    focus = false
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                id: deleteGroupButton

                Layout.preferredHeight: 40
                Material.foreground: Material.Pink
                Material.background: "#ECECEC"
                text: qsTr("Delete")
                onClicked: {
                    panelContainer.deleteGroup(groupData.groupName)
                    panelContainer.close()
                }
            }

            Button {
                id: closeGroupButton

                Layout.preferredHeight: 40
                Layout.preferredWidth: 32
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                Material.background: "#ECECEC"
                text: qsTr("X")
                onClicked: {
                    panelContainer.close()
                }
            }
        }

        RowLayout {
            id: rowLists

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 8

            ListView {
                id: listView

                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                model: wordsModel
                delegate: Rectangle {
                    id: delegateItem

                    width: parent.width
                    height: 32
                    color: "transparent"
                    Component.onCompleted: {
                        if (isInArray(index, groupWordsIds)) {
                            delegateItem.state = "disabled"
                        }
                    }

                    RowLayout {
                        width: parent.width
                        height: parent.height
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

                        Item {
                            Layout.preferredWidth: 24
                            Layout.fillHeight: true
                            Layout.margins: 6
                            Text {
                                id: rightArrowText
                                font.pixelSize: 16
                                text: ">"
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: listView.currentIndex = index
                        onClicked: delegateItem.toggle()
                    }

                    Behavior on x {
                        SpringAnimation {
                            id: addAnimation
                            spring: 4
                            damping: 0.15
                        }
                    }

                    states: State {
                        name: "disabled"
                        PropertyChanges {
                            target: delegateItem
                            enabled: false
                            color: "#F5F5F5"
                            x: 6
                        }
                        PropertyChanges {
                            target: rightArrowText
                            text: ""
                        }
                    }

                    function toggle() {
                        if (enabled === false) {
                            delegateItem.state = ""
                            removeItem(index, groupWordsIds)
                            groupWordsModel.removeWordId(id)
                            return
                        }
                        groupWordsIds.push(index)
                        groupWordsModel.addWordId(id)
                        listView1.model.append({"itemIndex": index, "word": word, "translation": translation})
                        delegateItem.state = "disabled"
                    }
                }
                highlight: Component {

                    Rectangle {
                        width: parent.width
                        height: 32
                        color: "#ECECEC"
                        y: listView.currentItem.y

                        Behavior on y {
                            SpringAnimation {
                                spring: 3
                                damping: 0.2
                            }
                        }
                    }
                }

                function enableItem(itemIndex) {
                    currentIndex = itemIndex
                    currentItem.toggle()
                }

                Component.onCompleted: {
                    var wordId, wordIndex
                    for (var i = 0; i < groupWordsModel.rowCount(); ++i) {
                        wordId = groupWordsModel.data(groupWordsModel.index(i, 0), GroupWordsModel.WordIdRole)
                        wordIndex = wordsModel.idRow(wordId)
                        if (wordIndex > -1) {
                            listView.currentIndex = wordIndex
                            listView.currentItem.toggle()
                        }
                    }
                    listView.currentIndex = 0
                }
            }

            Item {
                Layout.preferredWidth: 16
                Layout.fillHeight: true

                Rectangle {
                    id: separator

                    width: 1
                    height: parent.height
                    color: "#EEEEEE"
                }
            }

            ListView {
                id: listView1
                clip: true

                Layout.fillWidth: true
                Layout.fillHeight: true

                model: ListModel {}
                delegate: Rectangle {
                    id: delegateContainer

                    width: parent.width
                    height: 32
                    color: "transparent"

                    RowLayout {
                        width: parent.width
                        height: parent.height

                        Item {
                            Layout.preferredWidth: 24
                            Layout.fillHeight: true
                            Layout.margins: 6
                            Text {
                                font.pixelSize: 16
                                text: "<"
                            }
                        }

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

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: listView1.currentIndex = index

                        onClicked: {
                            listView.enableItem(itemIndex)
                            listView1.model.remove(index, 1)
                        }
                    }

                    Behavior on x {
                        SpringAnimation {
                            id: removeAnimation
                            spring: 4
                            damping: 0.15
                        }
                    }
                }
                highlight: Component {

                    Rectangle {
                        width: parent.width
                        height: 32
                        color: "#ECECEC"
                        y: listView1.currentItem.y

                        Behavior on y {
                            SpringAnimation {
                                spring: 3
                                damping: 0.2
                            }
                        }
                    }
                }
            }
        }

    }
    function isInArray(value, array) {
        return array.indexOf(value) > -1
    }
    function removeItem(value, array) {
        var index = array.indexOf(value)
        if (index !== -1) {
            array.splice(index, 1)
        }

    }
}
