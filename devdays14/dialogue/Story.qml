import QtQml 2.1
import "Logic.js" as GameLogic

QtObject {
    id: storyContainer
    //dang default bug
    //Possible second bug: Using TreeNode makes the window never show....
    property list<QtObject> allNodes
    property QtObject currentNode: null
    property QtObject lastNode: null //TODO: Hook up
    //Note that when currentNode changes, the UI will attempt to update to the new value

    Component.onCompleted: GameLogic.init(storyContainer)
    onCurrentNodeChanged:
        GameLogic.init(storyContainer)
}
