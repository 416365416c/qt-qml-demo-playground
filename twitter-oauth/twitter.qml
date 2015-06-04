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
import "TwitterCore" 1.0 as Twitter

Item {
    id: screen; width: 320; height: 480
    property bool userView : false
    property variant tmpStr
    function setMode(m){
        screen.userView = m;
        if(m == false){
            rssModel.tags='my timeline';
            rssModel.reload();
            toolBar.button2Label = "View others";
        } else {
            toolBar.button2Label = "Return home";
        }
    }
    function setUser(str){hack.running = true; tmpStr = str}
    function reallySetUser(){rssModel.tags = tmpStr;}

    //Workaround for bug 260266
    Timer{ interval: 1; running: false; repeat: false; onTriggered: screen.reallySetUser(); id:hack }

    //TODO: better way to return to the auth screen
    Keys.onEscapePressed: rssModel.credentials=''
    Rectangle {
        id: background
        anchors.fill: parent; color: "#343434";

        Image { source: "TwitterCore/images/stripes.png"; fillMode: Image.Tile; anchors.fill: parent; opacity: 0.3 }

        MouseArea {
            anchors.fill: parent
            onClicked: screen.focus = false;
        }

        Twitter.OAuth{
        id: oauth
        onAuthenticationCompleted: {
            rssModel.tags='my timeline';
            screen.focus = true;
            rssModel.credentials = 'yes'
                rssModel.reload();
        }
        }
        Twitter.RssModel { id: rssModel }
        Twitter.Loading { anchors.centerIn: parent; visible: rssModel.status==XmlListModel.Loading && state!='unauthed'}
        Text {
            width: 180
            text: "Could not access twitter using this screen name and password pair.";
            color: "#cccccc"; style: Text.Raised; styleColor: "black"; wrapMode: Text.WordWrap
            visible: rssModel.status==XmlListModel.Error; anchors.centerIn: parent
        }

        Item {
            id: views
            x: 2; width: parent.width - 4
            y:60 //Below the title bars
            height: 380

            Twitter.AuthView{
                id: authView
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width; height: parent.height-60;
                x: -(screen.width * 1.5)
            }

            Twitter.FatDelegate { id: fatDelegate }
            ListView {
                id: mainView; model: rssModel.model; delegate: fatDelegate;
                width: parent.width; height: parent.height; x: 0; cacheBuffer: 100;
            }
        }

        Twitter.MultiTitleBar { id: titleBar; width: parent.width }
        Twitter.ToolBar { id: toolBar; height: 40;
            //anchors.bottom: parent.bottom;
            //TODO: Use anchor changes instead of hard coding
            y: screen.height - 40
            width: parent.width; opacity: 0.9
            button1Label: "Update"
            button2Label: "View others"
            onButton1Clicked: rssModel.reload();
            onButton2Clicked:
            {
                if(screen.userView == true){
                    screen.setMode(false);
                }else{
                    rssModel.tags='';
                    screen.setMode(true);
                }
            }
        }

        states: [
            State {
                name: "unauthed"; when: rssModel.credentials==""
                PropertyChanges { target: authView; x: 0 }
                PropertyChanges { target: mainView; x: -(parent.width * 1.5) }
                PropertyChanges { target: titleBar; y: -80 }
                PropertyChanges { target: toolBar; y: screen.height }
            }
        ]
        transitions: [
            Transition { NumberAnimation { properties: "x,y"; duration: 500; easing.type: Easing.InOutQuad } }
        ]
    }
}
