import QtQuick 2.0
import Qt.labs.presentation 1.0

    CodeSlide {
        title: "Layouts"
	code: 'GridLayout {
	anchors.fill: parent
	Button { text: "Alpha"; }
	Button { text: "Beta"; }
	Button { text: "Gamma"; }
	TextArea { 
	  Layout.row: 1
	  Layout.columnSpan: 3
	  Layout.fillWidth: true
	  Layout.fillHeight: true
	  text: "I am the very model of a modern major general, Ive information vegetable, animal and mineral. I know the kings of england and I quote the fights historical: from marathon to waterloo in order categorical!"
	}
 }
'
    }
