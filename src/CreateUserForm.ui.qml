import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import wd.qt.importdata 1.0
import wd.qt.usersmodel 1.0
import "./CustomQml"

Item {
    id: item1
    property alias avatarImgArea: avatarImgArea
    property alias avatarImg: avatarImg
    property alias userNameInput: userNameInput
    property alias acceptButton: acceptButton
    property alias importBtnArea: importBtnArea
    property alias importBtnTxt: importBtnTxt
    property alias fileInfoPanel: fileInfoPanel
    property alias langText: langText
    property alias wordText: wordText
    property alias wordListView: wordListView
    property ImportData importData: ImportData {
    }
    property UsersModel usersModel: UsersModel
    property bool isListValid: false
    property bool isUserNameValid: false
    property alias validityNameText: validityNameText

    Item {
        id: uiCard

        x: 150
        y: 160
        width: 340
        height: 232
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Pane {
            id: uiCardBg

            x: 0
            y: 0
            width: 340
            height: 160
            Material.elevation: 6
            padding: 0

            Image {
                id: avatarImg

                property bool rounded: true
                property bool adapt: true

                width: 64
                height: 64
                anchors.left: parent.left
                anchors.leftMargin: 24
                anchors.top: parent.top
                anchors.topMargin: 24
                fillMode: Image.PreserveAspectCrop
                source: "qrc:///Graphics/horse.jpg"

                layer.enabled: rounded
                layer.effect: OpacityMask {
                    maskSource: Item {
                        width: avatarImg.width
                        height: avatarImg.height

                        Rectangle {
                            anchors.centerIn: parent
                            width: avatarImg.adapt ? avatarImg.width : Math.min(
                                                         avatarImg.width,
                                                         avatarImg.height)
                            height: avatarImg.adapt ? avatarImg.height : width
                            radius: Math.min(width, height)
                        }
                    }
                }

                MouseArea {
                    id: avatarImgArea

                    x: 0
                    y: 0
                    width: 64
                    height: 64
                    cursorShape: Qt.PointingHandCursor
                }
            }

            TextInput {
                id: userNameInput

                x: 105
                y: 56
                width: 131
                height: 32
                color: "#a4a4a4"
                text: qsTr("Your Name")
                echoMode: TextInput.Normal
                selectByMouse: true
                font.weight: Font.Light
                renderType: Text.QtRendering
                clip: false
                leftPadding: -1
                autoScroll: false
                font.pixelSize: 24
                maximumLength: 12
                validator: RegExpValidator {
                    regExp: /^[\w][\w ]{4,}/
                }
            }

            Text {
                id: importBtnTxt

                x: 270
                y: 126
                color: "#333333"
                text: qsTr("IMPORT")
                styleColor: "#000000"
                font.underline: false
                verticalAlignment: Text.AlignTop
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                anchors.right: parent.right
                anchors.rightMargin: 24
                font.pixelSize: 14

                MouseArea {
                    id: importBtnArea

                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                }
            }

            Item {
                id: fileInfoPanel

                y: 115
                width: 212
                height: 37
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 24
                visible: false
                clip: false

                Label {
                    id: langLabel

                    x: 0
                    y: 20
                    width: 54
                    height: 13
                    text: qsTr("Languages")
                    font.pointSize: 8
                }

                Text {
                    id: langText

                    x: 0
                    y: 0
                    width: 48
                    height: 20
                    color: "#a4a4a4"
                    font.pixelSize: 16
                    text: wordListView.listView.model ? wordListView.listView.model.wordOrigin + "/" + wordListView.listView.model.translationOrigin : ""
                }

                Label {
                    id: wordLabel

                    x: 157
                    y: 20
                    text: qsTr("Words")
                    font.pointSize: 8
                }

                Text {
                    id: wordText

                    x: 157
                    y: 0
                    width: 55
                    height: 20
                    color: "#a4a4a4"
                    text: wordListView.listView.count
                    font.pixelSize: 16
                }
            }

            Text {
                id: validityNameText

                x: 242
                y: 76
                color: "#f51c1c"
                text: qsTr("Invalid name")
                visible: false
                verticalAlignment: Text.AlignTop
                font.pixelSize: 10
            }
        }

        RoundButton {
            id: acceptButton

            text: "\u2713"
            enabled: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
        }

        WordListModel {
            id: wordListView

            x: 0
            y: 226
            width: 340
            height: 160
        }
    }
}
