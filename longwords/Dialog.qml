import Qt 4.7

Item{
    id:dialog;
    opacity: 0
    Behavior on opacity{NumberAnimation{}}
    property bool shown: opacity == 1; //can I mark this read-only?
    property alias text: dialogText.text
    function show(){
        dialog.opacity = 1;   
    }
    function hide(){
        dialog.opacity = 0;   
    }
    GameProps{id: props}
    Flickable{
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: Math.max(parent.height, dialogText.height + 16);
        Text{
            id:dialogText
            color: props.textColor
            font.pixelSize: props.textSize
            font.family: props.textFamily
            font.capitalization: Font.SmallCaps
            wrapMode: Text.WordWrap
            width: parent.width - 24;
            anchors.centerIn: parent;
            z: 1
        }
        Rectangle{
            id: rect
            border.color: "black"
            color: "white"
            anchors.fill: dialogText
            anchors.margins: -8
            z: 0
        }
        MouseArea{
            anchors.fill: rect
            onClicked: hide();
        }
    }
}
