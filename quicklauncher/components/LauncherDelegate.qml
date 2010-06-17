import Qt 4.7

Component{
    Item{
        width: 320
        height: 480
        function launch(){ 
            console.log("Launching: " + app.contentRoot + filename + args);
            app.launchDemo(app.contentRoot + filename, args);
        }

        Rectangle {
            id: bg
            anchors.fill: parent
            anchors.margins: 4
            z: 0
            radius: 4
            opacity: 0
            //TODO: Ensure that the gradient (or smooth) doesn't kill performance on devices
            smooth: true
            border.color: "#aaaaaa"
            gradient: Gradient{
                GradientStop{ 
                    position: 0.0; 
                    color: "lightsteelblue"
                }
                GradientStop{ 
                    position: 1.0; 
                    color: "steelblue"
                }
            }

            Text {
                color: "white"
                text: name
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 8
            }

            Text {
                color: "white"
                text: "Tap to launch"
                opacity: bg.opacity
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
            }

        }

        Image {
            id:img; 
            anchors.centerIn: parent
            smooth: true //Does it perform?
            source: app.contentRoot + image;
            width: 240; 
            height: 320; 
            fillMode: Image.PreserveAspectFit
            z: 2

        }
//        Rectangle{//This makes it really slow?
//            id: frame
//            opacity: 1
//            anchors.fill: img
//            anchors.margins: -8
//            z: 1
//            smooth: true
//            radius: 2
//            color: "white"
//        }
        MouseArea{
            anchors.fill: parent
            z: 5
            onClicked: if(ListView.isCurrentItem) launch(); else ListView.view.currentIndex = index;
            //TODO: Select after 500ms of hover? Or skip since this is for phones
        }
        Keys.onReturnPressed: launch();

        states: State{
            name: "selected"
            when: ListView.isCurrentItem;
            PropertyChanges {
                target: bg
                opacity: 1
            }
        }
        transitions: [
            Transition {
                PropertyAnimation{properties: "opacity"}
            }
        ]

    }
}
