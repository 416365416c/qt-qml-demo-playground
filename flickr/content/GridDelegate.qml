/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
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
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
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
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0

Item {
    id: wrapper; width: GridView.view.cellWidth; height: GridView.view.cellHeight

    function photoClicked() {
        imageDetails.photoTitle = title;
        imageDetails.photoTags = tags;
        imageDetails.photoWidth = photoWidth;
        imageDetails.photoHeight = photoHeight;
        imageDetails.photoType = photoType;
        imageDetails.photoAuthor = photoAuthor;
        imageDetails.photoDate = photoDate;
        imageDetails.photoUrl = url;
        imageDetails.rating = 0;
        scaleMe.state = "Details";
    }

    Item {
        anchors.centerIn: parent
        scale: 0.0
        Behavior on scale { NumberAnimation { easing.type: Easing.InOutQuad} }
        id: scaleMe

        Item {
            width: 77; height: 77; anchors.centerIn: parent
            Rectangle {
                id: whiteRect; width: 77; height: 77; color: "#dddddd"; smooth: true
                Image { id: thumb; source: imagePath; x: 1; y: 1; smooth: true }
                Image { source: "images/gloss.png" }
            }
        }

        Connections {
            target: toolBar
            onButton2Clicked: if (scaleMe.state == 'Details' ) scaleMe.state = 'Show'
        }

        states: [
            State {
                name: "Show"; when: thumb.status == Image.Ready
                PropertyChanges { target: scaleMe; scale: 1 }
            },
            State {
                name: "Details"
                PropertyChanges { target: scaleMe; scale: 1 }
                ParentChange { target: whiteRect; x: 10; y: 20; parent: imageDetails.frontContainer }
                PropertyChanges { target: background; state: "DetailedView" }
            }
        ]
        transitions: [
            Transition {
                from: "Show"; to: "Details"
                ParentAnimation {
                    via: foreground
                    NumberAnimation { properties: "x,y"; duration: 500; easing.type: Easing.InOutQuad }
                }
            },
            Transition {
                from: "Details"; to: "Show"
                ParentAnimation {
                    via: foreground
                    NumberAnimation { properties: "x,y"; duration: 500; easing.type: Easing.InOutQuad }
                }
            }
        ]
    }
    MouseArea { anchors.fill: wrapper; onClicked: photoClicked() }
}

