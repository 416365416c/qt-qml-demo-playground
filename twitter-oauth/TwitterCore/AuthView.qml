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

Item {
    id: wrapper
            Loading {  width: 128; height: 128; visible: wrapper.state == 'loading'
                anchors.centerIn: parent;
            }
    Column {
        anchors.centerIn: parent
        spacing: 20
        Column{
            spacing: 4
            Text {
                text: "Screen name:"
                font.pixelSize: 16; font.bold: true; color: "white"; style: Text.Raised; styleColor: "black"
                horizontalAlignment: Qt.AlignRight
            }
            Item {
                width: 220
                height: 28
                BorderImage { source: "images/lineedit.sci"; anchors.fill: parent }
                TextInput{
                    id: nameIn
                    width: parent.width - 8
                    anchors.centerIn: parent
                    maximumLength:21
                    font.pixelSize: 16;
                    font.bold: true
                    color: "#151515"; selectionColor: "green"
                    KeyNavigation.tab: passIn
                    KeyNavigation.backtab: guest
                    focus: true
                }
            }
        }
        Column{
            spacing: 4
            Text {
                text: "Password:"
                font.pixelSize: 16; font.bold: true; color: "white"; style: Text.Raised; styleColor: "black"
                horizontalAlignment: Qt.AlignRight
            }
            Item {
                width: 220
               height: 28
                BorderImage { source: "images/lineedit.sci"; anchors.fill: parent }
                TextInput{
                    id: passIn
                    width: parent.width - 8
                    anchors.centerIn: parent
                    maximumLength:21
                    echoMode: TextInput.Password
                    font.pixelSize: 16;
                    font.bold: true
                    color: "#151515"; selectionColor: "green"
                    KeyNavigation.tab: login
                    KeyNavigation.backtab: nameIn
                    onAccepted: login.doLogin();
                }
            }
        }
        Row{
            spacing: 10
            Button {
                width: 100
                height: 32
                id: login
                keyUsing: true;
                function doLogin(){
                    wrapper.state = "loading"
                    oauth.username=nameIn.text;
                    oauth.password=passIn.text;
                    oauth.beginAuthentication();
                }

                text: "Log in"
                KeyNavigation.right: guest
                KeyNavigation.tab: guest
                KeyNavigation.backtab: passIn
                Keys.onReturnPressed: login.doLogin();
                Keys.onEnterPressed: login.doLogin();
                Keys.onSelectPressed: login.doLogin();
                Keys.onSpacePressed: login.doLogin();
                onClicked: login.doLogin();
            }
            Button {
                width: 100
                height: 32
                id: guest
                keyUsing: true;
                function doGuest()
                {
                    rssModel.credentials='-';
                    screen.focus = true;
                    screen.setMode(true);
                }
                text: "Guest"
                KeyNavigation.left: login
                KeyNavigation.tab: nameIn
                KeyNavigation.backtab: login
                Keys.onReturnPressed: guest.doGuest();
                Keys.onEnterPressed: guest.doGuest();
                Keys.onSelectPressed: guest.doGuest();
                Keys.onSpacePressed: guest.doGuest();
                onClicked: guest.doGuest();
            }
        }
    }
}
