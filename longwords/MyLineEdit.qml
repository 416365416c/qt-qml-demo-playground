import Qt 4.7

TextInput{
    color: props.textColor
    maximumLength: 12//40,000 iterations found nothing longer than 11
    width: phantomText.width + 4
    Text{id: phantomText; opacity: 0; text: "WWWWWWWWWWWW"}
    font.pixelSize: props.textSize
    font.family: props.textFamily
    font.capitalization: Font.AllUppercase
    Rectangle{
        anchors.fill: parent
        anchors.margins: -4
        z:-1
        radius: 4
        color: 'white'
        border.color: 'lightsteelblue'
    }
    Rectangle{
        anchors.fill: parent
        anchors.margins: -5
        z:-1
        radius: 4
        color: 'white'
        border.color: 'steelblue'
    }
}
