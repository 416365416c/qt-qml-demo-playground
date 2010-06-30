import Qt 4.7

Rectangle{
    property alias text: textEdit.text
    color: 'white'
    TextEdit{
        id: textEdit
        height: parent.height
        anchors.left: parent.left
        anchors.right: splitter.left
        text: 'Default Text'
    }
    BorderImage {
        id: splitter
        x: sharedSplitterX
        onXChanged: sharedSplitterX = x;
        height: parent.height
        width: 10;
        source: "splitter.png"
        border.left: 2;
        border.right: 2;
        border.top: 2;
        border.bottom: 2;
        MouseArea{
            anchors.fill:parent
            drag.target: splitter
            drag.axis: Drag.XAxis
            drag.minimumX: 20
            drag.maximumX: root.width - 40
        }
        
    }
    Button{
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: splitter.right
        caption: 'Submit'
        anchors.margins: 8
        onClicked: process(textEdit.text);
    }
}
