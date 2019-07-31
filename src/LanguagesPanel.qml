import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import wd.qt.languagesmodel 1.0
import wd.qt.importdata 1.0

Item {
    id: languagesPanelContainer

    property var languagesModel
    property ImportData importData: ImportData {}

    anchors.fill: parent

    RowLayout {
        id: rowLayout

        spacing: 8
        anchors.rightMargin: 8
        anchors.leftMargin: 8
        anchors.bottomMargin: 8
        anchors.topMargin: 8
        anchors.fill: parent

        Column {
            Layout.preferredWidth: 150
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

            Button {
                Layout.preferredHeight: 40
                Material.background: "#ECECEC"
                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Add New")
                onClicked: {

                }
            }
        }

        ListView {
            id: listView

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 8
            clip: true
            spacing: 8
            model: languagesModel

            delegate: Frame {
                id: frame1

                padding: 8
                width: parent.width
                height: 40
                Material.elevation: 3

                Text {
                    id: updateBtnTxt

                    color: "#333333"
                    text: qsTr("UPDATE")
                    anchors.verticalCenter: parent.verticalCenter
                    styleColor: "#000000"
                    font.underline: false
                    anchors.right: parent.right
                    font.pixelSize: 14

                    MouseArea {
                        id: updateBtnArea

                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            updatePopup.tableName = tableName
                            updatePopup.open()
                        }
                    }
                }

                Column {
                    id: languagesColumn
                    anchors.verticalCenter: parent.verticalCenter

                    anchors.left: parent.left

                    Text {
                        id: langText
                        color: "#a4a4a4"
                        font.pixelSize: 16
                        text: langA + "/" + langB
                    }

                    Label {
                        id: langLabel
                        font.pointSize: 8
                        text: qsTr("Languages")
                    }
                }

                Column {
                    id: wordsColumn
                    anchors.verticalCenter: parent.verticalCenter

                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: langText1

                        color: "#a4a4a4"
                        font.pixelSize: 16
                        text: languagesModel.wordsCount(tableName)
                    }

                    Label {
                        id: langLabel1

                        font.pointSize: 8
                        text: qsTr("Words")
                    }
                }
            }
        }
    }

    Popup {
        id: updatePopup

        property string tableName
        property var component
        property var panel: null

        parent: windowContentStack
        x: 40
        y: 40
        width: mainwindow.width - 80
        height: mainwindow.height - 80
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape
        onAboutToShow: {
            if(panel === null) {
                createSpriteObjects()
                return
            }

            panel.tableName = tableName
        }
        onAboutToHide: {
            panel.clearPanel()
        }

        Item {
            id: updatePanel
            anchors.fill: parent
        }

        function updateLanguages() {
            languagesModel.select()
        }

        function createSpriteObjects() {
            component = Qt.createComponent("UpdateWordsListPanel.qml");
            panel = component.createObject(updatePanel, {"tableName": tableName});
        }
    }
}
