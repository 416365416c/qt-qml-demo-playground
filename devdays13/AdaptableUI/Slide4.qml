import QtQuick 2.0
import QtQuick.Controls 1.1
import Qt.labs.presentation 1.0

    Slide {
	title: "What is Adaptable UI?"
      Row{
	y: 20
	spacing: 20
	Rectangle {
	  width: 480
	  height: 240
	    color: "grey"
	    Grid {
	      Repeater {
		model: 8
		CheckBox {
		  text: "Option " + index
		}
	      }
	    }
        }
        Rectangle {
	  width: 320
	  height: 240
	  color: "white"
	  ListView {
	    anchors.fill: parent
	    model: 8
	    delegate: 
	      Row {
		spacing: 8
		width: childrenRect.width
	        height: childrenRect.height
		Text {
		  text: "Option " + index
		}
		Switch {}
	      }
	  }
	}
      }
    }
