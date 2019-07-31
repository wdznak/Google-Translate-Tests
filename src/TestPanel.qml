import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import wd.qt.userwordsmodel 1.0
import wd.qt.groupwordsmodel 1.0

Item {
    id: testContainer

    property var groupData
    property var wordsModel:        UserWordsModel{}
    property var groupWordsModel:   GroupWordsModel { groupId: groupData.groupId }
    property int wordsInGroup: groupWordsModel.rowCount()
    property real wordsPerTest:     10
    property real currentTestLevel: 0

    signal levelCompleted(var groupData)
    signal close()

    function startTest(testInfo) {
        testContainer.currentTestLevel = testInfo.level
        fetchWordsForTest(testInfo.from, testInfo.to)
        stackView.push(testWindow)
    }

    function fetchWordsForTest(from, to){
        var idList = []
        for(var i = from; i < to; ++i){
            idList.push(groupWordsModel.data(groupWordsModel.index(i,0), GroupWordsModel.WordIdRole))
        }
        wordsModel.selectIds(idList)
    }

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent

        Button {
            id: closeTestButton

            Layout.preferredHeight: 40
            Layout.preferredWidth: 32
            Material.background: "#ECECEC"
            text: qsTr("X")
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            onClicked: {
                testContainer.close()
            }
        }

        Pane {
            Layout.minimumWidth: 440
            Layout.maximumWidth: 620
            Layout.minimumHeight: 280
            Layout.maximumHeight: 480
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Material.background: Material.Amber

            GridLayout {
                id: gridLayout

                anchors.fill: parent
                columns: 5
                flow: GridLayout.LeftToRight

                Pane {
                    id: firstTestPanel

                    Layout.minimumHeight: 80
                    Layout.minimumWidth: 80
                    Layout.maximumHeight: 120
                    Layout.maximumWidth: 120
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Material.elevation: 6
                    padding: 0

                    MouseArea {
                        id: mouseArea

                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (testContainer.wordsInGroup > 0) {
                                startTest({"level": 1, "from": 0, "to": Math.min(wordsPerTest, testContainer.wordsInGroup)})
                            } else {
                                stackView.push(emptyTestWindow)
                            }
                        }

                        ColumnLayout {
                            id: columnLayout1
                            anchors.fill: parent

                            Label {
                                id: label1

                                Layout.minimumHeight: 20
                                Layout.maximumHeight: 30
                                Layout.fillHeight: true
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                Layout.topMargin: 8
                                verticalAlignment: Text.AlignVCenter
                                text: "1"
                                font.pointSize: 14
                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.minimumHeight: 40
                                Layout.minimumWidth: 40
                                Layout.maximumHeight: 60
                                Layout.maximumWidth: 60
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Image {
                                    id: image

                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                    visible: false
                                    smooth: true
                                    source: "qrc:/Graphics/ic_lock_open_black_24px.svg"

                                }
                                ColorOverlay{
                                    id: imageColor

                                    anchors.fill: image
                                    source: image
                                    color:"gray"
                                }
                            }

                            Label {
                                id: testRangelabel

                                Layout.minimumHeight: 20
                                Layout.maximumHeight: 30
                                Layout.fillHeight: true
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.bottomMargin: 8
                                verticalAlignment: Text.AlignVCenter
                                text: "1-" + Math.min(wordsPerTest, testContainer.wordsInGroup)
                                font.pointSize: 8
                            }
                        }
                    }
                    states: [
                        State {
                            name: "finished"
                            when: testContainer.groupData.groupLevel > 1 && testContainer.wordsInGroup > 0
                            PropertyChanges {
                                target: image
                                source: "qrc:/Graphics/ic_done_all_black_24px.svg"
                            }
                            PropertyChanges {
                                target: imageColor
                                color: "green"
                            }
                        },
                        State {
                            name: "empty"
                            when: testContainer.wordsInGroup === 0
                            PropertyChanges {
                                target: image
                                source: "qrc:/Graphics/ic_lock_black_24px.svg"
                            }
                            PropertyChanges {
                                target: imageColor
                                color: "red"
                            }
                            PropertyChanges {
                                target: testRangelabel
                                text: "empty"
                            }
                        }

                    ]
                }

                Repeater {
                    id: repeatMe
                    Pane {
                        id: testButtonRepeater

                        property int panelIndex: index + 2
                        //equation n-1+(wordsPerTest*n-wordsPerTest)
                        //for wordsPerTest = 10 n-1(10n*10) where n = panelIndex | simplified ver. 11n-11
                        property int from: (wordsPerTest+1)*panelIndex-(wordsPerTest+1)
                        //special case when the last test has less words than "wordsPerTest" variable
                        property int to: Math.min(from + wordsPerTest, testContainer.wordsInGroup)

                        Layout.minimumHeight: 80
                        Layout.minimumWidth: 80
                        Layout.maximumHeight: 120
                        Layout.maximumWidth: 120
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Material.elevation: 6
                        padding: 0

                        MouseArea {
                            id: mouseAreaRepeater

                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                fetchWordsForTest(from, to)
                                startTest({"level": panelIndex, "from": from, "to": to})
                            }

                            ColumnLayout {
                                id: columnLayout11
                                anchors.fill: parent

                                Label {
                                    id: label11

                                    Layout.minimumHeight: 20
                                    Layout.maximumHeight: 30
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                                    Layout.topMargin: 8
                                    verticalAlignment: Text.AlignVCenter
                                    text: panelIndex
                                    font.pointSize: 14
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.minimumHeight: 40
                                    Layout.minimumWidth: 40
                                    Layout.maximumHeight: 60
                                    Layout.maximumWidth: 60
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Image {
                                        id: imageRepeater

                                        anchors.centerIn: parent
                                        fillMode: Image.PreserveAspectFit
                                        visible: false
                                        smooth: true
                                        source: "qrc:/Graphics/ic_lock_open_black_24px.svg"
                                    }
                                    ColorOverlay{
                                        id: imageColorRepeater
                                        anchors.fill: imageRepeater
                                        source: imageRepeater
                                        color:"gray"
                                    }
                                }

                                Label {
                                    id: label111

                                    Layout.minimumHeight: 20
                                    Layout.maximumHeight: 30
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.bottomMargin: 8
                                    verticalAlignment: Text.AlignVCenter
                                    text: from + "-" + to
                                    font.pointSize: 8
                                }
                            }
                        }
                        states: [
                            State {
                                name: "finished"
                                when: panelIndex < testContainer.groupData.groupLevel
                                PropertyChanges {
                                    target: imageRepeater
                                    source: "qrc:/Graphics/ic_done_all_black_24px.svg"
                                }
                                PropertyChanges {
                                    target: imageColorRepeater
                                    color: "green"
                                }
                            },
                            State {
                                name: "locked"
                                when: panelIndex > testContainer.groupData.groupLevel
                                PropertyChanges {
                                    target: imageRepeater
                                    source: "qrc:/Graphics/ic_lock_black_24px.svg"
                                }
                                PropertyChanges {
                                    target: testButtonRepeater
                                    Material.elevation: 0
                                    Material.background: Material.color(Material.Grey, Material.Shade100)
                                }
                                PropertyChanges {
                                    target: mouseAreaRepeater
                                    enabled: false
                                }
                            }
                        ]

                        Connections {
                            target: testContainer
                            onLevelCompleted: {
                                if(panelIndex === groupData.groupLevel) {
                                    testButtonRepeater.state = ""
                                } else if (panelIndex > 1 && panelIndex === groupData.groupLevel - 1) {
                                    testButtonRepeater.state = "finished"
                                }
                            }
                        }
                    }
                }
                Component.onCompleted: {
                    repeatMe.model = Math.ceil((testContainer.wordsInGroup - wordsPerTest ) / wordsPerTest)
                }
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent

        Component {
            id: emptyTestWindow

            Pane {
                Material.background: Material.Red
                Material.elevation: 3
                MouseArea {
                    anchors.fill: parent
                    onClicked: stackView.clear()
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("This test does not have any words!")
                }
            }
        }

        Component {
            id: testWindow

            Pane {
                id: testPanel

                property int    currentWordIndex: 0
                property int    testScore:        0
                property real   goodAnswers:      0
                property bool   inverseTest:      false
                property var    modelIndex:       wordsModel.index(currentWordIndex, 0)
                property string word:             wordsModel.data(modelIndex, UserWordsModel.WordRole)
                property string translation:      wordsModel.data(modelIndex, UserWordsModel.TranslationRole)
                property real   attempt:          wordsModel.data(modelIndex, UserWordsModel.AttemptRole)
                property real   streak:           wordsModel.data(modelIndex, UserWordsModel.StreakRole)
                property string description:      wordsModel.data(modelIndex, UserWordsModel.DescriptionRole)
                property real   active:           wordsModel.data(modelIndex, UserWordsModel.ActiveRole)

                Material.elevation: 0

                ColumnLayout {
                    id: wordTestColumn

                    anchors.centerIn: parent
                    width: 380
                    height: 400

                    RowLayout {
                        Layout.fillWidth: true

                        Pane {
                            Layout.maximumWidth: wordTestColumn.width * 0.6
                            Material.elevation: 2
                            padding: 4

                            Label {
                                id: wordLabel

                                wrapMode: Text.WordWrap
                                width: parent.width
                                Layout.alignment: Qt.AlignLeft
                                text: inverseTest ? translation: word
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Pane {
                            Layout.maximumWidth: wordTestColumn.width*0.3
                            Material.elevation: 2
                            padding: 4

                            Label {
                                id: scoreLabel

                                text: testScore
                                Layout.alignment: Qt.AlignRight
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            id: descriptionLabel
                            text: description
                            Layout.alignment: Qt.AlignLeft
                        }
                        Label {
                            id: streakLabel
                            text: streak
                            Layout.alignment: Qt.AlignRight
                        }
                    }

                    RowLayout {
                        id: answerRow

                        Layout.fillWidth: true

                        TextField {
                            id: answerTextField

                            Layout.fillWidth: true
                            placeholderText: qsTr("Enter answer")
                            onAccepted: {
                                if (validateAnswer()) {
                                    goodAnswer()
                                } else {
                                    badAnswer()
                                }
                                text = ""
                            }
                        }

                        Text {
                            id: answerText

                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            visible: false
                            text: inverseTest ? word: translation
                        }
                    }

                    RowLayout {
                        id: navigationRow
                        Layout.fillWidth: true

                        Button {
                            text: "Close"
                            onClicked: stackView.clear()
                        }

                        Button {
                            text: "LOL"
                            onClicked: {
                                testContainer.groupData.groupLevel = currentTestLevel + 1
                                testContainer.groupData.points = 20
                                testContainer.levelCompleted(testContainer.groupData)
                                if (testContainer.groupData.groupLevel === 2){
                                    firstTestPanel.state = "finished"
                                }
                            }
                        }

                        Button {
                            id: acceptButton
                            text: qsTr("OK")
                            onClicked: {
                                if (validateAnswer()) {
                                    goodAnswer()
                                } else {
                                    badAnswer()
                                }
                                answerTextField.text = ""
                            }
                        }
                    }

                    states: State {
                        name: "showAnswer"
                        PropertyChanges {
                            target: answerTextField
                            visible: false
                        }
                        PropertyChanges {
                            target: answerText
                            visible: true
                        }
                        PropertyChanges {
                            target: acceptButton
                            text: qsTr("NEXT")
                            Material.background: Material.Yellow
                            onClicked: {
                                wordTestColumn.state = ""
                                nextWord()
                                console.log("Im next btn")
                            }
                        }
                    }
                }

                function validateAnswer() {
                    if(inverseTest){
                        return answerTextField.text.toUpperCase() === word.toUpperCase()
                    }
                    return answerTextField.text.toUpperCase() === translation.toUpperCase()
                }

                function goodAnswer() {
                    updateScore()
                    wordsModel.setData(modelIndex, streak + 1, UserWordsModel.StreakRole)
                    inverseTest = Math.floor(Math.random() * 2)
                    nextWord()
                }

                function badAnswer() {
                    wordsModel.setData(modelIndex, 0, UserWordsModel.StreakRole)
                    wordTestColumn.state = "showAnswer"
                }

                function updateScore() {
                    if (streak > 1) {
                        testScore += 100 / streak
                    } else {
                        testScore += 100
                    }

                }

                function nextWord() {
                    if(currentWordIndex < wordsPerTest - 1) currentWordIndex++
                    if(!active) {
                        if(currentWordIndex === wordsPerTest - 1) {
                            summupTest()
                        } else {
                            nextWord()
                        }
                        return
                    }
                    if(currentWordIndex === wordsPerTest - 1) {
                        summupTest()
                    }
                }

                function summupTest(){
                    if (goodAnswers > Math.floor(wordsPerTest * 0.8)) {
                        if (!(testContainer.currentTestLevel < testContainer.groupData.groupLevel)) {
                            testContainer.groupData.groupLevel = currentTestLevel + 1

                            if (testContainer.groupData.groupLevel === 2){
                                firstTestPanel.state = "finished"
                            }

                        }
                    }
                    testContainer.groupData.testScore = testScore
                    testContainer.levelCompleted(testContainer.groupData)
                    stackView.clear()
                }
            }
        }
    }

}
