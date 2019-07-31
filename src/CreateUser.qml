import QtQuick 2.7
import QtQuick.Dialogs 1.2
import wd.qt.importdata 1.0
import wd.qt.usersmodel 1.0

CreateUserForm {

    fileInfoPanel.onStateChanged: {
        if(importData.state === ImportData.READY) {
            wordListView.listView.model = importData.words()
            fileInfoPanel.visible       = true
            isListValid                 = true
        } else if(importData.state === ImportData.ERROR) {
            fileInfoPanel.visible = false
            islistValid           = false
        }
    }

    avatarImgArea.onClicked: {
        graphicFileDialog.open()
    }

    importBtnArea.onClicked: {
        dataFileDialog.open()
    }

    importBtnArea.onEntered: {
        importBtnArea.parent.color = "#484848"
    }

    importBtnArea.onExited: {
        importBtnArea.parent.color = "#333333"
    }

    userNameInput.onFocusChanged: {
        if (userNameInput.focus) {
            userNameInput.clear()
            isUserNameValid          = false
            validityNameText.visible = false
        }
    }

    userNameInput.onTextChanged: {
        isUserNameValid          = !usersModel.rowExists(userNameInput.text, UsersModel.NameRole)
        validityNameText.visible = !isUserNameValid
    }

    userNameInput.onAccepted: {
            userNameInput.focus = false
    }

    acceptButton.states: State {
       name: "active"
       when: userNameInput.acceptableInput && isListValid && isUserNameValid
       PropertyChanges {
           target: acceptButton
           enabled: true
       }
    }

    acceptButton.onClicked: {
        /*
         * grabToImage function is async so we delay creating user
         * until avatar is saved to avoid "cannot open file" error
         */
        var createUser = function() {
            usersModel.createUser(userNameInput.text, avatarName)
            UserManager.setUser(userNameInput.text)

            UserManager.createLanguageTable(importData.words())


            windowContentStack.replace("UserPanel.qml")
        }

        var avatarName = userNameInput.text + ".png"
        avatarImg.grabToImage(function(result) {
                                   result.saveToFile(avatarName);
                                   createUser() //now it's save to create user
                               }, Qt.size(512, 512));
    }

    Component.onCompleted: {
        importData.stateChanged.connect(fileInfoPanel.stateChanged)
    }

    FileDialog {
        id: graphicFileDialog

        title: "Please choose a graphic file"
        folder: shortcuts.home
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
        onAccepted: {
            avatarImg.source = graphicFileDialog.fileUrl
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
    }

}
