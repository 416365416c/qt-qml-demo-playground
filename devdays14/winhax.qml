import QtQuick.Window 2.1
import QtQuick 2.1

Window {
    width: 1920
    height: 1280
    visible: true
    Rectangle {
        color: "blue"
        anchors.fill: parent
        Text {
            color: "red"
            text: "I HAXXED UR MAHCINE"
            anchors.centerIn: parent
            font.pixelSize: 128
        }
    }
}
