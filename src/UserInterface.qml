import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id: toolBarContainer

    ToolBar {
        id: toolBar

        y: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        transformOrigin: Item.Center
        Material.primary: "White"

        RowLayout {
            id: toolBarRow

            anchors.rightMargin: 100
            anchors.leftMargin: 100
            anchors.fill: parent
            spacing: 1

            Item {
                id: userAvatarImg

                width: parent.height
                height: parent.height
                visible: false
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                Image {
                    id: avatarImg

                    property bool rounded: true
                    property bool adapt: true

                    width: parent.height * 0.75
                    height: parent.height * 0.75
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectCrop
                    source: "file:" + UserManager.avatar

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
                }
            }

            Label {
                id: userNickLabel

                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                visible: false
                text: UserManager.userName
                anchors.verticalCenter: parent.verticalCenter
            }


            Item {
                Layout.fillWidth: true
            }

            ToolButton {
                id: loginButton

                visible: false
                text: qsTr("Logout")
                onClicked: {
                    UserManager.logout()
                    windowContentStack.replace("Login.qml")
                }
            }

            states: [
                State {
                    name: "loggedIn"
                    when: UserManager.userName !== "none"
                    PropertyChanges { target: userAvatarImg; visible: true }
                    PropertyChanges { target: userNickLabel; visible: true }
                    PropertyChanges { target: loginButton;   visible: true }
                }
            ]
        }
    }
}
