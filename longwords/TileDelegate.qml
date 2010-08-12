import Qt 4.7

Rectangle{
    color: 'blanchedalmond'
    width: tileSize-2
    height: tileSize-2
    radius: 4
    x: column * tileSize
    y: row * tileSize
    Behavior on x{SmoothedAnimation{velocity:100}}
    Behavior on y{SmoothedAnimation{velocity:100}}
    //TODO: Blurred transparent lightgoldenrodyellow to get a glow effect for highlight?
    Text{
        text: letter
        anchors.centerIn: parent
        color: selected?'goldenrod':'burlywood'
        Behavior on color{ColorAnimation{}}
        font.pixelSize: tileSize - 4
        font.capitalization: Font.AllUppercase
    }
}
