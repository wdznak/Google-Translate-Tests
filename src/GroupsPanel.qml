import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "./CustomQml"
import wd.qt.languagesmodel 1.0
import wd.qt.groupsmodel 1.0

Item {
    id: groupsPanelContainer

    property var languagesModel

    states: State {
        name: "groupsExists"
        when: languagesModel.rowCount() > 0
        PropertyChanges {
            target:          componentLoader
            sourceComponent: groupsComponent
        }
    }

    Loader {
        id: componentLoader

        anchors.fill: parent
        sourceComponent: noGroupsComponent
    }

    Component {
        id: noGroupsComponent
        Item {
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("You do not have any language added. Please add one in \"Languages\" tab")
            }
        }
    }

    Component {
        id: groupsComponent

        Item {
            property int activeLanguageId: -1
            property string activeLanguageTable

            //Holds a list of tests for specified language
            GroupsModel {
                id: groupsModel
                languageId: activeLanguageId
            }

            RowLayout {
                id: rowLayout

                spacing: 8
                anchors.rightMargin: 8
                anchors.leftMargin: 8
                anchors.bottomMargin: 8
                anchors.topMargin: 8
                anchors.fill: parent

                //First column with navigation for listview
                Column {
                    id: column
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 400
                    spacing: 8
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                    ComboBox {
                        id: comboBox

                        anchors.horizontalCenter: parent.horizontalCenter
                        Layout.preferredHeight: 40
                        currentIndex: 0
                        font.pixelSize: 14
                        textRole: "langA"

                        model: languagesModel
                        delegate: ItemDelegate {
                            font.pixelSize: 12
                            height: 32
                            width: parent.width
                            text: langA + "/" + langB
                            onClicked: {
                                activeLanguageId    = id
                                activeLanguageTable = tableName
                            }

                        }
                        Component.onCompleted: {
                            var firstRow = languagesModel.index(0,0)
                            activeLanguageId = groupsPanelContainer.languagesModel.data(firstRow, LanguagesModel.IdRole)
                            activeLanguageTable = groupsPanelContainer.languagesModel.data(firstRow, LanguagesModel.TableNameRole)
                        }
                    }

                    Button {
                        Layout.preferredHeight: 40
                        Layout.preferredWidth: 32
                        Material.background: "#ECECEC"
                        anchors.horizontalCenter: parent.horizontalCenter

                        text: qsTr("Create New")
                        onClicked: {
                            groupsModel.createNewGroup("Default")
                        }
                    }
                }

                //Second column with list of groups
                ListView {
                    id: groupsListView

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.margins: 8
                    spacing: 8
                    clip: true

                    model: groupsModel
                    delegate: Frame {
                        id: delegateContainer

                        Material.elevation: 3
                        width: parent.width
                        bottomPadding: 4
                        topPadding: 4
                        rightPadding: 8
                        leftPadding: 8

                        RowLayout {
                            id: delegateRow
                            width: groupsListView.width - 32
                            height: 32

                            ColumnLayout {
                                id: nameColumn

                                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                                Layout.preferredWidth: 140

                                Text {
                                    id: groupNameText

                                    color: "#a4a4a4"
                                    font.pixelSize: 16
                                    text: groupName
                                }

                                Label {
                                    id: groupNameLabel

                                    font.pointSize: 8
                                    text: qsTr("Group Name")
                                }
                            }

                            Item { Layout.fillWidth: true }

                            ColumnLayout {
                                id: pointsColumn

                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                Text {
                                    id: groupPointsText

                                    color: "#a4a4a4"
                                    font.pixelSize: 16
                                    text: points
                                }

                                Label {
                                    id: groupPointsLabel

                                    font.pointSize: 8
                                    text: qsTr("Points")
                                }
                            }

                            Item { Layout.fillWidth: true }

                            ColumnLayout{
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                Text {
                                    id: startTestTextBtn

                                    color: "#333333"
                                    text: qsTr("START")
                                    styleColor: "#000000"
                                    font.underline: false
                                    font.pixelSize: 14

                                    MouseArea {
                                        id: startTestMouseArea

                                        hoverEnabled: true
                                        anchors.fill: parent
                                        cursorShape:  Qt.PointingHandCursor
                                        onClicked: {
                                            editorPopup.groupData = {
                                                "groupDelegateIndex": index,
                                                "groupId":            id,
                                                "groupName":          groupName,
                                                "groupLevel":         level
                                            }
                                            editorPopup.open()
                                        }
                                    }

                                }
                            }

                            ColumnLayout {

                                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                                Text {
                                    id: updateTestTextBtn

                                    color: "#333333"
                                    text: qsTr("UPDATE")
                                    styleColor: "#000000"
                                    font.underline: false
                                    font.pixelSize: 14

                                    MouseArea {
                                        id: updateTestMouseArea

                                        hoverEnabled: true
                                        anchors.fill: parent
                                        cursorShape:  Qt.PointingHandCursor
                                        onClicked: {
                                            editorPopup.editMode = true
                                            editorPopup.groupData = {
                                                "groupDelegateIndex": index,
                                                "groupId":            id,
                                                "groupName":          groupName
                                            }
                                            editorPopup.open()
                                        }
                                    }

                                }
                            }
                        }
                        function changeName(newName) {
                            groupName = newName
                        }

                        function changeLevel(newLevel) {
                            if (newLevel > level)
                                level = newLevel
                        }

                        function changeScore(testScore) {
                            points += testScore
                        }
                    }
                }

                Connections {
                    target: editorLoader.item
                    onGroupNameChanged: {
                        groupsListView.currentIndex = groupData.groupDelegateIndex
                        groupsListView.currentItem.changeName(groupData.groupName)
                    }
                }

                Connections {
                    target: editorLoader.item
                    onDeleteGroup: {
                        groupsModel.deleteGroup(groupName)
                    }
                }

                Connections {
                    target: testLoader.item
                    onLevelCompleted: {
                        groupsListView.currentIndex = groupData.groupDelegateIndex
                        groupsListView.currentItem.changeLevel(groupData.groupLevel)
                        groupsListView.currentItem.changeScore(groupData.testScore)
                    }
                }
            }

            Popup {
                id: editorPopup

                property var groupData
                property bool editMode: false

                // for QtQuick.Controls >=  2.4 - parent: Overlay.overlay
                parent: windowContentStack
                x: 40
                y: 40
                width: mainwindow.width - 80
                height: mainwindow.height - 80

                modal: true
                focus: true
                closePolicy: Popup.CloseOnEscape
                onAboutToShow: {
                    if(editMode) {
                        editorLoader.setSource("GroupEditorPanel.qml",
                                               { "wordsModel.name": { "tableName": activeLanguageTable,
                                                       "select":    true },
                                                   "groupData": groupData })
                    } else {
                        testLoader.setSource("TestPanel.qml",
                                             { "wordsModel.name": { "tableName": activeLanguageTable,
                                                     "select": false },
                                                 "groupData": groupData })
                    }
                }
                onAboutToHide: {
                    if(editMode) {
                        editorLoader.source = ""
                    } else {
                        testLoader.source = ""
                    }
                }

                Loader {
                    id: editorLoader
                    anchors.fill: parent
                }

                Loader {
                    id: testLoader
                    anchors.fill: parent
                }

                Connections {
                    target: testLoader.item
                    onClose: editorPopup.close()
                }

                Connections {
                    target: editorLoader.item
                    onClose: {
                        editorPopup.close()
                        editorPopup.editMode = false
                    }
                }
            }
        }
    }
}
