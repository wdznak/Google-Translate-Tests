import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import "./CustomQml"
import wd.qt.userwordsmodel 1.0
import wd.qt.importdata 1.0
import wd.qt.wordmodel 1.0

Item {
    id: panelContainer

    property string tableName
    property UserWordsModel wordsModel: UserWordsModel {}
    property int mediumFontSize:        12
    property bool importListActive:     true
    property var toHide:                []
    property var mod:                   null

    anchors.fill: parent

    function clearPanel() {
        mod = null
        acceptButton.visible = false
    }

    ImportData {
        id: importData

        onStateChanged: {
            if (state === ImportData.READY) {
                mod = importData.words()
                mod.removeRows(wordsModel.duplicatedRows(mod))
                if (mod.rowCount() > 0) {
                    acceptButton.visible = true
                }
            }
        }
    }

    Binding {
        target: wordsModel
        property: "name"
        value: {
            "tableName": tableName,
            "select":    true
        }
    }

    Rectangle {
        id: updateContainer

        anchors.fill: parent
        color: "#ffffff"

        Column {
            id: column
            anchors.topMargin: 0
            anchors.fill: parent
            anchors.margins: 8
//---Menu---
            RowLayout {
                id: rowPanel

                height: 40
                width: parent.width

                Button {
                    Layout.alignment: Qt.AlignLeft
                    Layout.preferredHeight: 40
                    Material.background: "#ECECEC"
                    text: qsTr("IMPORT")
                    onClicked: dataFileDialog.open()
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    id: acceptButton

                    Layout.alignment: Qt.AlignRight
                    Layout.preferredHeight: 40
                    Material.background: "#ECECEC"
                    Material.foreground: Material.Green
                    visible: false

                    text: qsTr("ACCEPT")
                    onClicked: {
                        if (wordsModel.addRows(mod)) {
                            updatePopup.updateLanguages()
                        }
                        updatePopup.close()
                    }
                }

                Button {
                    id: closeButton

                    Layout.alignment: Qt.AlignRight
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 32
                    Material.background: "#ECECEC"

                    text: qsTr("X")
                    onClicked: updatePopup.close()
                }
            }
//---Lists---
            Row {
                id: rowLists

                width: parent.width
                height: parent.height - rowPanel.height
                anchors.margins: 8
//---Left list---
                ListView {
                    id: oldListView

                    x: 0
                    y: 0
                    width: parent.width / 2
                    height: parent.height
                    clip: true
                    opacity: !importListActive ? 0.3 : 1
                    model: wordsModel

                    delegate: Item {
                        x: 5
                        width: parent.width
                        height: 24
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
                        }
                    }
                }

                Rectangle {
                    id: separator

                    width: 1
                    height: parent.height
                    color: "#EEEEEE"
                }
//---Right list---
                ListView {
                    id: newListView

                    x: 0
                    y: 0
                    width: parent.width / 2
                    height: parent.height
                    model: mod

                    delegate: Item {
                        property string wordA: word
                        property string wordB: translation

                        x: 5
                        width: parent.width
                        height: 24

                        RowLayout {
                            width: parent.width
                            height: parent.height
                            spacing: 2

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.margins: 6

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        if (loaderWord.state !== "editMode") {
                                            loaderWord.state = "editMode"
                                        }
                                    }

                                    Loader {
                                        id: loaderWord

                                        property bool firstColumn: true
                                        property string wordText: word
                                        property int modelIndex: index

                                        sourceComponent: wordTextComponent
                                        states: State {
                                            name: "editMode"
                                            PropertyChanges {
                                                target: loaderWord
                                                sourceComponent: wordEditComponent
                                            }
                                        }
                                    }
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.margins: 6

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        if (loaderTranslation.state !== "editMode") {
                                            loaderTranslation.state = "editMode"
                                        }
                                    }

                                    Loader {
                                        id: loaderTranslation

                                        property bool firstColumn: false
                                        property string wordText: translation
                                        property int modelIndex: index

                                        sourceComponent: wordTextComponent
                                        states: State {
                                            name: "editMode"
                                            PropertyChanges {
                                                target: loaderTranslation
                                                sourceComponent: wordEditComponent
                                            }
                                        }
                                    }
                                }
                            }

                            Component {
                                id: wordTextComponent

                                Text {
                                    font.pixelSize: mediumFontSize
                                    elide: Text.ElideRight
                                    text: wordText
                                }
                            }

                            Component {
                                id: wordEditComponent

                                TextInput {
                                    id: editMe

                                    property bool edited: false

                                    font.pixelSize: mediumFontSize
                                    color: "#333333"
                                    text: wordText
                                    clip: true
                                    Component.onCompleted: {
                                        editMe.selectAll()
                                        editMe.forceActiveFocus()
                                    }
                                    onEditingFinished: {
                                        if (edited === true) return

                                        if (editMe.text === "") {
                                            editMe.text = qsTr("ROW CAN NOT BE EMPTY")
                                            editMe.selectAll()
                                            return
                                        }

                                        if (firstColumn && !wordsModel.rowExists(editMe.text, translation)) {
                                            mod.editRow(modelIndex, editMe.text, WordModel.WordRole)
                                            edited = true
                                            loaderWord.state = ""
                                            return
                                        } else if (!firstColumn && !wordsModel.rowExists(word, editMe.text)) {
                                            mod.editRow(modelIndex, editMe.text, WordModel.TranslationRole)
                                            edited = true
                                            loaderTranslation.state = ""
                                            return
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

            }
        }
    }

    FileDialog {
        id: dataFileDialog
        title: "Please choose data file"
        folder: shortcuts.home
        nameFilters: [ "Microsoft Excel (*.xlsx)", "All files (*)" ]
        onAccepted: {
            importData.loadFile = dataFileDialog.fileUrl
        }
        onRejected: {
        }
    }
}
