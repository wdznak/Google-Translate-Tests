import QtQuick 2.0

Text {
    id: root

    signal clicked()

    color: "#333333"
    text: qsTr("Ipsum")
    styleColor: "#000000"
    font.underline: false
    verticalAlignment: Text.AlignTop

    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
