
import QtQuick 2.0
import Qt.labs.presentation 1.0

    CodeSlide {
        title: "Loaders"
        code:
"Item {
    Loader {
      id: nfcLoader
      source: 'NfcUI.qml'
    }
    Text {
      text: 'NFC not available'
      visible: nfcLoader.status == Loader.Error
    }
}
"
}