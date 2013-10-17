import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import Qt.labs.presentation 1.0

Slide {
    title: 'What is Adaptable UI?'
    
    Rectangle {
      color: "gray"
      anchors { left: parent.left; top: parent.top; 
	leftMargin: 80; topMargin: 120
	right: drect.right; bottom: drect.bottom }
      GridLayout {
	anchors.fill: parent
	Button { text: "Alpha"; Layout.row: 0; Layout.column: 0;Layout.fillWidth: true
	  Layout.fillHeight: true
	   }
	Button { text: "Beta"; Layout.row: 0; Layout.column: 1;Layout.fillWidth: true
	  Layout.fillHeight: true
	   }
	Button { text: "Gamma"; Layout.row: 0; Layout.column: 2; Layout.fillWidth: true
	  Layout.fillHeight: true
	   }
	TextArea { 
	  Layout.row: 1
	  Layout.columnSpan: 3
	  Layout.fillWidth: true
	  Layout.fillHeight: true
	  text: "I am the very model of a modern major general, I've information vegetable, animal and mineral. I know the kings of england and I quote the fights historical: from marathon to waterloo in order categorical! I'm very well aquainted too with matter mathematical, I understand equations both the simple and quadratical. About binomial theorem I am teeming with a lot of news - with many cheerful facts about the square of the hypotenuse!"
	}
      }
    }
      Rectangle {
	id: drect
         width: 20
         height: 20
         x: 620
         y: 480
         color: "lightsteelblue"
	 opacity: 0.5
         MouseArea{
	  anchors.fill: parent
	  drag.target: drect
            drag.axis: Drag.XAndYAxis
            drag.minimumX: 80
            drag.maximumX: 1400
            drag.minimumY: 120
            drag.maximumY: 1000
	}
      }
}
