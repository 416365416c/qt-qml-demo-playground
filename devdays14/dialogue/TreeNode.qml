import QtQuick 2.1
import "Logic.js" as GameLogic

QtObject {
    id: node
    //Same bug as Story
    property list<QtObject> choices
    property string prechoiceText: "" //some don't have it
    function select() {
        //Nothing here?
    }
}
