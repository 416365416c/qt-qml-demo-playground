import Qt 4.7

Rectangle{
    property alias text: label.text
    property alias templatesModel: templates.model
    color: 'white'

    Component{
        id: paneDelegate
        Item{
            width: templates.width
            height: 80
            MouseArea{anchors.fill: parent; onClicked: ListView.view.currentIndex = index }
            Row{
                anchors.centerIn: parent
                height: childrenRect.height
                Image{
                    source: icon
                    width: icon_size
                    height: icon_size
                }
                Text{
                    text: title
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    ListView{
        id: templates
        height: parent.height
        focus: true
        anchors.left: parent.left
        anchors.right: splitter.left
        delegate: paneDelegate
        highlight: Rectangle {
            height: 80
            width: templates.width
            color: "lightsteelblue"; radius: 5
            SpringFollow on y {
                to: templates.currentItem.y
                spring: 3
                damping: 0.2
            }
        }
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

    Image {
        id: documentIcon
        source: "document.png"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: splitter.right
    }
    Text {
        id: label
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.top: documentIcon.bottom
        anchors.right: parent.right
        anchors.left: splitter.right
    }

    Button{
        anchors.bottom: parent.bottom
        anchors.top: label.bottom
        anchors.right: parent.right
        anchors.left: splitter.right
        caption: 'Submit'
        anchors.margins: 8
        onClicked: process(label.text);
    }
}
