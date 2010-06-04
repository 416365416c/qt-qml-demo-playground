/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the QtDeclarative module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

import Qt 4.7

Rectangle{
    width: 800
    height: 480
    XmlListModel{
        id: theModel
        source: "config.xml"
        query: "/demolauncher/demos/example"
        XmlRole{ name: "image"; query: "@image/string()" }
        XmlRole{ name: "name"; query: "@name/string()" }
        XmlRole{ name: "filename"; query: "@filename/string()" }
        XmlRole{ name: "args"; query: "@args/string()" }
    }
    Component{ id: theDelegate
        Item{
            width: 320
            height: 480
            function launch(){ 
                console.log("Launching: " + filename + args);
                app.launchDemo(filename, args);
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 4
                z: 1
                radius: 4
                //TODO: Ensure that the gradient (or smooth) doesn't kill performance on devices
                smooth: true
                border.color: "#aaaaaa"
                gradient: Gradient{//TODO: Can we afford the performance hit of animating this color change?
                    GradientStop{ 
                        position: 0.0; 
                        color: ListView.isCurrentItem ? "lightgreen" : "lightsteelblue" 
                        Behavior on color{ColorAnimation{}}
                    }
                    GradientStop{ 
                        position: 1.0; 
                        color: ListView.isCurrentItem ? "forestgreen": "steelblue"
                        Behavior on color{ColorAnimation{}}
                    }
                }
            }
            Text {
                text: name
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 8
                z: 3
            }
            Image {
                id:img; 
                anchors.centerIn: parent
                smooth: true //Does it perform?
                source: image; 
                width: 240; 
                height: 320; 
                fillMode: Image.PreserveAspectFit
                z: 2
            }
            MouseArea{
                anchors.fill: parent
                z: 5
                onClicked: {ListView.view.currentIndex = index; launch();}
            }
            Keys.onReturnPressed: launch();
        }
    }
    ListView{
        anchors.fill: parent
        orientation: ListView.Horizontal
        model: theModel
        delegate: theDelegate
        focus: true
    }
}
