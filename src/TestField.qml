import QtQuick 2.0
import QtQml.Models 2.3
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    id: testContainer
    width: 300
    height: 300
    Pane {
        width: 100
        height: 30
        Frame {
            padding: 0
            anchors.fill: parent
            anchors.centerIn: parent
        }
    }


}
