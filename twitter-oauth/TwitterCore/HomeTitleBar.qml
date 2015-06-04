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

import Qt 4.7
import "OAuth.js" as OAuthLogic

Item {
    id: titleBar

    signal update()
    onYChanged: state="" //When switching titlebars

    BorderImage { source: "images/titlebar.sci"; width: parent.width; height: parent.height + 14; y: -7 }
    Item {
        id: container
        width: (parent.width * 2) - 55 ; height: parent.height

        function accept() {
            if(!oauth.authorized)
                return false;//Can't login like that

            var postman = OAuthLogic.createOAuthHeader("POST", 'http://api.twitter.com/1/statuses/update.xml', undefined, oauth, [["status", editor.text]] );
            postman.onreadystatechange = function() {
                if (postman.readyState == postman.DONE) {
                    titleBar.update();
                }
            }
            postman.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            postman.send();

            editor.text = ""
            titleBar.state = ""
        }

        Rectangle {
            x: 6; width: 50; height: 50; color: "white"; smooth: true
            anchors.verticalCenter: parent.verticalCenter

            UserModel { user: oauth.username; id: userModel }//TODO: Get it to load other users again
            Component { id: imgDelegate;
                Item {
                    Loading { width:48; height:48; visible: realImage.status != Image.Ready }
                    Image { source: image; width:48; height:48; id: realImage }
                }
            }
            ListView { model: userModel.model; x:1; y:1; delegate: imgDelegate }
        }

        Text {
            id: categoryText
            anchors.left: parent.left; anchors.right: tagButton.left
            anchors.leftMargin: 58; anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideLeft
            text: "Timeline for " + userModel.user
            font.pixelSize: 12; font.bold: true; color: "white"; style: Text.Raised; styleColor: "black"
        }

        Button {
            id: tagButton; x: titleBar.width - 90; width: 85; height: 32; text: "New Post..."
            anchors.verticalCenter: parent.verticalCenter;
            onClicked: if (titleBar.state == "Posting") container.accept(); else titleBar.state = "Posting"
        }

        Text {
            id: charsLeftText; anchors.horizontalCenter: tagButton.horizontalCenter;
            anchors.top: tagButton.bottom; anchors.topMargin: 2
            text: {140 - editor.text.length;} visible: titleBar.state == "Posting"
            font.pointSize: 10; font.bold: true; color: "white"; style: Text.Raised; styleColor: "black"
        }
        Item {
            id: txtEdit;
            anchors.left: tagButton.right; anchors.leftMargin: 5; y: 4
            anchors.right: parent.right; anchors.rightMargin: 40; height: parent.height - 9
            BorderImage { source: "images/lineedit.sci"; anchors.fill: parent }

            Binding {//TODO: Can this be a function, which also resets the cursor? And flashes?
                when: editor.text.length > 140
                target: editor
                property: "text"
                value: editor.text.slice(0,140)
            }
            TextEdit {
                id: editor
                anchors.left: parent.left;
                anchors.leftMargin: 8;
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4;
                cursorVisible: true; font.bold: true
                width: parent.width - 12
                height: parent.height - 8
                font.pixelSize: 12
                wrapMode: TextEdit.Wrap
                color: "#151515"; selectionColor: "green"
            }
            Keys.forwardTo: [(returnKey), (editor)]
            Item {
                id: returnKey
                Keys.onReturnPressed: container.accept()
                Keys.onEnterPressed: container.accept()
                Keys.onEscapePressed: titleBar.state = ""
            }
        }
    }
    states: [
        State {
            name: "Posting"
            PropertyChanges { target: container; x: -tagButton.x + 5 }
            PropertyChanges { target: titleBar; height: 80 }
            PropertyChanges { target: tagButton; text: "OK" }
            PropertyChanges { target: tagButton; width: 28 }
            PropertyChanges { target: tagButton; height: 24 }
            PropertyChanges { target: editor; focus: true }
        }
    ]
    transitions: [
        Transition {
            from: "*"; to: "*"
            NumberAnimation { properties: "x,y,width,height"; easing.type: Easing.InOutQuad }
        }
    ]
}
