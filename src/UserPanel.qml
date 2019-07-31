import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import "./CustomQml"
import wd.qt.languagesmodel 1.0
import wd.qt.usersmodel 1.0

Item {
    id: userPanelContainer

    property alias languagesModel: languagesModel

    LanguagesModel {
        id: languagesModel
        userId: UserManager.id
    }

    ShadowRectangle {
        id: userPanel

        width: 600
        height: 400
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        TabBar {
            id: tabBar

            x: 0
            y: 0
            width: parent.width
            height: 24
            spacing: 2

            TabButton {
                id: testsButton

                height: 24
                text: qsTr("Tests")
                padding: 8
                font.pointSize: 10
            }

            TabButton {
                id: languagesButton

                height: 24
                text: qsTr("Languages")
                padding: 8
                font.pointSize: 10
            }

            TabButton {
                id: optionsButton

                height: 24
                text: qsTr("Options")
                padding: 8
                font.pointSize: 10
            }
        }

        StackLayout {
            id: stackLayout

            anchors.topMargin: 24
            anchors.fill: parent
            currentIndex: tabBar.currentIndex

            GroupsPanel {
                languagesModel: languagesModel
            }

            LanguagesPanel {
                languagesModel: languagesModel
            }

            Item {
                anchors.fill: parent
                anchors.margins: 8
                RowLayout {
                    width: parent.width

                    Text {
                        Layout.alignment: Qt.AlignLeft
                        text: qsTr("Delete account permanently")
                    }

                    Button {
                        Layout.alignment: Qt.AlignRight
                        Material.background: Material.Red
                        text: qsTr("Delete")
                        onClicked: {
                            UsersModel.deleteUser(UserManager.userName)
                            UserManager.logout()
                            windowContentStack.replace("Login.qml")
                        }
                    }
                }
            }
        }
    }
}
