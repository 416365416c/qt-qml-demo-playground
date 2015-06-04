import QtQuick 2.1
import QtQuick.Window 2.1
import "Logic.js" as GameLogic

//This file has a fuchsia window so that it can be run standalone until it's integrated
Window {
    visible: true
    width: 300
    height: 300
    color: "fuchsia"
    Item {
        anchors.fill: parent
        TestContent{}
    }
}
