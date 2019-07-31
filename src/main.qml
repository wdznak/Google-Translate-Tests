import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.2
import wd.qt.usersmodel 1.0

ApplicationWindow {
    id: mainwindow

    width: 800
    height: 600
    minimumWidth: 540
    minimumHeight: 540
    visible: true
    title: qsTr("Google Translate Tests")
    background: Rectangle {
        color: "#757575"
    }

    header: UserInterface {}

    Component.onCompleted: {
        if(Window.Maximized === settings.visibility) {
            mainwindow.showMaximized()
        }

        if(UsersModel.rowCount()) {
            windowContentStack.push("Login.qml")
        } else {
            windowContentStack.push("CreateUser.qml")
        }
    }

    StackView {
        id: windowContentStack
        anchors.fill: parent
    }

    Settings {
        id: settings
        property int visibility: 2
    }

    onClosing: {
        settings.visibility = mainwindow.visibility
    }
}


