
import QtQuick 2.0
import Qt.labs.presentation 1.0

    CodeSlide {
        title: "Bindings"
        //moving a gradient stop based on screen type (custom exposed)
        code:
'
Rectangle {
  anchors.fill: parent
  gradient: Gradient {
    GradientStop { position: 0.0; color: "lightsteelblue" }
    GradientStop { position: AppLogic.specialFlag ? 0.5 : 1.0; color: "goldenrod" }
  }
}
'
    }
