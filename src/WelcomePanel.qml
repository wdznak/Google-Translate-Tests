import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    id: panelContainer

    Flow {
        id: flowContainer

        x: 8
        y: 8
        width: 624
        height: 410
        spacing: 8

        Frame {
            id: frame

            width: 131
            height: 171

            Column {
                id: column

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.left: parent.left
                spacing: 2

                Label {
                    id: nickName

                    text: qsTr("Nick")
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    id: userLevel

                    text: qsTr("LEVEL 99")
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Frame {
            id: wordLearnedFrame

            width: 134
            height: 66

            Label {
                id: wordsLearned

                x: 38
                y: 25
                text: qsTr("words learned")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 8
            }

            Label {
                id: number

                text: qsTr("254")
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 12
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Button {
        id: continueSesionBtn

        width: 200
        height: 48
        text: qsTr("Continue Sesion")
        highlighted: false
        checkable: false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        checked: false
        visible: true
    }
}
