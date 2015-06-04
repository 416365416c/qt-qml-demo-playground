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
    id: titleBar
    property string untaggedString: "Uploads from everyone"
    property string taggedString: "Recent uploads tagged "

    BorderImage { source: "images/titlebar.sci"; width: parent.width; height: parent.height + 14; y: -7 }

    Item {
        id: container
        width: (parent.width * 2) - 55 ; height: parent.height

        function accept() {
            imageDetails.closed()
            titleBar.state = ""
            background.state = ""
            rssModel.tags = editor.text
        }

        Image {
            id: quitButton
            anchors.left: parent.left//; anchors.leftMargin: 0
            anchors.verticalCenter: parent.verticalCenter
            source: "images/quit.png"
            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
            }
        }

        Text {
            id: categoryText
            anchors {
                left: quitButton.right; right: tagButton.left; leftMargin: 10; rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
            elide: Text.ElideLeft
            text: (rssModel.tags=="" ? untaggedString : taggedString + rssModel.tags)
            font.bold: true; font.pixelSize: 15; color: "White"; style: Text.Raised; styleColor: "Black"
        }

        Button {
            id: tagButton; x: titleBar.width - 50; width: 45; height: 32; text: "..."
            onClicked: if (titleBar.state == "Tags") container.accept(); else titleBar.state = "Tags"
            anchors.verticalCenter: parent.verticalCenter
        }

        Item {
            id: lineEdit
            y: 4; height: parent.height - 9
            anchors { left: tagButton.right; leftMargin: 5; right: parent.right; rightMargin: 5 }

            BorderImage { source: "images/lineedit.sci"; anchors.fill: parent }

            TextInput {
                id: editor
                anchors {
                    left: parent.left; right: parent.right; leftMargin: 10; rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                cursorVisible: true; font.bold: true
                color: "#151515"; selectionColor: "Green"
            }

            Keys.forwardTo: [ (returnKey), (editor)]

            Item {
                id: returnKey
                Keys.onReturnPressed: container.accept()
                Keys.onEnterPressed: container.accept()
                Keys.onEscapePressed: titleBar.state = ""
            }
        }
    }

    states: State {
        name: "Tags"
        PropertyChanges { target: container; x: -tagButton.x + 5 }
        PropertyChanges { target: tagButton; text: "OK" }
        PropertyChanges { target: editor; focus: true }
    }

    transitions: Transition {
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad }
    }
}
