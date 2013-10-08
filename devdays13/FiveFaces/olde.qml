import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    ColumnLayout {
        anchors.fill: parent
        Button { text: "Alpha" }
        Button { text: "Beta" }
        Button { text: "Gamma" }
        TextArea{ text: "Input text here"; Layout.fillWidth: true }
    }
}
