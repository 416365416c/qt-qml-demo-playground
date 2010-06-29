import Qt 4.7

Item{
    id: root
    height: 600
    width: 800
    property QtObject lastPane
    property QtObject curPane: null
    property int sharedSplitterX: 380 //there's probably a better way, but too lazy right now

    function showPane(type){
        var item = Qt.createQmlObject("import Qt 4.7\nimport MyApp 1.0\n"+type+"{anchors.fill: parent; opacity: 1; z: 0}",pane);
        lastPane = curPane
        curPane = item;
        if(lastPane != null){
            lastPane.z = 1;
            fadeOut.running = true;
            //lastPane.destroy(fadeOut.duration);//TODO: FILE BUG ON CRASH
        }
    }

    ListModel{
        id: paneModel//Maybe load from XML or another file? Or even popluated by the C++ of course
        ListElement{
            title: 'KWord Custom Doc'
            icon: 'kword.svgz'
            type: 'CustomWidget'//Types are either QML files or C++ exposed. I don't care
            section: 'C++ Widget'
        }
        ListElement{
            title: 'testA'
            icon: 'redhat-office.png'
            type: 'TestableA'
            section: 'QML Component'
        }
        ListElement{
            title: 'testB'
            icon: 'temp-home.png'
            type: 'TestableB'
            section: 'QML Component'
        }
        ListElement{
            title: 'SameGame'
            icon: 'redhat-games.png'
            type: 'SameGame'
            section: 'QML Demo - totally unrelated'
       }

    }

    Component{
        id: paneDelegate
        Item{
            width: paneSelection.width
            height: 80
            MouseArea{anchors.fill: parent; onClicked: ListView.view.currentIndex = index }
            Row{
                anchors.centerIn: parent
                height: childrenRect.height
                Image{
                    source: icon
                }
                Text{
                    text: title
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    ListView{
        id: paneSelection
        height: parent.height
        focus: true
        anchors.left: parent.left
        anchors.right: splitter.left
        model: paneModel
        delegate: paneDelegate
        onCurrentIndexChanged: showPane(model.get(currentIndex).type);
        highlightFollowsCurrentItem: false
        highlight: Rectangle {
            height: 80
            width: paneSelection.width
            color: "lightsteelblue"; radius: 5
            SpringFollow on y {
                to: paneSelection.currentItem.y
                spring: 3
                damping: 0.2
            }
        }
        section.property: 'section'
        section.delegate: Component{
                Rectangle{width: paneSelection.width; height: 40; color: 'darkgrey';
                Text{
                    color: 'white'
                    anchors.centerIn: parent
                    text: section
                }
            }
        }
    }

    BorderImage{
        id: splitter //approximates a horizontal splitter (but doesn't collapse whole sections)
        x: 220//This controls default start size
        width: 10;
        height: parent.height
        source: "splitter.png"
        border.left: 2;
        border.right: 2;
        border.top: 2;
        border.bottom: 2;
        MouseArea{
            anchors.fill:parent
            drag.target: splitter
            drag.axis: Drag.XAxis
            drag.minimumX: 20
            drag.maximumX: root.width - 40
        }
    }

    Item{
        id: paneMain
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: splitter.right
        anchors.right: root.right
        Item{
            height: titleText.height + 2
            width: parent.width
            id: paneTitle
            Column{
                Text{
                    id: titleText
                    text: paneModel.get(paneSelection.currentIndex).title

                }
                Rectangle{
                    width: paneTitle.widh
                    height:1
                    color: 'black'
                }
            }
        }
        Item {
            id: pane
            clip: true
            anchors.top: paneTitle.bottom
            anchors.bottom: parent.bottom
            width: parent.width
        }
    }

    NumberAnimation {
        id:fadeOut;
        target: lastPane;
        property: "opacity";
        to: 0;
        duration: 300
    }

}
