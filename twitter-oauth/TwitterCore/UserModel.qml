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

//This "model" gets the user information about the searched user. Mainly for the icon.
//Copied from RssModel

Item { id: wrapper
    property variant model: xmlModel
    property string user : ""
    onUserChanged: reload();
    property int status: xmlModel.status
    function reload() {
        if(user == "")
            return;
        var xhr;
        var url = "http://twitter.com/users/show.xml?screen_name="+user;
        if(oauth.authorized){
            xhr = OAuthLogic.createOAuthHeader("GET", url, undefined, {"token":oauth.token, "secret":oauth.secret});
        }else{
            xhr = new XMLHttpRequest;
            xhr.open("GET", url);
        }
        xhr.onreadystatechange = function() { 
            if (xhr.readyState == XMLHttpRequest.DONE) {
                xmlModel.xml = xhr.responseText;
            }
        }
        xhr.send();
    }
XmlListModel {
    id: xmlModel

    query: "/user"

    XmlRole { name: "name"; query: "name/string()" }
    XmlRole { name: "screenName"; query: "screen_name/string()" }
    XmlRole { name: "image"; query: "profile_image_url/string()" }
    XmlRole { name: "location"; query: "location/string()" }
    XmlRole { name: "description"; query: "description/string()" }
    XmlRole { name: "followers"; query: "followers_count/string()" }
    //XmlRole { name: "protected"; query: "protected/bool()" }
    //TODO: Could also get the user's color scheme, timezone and a few other things
}
}
