import QtQuick 2.7
import QtGraphicalEffects 1.0

Rectangle {
    //id: rectangle
    border.width: 0
    layer.enabled: true
    layer.effect: DropShadow {
        color: "#4D000000"
        verticalOffset: 12
        radius: 24
        samples: 49
    }
}
