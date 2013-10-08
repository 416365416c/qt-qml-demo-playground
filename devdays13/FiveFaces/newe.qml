import QtQuick 2.1
import QtQuick.Window 2.1

Window {
    width: 640
    height: 480
    visible: true
    Column {
        id: col
        states: State { name: "moved"
            PropertyChanges { target: ra; x: 480 }
            PropertyChanges { target: rb; x: 360 }
            PropertyChanges { target: rc; x: 240 }
            PropertyChanges { target: gs; color: "fuchsia" }
        }
        transitions: Transition { PropertyAnimation { properties: "x,color" } }
        spacing: 64
        Rectangle {
            id: ra
            color: "lightsteelblue"
            width: 64
            height: 64
        }
        Rectangle {
            id: rb
            color: "goldenrod"
            width: 64
            height: 64
        }
        Rectangle {
            id: rc
            gradient: Gradient {
                GradientStop { color: "green"; position: 0.0 }
                GradientStop { id: gs; color: "pink"; position: 1.0 }
            }
            width: 64
            height: 64
        }
        TextEdit {
            text: "Text goes here. There is no hint it is editable."
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: col.state = "moved"
    }
}
