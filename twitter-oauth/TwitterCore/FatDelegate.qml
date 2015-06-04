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

Component {
    id: listDelegate
    Item {
        id: wrapper; width: wrapper.ListView.view.width; height: if(txt.height > 58){txt.height+8}else{58}//50+4+4
        function handleLink(link){
            if(link.slice(0,3) == 'app'){
                screen.setUser(link.slice(7));
                screen.setMode(true);
            }else if(link.slice(0,4) == 'http'){
                Qt.openUrlExternally(link);
            }
        }
        function addTags(str){
            var ret = str.replace(/@[a-zA-Z0-9_]+/g, '<a href="app://$&">$&</a>');//click to jump to user?
            var ret2 = ret.replace(/http:\/\/[^ \n\t]+/g, '<a href="$&">$&</a>');//surrounds http links with html link tags
            return ret2;
        }
        Item {
            id: moveMe; height: parent.height
            Rectangle {
                id: blackRect
                color: "black"; opacity: wrapper.ListView.index % 2 ? 0.2 : 0.3; height: wrapper.height-2; width: wrapper.width; y: 1
            }
            Rectangle {
                id: whiteRect; x: 6; width: 50; height: 50; color: "white"; smooth: true
                anchors.verticalCenter: parent.verticalCenter

                Loading { x: 1; y: 1; width: 48; height: 48; visible: realImage.status != Image.Ready }
                Image { id: realImage; source: userImage; x: 1; y: 1; width:48; height:48 }
            }
            Text { id:txt; y:4; x: 56
                text: '<html><style type="text/css">a:link {color:"#aaccaa"}; a:visited {color:"#336633"}</style>'
                    + '<a href="app://@'+userScreenName+'"><b>'+userScreenName + "</b></a>  from " +source
                    + "<br /><b>" + wrapper.addTags(statusText) + "</b></html>";
                textFormat: Qt.RichText
                color: "#cccccc"; style: Text.Raised; styleColor: "black"; wrapMode: Text.WordWrap
                anchors.left: whiteRect.right; anchors.right: blackRect.right; anchors.leftMargin: 6; anchors.rightMargin: 6
                onLinkActivated: wrapper.handleLink(link)
            }
        }
    }
}
