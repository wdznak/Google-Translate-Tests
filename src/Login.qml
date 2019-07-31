import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import "./CustomQml"
import wd.qt.usersmodel 1.0

Item {
    id: item1

    Item {
        id: frame

        width: 340
        height: 250
        anchors.fill: parent

        Pane {
            id: background

            Material.elevation: 6
            width: 340
            height: 200
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            ListView {
                id: listView

                width: parent.width
                height: parent.height
                clip: true
                highlightFollowsCurrentItem: false
                focus: true

                highlight: Component {
                    id: highlight

                    Rectangle {
                        width: parent.width; height: 40
                        color: "#EEEEEE";
                        y: listView.currentItem.y

                        Behavior on y {
                            SpringAnimation {
                                spring: 3
                                damping: 0.2
                            }
                        }
                    }
                }
                model: UsersModel

                delegate: MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    width: parent.width
                    height: 40
                    onClicked: {
                        UserManager.setUser(model.name)
                        windowContentStack.replace("UserPanel.qml")
                    }

                    onEntered: listView.currentIndex = index
                    hoverEnabled: true

                    Rectangle {
                        width: parent.width
                        height: parent.height
                        anchors.centerIn: parent
                        color: "transparent"

                        Row {
                            width: parent.width
                            height: parent.height
                            padding: 4
                            spacing: 2

                            Item {
                                height: 40
                                width: 40
                                anchors.verticalCenter: parent.verticalCenter

                                Image {
                                    id: avatarImg

                                    property bool rounded: true
                                    property bool adapt: true

                                    anchors.centerIn: parent
                                    width: 32
                                    height: 32
                                    fillMode: Image.PreserveAspectCrop
                                    source: "file:" + model.avatar
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
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                leftPadding: 16
                                text: model.name
                            }
                        }
                    }
                }
            }
        }

        RoundButton {
            id: roundButton

            x: 146
            y: 355
            text: "+"
            anchors.horizontalCenter: background.horizontalCenter
            anchors.top: background.bottom
            anchors.topMargin: 25
            highlighted: false
            onClicked: windowContentStack.replace("CreateUser.qml")
        }
    }
}
